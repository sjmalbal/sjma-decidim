#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "zip"
require "nokogiri"
require "active_support/all"
require "i18n"

path = ARGV.fetch(0) do
  abort "Usage: ruby script/sjma/extract_statute_change_highlights.rb path/to/statutes.docx"
end

HIGHLIGHT_KIND = {
  "green" => "addition",
  "yellow" => "modification",
  "magenta" => "deletion",
  "red" => "deletion",
  "darkRed" => "deletion",
  "cyan" => "modification",
  "darkCyan" => "modification"
}.freeze

NS = {
  "w" => "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
}.freeze

def paragraph_text(paragraph)
  paragraph.xpath(".//w:t", NS).map(&:text).join.strip
end

def normalized_heading(text)
  I18n.transliterate(text.to_s.strip).upcase
end

def article_heading?(text)
  normalized = normalized_heading(text)
  normalized.start_with?("ARTICLE ") || normalized.start_with?("DISPOSICIO ")
end

def highlighted_runs(paragraph)
  paragraph.xpath(".//w:r", NS).filter_map do |run|
    text = run.xpath(".//w:t", NS).map(&:text).join
    next if text.blank?

    color = run.at_xpath("w:rPr/w:highlight", NS)&.[]("w:val")
    next if color.blank?

    {
      "kind" => HIGHLIGHT_KIND.fetch(color, "modification"),
      "source_color" => color,
      "text" => text
    }
  end
end

xml = Zip::File.open(path) { |zip| zip.read("word/document.xml") }
doc = Nokogiri::XML(xml)

current_article = nil
notes_by_article = Hash.new { |hash, key| hash[key] = [] }

doc.xpath("//w:p", NS).each do |paragraph|
  text = paragraph_text(paragraph)
  next if text.blank?

  if article_heading?(text)
    current_article = text
    next
  end

  next if current_article.blank?

  highlighted_runs(paragraph)
    .chunk_while { |previous, current| previous["kind"] == current["kind"] && previous["source_color"] == current["source_color"] }
    .each do |runs|
    run = runs.first
    notes_by_article[current_article] << {
      "kind" => run["kind"],
      "summary" => "Text ressaltat en #{File.basename(path)}.",
      "old_text" => "",
      "draft_text" => runs.pluck("text").join,
      "source_color" => run["source_color"]
    }
  end
end

puts({ "articles" => notes_by_article }.deep_stringify_keys.to_yaml)
