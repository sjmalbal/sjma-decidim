# frozen_string_literal: true

SJMA_RESET_PASSWORD_WITHIN = 15.days

Devise.setup do |config|
  config.reset_password_within = SJMA_RESET_PASSWORD_WITHIN
end

Rails.application.config.to_prepare do
  next unless defined?(Decidim::User)
  next unless Decidim::User.respond_to?(:reset_password_within=)

  Decidim::User.reset_password_within = SJMA_RESET_PASSWORD_WITHIN
end
