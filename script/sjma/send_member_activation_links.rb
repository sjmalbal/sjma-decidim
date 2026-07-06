#!/usr/bin/env ruby
# frozen_string_literal: true

require "csv"
require "fileutils"
require "securerandom"

# Usage:
#   bin/rails runner script/sjma/send_member_activation_links.rb
#   LIMIT=3 bin/rails runner script/sjma/send_member_activation_links.rb
#   APPLY=true TEST_EMAIL=secretaria@sjmalbal.com LIMIT=1 bin/rails runner script/sjma/send_member_activation_links.rb
#   APPLY=true TEST_EMAIL=secretaria@sjmalbal.com MEMBER_EMAIL=soci@example.org bin/rails runner script/sjma/send_member_activation_links.rb
#   APPLY=true TEST_EMAIL=secretaria@sjmalbal.com MEMBER_DNI=12345678Z bin/rails runner script/sjma/send_member_activation_links.rb
#   APPLY=true CONFIRM=send-member-activation-links bin/rails runner script/sjma/send_member_activation_links.rb
#
# By default, only active SJMA members with sjma_must_change_password=true and a
# contact email receive activation links. The contact email is the Supabase email
# stored in extended_data, falling back to Decidim's email when it is not
# synthetic. This allows one contact email to receive links for multiple member
# DNIs while Decidim keeps its internal unique email constraint. Use ALL_ACTIVE=true
# only for a deliberate resend to every active member with a contact email.
# MEMBER_EMAIL selects one contact email and may match multiple members.
# MEMBER_DNI selects one exact member DNI using the same private digest as the
# login flow. Both are intended for real end-to-end tests delivered through
# TEST_EMAIL.
class SjmaMemberActivationLinks
  CONFIRMATION = "send-member-activation-links"
  SYNTHETIC_EMAIL_DOMAIN = "@members.sjmalbal.com"

  def initialize
    @apply = ENV["APPLY"] == "true"
    @confirm = ENV["CONFIRM"].to_s
    @all_active = ENV["ALL_ACTIVE"] == "true"
    @test_email = ENV["TEST_EMAIL"].presence
    @member_email = ENV["MEMBER_EMAIL"].to_s.strip.downcase.presence
    @member_dni = ENV["MEMBER_DNI"].to_s.strip.presence
    @limit = ENV["LIMIT"].presence&.to_i
    @sleep_seconds = ENV.fetch("SLEEP_SECONDS", "0.25").to_f
    @organization = Decidim::Organization.first!
    @rows = []
  end

  def call
    validate_apply!

    stats = { eligible: 0, dry_run: 0, sent: 0, skipped: 0, failed: 0 }
    users.find_each do |user|
      break if @limit && stats[:eligible] >= @limit

      stats[:eligible] += 1
      result = process_user(user)
      stats[result] += 1
      sleep @sleep_seconds if @apply && @sleep_seconds.positive?
    rescue StandardError => e
      stats[:failed] += 1
      record(user, "failed", e.message)
      warn "FAIL user_id=#{user&.id}: #{e.class}: #{e.message}"
    end

    raise missing_member_message if selected_member_filter? && stats[:eligible].zero?

    write_report
    puts stats.inspect
    puts "DRY_RUN=true: no database changes or emails sent" unless @apply
  end

  private

  def validate_apply!
    raise "Use either MEMBER_EMAIL or MEMBER_DNI, not both" if @member_email && @member_dni
    raise "Invalid MEMBER_DNI format" if @member_dni && !Sjma::MemberAuth.dni_like?(@member_dni)

    return unless @apply
    return if @test_email.present?
    return if @confirm == CONFIRMATION

    raise "Refusing production send without CONFIRM=#{CONFIRMATION}"
  end

  def selected_member_filter?
    @member_email.present? || @member_dni.present?
  end

  def missing_member_message
    return "No active member with a contact email found for MEMBER_EMAIL=#{@member_email}" if @member_email

    "No active member found for MEMBER_DNI ending in #{Sjma::MemberAuth.dni_last4(@member_dni)}"
  end

  def users
    scope = active_members_scope.order(:id)

    return with_contact_email(scope).where(member_email_filter, @member_email, @member_email) if @member_email
    return scope.where(sjma_dni_digest: Sjma::MemberAuth.dni_digest(@member_dni)) if @member_dni
    return with_contact_email(scope) if @all_active

    with_contact_email(scope).where(sjma_must_change_password: true)
  end

  def active_members_scope
    Decidim::User.where(
      decidim_organization_id: @organization.id,
      type: "Decidim::User",
      managed: false,
      admin: false,
      deleted_at: nil,
      sjma_member_active: true
    ).where.not(sjma_dni_digest: nil)
  end

  def with_contact_email(scope)
    scope.where(
      "NULLIF(TRIM(extended_data->>'sjma_supabase_email'), '') IS NOT NULL OR (email IS NOT NULL AND email <> '' AND LOWER(email) NOT LIKE ?)",
      "%#{SYNTHETIC_EMAIL_DOMAIN}"
    )
  end

  def member_email_filter
    "LOWER(NULLIF(TRIM(extended_data->>'sjma_supabase_email'), '')) = ? OR LOWER(email) = ?"
  end

  def process_user(user)
    recipient = activation_recipient_email(user)
    unless recipient.present? || @test_email.present?
      record(user, "skipped", "missing contact email")
      return :skipped
    end

    unless @apply
      record(user, "dry_run", "would send activation link to #{recipient || @test_email}")
      return :dry_run
    end

    user.password = internal_password
    user.password_confirmation = user.password
    user.sjma_must_change_password = false if user.respond_to?(:sjma_must_change_password=)
    user.confirmed_at ||= Time.current if user.respond_to?(:confirmed_at=)
    user.save!

    token = user.send(:set_reset_password_token)
    delivered_to = @test_email.presence || recipient
    intended_recipient = recipient.presence || user.email
    Sjma::MemberActivationMailer.activation_instructions(
      user,
      token,
      delivered_to:,
      intended_recipient:,
      test_delivery: @test_email.present?
    ).deliver_now
    record(user, "sent", @test_email.present? ? "delivered to test email #{@test_email}; intended recipient #{intended_recipient}" : "delivered to #{delivered_to}")
    :sent
  end

  def activation_recipient_email(user)
    supabase_email = user.extended_data.to_h["sjma_supabase_email"].to_s.strip.downcase
    return supabase_email if supabase_email.present?

    email = user.email.to_s.strip.downcase
    return if email.blank? || email.end_with?(SYNTHETIC_EMAIL_DOMAIN)

    email
  end

  def internal_password
    "#{SecureRandom.base58(24)}aA8-"
  end

  def record(user, status, detail)
    @rows << {
      user_id: user&.id,
      member_number: user&.sjma_member_number,
      dni_last4: user&.sjma_dni_last4,
      email: user&.email,
      contact_email: user ? activation_recipient_email(user) : nil,
      status:,
      detail:
    }
  end

  def write_report
    FileUtils.mkdir_p(report_dir)
    path = report_dir.join("activation-links-#{Time.current.strftime("%Y%m%d%H%M%S")}.csv")
    CSV.open(path, "w", headers: @rows.first&.keys || %i[user_id member_number dni_last4 email status detail], write_headers: true) do |csv|
      @rows.each { |row| csv << row.values }
    end
    puts "Report written to #{path}"
  end

  def report_dir
    Rails.root.join("local", "member-activation")
  end
end

SjmaMemberActivationLinks.new.call
