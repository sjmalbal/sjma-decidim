# frozen_string_literal: true

module SjmaChangeMarkerCleaner
  MARKER_SELECTORS = "span.sjma-change-marker, span.mark, mark.sjma-change-marker, mark.mark"

  module_function

  def unwrap(value)
    return value unless value.is_a?(String)
    return value unless value.include?("sjma-change-marker") || value.include?("class=\"mark\"") || value.include?("class='mark'")

    fragment = Nokogiri::HTML.fragment(value)
    fragment.css(MARKER_SELECTORS).each do |node|
      node.replace(node.children)
    end
    fragment.to_html
  end

  def unwrap_translated(value)
    return value.transform_values { |subvalue| unwrap_translated(subvalue) } if value.is_a?(Hash)

    unwrap(value)
  end

  def clean_emendation_params(params)
    return params unless params.respond_to?(:with_indifferent_access)

    cleaned = params.with_indifferent_access
    cleaned[:body] = unwrap(cleaned[:body]) if cleaned.key?(:body)
    cleaned
  end

  def clean_amendable_params(params)
    return params unless params.respond_to?(:with_indifferent_access)

    cleaned = params.with_indifferent_access
    cleaned[:body] = unwrap_translated(cleaned[:body]) if cleaned.key?(:body)
    cleaned
  end
end

module SjmaCleanChangeMarkersForAmendmentForms
  def amendments_form_fields_value(original_resource, attribute)
    value = super
    return value unless attribute.to_sym == :body

    SjmaChangeMarkerCleaner.unwrap(value)
  end
end

module SjmaCleanChangeMarkersForAmendmentParams
  def amendable_params
    original = super
    cleaned = SjmaChangeMarkerCleaner.clean_amendable_params(original)
    self.amendable_params = cleaned if cleaned != original
    cleaned
  end

  def amendable_params=(params)
    super(SjmaChangeMarkerCleaner.clean_amendable_params(params))
  end

  def emendation_params
    original = super
    cleaned = SjmaChangeMarkerCleaner.clean_emendation_params(original)
    self.emendation_params = cleaned if cleaned != original
    cleaned
  end

  def emendation_params=(params)
    super(SjmaChangeMarkerCleaner.clean_emendation_params(params))
  end
end

module SjmaCleanChangeMarkersForAmendmentComparison
  private

  def normalized_body(resource)
    SjmaChangeMarkerCleaner.unwrap(super)
  end
end

module SjmaCleanChangeMarkersForProposalDiff
  private

  def parse_i18n_changeset(attribute, values, type, diff)
    values = values.map { |value| SjmaChangeMarkerCleaner.unwrap_translated(value) } if attribute.to_sym == :body

    super(attribute, values, type, diff)
  end
end

Rails.application.config.to_prepare do
  unless Decidim::AmendmentsHelper.ancestors.include?(SjmaCleanChangeMarkersForAmendmentForms)
    Decidim::AmendmentsHelper.prepend(SjmaCleanChangeMarkersForAmendmentForms)
  end

  unless Decidim::Amendable::Form.ancestors.include?(SjmaCleanChangeMarkersForAmendmentComparison)
    Decidim::Amendable::Form.prepend(SjmaCleanChangeMarkersForAmendmentComparison)
  end

  [
    Decidim::Amendable::CreateForm,
    Decidim::Amendable::EditForm,
    Decidim::Amendable::PublishForm,
    Decidim::Amendable::PromoteForm,
    Decidim::Amendable::ReviewForm
  ].each do |form_class|
    unless form_class.ancestors.include?(SjmaCleanChangeMarkersForAmendmentParams)
      form_class.prepend(SjmaCleanChangeMarkersForAmendmentParams)
    end
  end

  unless Decidim::Proposals::DiffRenderer.ancestors.include?(SjmaCleanChangeMarkersForProposalDiff)
    Decidim::Proposals::DiffRenderer.prepend(SjmaCleanChangeMarkersForProposalDiff)
  end
end
