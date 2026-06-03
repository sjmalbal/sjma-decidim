#!/usr/bin/env ruby
# frozen_string_literal: true

require "csv"
require "fileutils"
require "json"
require "net/http"
require "securerandom"
require "set"
require "uri"

class SupabaseMemberSync
  PAGE_SIZE = 1000

  def initialize
    @apply = ENV["APPLY"] == "true"
    @reset_passwords = ENV["RESET_TEMP_PASSWORDS"] == "true"
    @organization = Decidim::Organization.first!
    @credentials = []
    @seen_digests = Set.new
  end

  def call
    rows = fetch_rows
    stats = { created: 0, updated: 0, skipped: 0 }

    rows.each do |row|
      result = sync_row(row)
      stats[result] += 1
    rescue StandardError => e
      stats[:skipped] += 1
      warn "SKIP #{safe_row_reference(row)}: #{e.class}: #{e.message}"
    end

    write_credentials if @apply && @credentials.any?
    puts stats.inspect
    puts "DRY_RUN=true: no changes written" unless @apply
  end

  private

  def fetch_rows
    rows = []
    offset = 0

    loop do
      page = supabase_get(offset)
      rows.concat(page)
      break if page.length < PAGE_SIZE

      offset += PAGE_SIZE
    end

    rows
  end

  def supabase_get(offset)
    uri = URI("#{supabase_url}/rest/v1/#{table_name}")
    uri.query = URI.encode_www_form(
      select: selected_columns.join(","),
      limit: PAGE_SIZE,
      offset:
    )

    request = Net::HTTP::Get.new(uri)
    request["apikey"] = supabase_key
    request["Authorization"] = "Bearer #{supabase_key}"
    request["Accept"] = "application/json"
    request["Accept-Encoding"] = "identity"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    raise "Supabase HTTP #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def sync_row(row)
    dni = value(row, :dni)
    email = value(row, :email).to_s.strip.downcase
    dni_digest = Sjma::MemberAuth.dni_digest(dni)
    raise "missing DNI" if dni.blank?
    raise "duplicate DNI in Supabase result" if @seen_digests.include?(dni_digest)

    @seen_digests << dni_digest

    user = Decidim::User.find_or_initialize_by(
      decidim_organization_id: @organization.id,
      sjma_dni_digest: dni_digest
    )
    created = user.new_record?

    assign_member_attributes(user, row)

    if created || @reset_passwords
      password = generate_valid_password(user)
      user.password = password
      user.password_confirmation = password
      user.sjma_must_change_password = true
    end

    return created ? :created : :updated unless @apply

    user.save!
    @credentials << credential_row(user, row, password) if password.present?
    created ? :created : :updated
  end

  def assign_member_attributes(user, row)
    dni = value(row, :dni)
    member_number = value(row, :member_number)

    user.email = email_for(user, row)
    user[:name] = member_name(row)
    user.nickname = nickname_for(row) if user.nickname.blank?
    user.locale ||= "ca"
    user.tos_agreement = true if user.new_record? && user.respond_to?(:tos_agreement=)
    user.accepted_tos_version ||= @organization.tos_version if user.respond_to?(:accepted_tos_version=) && @organization.respond_to?(:tos_version)
    user.confirmed_at ||= Time.current
    user.sjma_dni_digest = Sjma::MemberAuth.dni_digest(dni)
    user.sjma_dni_last4 = Sjma::MemberAuth.dni_last4(dni)
    user.sjma_member_number = member_number if member_number.present?
    user.sjma_member_active = true
    user.sjma_synced_from_supabase_at = Time.current
    user.extended_data ||= {}
    user.extended_data["sjma_supabase_email"] = value(row, :email).to_s.strip.presence
    user.extended_data["sjma_supabase_member_id"] = member_number.to_s if member_number.present?
    user.extended_data["sjma_first_name"] = value(row, :first_name).to_s.strip.presence
    user.extended_data["sjma_last_name"] = value(row, :last_name).to_s.strip.presence
    user.extended_data["sjma_second_last_name"] = value(row, :second_last_name).to_s.strip.presence
  end

  def member_name(row)
    [value(row, :first_name), value(row, :last_name), value(row, :second_last_name)].compact_blank.join(" ").presence || "Soci SJMA"
  end

  def email_for(user, row)
    email = value(row, :email).to_s.strip.downcase
    return synthetic_email(row) if email.blank?

    owner = Decidim::UserBaseEntity.where(
      decidim_organization_id: @organization.id,
      email:
    ).where.not(id: user.id).first

    return email unless owner

    synthetic_email(row)
  end

  def synthetic_email(row)
    member_number = value(row, :member_number).presence || Sjma::MemberAuth.dni_last4(value(row, :dni))
    "soci-#{member_number.to_s.parameterize}@members.sjmalbal.com"
  end

  def nickname_for(row)
    base = value(row, :member_number).presence || "soci-#{Sjma::MemberAuth.dni_last4(value(row, :dni))}"
    Decidim::UserBaseEntity.nicknamize(base.to_s, @organization.id)
  end

  def credential_row(user, row, password)
    {
      member_number: user.sjma_member_number,
      dni_last4: user.sjma_dni_last4,
      email: user.email,
      name: member_name(row),
      first_name: value(row, :first_name).to_s.strip,
      last_name: value(row, :last_name).to_s.strip,
      second_last_name: value(row, :second_last_name).to_s.strip,
      temporary_password: password
    }
  end

  def write_credentials
    dir = Rails.root.join("local/member-sync")
    FileUtils.mkdir_p(dir)
    path = dir.join("credentials-#{Time.current.strftime("%Y%m%d%H%M%S")}.csv")

    CSV.open(path, "w", headers: @credentials.first.keys, write_headers: true) do |csv|
      @credentials.each { |row| csv << row.values }
    end

    puts "Credentials written to #{path}"
  end

  def generate_valid_password(user)
    100.times do
      password = generate_password
      user.password = password
      user.password_confirmation = password
      return password if user.valid?

      user.errors.clear
    end

    raise "could not generate a valid temporary password"
  end

  def generate_password
    # Avoid ambiguous characters when these credentials are sent manually.
    letters = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    digits = "23456789"
    symbols = "-_+"
    alphabet = letters + digits + symbols
    chars = [
      letters[SecureRandom.random_number(letters.length)],
      letters[SecureRandom.random_number(letters.length)],
      digits[SecureRandom.random_number(digits.length)],
      digits[SecureRandom.random_number(digits.length)],
      symbols[SecureRandom.random_number(symbols.length)]
    ]
    chars.concat(Array.new(11) { alphabet[SecureRandom.random_number(alphabet.length)] })
    chars.shuffle.join
  end

  def safe_row_reference(row)
    "#{value(row, :email)} / DNI ****#{Sjma::MemberAuth.dni_last4(value(row, :dni))}"
  end

  def value(row, key)
    row[column_for(key)]
  end

  def selected_columns
    column_names.values.uniq
  end

  def column_for(key)
    column_names.fetch(key)
  end

  def column_names
    @column_names ||= {
      dni: ENV.fetch("SUPABASE_SOCIOS_DNI_COLUMN", "soc_nif"),
      email: ENV.fetch("SUPABASE_SOCIOS_EMAIL_COLUMN", "soc_email"),
      name: ENV.fetch("SUPABASE_SOCIOS_NAME_COLUMN", "soc_nombre"),
      first_name: ENV.fetch("SUPABASE_SOCIOS_FIRST_NAME_COLUMN", "soc_nombre"),
      last_name: ENV.fetch("SUPABASE_SOCIOS_LAST_NAME_COLUMN", "soc_apellido1"),
      second_last_name: ENV.fetch("SUPABASE_SOCIOS_SECOND_LAST_NAME_COLUMN", "soc_apellido2"),
      member_number: ENV.fetch("SUPABASE_SOCIOS_MEMBER_NUMBER_COLUMN", "soc_id")
    }
  end

  def table_name
    ENV.fetch("SUPABASE_SOCIOS_TABLE", "socios")
  end

  def supabase_url
    return ENV["SUPABASE_URL"].delete_suffix("/") if ENV["SUPABASE_URL"].present?

    "https://#{ENV.fetch("SUPABASE_PROJECT_ID")}.supabase.co"
  end

  def supabase_key
    ENV.fetch("SUPABASE_SECRET_KEY")
  end
end

SupabaseMemberSync.new.call
