# frozen_string_literal: true

module Sjma
  class MemberActivationMailer < Decidim::ApplicationMailer
    helper Decidim::ResourceHelper

    def activation_instructions(user, token, delivered_to: nil)
      @user = user
      @organization = user.organization
      @organization_name = translated_attribute(@organization.name)
      @token = token
      @delivered_to = delivered_to
      @activation_url = Decidim::Core::Engine.routes.url_helpers.edit_user_password_url(
        reset_password_token: @token,
        host: @organization.host,
        protocol: "https"
      )

      with_user(@user) do
        mail(
          to: delivered_to.presence || @user.email,
          subject: I18n.t("sjma.member_activation_mailer.activation_instructions.subject", organization: @organization_name)
        )
      end
    end

    private

    attr_reader :organization
  end
end
