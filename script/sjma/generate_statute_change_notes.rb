#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "i18n"

OCR_PATH = Rails.root.join(".analysis/original_ocr/estatuts-originals-ocr.txt")
OUTPUT_PATH = Rails.root.join("config/sjma_statute_change_notes.yml")

OLD_ARTICLE_MAP = {
  1 => [1],
  2 => [2],
  3 => [3],
  4 => [4],
  5 => [5],
  6 => [6],
  7 => [61],
  8 => [8, 9, 10],
  9 => [11],
  10 => [12, 13],
  11 => [14],
  12 => [15],
  13 => [15],
  14 => [16, 17],
  15 => [18],
  16 => [19],
  17 => [20],
  18 => [21],
  19 => [21],
  20 => [21],
  21 => [22],
  22 => [23],
  23 => [24],
  24 => [24],
  25 => [25],
  26 => [29],
  27 => [25, 27],
  28 => [26],
  29 => [27],
  30 => [26],
  31 => [25],
  32 => [30],
  33 => [31],
  34 => [32],
  35 => [33],
  36 => [33],
  37 => [34],
  38 => [35],
  39 => [28],
  43 => [37],
  44 => [28],
  53 => [44, 47, 48, 49, 50],
  56 => [46],
  58 => [51],
  59 => [44, 45],
  61 => [39, 40],
  63 => [41],
  64 => [43],
  65 => [42],
  68 => [7],
  75 => [59],
  76 => [38],
  77 => [14],
  78 => [14, 58, 60],
  90 => [57],
  92 => [52],
  94 => [53],
  95 => [54],
  96 => [53],
  97 => [55],
  98 => [56],
  99 => [55, 56],
  103 => [61],
  104 => [62]
}.freeze

ARTICLE_JUSTIFICATIONS = {
  5 => "actualitza la identificació del domicili social i deixa el redactat adaptat a la ubicació real de la Societat.",
  7 => "separa la durada indefinida de la regulació detallada de la dissolució, que es reordena en el títol final perquè siga més fàcil de localitzar.",
  8 => "simplifica les classes de socis, adapta la terminologia a Persones Associades i Joventuts, i concentra en un mateix article les regles bàsiques del llibre registre.",
  9 => "substitueix les categories honorífiques/protectores antigues per un sistema més flexible de mencions, col·laboració, patrocini i mecenatge.",
  10 => "manté el procediment d'ingrés, però ajusta els terminis i la suspensió d'admissions al calendari electoral perquè no afecte indegudament les votacions.",
  11 => "actualitza les causes de baixa i pèrdua de la condició de Persona Associada i les adapta al nou règim disciplinari dels estatuts.",
  14 => "reformula els deures de les persones associades amb llenguatge actual, perspectiva inclusiva i coherència amb la nova estructura d'obligacions socials.",
  31 => "reordena la composició de la Junta Directiva, elimina figures antigues poc adaptades al funcionament actual i permet assessors amb veu i sense vot.",
  32 => "trasllada la delegació de facultats a un article orgànic propi de la Junta Directiva, on encaixa millor dins del règim de funcionament intern.",
  33 => "actualitza les funcions de la Presidència per adaptar-les al model de confiança presidencial i a la distribució actual de responsabilitats.",
  34 => "ordena les funcions de la Vicepresidència i supletorietats per donar resposta a absències, delegacions i organització interna.",
  35 => "reordena les funcions de la Secretaria i les adapta a les obligacions documentals, registrals i de comunicació actuals.",
  36 => "introdueix la Vicesecretaria per donar continuïtat i suport a les funcions documentals i administratives.",
  37 => "actualitza les funcions de Tresoreria i les vincula a pressupostos, comptabilitat i control econòmic.",
  38 => "defineix millor el paper de les Vocalies dins d'una Junta Directiva més flexible i distribuïda.",
  39 => "actualitza el règim de reunions de la Junta Directiva, incloent formes de convocatòria i funcionament més adaptades a la pràctica actual.",
  41 => "preveu escenaris sense candidatures o amb òrgans provisionals, una situació que els estatuts vigents no regulaven amb prou detall.",
  42 => "reforça la responsabilitat de la Junta Directiva davant l'Assemblea General i ordena el control polític de la seua gestió.",
  45 => "crea un espai específic de participació dels músics perquè les qüestions artístiques tinguen un canal propi dins de la Societat.",
  46 => "atribueix funcions concretes a les Assemblees de Músics per ordenar consultes, dictàmens i participació artística.",
  47 => "regula el funcionament pràctic de les Assemblees de Músics perquè les convocatòries, sessions i votacions siguen previsibles.",
  48 => "dona forma jurídica als dictàmens de l'Assemblea de Músics i clarifica el seu valor davant la Junta Directiva.",
  49 => "introdueix Persones Delegades per coordinar millor les agrupacions artístiques i canalitzar la relació amb la Direcció i la Junta Directiva.",
  50 => "detalla funcions de coordinació, control d'assistència i comunicació de les Persones Delegades.",
  51 => "incorpora una definició expressa de l'Arxiu de la Societat per protegir i ordenar el seu patrimoni documental i musical.",
  52 => "desenvolupa la conservació i gestió de l'Arxiu com una responsabilitat pròpia i no només accessòria.",
  53 => "actualitza la regulació dels músics i la seua participació en les agrupacions artístiques.",
  54 => "crea el concepte d'exercici artístic per ordenar la planificació anual de l'activitat musical.",
  55 => "diferencia les Direccions tècnic-artístiques del govern associatiu i defineix millor la seua relació amb la Junta Directiva.",
  56 => "actualitza les funcions de les Direccions tècnic-artístiques i les amplia amb planificació i memòria anual.",
  57 => "regula el dipòsit d'instruments i béns artístics de la Societat per donar seguretat sobre el seu ús i conservació.",
  61 => "reordena la regulació de l'Escola de Música i la connecta amb els òrgans de govern i la normativa aplicable.",
  62 => "introdueix l'Equip Directiu de l'Escola per reflectir millor la seua gestió real.",
  68 => "actualitza les obligacions comptables i documentals a la normativa vigent i a una gestió més transparent.",
  69 => "incorpora la gestió dels sistemes d'informació per assegurar la continuïtat entre juntes i evitar pèrdua d'accessos o documentació.",
  70 => "ordena la publicitat dels actes dels òrgans socials perquè les persones associades tinguen informació accessible.",
  71 => "afegeix un règim de transparència coherent amb una entitat associativa que gestiona recursos i decisions col·lectives.",
  72 => "incorpora una regulació bàsica de protecció de dades personals adaptada a la normativa actual.",
  73 => "reconeix el dret d'accés a la informació social i el canalitza de manera ordenada.",
  74 => "afegeix principis de bon govern per orientar la gestió interna i prevenir conflictes d'interés.",
  75 => "reordena els recursos interns i evita una remissió genèrica al règim federatiu quan és preferible una regulació pròpia.",
  76 => "clarifica la impugnació per via jurisdiccional i la relació entre acords socials i control judicial.",
  77 => "actualitza la responsabilitat disciplinària i la vincula al nou règim de faltes, sancions i procediment.",
  78 => "estableix principis generals del règim disciplinari per garantir seguretat jurídica, audiència i proporcionalitat.",
  79 => "classifica les faltes per donar una base clara a l'aplicació del règim disciplinari.",
  80 => "defineix les faltes molt greus per evitar que les sancions més severes depenguen d'una regulació genèrica.",
  81 => "defineix les faltes greus i diferencia millor els incompliments segons la seua intensitat.",
  82 => "defineix les faltes lleus per graduar la resposta disciplinària de manera proporcional.",
  83 => "concreta les sancions per faltes molt greus.",
  84 => "concreta les sancions per faltes greus.",
  85 => "concreta les sancions per faltes lleus.",
  86 => "afegeix criteris de graduació perquè les sancions siguen proporcionades a cada cas.",
  87 => "regula la prescripció de faltes i sancions per donar seguretat temporal al règim disciplinari.",
  88 => "estableix un règim específic per a les persones que composen la Junta Directiva, atenent a la seua responsabilitat orgànica.",
  89 => "preveu un reglament del procediment sancionador per desenvolupar garanties i tramitació.",
  90 => "actualitza la responsabilitat patrimonial de la Societat i de les Persones Associades.",
  92 => "reordena la regulació del patrimoni inicial dins del bloc econòmic.",
  94 => "actualitza els recursos econòmics i els adapta a la realitat de finançament de la Societat.",
  95 => "manté el principi de destinació social dels beneficis i l'adapta al nou redactat.",
  97 => "ordena els pressupostos ordinaris i el calendari d'aprovació.",
  98 => "diferencia els pressupostos extraordinaris per a necessitats no ordinàries.",
  99 => "reforça el control financer i la rendició de comptes davant l'Assemblea.",
  100 => "introdueix un procediment específic de modificació estatutària perquè els canvis futurs tinguen un marc clar.",
  101 => "regula la presentació i tramitació d'esmenes per facilitar una deliberació ordenada de les persones associades.",
  102 => "ordena la votació de les esmenes i del text final per evitar confusió entre debat parcial i aprovació global.",
  103 => "trasllada i actualitza les causes de dissolució al títol final, on encaixen sistemàticament millor.",
  104 => "actualitza la liquidació i el destí dels béns perquè siga coherent amb la normativa i amb la finalitat social de l'entitat."
}.freeze

DELETION_NOTES = {
  31 => [
    {
      "old_refs" => [36],
      "summary" => "Justificació: se suprimeix la figura específica de l'Ajustador perquè les seues funcions es redistribueixen dins d'una organització artística i directiva més clara."
    }
  ],
  9 => [
    {
      "old_refs" => [11],
      "summary" => "Justificació: se suprimeix la categoria separada de Socis Protectors perquè la col·laboració econòmica o institucional passa a regular-se amb fórmules més flexibles de patrocini, mecenatge o conveni.",
      "old_text" => <<~TEXT.strip
        Serán Socios Protectores los que, con tal carácter lo soliciten de la Asociación contribuyendo al
        sostenimiento material de la misma, sin tomar parte en la vida activa de la Entidad.
        Los Socios Honorarios y Protectores no podrán ser electores ni elegibles, y carecerán de voto
        en las Asambleas Generales de la Asociación.
      TEXT
    }
  ],
  75 => [
    {
      "old_refs" => [60],
      "summary" => "Justificació: se suprimeix la remissió genèrica al règim sancionador federatiu perquè el nou text incorpora una regulació pròpia de recursos i disciplina interna."
    }
  ]
}.freeze

STRUCTURAL_HEADING_PATTERN = /\b(?:CAP[IÍ]TULO|T[IÍ]TULO)\b/i

def normalize_ocr(text)
  normalized = text
    .gsub(/\r\n?/, "\n")
    .gsub(/^===== PAGE \d+ =====\n?/i, "")
    .gsub(/[ \t]+/, " ")
    .gsub(/\n{3,}/, "\n\n")
    .strip

  lines = normalized.lines.map(&:strip)
  structural_index = lines.find_index { |line| line.match?(STRUCTURAL_HEADING_PATTERN) }
  lines = lines.first(structural_index) if structural_index

  cleaned_lines = lines
    .filter_map { |line| clean_ocr_line(line) }

  postprocess_ocr_text(reflow_ocr_lines(cleaned_lines))
    .gsub(/\n{3,}/, "\n\n")
    .strip
end

def postprocess_ocr_text(text)
  text
    .gsub(/\s+ES\s+3\b/i, "")
    .gsub(/\bPodrá También\b/, "Podrá también")
    .gsub(/\bcon voz [o0] y Sin voto\.\s+E\s+39\s+Los\b/i, "con voz y sin voto. Los")
    .gsub(/\bcon voz [o0] y Sin voto\b/i, "con voz y sin voto")
end

def reflow_ocr_lines(lines)
  paragraphs = []
  current = nil

  lines.each do |line|
    if current.blank? || starts_ocr_paragraph?(line)
      paragraphs << current if current.present?
      current = line
    else
      current = current.end_with?("-") ? "#{current.delete_suffix("-")}#{line}" : "#{current} #{line}"
    end
  end

  paragraphs << current if current.present?
  paragraphs.join("\n\n")
end

def starts_ocr_paragraph?(line)
    line.match?(/\AArt[ií]culo\s+\d+/i) ||
    line.match?(/\A\d+[ªº"%]*\.-/) ||
    line.match?(/\A[a-z]\)/i) ||
    line.match?(/\A(?:Esta Asociación|La Asamblea|También,|Deberá|En el propio|Todos los miembros|No obstante|Contra el acuerdo|El acuerdo|El cargo|El Archivero)\b/i)
end

def clean_ocr_line(line)
  line = line.to_s.strip
  return nil if line.blank?
  return nil if line.match?(/\A===== PAGE \d+ =====\z/i)

  line = line.sub(/\A.*?(Art[ií]culo\s+\d+\s*\.?-?)/i, "\\1") if line.match?(/Art[ií]culo\s+\d+/i)
  line = line.sub(/\A[|>\\\/=_—\-.,;:ºª"“”*\s]+/, "").strip
  line = line.sub(/\Ay\s+Zo\s+NE74\s+3\s+/i, "a) ")
  line = line.sub(/\AN\s+(b\))/i, "\\1")
  line = line.sub(/\A€\)/, "e)")
  line = line.sub(/\A1\)/, "f)")
  line = line.sub(/\A8\)/, "g)")
  line = line.sub(/\AE\s+(Ser[aá]n\s+Socios\s+Protectores)/i, "\\1")
  line = line.sub(/\Asereunir[aá]/i, "se reunirá")
  line = line.sub(/\AUD\s+(del\s+D[ií]a)/i, "\\1")
  line = line.sub(/\ANV,\s*/i, "a) ")
  line = line.sub(/\Ae\)\s+(Aprobar las cuentas)/i, "c) \\1")
  line = line.sub(/\Ay\s+(Asamblea General)/i, "\\1")
  line = line.sub(/\A5%.-/, "5ª.-")
  line = line.sub(/\AL\s+(de inocencia)/i, "\\1")
  line = line.sub(/\A[ÚU]\s*;\s*3\s+(El acuerdo)/i, "\\1")
  line = line.sub(/\AYo\s+(motivada)/i, "\\1")
  line = line.sub(/\AAE\s+ar\s+acuerdo/i, "Contra el acuerdo")
  line = line.sub(/\AA\s+(declaración)/i, "\\1")
  line = line.sub(/\AY\s+(representación)/i, "\\1")
  line = line.sub(/\AAN\s+(domicilio)/i, "\\1")
  line = line.sub(/\Adas\s+[“\"]?mínimo/i, "mínimo")
  line = line.sub(/\Aa\s+(gestión y administración)/i, "\\1")
  line = line.sub(/\ADs\s+\.,?\s*(ambién designar)/i, "T\\1")
  line = line.sub(/\A3\s+E\s+¿?(Los miembros)/i, "\\1")
  line = line.sub(/\ALes\s+as\s+E\.\s+(gratuitamente)/i, "\\1")
  line = line.sub(/\Ao obstante/i, "No obstante")
  line = line.sub(/\ANe\s+(d\))/i, "\\1")
  line = line.sub(/\ABets\s+(e\))/i, "\\1")
  line = line.sub(/\AE\s+\|\s+5\s+(6["*ªº]?\.-)/i, "\\1")
  line = line.sub(/\s+ES\s+3\z/i, "")
  line = line.sub(/\s+E\s+39\s+(Los miembros)/i, " \\1")
  line = line.gsub(/(\d+)[*"”]\.-/, "\\1ª.-")
  line = line.gsub(/(\d+)\*\.-/, "\\1ª.-")
  line = line.gsub("con voz o y Sin voto", "con voz y sin voto")
  line = line.gsub("con voz y Sin voto", "con voz y sin voto")
  line = line.gsub("a. 3. .ni superior a.7..", "a 3 ni superior a 7.")
  line = line.gsub("válidamente adaptados", "válidamente adoptados")
  line = line.gsub("domiciliasión", "domiciliación")
  line = line.gsub(/\b0 a petición\b/, "o a petición")
  return nil if line.blank?

  letters = line.scan(/[[:alpha:]]/).size
  return nil if line.length <= 3 && letters <= 2
  return nil if line.length <= 12 && letters <= 4 && line.match?(/[^\p{Alnum}\s]/)
  return nil if line.match?(/\A(?:LO|CENA\s*\d+|O\s*>|["“”]?o\s+ER)\z/i)
  return nil if line.match?(/\A(?:EL\s+T|[ÚU]s\s+\d+\s+a)\z/i)

  line
end

def parse_old_articles(text)
  statutes_start = text.index("ESTATUTOS SOCIALES") || 0
  source = text[statutes_start..]
  matches = source.to_enum(:scan, /^.{0,25}Art[ií]culo\s+(\d+)\s*\.?-?/).map { Regexp.last_match }
  articles = {}

  matches.each_with_index do |match, index|
    number = match[1].to_i
    number = 59 if number == 69
    next if articles.key?(number)

    start_index = match.begin(0)
    end_index = matches[index + 1]&.begin(0) || source.length
    articles[number] = normalize_ocr(source[start_index...end_index])
  end

  articles
end

def article_number(title)
  title.to_s[/\AArticle\s+(\d+)/, 1]&.to_i
end

def highlighted_text(body)
  body.to_s.scan(%r{<span class="sjma-change-marker">(.*?)</span>}m).flatten.join("\n\n").strip
end

def justification_for(number, title, kind)
  base = ARTICLE_JUSTIFICATIONS[number] || generic_justification_for(title, kind)

  "Justificació: #{base}".gsub(/\s+/, " ").strip
end

def generic_justification_for(title, kind)
  normalized = I18n.transliterate(title.to_s).downcase

  return "permet adaptar el redactat al valencià, al llenguatge inclusiu i a una estructura estatutària més ordenada." if normalized.match?(/\Aarticle\s+(1|2|3|4|6)\b/)
  return "ordena millor la regulació de drets, deures i participació de les persones associades." if normalized.match?(/persona associada|persones associades|drets|deures|baixa|ingres/)
  return "ordena millor les competències, convocatòries i acords de l'Assemblea General." if normalized.match?(/assemble|convocatoria|acord|constitucio/)
  return "adapta el funcionament de la Junta Directiva a una estructura més clara, flexible i responsable." if normalized.match?(/junta directiva|presidencia|vicepresidencia|secretaria|tresoreria|vocalies|interinitat|resolucions/)
  return "crea un canal específic per a la participació artística i la coordinació de les agrupacions musicals." if normalized.match?(/musics|delegades|dictamens|agrupacions|direccions tecnic/)
  return "ordena millor l'Escola de Música, la Banda Simfònica i les seues relacions amb els òrgans socials." if normalized.match?(/escola|banda simfonica|pla d'estudis/)
  return "incorpora obligacions actuals de documentació, informació, transparència, dades personals i bon govern." if normalized.match?(/informacio|transparencia|dades|bon govern|comptables|documentals/)
  return "desenvolupa un règim disciplinari propi, més clar i graduat." if normalized.match?(/disciplin|faltes|sancions|prescripcio/)
  return "ordena el règim econòmic, patrimonial, pressupostari i de rendició de comptes." if normalized.match?(/patrimoni|pressupost|financer|comptes|liquidacio|dissolucio/)
  return "regula de manera expressa el procediment d'esmenes i modificació dels estatuts." if normalized.match?(/modificacio|esmena/) || normalized.match?(/\Aarticle\s+10[0-2]\b/)

  if kind == "addition"
    "cobreix una matèria que els estatuts vigents no regulaven de manera expressa o suficient."
  else
    "actualitza, reordena o precisa una regulació anterior perquè siga més clara i aplicable."
  end
end

raise "Missing OCR source: #{OCR_PATH}" unless OCR_PATH.exist?

old_articles = parse_old_articles(OCR_PATH.read)
component = Decidim::Component.find(7)
notes = {}

Decidim::Proposals::Proposal.where(component: component, participatory_text_level: "article").order(:position).find_each do |proposal|
  title = proposal.title.fetch("ca")
  number = article_number(title)
  changed_text = highlighted_text(proposal.body.fetch("ca", ""))
  mapped_old_refs = OLD_ARTICLE_MAP.fetch(number, [])
  article_notes = []

  if changed_text.present?
    if mapped_old_refs.any?
      article_notes << {
        "kind" => "modification",
        "summary" => justification_for(number, title, "modification"),
        "old_text" => mapped_old_refs.filter_map { |ref| old_articles[ref] }.join("\n\n"),
        "draft_text" => changed_text,
        "old_article_refs" => mapped_old_refs.dup
      }
    else
      article_notes << {
        "kind" => "addition",
        "summary" => justification_for(number, title, "addition"),
        "old_text" => "",
        "draft_text" => changed_text,
        "old_article_refs" => []
      }
    end
  end

  DELETION_NOTES.fetch(number, []).each do |note|
    old_refs = note.fetch("old_refs")
    article_notes << {
      "kind" => "deletion",
      "summary" => note.fetch("summary"),
      "old_text" => note["old_text"].presence || old_refs.filter_map { |ref| old_articles[ref] }.join("\n\n"),
      "draft_text" => "",
      "old_article_refs" => old_refs.dup
    }
  end

  notes[title] = article_notes if article_notes.any?
end

OUTPUT_PATH.write(
  {
    "articles" => notes
  }.to_yaml(line_width: 120)
)

puts "Wrote #{notes.size} article note groups to #{OUTPUT_PATH}"
