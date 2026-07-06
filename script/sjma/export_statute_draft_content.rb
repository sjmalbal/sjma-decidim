# frozen_string_literal: true

require "yaml"
require "time"

PROCESS_SLUG = ENV.fetch("PROCESS_SLUG", "modificacio-estatutaria-2022-2026")
COMPONENT_ID = ENV.fetch("COMPONENT_ID", "7").to_i
LOCALE = ENV.fetch("LOCALE", "ca")
OUTPUT_PATH = Rails.root.join("config/sjma_statute_draft_content.yml")
PROPOSAL_CLASS = "Decidim::Proposals::Proposal"

process = Decidim::ParticipatoryProcess.find_by!(slug: PROCESS_SLUG)
component = Decidim::Component.find_by!(
  id: COMPONENT_ID,
  participatory_space: process,
  manifest_name: "proposals"
)

records = Decidim::Proposals::Proposal
          .where(component:)
          .where.not(participatory_text_level: nil)
          .order(:position, :id)
          .reject { |proposal| proposal.respond_to?(:emendation?) && proposal.emendation? }
          .map do |proposal|
            {
              "source_id" => proposal.id,
              "position" => proposal.position,
              "participatory_text_level" => proposal.participatory_text_level,
              "title" => proposal.title.fetch(LOCALE, ""),
              "body" => proposal.body.fetch(LOCALE, "")
            }
          end

data = {
  "process_slug" => PROCESS_SLUG,
  "component_id" => component.id,
  "component_manifest_name" => component.manifest_name,
  "locale" => LOCALE,
  "exported_at" => Time.current.utc.iso8601,
  "records" => records
}

File.write(OUTPUT_PATH, YAML.dump(data))

puts "Wrote #{records.length} statute draft content records to #{OUTPUT_PATH}"
