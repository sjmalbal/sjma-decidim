# frozen_string_literal: true

module SjmaArticleAmendmentsOnlyPermissions
  private

  def can_create_amendment?
    if proposal&.component&.settings&.participatory_texts_enabled? &&
       proposal.participatory_text_level != "article"
      return toggle_allow(false)
    end

    super
  end
end

module SjmaArticleAmendmentsOnlyHelper
  def amend_button_for(amendable)
    if amendable.respond_to?(:participatory_text_level) &&
       amendable.component&.settings&.participatory_texts_enabled? &&
       amendable.participatory_text_level != "article"
      return
    end

    super
  end
end

Rails.application.config.to_prepare do
  unless Decidim::Proposals::Permissions.ancestors.include?(SjmaArticleAmendmentsOnlyPermissions)
    Decidim::Proposals::Permissions.prepend(SjmaArticleAmendmentsOnlyPermissions)
  end

  unless Decidim::AmendmentsHelper.ancestors.include?(SjmaArticleAmendmentsOnlyHelper)
    Decidim::AmendmentsHelper.prepend(SjmaArticleAmendmentsOnlyHelper)
  end
end
