# frozen_string_literal: true

# SJMA member registration is handled outside Decidim. This platform only
# accepts existing users imported from the members registry.
module SjmaExistingUsersOnly
  def sign_up_enabled?
    false
  end
end

module SjmaDisableRegistrationsController
  def new
    redirect_to new_user_session_path, alert: I18n.t("sjma.member_auth.registration_disabled")
  end

  def create
    redirect_to new_user_session_path, alert: I18n.t("sjma.member_auth.registration_disabled")
  end
end

module SjmaDisableOmniauthRegistrationsController
  def create
    redirect_to new_user_session_path, alert: I18n.t("sjma.member_auth.registration_disabled")
  end
end

Rails.application.config.to_prepare do
  unless Decidim::Organization.ancestors.include?(SjmaExistingUsersOnly)
    Decidim::Organization.prepend(SjmaExistingUsersOnly)
  end

  unless Decidim::Devise::RegistrationsController.ancestors.include?(SjmaDisableRegistrationsController)
    Decidim::Devise::RegistrationsController.prepend(SjmaDisableRegistrationsController)
  end

  if defined?(Decidim::Devise::OmniauthRegistrationsController) &&
     !Decidim::Devise::OmniauthRegistrationsController.ancestors.include?(SjmaDisableOmniauthRegistrationsController)
    Decidim::Devise::OmniauthRegistrationsController.prepend(SjmaDisableOmniauthRegistrationsController)
  end
end
