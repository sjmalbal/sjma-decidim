# frozen_string_literal: true

module SjmaDniLoginLookup
  def find_for_authentication(warden_conditions)
    organization = warden_conditions.dig(:env, "decidim.current_organization")
    login = warden_conditions[:email].to_s
    admin_login = sjma_admin_login?(warden_conditions)

    if admin_login
      user = super
      return user if user&.admin?

      return
    end

    if organization && Sjma::MemberAuth.dni_like?(login)
      user = find_by(
        decidim_organization_id: organization.id,
        sjma_dni_digest: Sjma::MemberAuth.dni_digest(login),
        sjma_member_active: true
      )
      return user if user
    end

    nil
  end

  private

  def sjma_admin_login?(warden_conditions)
    params = warden_conditions.dig(:env, "action_dispatch.request.parameters") || {}
    ActiveModel::Type::Boolean.new.cast(params["admin_login"])
  end
end

module SjmaRequirePasswordChange
  extend ActiveSupport::Concern

  included do
    before_action :sjma_redirect_to_password_change
  end

  private

  def sjma_redirect_to_password_change
    return unless respond_to?(:current_user, true)
    return unless current_user&.respond_to?(:sjma_must_change_password?)
    return unless current_user.sjma_must_change_password?
    return unless request.format.html?
    return if sjma_password_change_allowed_path?

    redirect_to decidim.change_password_path, alert: I18n.t("sjma.member_auth.must_change_password")
  end

  def sjma_password_change_allowed_path?
    request.path.start_with?(
      "/change_password",
      "/apply_password",
      "/users/sign_out",
      "/decidim-packs",
      "/assets",
      "/rails/active_storage"
    )
  end
end

module SjmaClearPasswordChangeFlag
  private

  def update_password
    password_was_blank = form.current_user.encrypted_password.blank?

    super

    return if form.password.blank?

    form.current_user.sjma_must_change_password = false if form.current_user.respond_to?(:sjma_must_change_password=)
    form.current_user.password_updated_at = Time.current if password_was_blank
  end
end

module SjmaMemberPasswordChange
  def change_password
    if current_user&.respond_to?(:sjma_must_change_password?) && current_user.sjma_must_change_password?
      self.resource = current_user
      @send_path = apply_password_path
      flash.now[:secondary] = I18n.t("sjma.member_auth.password_change_body")
      render "decidim/devise/passwords/member_first_change"
    else
      super
    end
  end

  def apply_password
    self.resource = current_user
    @send_path = apply_password_path

    @form = Decidim::PasswordForm.from_params(params["user"]).with_context(current_user:)
    Decidim::UpdatePassword.call(@form) do
      on(:ok) do
        current_user.update!(sjma_must_change_password: false) if current_user.respond_to?(:sjma_must_change_password=)
        flash[:notice] = I18n.t("sjma.member_auth.password_changed")
        bypass_sign_in(current_user)
        redirect_to decidim.root_path
      end

      on(:invalid) do
        flash.now[:alert] = I18n.t("passwords.update.error", scope: "decidim")
        resource.errors.errors.concat(@form.errors.errors)
        template = if current_user&.respond_to?(:sjma_must_change_password?) && current_user.sjma_must_change_password?
                     "decidim/devise/passwords/member_first_change"
                   else
                     "edit"
                   end
        render template
      end
    end
  end
end

Rails.application.config.to_prepare do
  unless Decidim::User.singleton_class.ancestors.include?(SjmaDniLoginLookup)
    Decidim::User.singleton_class.prepend(SjmaDniLoginLookup)
  end

  unless Decidim::ApplicationController.ancestors.include?(SjmaRequirePasswordChange)
    Decidim::ApplicationController.include(SjmaRequirePasswordChange)
  end

  unless Decidim::UpdateAccount.ancestors.include?(SjmaClearPasswordChangeFlag)
    Decidim::UpdateAccount.prepend(SjmaClearPasswordChangeFlag)
  end

  unless Decidim::Devise::PasswordsController.ancestors.include?(SjmaMemberPasswordChange)
    Decidim::Devise::PasswordsController.prepend(SjmaMemberPasswordChange)
  end
end
