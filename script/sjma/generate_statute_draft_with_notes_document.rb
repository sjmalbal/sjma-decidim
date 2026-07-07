# frozen_string_literal: true

require "cgi"
require "yaml"

ROOT = File.expand_path("../..", __dir__)
SOURCE_DIR = File.join(ROOT, "local/source-documents")
DRAFT_PATH = File.join(ROOT, "config/sjma_statute_draft_content.yml")
NOTES_PATH = File.join(ROOT, "config/sjma_statute_change_notes.yml")
OUTPUT_PATH = File.join(SOURCE_DIR, "esborrany-estatuts-amb-notes-sjma.html")

KIND_LABELS = {
  "addition" => "Addició",
  "deletion" => "Supressió",
  "modification" => "Modificació"
}.freeze

def escape_html(value)
  CGI.escapeHTML(value.to_s)
end

def text_blocks(value)
  value.to_s.split(/\n{2,}/).map(&:strip).reject(&:empty?)
end

def html_text(value, allow_change_marker: false)
  text_blocks(value).map do |block|
    escaped = escape_html(block)

    if allow_change_marker
      escaped = escaped
                .gsub('&lt;span class=&quot;sjma-change-marker&quot;&gt;', '<span class="sjma-change-marker">')
                .gsub("&lt;/span&gt;", "</span>")
    end

    "<p>#{escaped.gsub(/\n/, '<br>')}</p>"
  end.join("\n")
end

def note_text(note, key)
  note[key] || note[key.to_sym]
end

draft = YAML.safe_load(File.read(DRAFT_PATH), permitted_classes: [Time], aliases: true)
notes = YAML.safe_load(File.read(NOTES_PATH), permitted_classes: [Symbol], aliases: true)
records = draft.fetch("records")
notes_by_article = notes.fetch("articles", {})

article_count = records.count { |record| record.fetch("participatory_text_level") == "article" }
note_count = notes_by_article.values.sum(&:length)
exported_at = draft["exported_at"].to_s

content = records.map do |record|
  level = record.fetch("participatory_text_level")
  title = record.fetch("title")
  body = record.fetch("body").to_s

  case level
  when "section"
    <<~HTML
      <section class="statute-heading statute-heading--title">
        <h2>#{escape_html(title)}</h2>
      </section>
    HTML
  when "sub-section"
    normalized = title.downcase
    class_name = normalized.start_with?("secció", "seccio") ? "section" : "chapter"
    <<~HTML
      <section class="statute-heading statute-heading--#{class_name}">
        <h3>#{escape_html(title)}</h3>
      </section>
    HTML
  when "article"
    article_notes = Array(notes_by_article[title])
    notes_html = if article_notes.empty?
                   ""
                 else
                   items = article_notes.map do |note|
                     kind = note_text(note, "kind").to_s
                     label = KIND_LABELS.fetch(kind, "Canvi")
                     summary = note_text(note, "summary")
                     old_text = note_text(note, "old_text")
                     draft_text = note_text(note, "draft_text")

                     <<~HTML
                       <section class="change-note change-note--#{escape_html(kind.empty? ? 'change' : kind)}">
                         <div class="change-note__label">#{escape_html(label)}</div>
                         #{summary.to_s.empty? ? "" : %(<div class="change-note__summary">#{html_text(summary)}</div>)}
                         #{old_text.to_s.empty? ? "" : %(<div class="change-note__text"><strong>Text vigent afectat</strong>#{html_text(old_text)}</div>)}
                         #{draft_text.to_s.empty? ? "" : %(<div class="change-note__text"><strong>Text proposat</strong>#{html_text(draft_text)}</div>)}
                       </section>
                     HTML
                   end.join("\n")

                   <<~HTML
                     <aside class="change-notes">
                       <h4>Canvis respecte al text vigent</h4>
                       #{items}
                     </aside>
                   HTML
                 end

    <<~HTML
      <article class="statute-article">
        <h3>#{escape_html(title)}</h3>
        <div class="article-body">
          #{html_text(body, allow_change_marker: true)}
        </div>
        #{notes_html}
      </article>
    HTML
  else
    ""
  end
end.join("\n")

html = <<~HTML
  <!doctype html>
  <html lang="ca">
  <head>
    <meta charset="utf-8">
    <title>Esborrany d'Estatuts amb notes de canvi</title>
    <link rel="stylesheet" href="esborrany-estatuts-amb-notes-sjma.css">
  </head>
  <body>
    <table class="paged-document" aria-hidden="true">
      <thead>
        <tr>
          <td>
            <header class="document-header">
              <img src="sjma-doc-assets/logo-sjma-l-horizontal-blanc.svg" alt="Societat Joventut Musical d'Albal">
            </header>
          </td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <main>
              <section class="front-matter">
                <h1>Esborrany d'Estatuts amb notes de canvi</h1>
                <p class="lead">Societat Joventut Musical d'Albal. Modificació estatutària 2022-2026.</p>
                <p>Aquest document conté el text de l'esborrany d'Estatuts socials i les notes explicatives dels canvis respecte al text vigent. Els fragments marcats indiquen parts modificades o incorporades en l'esborrany.</p>
                <p>Per a presentar una esmena en paper, utilitzeu el model imprés disponible en la seu de la Societat, indiqueu l'article afectat i depositeu el formulari en la bústia de suggeriments dins del termini establit.</p>
                <p class="meta">Text exportat de la plataforma: #{escape_html(exported_at)}. Articles: #{article_count}. Notes de canvi: #{note_count}.</p>
              </section>
              #{content}
            </main>
          </td>
        </tr>
      </tbody>
    </table>
  </body>
  </html>
HTML

File.write(OUTPUT_PATH, html)

puts "Wrote #{OUTPUT_PATH}"
puts "Records: #{records.length}; articles: #{article_count}; notes: #{note_count}"
