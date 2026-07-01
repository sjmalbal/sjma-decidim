#!/usr/bin/env ruby
# frozen_string_literal: true

COMPONENT_ID = ENV.fetch("DECIDIM_PROPOSALS_COMPONENT_ID", "7")
LOCALE = "ca"
ARTICLE_TITLE = "Article 3. De l’activitat i dels fins de la Societat"

ARTICLE_BODY = <<~HTML.strip
  La Societat és una entitat sense ànim de lucre de naturalesa cultural.

  La Societat tindrà per objecte o finalitat promoure, fomentar i difondre
  la música i la cultura, procurant la formació cultural de les Persones
  Associades, del veïnat i de la ciutadania en general, així com
  organitzar i programar projectes per a la formació de la joventut i la
  seua educació integral; en especial i principalment, mitjançant
  l’ensenyança de la música i la formació musical.

  A aquestos efectes, realitzarà totes aquelles activitats que fomenten
  aspectes culturals, artístics i recreatius, i de manera particular les
  següents:

  a) <span class="sjma-change-marker">Amb caràcter prioritari, la promoció i difusió de la música per mitjà de les Agrupacions artístiques, especialment de la Banda Simfònica, i de l'Escola. Podrà crear conjunts instrumentals i vocals de qualsevol tipus, i organitzar concerts, festivals, certàmens i audicions de qualsevol classe.</span>

  b) <span class="sjma-change-marker">La promoció i foment de les arts escèniques, plàstiques i literàries mitjançant la programació d'exposicions, mostres, representacions teatrals, cinematogràfiques, conferències, seminaris i biblioteques, etc. Podrà ampliar els ensenyaments de l'Escola a altres disciplines artístiques, especialment la dansa i les arts escèniques.</span>

  c) Proveirà d’esbarjo i esplai a les seues Persones Associades
  mitjançant les adequades activitats per a l’oci i diversió
  d’aquestes.
HTML

def normalized_title(value)
  I18n.transliterate(ActionView::Base.full_sanitizer.sanitize(value.to_s)).squish.downcase
end

component = Decidim::Component.find(COMPONENT_ID)
target_title = normalized_title(ARTICLE_TITLE)

proposal = Decidim::Proposals::Proposal
           .where(component:, participatory_text_level: "article")
           .detect { |candidate| normalized_title(candidate.title[LOCALE] || candidate.title.values.first) == target_title }

raise "Article proposal not found: #{ARTICLE_TITLE}" unless proposal

proposal.body = proposal.body.merge(LOCALE => ARTICLE_BODY)
proposal.save!

puts "Updated proposal ##{proposal.id}: #{ARTICLE_TITLE}"
