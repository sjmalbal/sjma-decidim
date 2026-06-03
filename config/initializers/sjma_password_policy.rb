# frozen_string_literal: true

# Decidim defaults to 10 characters for normal users and uses a separate
# configurable minimum for admins. SJMA uses the same relaxed minimum for both.
module SjmaPasswordPolicy
  MINIMUM_LENGTH = 8

  def minimum_length_for(record)
    return Decidim.config.admin_password_min_length if record.try(:admin?) && Decidim.config.admin_password_strong

    MINIMUM_LENGTH
  end
end

Rails.application.config.to_prepare do
  PasswordValidator.singleton_class.prepend(SjmaPasswordPolicy) unless PasswordValidator.singleton_class.ancestors.include?(SjmaPasswordPolicy)
end
