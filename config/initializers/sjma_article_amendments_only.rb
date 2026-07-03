# frozen_string_literal: true

module SjmaArticleAmendmentsOnlyPermissions
  private

  def can_create_amendment?
    if proposal&.component&.settings&.participatory_texts_enabled? &&
       !sjma_statute_amendable_article?(proposal)
      return toggle_allow(false)
    end

    super
  end

  def sjma_statute_amendable_article?(resource)
    return false unless resource&.respond_to?(:participatory_text_level)
    return false unless resource.participatory_text_level == "article"

    title = resource.title
    raw_title = title.respond_to?(:values) ? title.values.compact.first.to_s : title.to_s
    I18n.transliterate(raw_title).strip.downcase.start_with?("article ")
  end
end

module SjmaArticleAmendmentsOnlyHelper
  def amend_button_for(amendable)
    if amendable.respond_to?(:participatory_text_level) &&
       amendable.component&.settings&.participatory_texts_enabled? &&
       !sjma_statute_amendable_article?(amendable)
      return
    end

    super
  end

  private

  def sjma_statute_amendable_article?(resource)
    return false unless resource.respond_to?(:participatory_text_level)
    return false unless resource.participatory_text_level == "article"

    title = resource.title
    raw_title = title.respond_to?(:values) ? title.values.compact.first.to_s : title.to_s
    I18n.transliterate(raw_title).strip.downcase.start_with?("article ")
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
