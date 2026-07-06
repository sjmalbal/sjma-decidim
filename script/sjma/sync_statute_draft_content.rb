# frozen_string_literal: true

require "yaml"
require "set"

CONFIG_PATH = Rails.root.join("config/sjma_statute_draft_content.yml")
PROPOSAL_CLASS = "Decidim::Proposals::Proposal"
SYNC_LEVELS = %w[section sub-section article].freeze

def enabled?(name)
  ENV.fetch(name, "false").casecmp("true").zero?
end

def proposal_title(proposal, locale)
  proposal.title.to_h.fetch(locale, "")
end

def proposal_body(proposal, locale)
  proposal.body.to_h.fetch(locale, "")
end

def base_text_proposal?(proposal)
  SYNC_LEVELS.include?(proposal.participatory_text_level) &&
    !(proposal.respond_to?(:emendation?) && proposal.emendation?)
end

def load_config
  YAML.safe_load(CONFIG_PATH.read, permitted_classes: [Time], aliases: true)
end

def find_component(config)
  process = Decidim::ParticipatoryProcess.find_by!(slug: config.fetch("process_slug"))
  components = Decidim::Component.where(
    participatory_space: process,
    manifest_name: config.fetch("component_manifest_name")
  )

  components.find_by(id: config.fetch("component_id")) ||
    (components.one? ? components.first : raise("Cannot identify a single statute proposals component"))
end

def relation_count(model_name, conditions)
  return 0 unless model_name.safe_constantize

  model_name.constantize.where(conditions).count
end

def comment_count(proposal_ids)
  comment_class = "Decidim::Comments::Comment".safe_constantize
  return 0 unless comment_class

  commentable = comment_class.where(
    decidim_commentable_type: PROPOSAL_CLASS,
    decidim_commentable_id: proposal_ids
  )
  root_commentable = comment_class.where(
    decidim_root_commentable_type: PROPOSAL_CLASS,
    decidim_root_commentable_id: proposal_ids
  )

  commentable.or(root_commentable).count
end

def participation_counts(proposal_ids)
  return {} if proposal_ids.empty?

  {
    "amendments" => relation_count(
      "Decidim::Amendment",
      decidim_amendable_type: PROPOSAL_CLASS,
      decidim_amendable_id: proposal_ids
    ),
    "emendations" => relation_count(
      "Decidim::Amendment",
      decidim_emendation_type: PROPOSAL_CLASS,
      decidim_emendation_id: proposal_ids
    ),
    "comments" => comment_count(proposal_ids),
    "endorsements" => relation_count(
      "Decidim::Endorsement",
      resource_type: PROPOSAL_CLASS,
      resource_id: proposal_ids
    ),
    "votes" => relation_count(
      "Decidim::Proposals::ProposalVote",
      decidim_proposal_id: proposal_ids
    )
  }
end

def build_plan(component, records, locale)
  current = Decidim::Proposals::Proposal
            .where(component:)
            .order(:position, :id)
            .select { |proposal| base_text_proposal?(proposal) }

  by_id = current.index_by(&:id)
  by_title = current.group_by { |proposal| proposal_title(proposal, locale) }
  used_ids = Set.new
  changes = []
  unchanged = 0

  records.each do |record|
    proposal = by_id[record.fetch("source_id")]

    if proposal.nil?
      title_matches = Array(by_title[record.fetch("title")])
      proposal = title_matches.first if title_matches.one?
    end

    if proposal.nil?
      changes << ["create", nil, record]
      next
    end

    used_ids << proposal.id

    changed = proposal_title(proposal, locale) != record.fetch("title") ||
              proposal_body(proposal, locale) != record.fetch("body") ||
              proposal.participatory_text_level != record.fetch("participatory_text_level") ||
              proposal.position != record.fetch("position")

    if changed
      changes << ["update", proposal, record]
    else
      unchanged += 1
    end
  end

  target_source_ids = records.map { |record| record.fetch("source_id") }.to_set
  current.each do |proposal|
    next if used_ids.include?(proposal.id)
    next if target_source_ids.include?(proposal.id)

    changes << ["delete", proposal, nil]
  end

  matched_source_ids = records.count { |record| by_id.key?(record.fetch("source_id")) }

  [changes, unchanged, current.map(&:id), matched_source_ids]
end

def apply_change!(component, change, locale)
  action, proposal, record = change

  case action
  when "create"
    created = Decidim::Proposals::Proposal.new(
      component:,
      title: { locale => record.fetch("title") },
      body: { locale => record.fetch("body") },
      participatory_text_level: record.fetch("participatory_text_level"),
      position: record.fetch("position"),
      published_at: Time.current,
      created_in_meeting: false
    )
    created.coauthorships.build(
      decidim_author_id: component.organization.id,
      decidim_author_type: "Decidim::Organization"
    )
    created.save!
  when "update"
    proposal.update!(
      title: proposal.title.to_h.merge(locale => record.fetch("title")),
      body: proposal.body.to_h.merge(locale => record.fetch("body")),
      participatory_text_level: record.fetch("participatory_text_level"),
      position: record.fetch("position")
    )
  when "delete"
    proposal.destroy!
  else
    raise "Unknown sync action: #{action}"
  end
end

apply = enabled?("APPLY_STATUTE_DRAFT_CONTENT") || enabled?("APPLY")
allow_published_change = enabled?("ALLOW_PUBLISHED_STATUTE_CONTENT_CHANGE")

config = load_config
locale = config.fetch("locale")
records = config.fetch("records")
component = find_component(config)

changes, unchanged, current_ids, matched_source_ids = build_plan(component, records, locale)
minimum_matches = (records.length * 0.75).floor

if matched_source_ids < minimum_matches && !enabled?("ALLOW_LOW_MATCH_STATUTE_SYNC")
  raise "Refusing statute content sync: only #{matched_source_ids}/#{records.length} source ids match"
end

counts = participation_counts(current_ids)
participation_total = counts.values.sum

puts "Statute draft content sync: #{apply ? "APPLY" : "DRY-RUN"}"
puts "Component: #{component.id} #{component.name.to_h.fetch(locale, component.name)}"
puts "Records: #{records.length}; unchanged: #{unchanged}; pending changes: #{changes.length}"
puts "Participation counts: #{counts.inspect}"

changes.each do |action, proposal, record|
  label = record&.fetch("title", nil) || proposal_title(proposal, locale)
  puts "- #{action}: #{proposal&.id || "new"} #{label}"
end

if apply && changes.any? && participation_total.positive? && !allow_published_change
  raise "Refusing to change statute content because participation already exists; set ALLOW_PUBLISHED_STATUTE_CONTENT_CHANGE=true to override"
end

if apply
  Decidim::Proposals::Proposal.transaction do
    changes.each { |change| apply_change!(component, change, locale) }
  end
  puts "Applied #{changes.length} statute draft content changes"
else
  puts "Dry-run only; set APPLY_STATUTE_DRAFT_CONTENT=true to write changes"
end
