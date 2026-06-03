# frozen_string_literal: true

module SjmaStatuteChangeNotes
  CONFIG_PATH = Rails.root.join("config/sjma_statute_change_notes.yml")
  KIND_LABELS = {
    "addition" => "Addició",
    "deletion" => "Supressió",
    "modification" => "Modificació"
  }.freeze

  module_function

  def for_title(title)
    notes = data.fetch("articles", {})[title.to_s]
    Array(notes).select(&:present?)
  end

  def label_for(kind)
    KIND_LABELS.fetch(kind.to_s, "Canvi")
  end

  def class_for(kind)
    normalized = KIND_LABELS.key?(kind.to_s) ? kind.to_s : "change"
    "sjma-change-badge--#{normalized}"
  end

  def primary_kind(notes)
    kinds = Array(notes).map { |note| note["kind"] || note[:kind] }.map(&:to_s)

    return "modification" if kinds.include?("modification")
    return "addition" if kinds.include?("addition")
    return "deletion" if kinds.include?("deletion")

    "change"
  end

  def data
    return {} unless CONFIG_PATH.exist?

    if @data.nil? || @config_mtime != CONFIG_PATH.mtime
      @config_mtime = CONFIG_PATH.mtime
      @data = YAML.safe_load(CONFIG_PATH.read, permitted_classes: [Symbol], aliases: true) || {}
    end

    @data || {}
  end
end

module SjmaParticipatoryTextChangeNotesCell
  private

  def sjma_change_notes
    SjmaStatuteChangeNotes.for_title(translated_attribute(model.title))
  end

  def sjma_change_primary_kind
    SjmaStatuteChangeNotes.primary_kind(sjma_change_notes)
  end

  def sjma_change_kind_label(kind)
    SjmaStatuteChangeNotes.label_for(kind)
  end

  def sjma_change_kind_class(kind)
    SjmaStatuteChangeNotes.class_for(kind)
  end
end

Rails.application.config.to_prepare do
  cell_class = Decidim::Proposals::ParticipatoryTextProposalCell

  unless cell_class.ancestors.include?(SjmaParticipatoryTextChangeNotesCell)
    cell_class.prepend(SjmaParticipatoryTextChangeNotesCell)
  end
end
