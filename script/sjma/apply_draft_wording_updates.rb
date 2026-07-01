#!/usr/bin/env ruby
# frozen_string_literal: true

COMPONENT_ID = ENV.fetch("DECIDIM_PROPOSALS_COMPONENT_ID", "7")
LOCALE = "ca"
ARTICLE8_TITLE_PREFIX = "Article 8."
ARTICLE9_TITLE_PREFIX = "Article 9."
ARTICLE10_TITLE_PREFIX = "Article 10."
ARTICLE13_TITLE_PREFIX = "Article 13."
ARTICLE14_TITLE_PREFIX = "Article 14."
ARTICLE17_TITLE_PREFIX = "Article 17."
ARTICLE19_TITLE_PREFIX = "Article 19."
ARTICLE20_TITLE_PREFIX = "Article 20."
ARTICLE23_TITLE_PREFIX = "Article 23."
ARTICLE24_TITLE_PREFIX = "Article 24."
ARTICLE29_TITLE_PREFIX = "Article 29."
ARTICLE30_TITLE_PREFIX = "Article 30."
ARTICLE31_TITLE_PREFIX = "Article 31."
ARTICLE32_TITLE_PREFIX = "Article 32."
ARTICLE33_TITLE_PREFIX = "Article 33."
ARTICLE35_TITLE_PREFIX = "Article 35."
ARTICLE36_TITLE_PREFIX = "Article 36."
ARTICLE42_TITLE_PREFIX = "Article 42."
ARTICLE75_TITLE_PREFIX = "Article 75."

ARTISTIC_HEADINGS = {
  "CAPÍTOL TERCER: DELS ALTRES ÒRGANS DE PARTICIPACIÓ" => ["TÍTOL III: DE L’ACTIVITAT ARTÍSTICA", "section"],
  "Secció 1ª: De l’Assemblea de Músics" => ["CAPÍTOL PRIMER: DE LES AGRUPACIONS ARTÍSTIQUES TITULARS", "sub-section"],
  "Secció 2ª: De les Persones Delegades" => ["Secció 1ª: De les Persones Delegades", "sub-section"],
  "Secció 3ª: De l’Arxiu de la Societat" => ["CAPÍTOL SEGON: DE L’ARXIU DE LA SOCIETAT", "sub-section"],
  "CAPÍTOL PRIMER: DE LES AGRUPACIONS MUSICALS DE LA SOCIETAT" => ["Secció 1ª: De les Assemblees d’Agrupació", "sub-section"],
  "Secció 1ª: De l’estatut de les persones que les componen" => ["Secció 2ª: De la Comissió Mixta d’Agrupacions", "sub-section"],
  "Secció 2ª: De les agrupacions de la Societat" => ["Secció 3ª: Dels Reglaments de Règim Intern", "sub-section"],
  "CAPÍTOL SEGON: DE LA RESTA D’ACTIVITATS ARTÍSTIQUES I CULTURALS" => ["Secció 4ª: Del seguiment de les Agrupacions Artístiques", "sub-section"],
  "CAPÍTOL ÚNIC: DE L’ESCOLA DE MÚSICA" => ["CAPÍTOL ÚNIC: DE L’ESCOLA", "sub-section"]
}.freeze

ARTISTIC_HEADINGS_BY_ID = {
  538 => ["TÍTOL III: DE L’ACTIVITAT ARTÍSTICA", "section"],
  550 => ["CAPÍTOL TERCER: DE L’ORGANITZACIÓ I COORDINACIÓ DE LES AGRUPACIONS", "sub-section"]
}.freeze

ARTICLE10_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les persones físiques o jurídiques que desitgen ingressar en la Societat com a Persones Associades hauran de sol·licitar-ho per escrit, mitjançant correu electrònic, formulari electrònic o altres canals habilitats per la Societat, dirigint la sol·licitud a la Junta Directiva.</span>

  <span class="sjma-change-marker">2. Es donarà publicitat a la petició durant el termini d’un mes, durant el qual podran presentar-se al·legacions. Transcorregut aquest termini, la persona sol·licitant passarà a integrar-se com a Persona Associada, llevat que la Junta Directiva haja comunicat motivadament la denegació de l’admissió o la suspensió de la decisió per causa justificada.</span>

  <span class="sjma-change-marker">3. La suspensió no podrà excedir d’un mes addicional. Transcorregut aquest termini sense denegació motivada, la persona sol·licitant passarà a integrar-se com a Persona Associada.</span>

  <span class="sjma-change-marker">4. La denegació de l’admissió podrà ser objecte de revisió interna en els termes previstos en l’article 75 d’aquestos Estatuts, sense perjudici de les accions d’impugnació que corresponguen davant l’ordre jurisdiccional civil.</span>
HTML

ARTICLE29_OLD_ELECTORAL_ROLL_TEXT = "a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari."
ARTICLE29_NEW_ELECTORAL_ROLL_TEXT = <<~HTML.strip
  a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari.

  <span class="sjma-change-marker">A l’efecte de participar en les eleccions internes, només formaran part del cens electoral les persones que hagueren adquirit la condició de Persona Associada abans de la data de convocatòria de les eleccions.</span>
HTML

ARTICLE75_TITLE = "Article 75. De la revisió interna de les Resolucions de la Junta Directiva"
ARTICLE75_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Persones Associades podran sol·licitar la revisió interna de les Resolucions de la Junta Directiva que estimen contràries a la llei, als Estatuts o als Acords de l’Assemblea General, mitjançant escrit motivat presentat davant la mateixa Junta Directiva per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, en el termini de 30 dies des de la notificació de la Resolució o Resolucions de què es tracte.</span>

  <span class="sjma-change-marker">2. La sol·licitud de revisió interna obligarà la Junta Directiva a revisar la Resolució impugnada i a dictar una nova Resolució motivada, confirmant-la, modificant-la o deixant-la sense efecte, en la primera reunió ordinària que celebre o, en tot cas, en el termini màxim de 3 mesos des de la presentació de la sol·licitud.</span>

  <span class="sjma-change-marker">3. Si la Junta Directiva confirma la Resolució impugnada, totalment o parcialment, la Persona Associada interessada podrà promoure la sol·licitud de convocatòria d’una Assemblea General Extraordinària en els termes previstos en aquestos Estatuts, sempre que reunisca el suport mínim exigit per a la seua convocatòria.</span>

  <span class="sjma-change-marker">4. La sol·licitud de revisió interna no impedirà l’exercici directe de les accions d’impugnació que corresponguen davant l’ordre jurisdiccional civil, en els termes previstos en l’article següent i en la normativa aplicable.</span>
HTML

ARTICLE13_YOUTH_RIGHTS_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">2. Les persones que componen les Joventuts gaudiran, en general, dels drets que se’n deriven de la seua capacitat d’obrar i de les disposicions normatives vigents. En particular, gaudiran únicament dels drets previstos als apartats a), b), d), e) i f) d’aquest article.</span>
HTML

ARTICLE14_OLD_YOUTH_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">2. Les persones que composen les Joventuts de la Societat ostentaran, en general, els drets i deures que se’n deriven de la seua capacitat d’obrar i de les disposicions normatives vigents. En particular, gaudiran únicament dels drets previstos als apartats a), b), d), e) i f) de l’article 13 d’aquestos Estatuts, i assumiran únicament els deures previstos als apartats a), c) i d) de l’article 14 d’aquestos Estatuts.</span>
HTML

ARTICLE14_NEW_YOUTH_DUTIES_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">2. Les persones que componen les Joventuts assumiran, en general, els deures que se’n deriven de la seua capacitat d’obrar i de les disposicions normatives vigents. En particular, assumiran únicament els deures previstos als apartats a), c) i d) d’aquest article.</span>
HTML

ARTICLE17_OLD_CREDIT_TEXT = '<span class="sjma-change-marker">h) Aprovar l’assumpció pel patrimoni de la Societat de crèdits superiors a 12.000 €.</span>'
ARTICLE17_NEW_CREDIT_TEXT = '<span class="sjma-change-marker">h) Aprovar la sol·licitud o concertació de crèdits, préstecs o altres operacions d’endeutament quan el seu import siga superior al 10 per cent del pressupost ordinari anual aprovat per l’Assemblea General.</span>'
ARTICLE17_OLD_ELECTION_TEXT = 'c) Triar i cessar a la <span class="sjma-change-marker">Presidència de la Junta Directiva en els termes descrits en estos Estatuts.</span>'
ARTICLE17_NEW_ELECTION_TEXT = '<span class="sjma-change-marker">c) Triar i cessar la Junta Directiva en els termes descrits en aquestos Estatuts.</span>'

ARTICLE20_OLD_EXTRAORDINARY_AGENDA_TEXT = "3. En les Assemblees Generals Extraordinàries no podran ser tractats més assumptes que els expressats en la Convocatòria."
ARTICLE20_NEW_EXTRAORDINARY_AGENDA_TEXT = '<span class="sjma-change-marker">3. En les Assemblees Generals Extraordinàries no es podrà alterar l’Ordre del Dia expressat en la Convocatòria.</span>'

ARTICLE23_OLD_VOTE_TEXT = "2. L’Assemblea General adopta els seus acords pel principi majoritari o de democràcia interna, corresponent un vot a cada Persona Associada present o representada."
ARTICLE23_NEW_VOTE_TEXT = '<span class="sjma-change-marker">2. En l’Assemblea General correspon un vot a cada Persona Associada present o representada.</span>'

ARTICLE24_OLD_SIMPLE_MAJORITY_TEXT = "1. Els Acords de l’Assemblea General s’adoptaran en general per majoria simple de les Persones Associades presents quan els vots afirmatius superen als negatius, excepte en aquells casos en que els presents Estatuts determinen altra cosa."
ARTICLE24_NEW_SIMPLE_MAJORITY_TEXT = '<span class="sjma-change-marker">1. Els Acords de l’Assemblea General s’adoptaran en general per majoria simple de les Persones Associades presents i representades vàlidament quan els vots afirmatius superen als negatius, excepte en aquells casos en que els presents Estatuts determinen altra cosa.</span>'
ARTICLE24_OLD_QUALIFIED_MAJORITY_TEXT = "2. Requeriran de majoria absoluta, que resultarà quan els vots afirmatius superen la mitat dels vots emesos, els següents assumptes:"
ARTICLE24_NEW_QUALIFIED_MAJORITY_TEXT = '<span class="sjma-change-marker">2. Requeriran de majoria qualificada, que resultarà quan els vots afirmatius superen la mitat dels vots emesos, els següents assumptes:</span>'
ARTICLE24_OLD_SPECIFIC_CALL_TEXT = "3. En qualsevol cas, els Acords relatius als punts esmentats a l’apartat anterior requeriran que s’haja convocat específicament amb tal objecte l’Assemblea General corresponent."
ARTICLE24_NEW_SPECIFIC_CALL_TEXT = '<span class="sjma-change-marker">3. En qualsevol cas, els Acords relatius al punt d) de l’apartat anterior i als esmentats al capítol 4 del títol V requeriran que s’haja convocat específicament amb tal objecte l’Assemblea General corresponent.</span>'

ARTICLE103_OLD_DISSOLUTION_MAJORITY_TEXT = "a) Per Acord de l’Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria absoluta de les Persones Associades assistents amb dret a vot."
ARTICLE103_NEW_DISSOLUTION_MAJORITY_TEXT = '<span class="sjma-change-marker">a) Per Acord de l’Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria qualificada de les Persones Associades assistents amb dret a vot.</span>'

ARTICLE31_OLD_BOARD_COMPOSITION_TEXT = "1. La Junta Directiva haurà de comptar en tot cas amb la Presidència, una Secretaria, una Tresoreria i un número de Vocals no inferior a 5 ni superior a 20. Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, i amb una Vicesecretaria."
ARTICLE31_NEW_BOARD_COMPOSITION_TEXT = '<span class="sjma-change-marker">1. La Junta Directiva haurà de comptar en tot cas amb la Presidència, una Secretaria, una Tresoreria i un número de Vocals no inferior a 5 ni superior a 20. Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, amb una Vicesecretaria i amb una Vicetresoreria.</span>'

ARTICLE32_OLD_ANNUAL_ACCOUNTS_TEXT = "c) Presentar a l’Assemblea General el Balanç i Compte de Resultats de cada exercici a l’Assemblea General."
ARTICLE32_NEW_ANNUAL_ACCOUNTS_TEXT = '<span class="sjma-change-marker">c) Presentar a l’Assemblea General els Comptes Anuals de cada exercici.</span>'

ARTICLE32_OLD_SCHOOL_STAFF_TEXT = <<~HTML.strip
  g) <span class="sjma-change-marker">Nomenar o separar a les Direccions tècnic-artístiques de les agrupacions artístiques i als càrrecs que conformen l’Equip Directiu de l’Escola de la Societat.</span>

  h) Programar les activitats per a desenvolupar, i organitzar, impulsar, disciplinar i controlar tots els assumptes referents a les agrupacions artístiques, l’Escola i demés seccions i comissions culturals creades al si de la Societat.

  <span class="sjma-change-marker">i) Aprovar les operacions que impliquen contraprestacions econòmiques a satisfer per part de la Societat que siguen iguals o superiors a la quantitat de mil euros.</span>

  j) Aprovar els reglaments interns que desenvolupen aquestos Estatuts <span class="sjma-change-marker">quan no siga competència de l’Assemblea General.</span>

  <span class="sjma-change-marker">k) Convocar i dirigir consultes internes al conjunt de Persones Associades.</span>

  l) Qualsevol altra facultat que no estiga expressament i específicament atribuïda a cap altre òrgan de govern i administració de la Societat, o que se deleguen de manera expressa a la Junta Directiva.
HTML

ARTICLE32_NEW_SCHOOL_STAFF_TEXT = <<~HTML.strip
  g) <span class="sjma-change-marker">Nomenar o separar a les Direccions tècnic-artístiques de les agrupacions artístiques i als càrrecs que conformen l’Equip Directiu de l’Escola de la Societat.</span>

  <span class="sjma-change-marker">h) Contractar o acomiadar al personal de l’Escola a proposta de l’Equip Directiu de l’Escola.</span>

  i) Programar les activitats per a desenvolupar, i organitzar, impulsar, disciplinar i controlar tots els assumptes referents a les agrupacions artístiques, l’Escola i demés seccions i comissions culturals creades al si de la Societat.

  <span class="sjma-change-marker">j) Aprovar les operacions que impliquen contraprestacions econòmiques a satisfer per part de la Societat que siguen iguals o superiors a la quantitat de mil euros.</span>

  k) Aprovar els reglaments interns que desenvolupen aquestos Estatuts <span class="sjma-change-marker">quan no siga competència de l’Assemblea General.</span>

  <span class="sjma-change-marker">l) Convocar i dirigir consultes internes al conjunt de Persones Associades.</span>

  m) Qualsevol altra facultat que no estiga expressament i específicament atribuïda a cap altre òrgan de govern i administració de la Societat, o que se deleguen de manera expressa a la Junta Directiva.
HTML

ARTICLE33_OLD_SCHOOL_STAFF_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">e) Contractar o acomiadar al personal de l’Escola a proposta de l’Equip Directiu de l’Escola.</span>

  f) Totes aquelles que li corresponen d’acord amb els presents Estatuts.
HTML

ARTICLE33_NEW_SCHOOL_STAFF_TEXT = "e) Totes aquelles que li corresponen d’acord amb els presents Estatuts."

ARTICLE35_OLD_FORMAL_NOTICES_TEXT = "b) Autoritzar les citacions."
ARTICLE35_NEW_FORMAL_NOTICES_TEXT = '<span class="sjma-change-marker">b) Autoritzar, junt amb la Presidència, les convocatòries, citacions i comunicacions formals de la Societat quan corresponga.</span>'
ARTICLE35_OLD_CERTIFICATES_TEXT = "e) Autoritzar els títols socials."
ARTICLE35_NEW_CERTIFICATES_TEXT = '<span class="sjma-change-marker">e) Autoritzar les certificacions, credencials o documents acreditatius expedits per la Societat.</span>'

ARTICLE36_OLD_NO_VICESECRETARY_TEXT = '<span class="sjma-change-marker">En el supòsit de no haver designat cap Vicepresidència, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Presidència de la Junta Directiva.</span>'
ARTICLE36_NEW_NO_VICESECRETARY_TEXT = '<span class="sjma-change-marker">En el supòsit de no haver designat cap Vicesecretaria, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Junta Directiva.</span>'

VICETRESORERIA_TITLE = "Article 37 bis. De la Vicetresoreria"
VICETRESORERIA_BODY = <<~HTML.strip
  <span class="sjma-change-marker">La persona que, en el seu cas, assumisca la Vicetresoreria substituirà a la Tresoreria per raons justificades de malaltia, absència i/o impossibilitat, quan concórreguen les causes previstes a l’Article 31.3 apartats a) o c), o per delegació expressa de la Tresoreria, sense perjuí d’ulteriors delegacions o apoderaments per part d’altres components de la Junta Directiva.</span>

  <span class="sjma-change-marker">En el supòsit de no haver designat cap Vicetresoreria, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Junta Directiva.</span>
HTML

ARTICLE20_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Assemblea General celebrarà sessió extraordinària quan així ho sol·licite la Presidència per voluntat pròpia o en acompliment del que prescriuen aquestos Estatuts, o un terç dels membres de la Junta Directiva per petició voluntària o en acompliment del que prescriuen aquestos Estatuts, o un 10 per cent de les Persones Associades. La sol·licitud serà dirigida a la Presidència de la Societat mitjançant escrit, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, i en el qual s’expressarà de manera concreta les causes que motiven la sol·licitud i l’Ordre del Dia que haurà de ser objecte de la Convocatòria.</span>

  <span class="sjma-change-marker">2. Les sessions extraordinàries de l’Assemblea General es convocaran dins dels 15 dies següents a la sol·licitud i s’hauran de celebrar necessàriament dins dels 30 dies naturals posteriors a la data de la sol·licitud.</span>

  <span class="sjma-change-marker">3. En les Assemblees Generals Extraordinàries no es podrà alterar l’Ordre del Dia expressat en la Convocatòria.</span>
HTML

ARTICLE22_NEW_MINUTES_APPROVAL_TEXT = '<span class="sjma-change-marker">2. La Secretaria redactarà l’Acta de cada sessió, la qual reflexarà un extracte de les deliberacions, el text dels acords que s’hagen adoptat i el resultat numèric de les votacions. Al començament de cada sessió de l’Assemblea es sotmetrà a aprovació la redacció de l’Acta de la sessió anterior, sense perjuí de l’executivitat dels Acords que en aquella s’hi adopten.</span>'

SECRETARIA_TERMINOLOGY_REPLACEMENTS = {
  "presentada al Secretariat de l’Assemblea" =>
    "presentada a la Secretaria de l’Assemblea",
  "1. Dirigiran la sessió la Presidència i el Secretariat de l’Assemblea General, assumint-se dita condició pels qui ho siguen de la Junta Directiva." =>
    '<span class="sjma-change-marker">1. Dirigiran la sessió la Presidència i la Secretaria de l’Assemblea General, assumint-se dita condició pels qui ho siguen de la Junta Directiva.</span>',
  "2. El Secretariat redactarà l’Acta de cada reunió, la qual reflexarà un extracte de les deliberacions, el text dels acords que s’hagen adoptat i el resultat numèric de les votacions. Al començament de cada reunió de l’Assemblea es llegirà l’Acta de la sessió anterior a fi de que s’aprove la seua redacció, sense perjuí de l’executivitat dels Acords que en aquella s’hi adoptaren." =>
    ARTICLE22_NEW_MINUTES_APPROVAL_TEXT,
  '<span class="sjma-change-marker">2. La Secretaria redactarà l’Acta de cada reunió, la qual reflexarà un extracte de les deliberacions, el text dels acords que s’hagen adoptat i el resultat numèric de les votacions. Al començament de cada reunió de l’Assemblea es llegirà l’Acta de la sessió anterior a fi de que s’aprove la seua redacció, sense perjuí de l’executivitat dels Acords que en aquella s’hi adoptaren.</span>' =>
    ARTICLE22_NEW_MINUTES_APPROVAL_TEXT,
  "persona que assumisca el Secretariat" =>
    "persona que assumisca la Secretaria",
  "Sense perjuí del que es disposa per a la Vicepresidència i la Vicesecretaria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, a la Presidència, al Secretariat i/o a la Tresoreria respectivament." =>
    '<span class="sjma-change-marker">Sense perjuí del que es disposa per a la Vicepresidència i la Vicesecretaria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, a la Presidència, a la Secretaria i/o a la Tresoreria respectivament.</span>',
  '<span class="sjma-change-marker">Sense perjuí del que es disposa per a la Vicepresidència i la Vicesecretaria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, a la Presidència, a la Secretaria i/o a la Tresoreria respectivament.</span>' =>
    '<span class="sjma-change-marker">Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, a la Presidència, a la Secretaria i/o a la Tresoreria respectivament.</span>',
  "exercirà el Secretariat de l’Assemblea de Músics" =>
    "exercirà la Secretaria de l’Assemblea de Músics",
  "seran assumides pel Secretariat" =>
    "seran assumides per la Secretaria"
}.freeze

ASSEMBLY_SESSION_TERMINOLOGY_REPLACEMENTS = {
  "1. L’Assemblea General es reunirà en sessions Ordinàries i Extraordinàries." =>
    '<span class="sjma-change-marker">1. L’Assemblea General celebrarà sessions ordinàries i extraordinàries.</span>',
  "Per a les sessions en que es reunisca l’Assemblea General" =>
    "Per a les sessions que celebre l’Assemblea General",
  "La Secretaria redactarà l’Acta de cada reunió" =>
    "La Secretaria redactarà l’Acta de cada sessió",
  "convocaran reunió extraordinària de l’Assemblea General, reunió en la qual" =>
    "convocaran sessió extraordinària de l’Assemblea General, sessió en la qual",
  "convocatòria de reunió extraordinària" =>
    "convocatòria de sessió extraordinària"
}.freeze

QUALIFIED_MAJORITY_TERMINOLOGY_REPLACEMENTS = {
  ARTICLE24_OLD_QUALIFIED_MAJORITY_TEXT => ARTICLE24_NEW_QUALIFIED_MAJORITY_TEXT,
  ARTICLE103_OLD_DISSOLUTION_MAJORITY_TEXT => ARTICLE103_NEW_DISSOLUTION_MAJORITY_TEXT,
  "majoria absoluta" => "majoria qualificada"
}.freeze

ELECTRONIC_WRITING_REPLACEMENTS = {
  "b) La pròpia voluntat de la persona interessada comunicada per escrit a la Junta Directiva." =>
    '<span class="sjma-change-marker">b) La pròpia voluntat de la persona interessada comunicada a la Junta Directiva per escrit, per correu electrònic, formulari electrònic o altres canals habilitats per la Societat.</span>',
  "La sol·licitud serà dirigida mitjançant escrit a la Presidència de la Societat, en el qual s’expressarà de manera concreta les causes que motiven la sol·licitud i l’Ordre del Dia que haurà de ser objecte de la Convocatòria." =>
    '<span class="sjma-change-marker">La sol·licitud serà dirigida a la Presidència de la Societat mitjançant escrit, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, i en el qual s’expressarà de manera concreta les causes que motiven la sol·licitud i l’Ordre del Dia que haurà de ser objecte de la Convocatòria.</span>',
  "i seran fetes per escrit, expressant-s’hi lloc, dia i hora on es vagen a celebrar, així com l’Ordre del Dia." =>
    '<span class="sjma-change-marker">i seran fetes per escrit, incloent-hi el correu electrònic o altres canals electrònics habilitats per la Societat, expressant-s’hi lloc, dia i hora on es vagen a celebrar, així com l’Ordre del Dia.</span>',
  "Les Convocatòries es faran públiques al Tauler d’Anuncis de la Societat, a més de distribuir-se en mà o per correu o per altres mitjans tècnics i informàtics a cada Persona Associada que conste al Llibre Registre de la Societat." =>
    '<span class="sjma-change-marker">Les Convocatòries es faran públiques al Tauler d’Anuncis de la Societat, a més de distribuir-se en mà, per correu postal, per correu electrònic o per altres mitjans tècnics i informàtics a cada Persona Associada que conste al Llibre Registre de la Societat.</span>',
  "mitjançant escrit presentat a la Junta Directiva en aquell moment i publicat al Tauler d’Anuncis de la Societat i, facultativament, en els demés mitjans de publicitat de la Societat." =>
    "mitjançant escrit presentat a la Junta Directiva, per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, i publicat al Tauler d’Anuncis de la Societat i, facultativament, en els demés mitjans de publicitat de la Societat.",
  "podran presentar-se a la mateixa sessió de l’Assemblea mitjançant l’escrit descrit presentat a la Mesa de l’Assemblea." =>
    "podran presentar-se a la mateixa sessió de l’Assemblea mitjançant l’escrit descrit, presentat a la Mesa de l’Assemblea o pels canals electrònics habilitats per la Societat.",
  "a) Dimissió voluntària presentada mitjançant un escrit en el que es raonen els motius; en el cas de la Presidència, dirigit al conjunt de la Societat, i en el cas de la resta de càrrecs de la Junta Directiva, dirigit a la Presidència de la Junta Directiva." =>
    '<span class="sjma-change-marker">a) Dimissió voluntària presentada mitjançant escrit en què es raonen els motius, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat; en el cas de la Presidència, dirigit al conjunt de la Societat, i en el cas de la resta de càrrecs de la Junta Directiva, dirigit a la Presidència de la Junta Directiva.</span>',
  "en l’escrit de sol·licitud de convocatòria de reunió extraordinària i haurà d’incloure una nova candidatura a la Presidència i als restants càrrecs de la Junta Directiva." =>
    "en l’escrit de sol·licitud de convocatòria de sessió extraordinària, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, i haurà d’incloure una candidatura completa de Junta Directiva en llista tancada."
}.freeze

ARTICLE19_OLD_BODY = <<~HTML.strip
  1. L’Assemblea General es reunirà amb caràcter ordinari <span class="sjma-change-marker">dos vegades a l’any. La primera sessió haurà de celebrar-se entre els mesos de gener i febrer, i la segona entre juny i juliol.</span>

  <span class="sjma-change-marker">2. L’Ordre del Dia de la primera sessió de cada any de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovar els pressupostos ordinaris proposats per la Junta Directiva.</span>

  <span class="sjma-change-marker">b) Aprovar els Comptes Anuals de la Societat presentats per la Junta Directiva.</span>

  <span class="sjma-change-marker">c) Aprovar o modificar les quotes que hagen de satisfer les Persones Associades, així com les derrames i altres aportacions extraordinàries proposades per la Junta Directiva.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  <span class="sjma-change-marker">3. L’Ordre del Dia de la segona sessió de cada any de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovar o censurar la gestió i actuació de la Junta Directiva o dels seus membres</span>

  <span class="sjma-change-marker">b) Aprovar la Memòria d’activitats del darrer curs.</span>

  <span class="sjma-change-marker">c) Triar i cessar a la Presidència de la Junta Directiva, quan siga procedent de conformitat amb aquestos Estatuts.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  4. Podran ampliar-se els punts de l’Ordre del Dia de les Assemblees Generals amb les demés matèries de competència de l’Assemblea General que se relacionen a l’article 17.1 d’aquestos Estatuts.
HTML

ARTICLE19_NEW_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Assemblea General celebrarà sessions ordinàries dos vegades a l’any. La primera sessió, denominada econòmica, haurà de celebrar-se al primer trimestre, i la segona sessió, denominada social, al tercer trimestre.</span>

  <span class="sjma-change-marker">2. L’Ordre del Dia de la sessió econòmica de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovació de l’acta de la sessió anterior de l’Assemblea General.</span>

  <span class="sjma-change-marker">b) Aprovar els Comptes Anuals de la Societat presentats per la Junta Directiva.</span>

  <span class="sjma-change-marker">c) Aprovar els pressupostos ordinaris proposats per la Junta Directiva.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  <span class="sjma-change-marker">3. L’Ordre del Dia de la sessió social de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovació de l’acta de la sessió anterior de l’Assemblea General.</span>

  <span class="sjma-change-marker">b) Aprovar la Memòria d’activitats del darrer curs.</span>

  <span class="sjma-change-marker">c) Triar i cessar la Junta Directiva, quan siga procedent de conformitat amb aquestos Estatuts.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  4. Podran ampliar-se els punts de l’Ordre del Dia de les Assemblees Generals amb les demés matèries de competència de l’Assemblea General que se relacionen a l’article 17.1 d’aquestos Estatuts.
HTML

ARTICLE29_TITLE = "Article 29. De l’elecció de la Junta Directiva"
ARTICLE29_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva serà escollida per l’Assemblea General mitjançant candidatures completes en llista tancada, d’acord amb el que establixen aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. El procediment electoral per a triar la Junta Directiva es regirà per les següents normes:</span>

  a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari.

  <span class="sjma-change-marker">A l’efecte de participar en les eleccions internes, només formaran part del cens electoral les persones que hagueren adquirit la condició de Persona Associada abans de la data de convocatòria de les eleccions.</span>

  <span class="sjma-change-marker">b) Les candidatures es presentaran com a llistes tancades a la Junta Directiva en el termini de 7 dies naturals comptats des de l’endemà de la convocatòria de l’Assemblea en què s’hi vaja a celebrar l’elecció, mitjançant escrit presentat a la Junta Directiva, per correu electrònic, formulari electrònic o altres canals habilitats per la Societat.</span>

  <span class="sjma-change-marker">En aquest escrit haurà de figurar la relació completa de persones que integren la candidatura i el càrrec que desenvoluparà cadascuna dins de la Junta Directiva.</span>

  <span class="sjma-change-marker">En cap cas es tractarà d’una llista oberta ni d’una elecció separada per càrrecs, de manera que el vot recaurà sobre la candidatura completa a la Junta Directiva.</span>

  <span class="sjma-change-marker">El dia natural següent a la finalització del termini de presentació, la Junta Directiva farà publicitat de les candidatures presentades al Tauler d’Anuncis de la Societat, per correu electrònic i pels altres canals habituals de comunicació de la Societat.</span>

  <span class="sjma-change-marker">Entre la publicació de les candidatures i la sessió de l’Assemblea en què s’haja de votar hauran de transcórrer, almenys, 7 dies naturals, perquè les Persones Associades que formen part del cens electoral puguen conèixer les candidatures i formar el seu criteri de vot.</span>

  <span class="sjma-change-marker">c) Abans d’efectuar la votació, les candidatures exposaran les seues propostes i projectes per a la Societat. A més, hauran de presentar totes les persones que integren la candidatura i els càrrecs que desenvoluparan. A partir d’aquestos punts, podran debatre i confrontar posicions amb les restants candidatures.</span>

  <span class="sjma-change-marker">Correspondrà a la Persona Associada de major edat present en la sessió moderar les intervencions i el debat, per al qual passarà a formar part de la Mesa de l’Assemblea General com a Moderador. En cas que aquesta Persona Associada integrara també una candidatura a la Junta Directiva, exercirà la funció de Moderador la següent Persona Associada de més edat, i així successivament.</span>

  <span class="sjma-change-marker">d) Quan només es presentara una única candidatura, la Junta Directiva podrà ser escollida en votació ordinària per braços alçats, sempre i quan cap Persona Associada present a la sessió es mostre contrària a aquest procediment de votació, cas en el qual es farà votació secreta per papereta. Quan hi haguera més d’una candidatura, l’elecció es farà sempre en votació secreta per papereta.</span>

  <span class="sjma-change-marker">En els casos en què es fera votació secreta per papereta, es confeccionaran paperetes de votació, en les quals figuraran manuscrits, mecanografiats, en impremta o fotocopiats els noms i cognoms de cadascuna de les candidatures a la Junta Directiva.</span>

  <span class="sjma-change-marker">e) Serà escollida la candidatura a la Junta Directiva que aconseguisca la majoria qualificada dels vots de les Persones Associades presents o representades. Si cap candidatura aconseguira aquesta majoria, es durà a terme una segona votació en la que resultarà escollida la candidatura que aconseguisca la majoria simple.</span>

  <span class="sjma-change-marker">f) Les Persones Associades podran delegar el seu dret de votació en les eleccions a la Junta Directiva en altra Persona Associada representant en els termes previstos en aquestos Estatuts. L’autorització de la representació haurà de contindre únicament les dades exigides amb caràcter general per a la delegació de veu i vot, sense indicar el sentit del vot de la persona representada.</span>

  <span class="sjma-change-marker">En les votacions secretes per papereta, la Persona Associada representant podrà dipositar la seua papereta i les paperetes corresponents a les Persones Associades que represente, preservant en tot cas el caràcter secret del vot.</span>

  <span class="sjma-change-marker">g) La candidatura a la Junta Directiva que resulte escollida assumirà els càrrecs que consten en la llista tancada presentada, sense necessitat de designació posterior per part de la Presidència.</span>

  3. Les normes contingudes a l’apartat anterior podran desenvolupar-se amb major detall i extensió en un Reglament de Règim Electoral, que haurà de ser aprovat per Acord de l’Assemblea General. En cap cas, aquest Reglament podrà contradir les regles establertes en aquestos Estatuts.
HTML

ARTICLE30_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La durada en l’exercici del càrrec de totes les persones que componen la Junta Directiva serà de 4 anys, computats des de la data de l’elecció de la Junta Directiva fins a la sessió de l’Assemblea General que corresponga a la terminació del seu mandat, sense perjuí dels supòsits d’interinitat i la resta de previsions d’aquestos Estatuts.</span>

  2. Totes elles podran tornar a ser escollides per períodes iguals.

  3. El cessament en el càrrec abans d’extingir-se el termini ordinari podrà deure’s a:

  <span class="sjma-change-marker">a) Dimissió voluntària presentada mitjançant escrit en què es raonen els motius, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat; en el cas de la Presidència, dirigit al conjunt de la Societat, i en el cas de la resta de càrrecs de la Junta Directiva, dirigit a la Presidència de la Junta Directiva.</span>

  b) Malaltia degudament acreditada que incapacite per a l’exercici del càrrec.

  c) Causar baixa com a Persona Associada de la Societat.

  <span class="sjma-change-marker">d) Cessament acordat per l’Assemblea General en els termes previstos en aquestos Estatuts.</span>

  <span class="sjma-change-marker">e) Les restants causes previstes en aquestos Estatuts.</span>

  <span class="sjma-change-marker">4. Quan es produïsquen vacants en una Junta Directiva distintes a la Presidència, la Junta Directiva podrà designar provisionalment, mitjançant Resolució adoptada en reunió, la Persona Associada que assumirà el càrrec vacant fins a la següent sessió de l’Assemblea General.</span>

  <span class="sjma-change-marker">En la primera sessió de l’Assemblea General que se celebre, la vacant serà coberta formalment mitjançant votació de l’Assemblea General, a proposta de la Junta Directiva, pel temps que reste del mandat.</span>

  <span class="sjma-change-marker">Quan es produïsca vacant en la Presidència, un terç dels components de la Junta Directiva en el càrrec convocaran sessió extraordinària de l’Assemblea General, sessió en la qual finalitzarà la Junta Directiva en eixe moment i es triarà una nova Junta Directiva mitjançant candidatura de llista tancada en els termes previstos en aquestos Estatuts.</span>

  <span class="sjma-change-marker">5. Quan a les eleccions a Junta Directiva no es presentara cap candidatura completa, la Junta Directiva del mandat finalitzat incorrerà en el supòsit d’interinitat previst a l’article 41 d’aquestos Estatuts durant un període màxim de 3 mesos. Si finalitzat aquest període persisteix l’absència de candidatures, s’entendrà que concorre la situació prevista a l’article 39 del Codi Civil com a causa de dissolució de la Societat.</span>
HTML

ARTICLE42_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva retrà comptes de la seua gestió i actuació davant de l’Assemblea General en els termes previstos en aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. La Presidència, en nom de la Junta Directiva i prèvia deliberació d’aquesta en reunió, podrà plantejar davant l’Assemblea General en sessió ordinària un vot de confiança sobre la gestió i actuació de la Junta Directiva.</span>

  <span class="sjma-change-marker">La confiança s’entendrà atorgada quan vote a favor d’aquesta la majoria simple de les persones presents amb dret a vot. Si no s’atorga, s’entendrà revocada la confiança en la Junta Directiva i cessades totes les persones que la componen. La Junta Directiva cessada continuarà en funcions en règim d’interinitat fins que l’Assemblea General trie una nova Junta Directiva.</span>

  <span class="sjma-change-marker">3. L’Assemblea General podrà revocar en sessió extraordinària la confiança en la Junta Directiva mitjançant vot de censura. El vot de censura haurà de ser proposat per almenys un 10 per cent de les Persones Associades amb dret a vot i haurà d’incloure una candidatura completa de Junta Directiva en llista tancada.</span>

  <span class="sjma-change-marker">El vot de censura s’entendrà aprovat quan vote a favor d’aquest la majoria qualificada de les persones presents amb dret a vot. Si s’aprova, cessarà la Junta Directiva existent i quedarà escollida com a nova Junta Directiva la candidatura proposada en el vot de censura.</span>
HTML

ARTICLE8_OLD_REGISTER_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">5. Les Persones Associades i les Joventuts es relacionaran en un Llibre Registre, per rigorós ordre d’antiguitat. Aquest podrà consistir en una base de dades informatitzada, sempre i quan permeta obtindre en qualsevol moment una relació nominal d’iguals característiques.</span>

  <span class="sjma-change-marker">El Llibre Registre estarà conformat per dues seccions: el Registre Històric i el Registre d’altes. En el primer, a cada Persona Associada se li assignarà un número seqüencial i vitalici de caràcter intransmissible. En el segon, s’assignarà a cada Persona Associada el número d’ordre que li corresponga en la relació de socis en alta, sent també seqüencial però variant de manera ascendent en funció de les baixes produïdes.</span>
HTML

ARTICLE8_NEW_REGISTER_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">5. Les Persones Associades i les Joventuts es relacionaran en un Llibre Registre, que podrà consistir en una base de dades informatitzada, sempre que permeta obtindre en qualsevol moment una relació nominal actualitzada.</span>

  <span class="sjma-change-marker">El Llibre Registre estarà conformat per dues seccions: el Registre Actiu i el Registre Històric. En el Registre Actiu constaran les Persones Associades en situació d’alta, a cadascuna de les quals se li assignarà un número seqüencial, permanent i intransmissible.</span>

  <span class="sjma-change-marker">Quan una Persona Associada cause baixa, passarà al Registre Històric, conservant en tot cas el número que tenia assignat. Aquest número no podrà ser reutilitzat ni assignat a cap altra Persona Associada. Les noves altes rebran el número correlatiu següent a l’últim número assignat, amb independència que les persones titulars dels números anteriors continuen en el Registre Actiu o hagen passat al Registre Històric.</span>

  <span class="sjma-change-marker">En el Registre Històric únicament es conservaran les dades mínimes necessàries per a identificar la persona i acreditar la seua relació històrica amb la Societat, sense perjudici dels drets que li corresponguen en matèria de protecció de dades personals, inclòs, si escau, el dret de supressió d’acord amb la normativa vigent aplicable.</span>
HTML

ARTICLE45_TITLE = "Article 45. De les Agrupacions Artístiques Titulars"
ARTICLE45_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Agrupacions Artístiques Titulars són les agrupacions estables de la Societat que desenvolupen una activitat artística pròpia i continuada, i que formen part de la representació artística de la Societat.</span>

  <span class="sjma-change-marker">2. La Banda Simfònica és l’Agrupació Artística Titular principal i històrica de la Societat. Aquesta consideració no suposa menor rellevància institucional, artística o social de la resta d’Agrupacions Artístiques Titulars.</span>

  <span class="sjma-change-marker">3. Les Agrupacions Artístiques Titulars seran creades per Resolució de la Junta Directiva.</span>
HTML

ARTICLE46_TITLE = "Article 46. De la doble vessant artística i educativa"
ARTICLE46_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Les Agrupacions Artístiques Titulars podran tindre una vessant artística i una vessant educativa o pedagògica quan així es determine en la planificació educativa de l’Escola de la Societat, d’acord amb el Projecte Educatiu de Centre, el Pla d’Estudis i les normes d’organització de l’Escola, i siga aprovat per Resolució de la Junta Directiva, sense alterar la seua condició d’Agrupació Artística Titular.</span>
HTML

ARTICLE47_TITLE = "Article 47. De l’exercici artístic"
ARTICLE47_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’exercici artístic de les Agrupacions Artístiques Titulars és el període anual en què aquestes desenvolupen la seua activitat ordinària, i comprendrà de l’1 de setembre al 31 d’agost de l’any següent.</span>

  <span class="sjma-change-marker">2. La programació concreta de cada Agrupació dins de l’exercici artístic s’adaptarà a la seua naturalesa, calendari i necessitats, i haurà de coordinar-se amb la programació general de la Societat i de l’Escola per afavorir una planificació coherent, evitar solapaments i facilitar projectes, cicles o festivals comuns.</span>
HTML

ARTICLE48_TITLE = "Article 48. De la direcció artística i tècnica"
ARTICLE48_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Cada Agrupació Artística Titular comptarà, com a mínim, amb una Direcció tècnic-artística, exercida per una persona contractada per la Societat.</span>

  <span class="sjma-change-marker">2. Quan la naturalesa, dimensió, activitat o projecció de l’Agrupació ho requerisca, la Junta Directiva podrà ampliar, modificar o reduir mitjançant Resolució l’estructura de direcció artística i tècnica de l’Agrupació, que podrà estar integrada per una o diverses persones contractades per la Societat, diferenciant, si escau, funcions de direcció artística, direcció tècnica, direcció titular, direccions convidades o altres responsabilitats artístiques anàlogues.</span>

  <span class="sjma-change-marker">3. En aquests Estatuts, les referències a la Direcció tècnic-artística de l’Agrupació s’entendran fetes a la persona contractada que exercisca aquesta funció o, si escau, a les persones contractades que integren l’estructura de direcció artística i tècnica de l’Agrupació, dins de les funcions que cadascuna tinga atribuïdes.</span>

  <span class="sjma-change-marker">4. Corresponen a la Direcció tècnic-artística de l’Agrupació, dins de l’àmbit de les seues responsabilitats, la direcció artística de l’Agrupació, la planificació de l’activitat ordinària, la preparació dels assajos i actuacions, la proposta de projectes i repertoris, la coordinació amb la Junta Directiva i l’assessorament artístic que aquesta requerisca.</span>

  <span class="sjma-change-marker">5. La Direcció tècnic-artística de l’Agrupació acatarà i complirà aquests Estatuts, els Acords de l’Assemblea General i les Resolucions de la Junta Directiva, sense perjuí de la seua llibertat artística, de les seues competències tècniques i de les condicions determinades en la relació professional establerta amb la Societat.</span>
HTML

ARTICLE49_TITLE = "Article 49. De les persones integrants actives"
ARTICLE49_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Són persones integrants actives de cada Agrupació Artística Titular aquelles que participen de manera assídua en la seua activitat artística, en els termes que es determinen reglamentàriament o, subsidiàriament, per la Direcció tècnic-artística.</span>

  <span class="sjma-change-marker">2. Les persones integrants actives majors d’edat hauran de tindre la condició de Persones Associades de la Societat, sense perjudici de la participació educativa, temporal o puntual que puga correspondre a altres persones d’acord amb aquests Estatuts.</span>

  <span class="sjma-change-marker">3. Les persones integrants actives hauran de col·laborar en el bon funcionament de l’Agrupació, respectar la seua organització interna i assistir als assajos, actuacions i activitats per a les quals siguen convocades, d’acord amb la naturalesa de cada Agrupació i amb les indicacions de la seua Direcció tècnic-artística.</span>
HTML

ARTICLE50_TITLE = "Article 50. De les Persones Delegades"
ARTICLE50_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Cada Agrupació Artística Titular comptarà, com a mínim, amb una Persona Delegada major d’edat, que haurà de ser Persona Associada i persona integrant activa de l’Agrupació.</span>

  <span class="sjma-change-marker">2. Per Resolució de la Junta Directiva, escoltada la Direcció tècnic-artística, podrà ampliar-se el nombre de Persones Delegades fins a un màxim de tres persones majors d’edat, atenent al nombre de persones integrants actives, al volum d’activitat i a les necessitats organitzatives de l’Agrupació.</span>

  <span class="sjma-change-marker">3. Quan una Agrupació Artística Titular compte amb una presència significativa de persones menors d’edat, la Junta Directiva podrà acordar, escoltada la Direcció tècnic-artística, que s’escullen una o dues Persones Delegades Junior entre les persones integrants actives majors de 15 anys i menors d’edat.</span>

  <span class="sjma-change-marker">4. Les Persones Delegades Junior tindran com a funció principal traslladar la visió, opinions, preferències, inquietuds i forma de pensar de les persones menors d’edat de l’Agrupació. Participaran en les funcions de comunicació, coordinació i proposta d’acord amb la seua edat i capacitat, sense assumir funcions de representació legal ni responsabilitats reservades a persones majors d’edat.</span>

  <span class="sjma-change-marker">5. Correspon a les Persones Delegades:</span>

  <span class="sjma-change-marker">a) Facilitar la comunicació interna de l’Agrupació.</span>

  <span class="sjma-change-marker">b) Coordinar, amb el suport i l’aprovació de la Direcció tècnic-artística i de la Junta Directiva quan corresponga, les activitats, concerts, desplaçaments i projectes especials de l’Agrupació.</span>

  <span class="sjma-change-marker">c) Donar suport a la Direcció tècnic-artística en assumptes artístics, organitzatius i socials de l’Agrupació, inclosa la detecció de necessitats de les diferents seccions i la millora de la seua dinàmica interna.</span>

  <span class="sjma-change-marker">d) Representar en la Comissió Mixta d’Agrupacions la visió general de l’Agrupació, traslladant-hi les seues propostes, necessitats, inquietuds, projectes i incidències, així com aquells assumptes que resulten rellevants per a la coordinació general de la Societat.</span>

  <span class="sjma-change-marker">e) Contribuir a mantindre un bon clima humà, de treball i de convivència dins de l’Agrupació.</span>

  <span class="sjma-change-marker">f) Les altres funcions que els atribuïsquen aquests Estatuts o les normes internes de la Societat.</span>
HTML

ARTICLE53_TITLE = "Article 53. De l’elecció de les Persones Delegades"
ARTICLE53_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Persones Delegades tindran una vigència d’un exercici artístic i podran ser reelegides.</span>

  <span class="sjma-change-marker">2. Cada Agrupació Artística Titular celebrarà, almenys una vegada a l’any, una Assemblea d’Agrupació per a l’elecció de les seues Persones Delegades i per a tractar altres assumptes propis de l’Agrupació.</span>

  <span class="sjma-change-marker">3. L’elecció de les Persones Delegades haurà de celebrar-se durant el tercer trimestre de l’any natural, coincidint amb la finalització d’un exercici artístic i la preparació del següent.</span>

  <span class="sjma-change-marker">4. La convocatòria haurà d’indicar, almenys, data, hora, lloc o mitjà de celebració, Ordre del Dia, nombre de Persones Delegades a escollir i termini de presentació de candidatures.</span>

  <span class="sjma-change-marker">5. La convocatòria haurà de realitzar-se amb una antelació mínima de 15 dies naturals. Les candidatures podran presentar-se durant els 7 dies naturals següents a la convocatòria.</span>

  <span class="sjma-change-marker">6. El dia natural següent a la finalització del termini de presentació es farà pública la relació de candidatures presentades pels mitjans habituals de comunicació interna de l’Agrupació.</span>

  <span class="sjma-change-marker">7. Resultaran escollides les persones candidates que obtinguen major nombre de vots fins a cobrir el nombre de Persones Delegades que corresponga a l’Agrupació.</span>

  <span class="sjma-change-marker">8. Durant el primer exercici artístic de funcionament d’una Agrupació Artística Titular, les Persones Delegades seran designades provisionalment per Resolució de la Junta Directiva, escoltada la Direcció tècnic-artística, una vegada transcorregut un període inicial suficient per a valorar la participació i implicació de les persones que la integren.</span>

  <span class="sjma-change-marker">9. Si finalitzat el tercer trimestre no s’haguera convocat l’Assemblea d’Agrupació per a l’elecció de Persones Delegades, la Direcció tècnic-artística haurà de convocar-la, amb el vistiplau de la Junta Directiva.</span>
HTML

ARTICLE54_TITLE = "Article 54. De les Assemblees d’Agrupació"
ARTICLE54_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació són espais interns de deliberació i proposta de les persones integrants actives de cada Agrupació Artística Titular.</span>

  <span class="sjma-change-marker">2. No tenen la consideració d’òrgans de govern de la Societat i els seus acords o posicionaments tindran caràcter intern i no vinculant.</span>

  <span class="sjma-change-marker">3. La Direcció tècnic-artística i les persones representants de la Junta Directiva podran assistir-hi, amb veu i sense vot, quan siguen convidades per les Persones Delegades o per acord de la mateixa Assemblea d’Agrupació.</span>

  <span class="sjma-change-marker">4. La Direcció tècnic-artística o la Junta Directiva podran sol·licitar a les Persones Delegades la convocatòria d’una Assemblea d’Agrupació quan consideren necessari tractar amb l’Agrupació projectes, necessitats, incidències o assumptes d’especial rellevància. En aquest cas, les Persones Delegades hauran de convocar-la, i la Direcció tècnic-artística o les persones representants de la Junta Directiva sol·licitants podran assistir-hi amb veu i sense vot.</span>
HTML

ARTICLE55_TITLE = "Article 55. Del funcionament de les Assemblees d’Agrupació"
ARTICLE55_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació seran convocades per les Persones Delegades, d’acord amb aquests Estatuts i amb les normes internes de cada Agrupació.</span>

  <span class="sjma-change-marker">2. La convocatòria haurà de fer-se pública pels mitjans habituals de comunicació interna de l’Agrupació i haurà d’indicar, almenys, la data, hora, lloc o mitjà de celebració i l’Ordre del Dia.</span>

  <span class="sjma-change-marker">3. Les Assemblees d’Agrupació quedaran vàlidament constituïdes amb les persones integrants actives que hi assistisquen, sense exigència de quòrum mínim, llevat que el Reglament de Règim Intern de l’Agrupació establisca una altra previsió compatible amb aquests Estatuts.</span>

  <span class="sjma-change-marker">4. Les votacions es realitzaran per majoria simple de les persones integrants actives assistents amb dret a vot, sense perjudici de les regles específiques previstes per a l’elecció de Persones Delegades o per les normes internes de l’Agrupació.</span>
HTML

ARTICLE56_TITLE = "Article 56. Dels acords i posicionaments de les Assemblees d’Agrupació"
ARTICLE56_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació podran adoptar acords o posicionaments interns sobre els assumptes propis de l’Agrupació.</span>

  <span class="sjma-change-marker">2. Aquests acords o posicionaments no tindran caràcter vinculant per als òrgans de govern de la Societat, sense perjudici que hagen de ser traslladats a la Direcció tècnic-artística, a la Comissió Mixta d’Agrupacions o a la Junta Directiva quan corresponga.</span>
HTML

ARTICLE57_TITLE = "Article 57. Del dipòsit de béns mobles relacionats amb l’activitat artística propietat de la Societat"
ARTICLE57_BODY = <<~HTML.strip
  1. L’instrument, uniforme <span class="sjma-change-marker">o qualsevol altre objecte que siga propietat de la Societat i el deixe a les persones integrants actives de l’Agrupació</span> es farà en qualitat de dipòsit. Estaran sempre a disposició de la Junta Directiva, que podrà retirar-los quan així ho acordara, cas en el qual la persona dipositària els haurà de lliurar immediatament. Si així no ho fera, incorrerà en les responsabilitats civils o penals pertinents. <span class="sjma-change-marker">La Junta Directiva determinarà les condicions del dipòsit</span>. <span class="sjma-change-marker">Per a la resta de qüestions no previstes, serà aplicable el règim del dipòsit previst al Codi Civil.</span>

  <span class="sjma-change-marker">2. Les persones que, per qualsevol circumstància, deixen de ser persones integrants actives de l’Agrupació, es veuran obligades a tornar quantes pertinències de la Societat estiguen al seu càrrec en un termini no superior d’un mes prèvia notificació de la Junta Directiva.</span>
HTML

ARTICLE58_TITLE = "Article 58. Dels Reglaments de Règim Intern de les Agrupacions"
ARTICLE58_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Agrupacions Artístiques Titulars podran comptar amb Reglaments de Règim Intern que desenvolupen la seua organització i funcionament, sempre que no contradiguen aquests Estatuts, els Acords de l’Assemblea General ni les Resolucions de la Junta Directiva.</span>

  <span class="sjma-change-marker">2. L’elaboració o modificació dels Reglaments de Règim Intern es farà de manera participada entre la Junta Directiva, la Direcció tècnic-artística, les Persones Delegades i les persones integrants actives de l’Agrupació.</span>

  <span class="sjma-change-marker">3. Abans de la seua aprovació, el text proposat haurà de fer-se públic entre les persones integrants actives de l’Agrupació durant un termini mínim de 7 dies naturals, perquè puguen formular aportacions.</span>

  <span class="sjma-change-marker">4. L’aprovació dels Reglaments de Règim Intern correspondrà en tot cas a la Junta Directiva mitjançant Resolució.</span>

  <span class="sjma-change-marker">5. Una vegada aprovats, els Reglaments de Règim Intern es faran públics entre les persones integrants actives de l’Agrupació pels mitjans habituals de comunicació interna.</span>
HTML

ARTICLE59_TITLE = "Article 59. De la Comissió Mixta d’Agrupacions"
ARTICLE59_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Comissió Mixta d’Agrupacions és l’espai de coordinació entre les Agrupacions Artístiques Titulars, les agrupacions i conjunts de l’Escola i la Junta Directiva.</span>

  <span class="sjma-change-marker">2. La Comissió Mixta d’Agrupacions tindrà caràcter consultiu, de coordinació i seguiment, sense facultats decisòries pròpies.</span>

  <span class="sjma-change-marker">3. Estarà integrada per les Persones Delegades de les Agrupacions Artístiques Titulars, les persones representants de les agrupacions i conjunts de l’Escola i almenys dues persones representants de la Junta Directiva.</span>

  <span class="sjma-change-marker">4. Es reunirà, almenys, una vegada al mes. Una de les persones representants de la Junta Directiva dirigirà les reunions i una altra prendrà acta.</span>
HTML

ARTICLE60_TITLE = "Article 60. Del seguiment de les Agrupacions Artístiques"
ARTICLE60_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. En la primera reunió ordinària de la Junta Directiva posterior a cada reunió de la Comissió Mixta d’Agrupacions s’inclourà un punt específic de l’Ordre del Dia denominat “Seguiment de les Agrupacions Artístiques”, en el qual es donarà compte dels assumptes tractats en la Comissió.</span>

  <span class="sjma-change-marker">2. La Junta Directiva podrà convidar les persones membres de la Comissió Mixta d’Agrupacions a les seues reunions, amb veu i sense vot, quan s’hi tracten assumptes d’especial rellevància per a les agrupacions que representen o coordinen, especialment quan aquests assumptes hagen sigut tractats prèviament en la Comissió i s’haja determinat així.</span>
HTML

ARTICLE65_TITLE = "Article 65. De les agrupacions i conjunts de l’Escola"
ARTICLE65_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les agrupacions i conjunts de l’Escola es regiran per la planificació educativa de l’Escola de la Societat, el Projecte Educatiu de Centre, el Pla d’Estudis i les normes d’organització i funcionament de l’Escola.</span>

  <span class="sjma-change-marker">2. Les agrupacions i conjunts de l’Escola estaran representats en la Comissió Mixta d’Agrupacions per la Direcció de l’Escola o per les persones responsables que aquesta designe d’acord amb l’organització educativa vigent.</span>

  <span class="sjma-change-marker">3. L’alumnat de l’Escola, quan reunisca les condicions d’aptitud suficients d’acord amb el criteri de la Direcció tècnic-artística i del professorat corresponent, i, si escau, seguint el procediment que reglamentàriament determine la Junta Directiva, podrà incorporar-se a les Agrupacions Artístiques Titulars.</span>
HTML

ARTICLE61_OLD_SCHOOL_PURPOSE_TEXT = "1. Per a fomentar l’art musical, aquesta Societat tindrà com a interés primordial la creació, organització i gestió d’una Escola i el seu manteniment."
ARTICLE61_NEW_SCHOOL_PURPOSE_TEXT = '<span class="sjma-change-marker">1. Per a fomentar l’art musical i altres disciplines artístiques, aquesta Societat tindrà com a interés primordial la creació, organització, gestió i manteniment d’una Escola.</span>'
ARTICLE61_OLD_SCHOOL_ACCESS_TEXT = '2. Totes les Persones Associades <span class="sjma-change-marker">i aquelles que componen les Joventuts</span> podran ingressar en l’Escola <span class="sjma-change-marker">en els termes que reglamentàriament es disposen</span>.'
ARTICLE61_NEW_SCHOOL_ACCESS_TEXT = '<span class="sjma-change-marker">2. L’Escola estarà oberta a les Persones Associades, a les persones que componen les Joventuts i a persones no associades, en els termes que reglamentàriament es disposen. Les Persones Associades i les Joventuts podran gaudir de les condicions, beneficis o bonificacions que aprove l’òrgan competent de la Societat.</span>'
ARTICLE62_OLD_SCHOOL_DIRECTOR_STAFF_TEXT = '<span class="sjma-change-marker">3. Podrà assumir la Direcció de l’Escola qualsevol de les persones contractades per la Societat que exercisquen la funció docent a l’Escola.</span>'
ARTICLE62_NEW_SCHOOL_DIRECTOR_STAFF_TEXT = '<span class="sjma-change-marker">3. Podrà assumir la Direcció de l’Escola qualsevol persona contractada per la Societat que forme part del claustre de l’Escola i complisca els requisits exigits per la normativa vigent aplicable.</span>'
ARTICLE62_OLD_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola qualsevol persona d’entre les contractades per la Societat que exercisquen la funció docent a l’Escola, qualsevol dels components de la Junta Directiva i qualsevol altra persona que, per raó del seu mèrit i capacitat, es considere convenient per a l’Escola que hi forme part.</span>'
ARTICLE62_INTERMEDIATE_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola qualsevol persona d’entre les contractades per la Societat que exercisquen la funció docent o de gestió a l’Escola, qualsevol dels components de la Junta Directiva i qualsevol altra persona que, per raó del seu mèrit i capacitat, es considere convenient per a l’Escola que hi forme part.</span>'
ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola les persones contractades per la Societat que exercisquen funcions docents, de gestió administrativa o de gestió acadèmica a l’Escola, d’acord amb la planificació i organització educativa vigent.</span>'
ARTICLE62_COLLABORATORS_TEXT = '<span class="sjma-change-marker">5. Sense formar part de l’Equip Directiu de l’Escola, la Junta Directiva, la Direcció de l’Escola o l’Equip Directiu podran encomanar tasques concretes de col·laboració, suport o coordinació a persones membres de la Junta Directiva, Persones Associades, famílies de l’alumnat o altres persones vinculades a la Societat, quan resulte convenient per al funcionament de l’Escola.</span>'

ARTISTIC_ARTICLE_REPLACEMENTS = {
  "Article 45." => [ARTICLE45_TITLE, ARTICLE45_BODY],
  "Article 46." => [ARTICLE46_TITLE, ARTICLE46_BODY],
  "Article 47." => [ARTICLE47_TITLE, ARTICLE47_BODY],
  "Article 48." => [ARTICLE48_TITLE, ARTICLE48_BODY],
  "Article 49." => [ARTICLE49_TITLE, ARTICLE49_BODY],
  "Article 50." => [ARTICLE50_TITLE, ARTICLE50_BODY],
  "Article 53." => [ARTICLE53_TITLE, ARTICLE53_BODY],
  "Article 54." => [ARTICLE54_TITLE, ARTICLE54_BODY],
  "Article 55." => [ARTICLE55_TITLE, ARTICLE55_BODY],
  "Article 56." => [ARTICLE56_TITLE, ARTICLE56_BODY],
  "Article 57." => [ARTICLE57_TITLE, ARTICLE57_BODY],
  "Article 58." => [ARTICLE58_TITLE, ARTICLE58_BODY],
  "Article 59." => [ARTICLE59_TITLE, ARTICLE59_BODY],
  "Article 60." => [ARTICLE60_TITLE, ARTICLE60_BODY],
  "Article 65." => [ARTICLE65_TITLE, ARTICLE65_BODY]
}.freeze

TRANSITIONAL_TITLE = "DISPOSICIONS TRANSITÒRIES"
TRANSITIONAL_BODY = <<~HTML.strip
  Primera. No seran aplicables les disposicions de la Secció 4ª del Capítol I del Títol V d’aquestos Estatuts mentre no s’aprove el corresponent Reglament del procediment disciplinari.

  <span class="sjma-change-marker">Segona. Les Agrupacions Artístiques Titulars existents en el moment d’entrada en vigor d’aquestos Estatuts comptaran inicialment amb el següent nombre de Persones Delegades:</span>

  <span class="sjma-change-marker">a) Banda Simfònica: 3 Persones Delegades.</span>

  <span class="sjma-change-marker">b) Colla de Dolçaina i Percussió: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">c) Orquestra: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">d) Cor d’Adults: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">Aquest nombre podrà ser modificat posteriorment per Resolució de la Junta Directiva en els termes previstos en aquestos Estatuts.</span>
HTML

def ensure_vicetresoreria_article!(component)
  scope = Decidim::Proposals::Proposal.where(component:)
  existing = scope.find { |proposal| proposal.title.fetch(LOCALE, nil) == VICETRESORERIA_TITLE }

  if existing
    existing.update!(
      body: existing.body.merge(LOCALE => VICETRESORERIA_BODY),
      participatory_text_level: "article"
    )
    return
  end

  article37 = scope.find { |proposal| proposal.title.fetch(LOCALE, "").start_with?("Article 37.") }
  raise "Article 37 not found; cannot insert #{VICETRESORERIA_TITLE}" unless article37

  insert_position = article37.position + 1

  Decidim::Proposals::Proposal.transaction do
    proposal = Decidim::Proposals::Proposal.new(
      component:,
      title: { LOCALE => VICETRESORERIA_TITLE },
      body: { LOCALE => VICETRESORERIA_BODY },
      participatory_text_level: "article",
      position: insert_position,
      published_at: article37.published_at,
      created_in_meeting: false
    )
    proposal.coauthorships.build(
      decidim_author_id: component.organization.id,
      decidim_author_type: "Decidim::Organization"
    )
    proposal.save!
  end
end

component = Decidim::Component.find(COMPONENT_ID)
ensure_vicetresoreria_article!(component)
scope = Decidim::Proposals::Proposal.where(component:)

updated = []

scope.find_each do |proposal|
  title = proposal.title || {}
  body = proposal.body || {}
  ca_title = title.fetch(LOCALE, "")
  ca_body = body.fetch(LOCALE, "")

  next_title = ca_title.gsub("Escola de Música", "Escola")
  next_body = ca_body.gsub("Escola de Música", "Escola")
  next_title = next_title.gsub("Joventuts de la Societat", "Joventuts")
  next_body = next_body.gsub("Joventuts de la Societat", "Joventuts")
  next_level = proposal.participatory_text_level

  if ARTISTIC_HEADINGS.key?(ca_title)
    next_title, next_level = ARTISTIC_HEADINGS.fetch(ca_title)
    next_body = next_title
  end

  if ARTISTIC_HEADINGS_BY_ID.key?(proposal.id)
    next_title, next_level = ARTISTIC_HEADINGS_BY_ID.fetch(proposal.id)
    next_body = next_title
  end

  ELECTRONIC_WRITING_REPLACEMENTS.each do |old_text, new_text|
    next_body = next_body.gsub(old_text, new_text)
  end

  SECRETARIA_TERMINOLOGY_REPLACEMENTS.each do |old_text, new_text|
    next_body = next_body.gsub(old_text, new_text)
  end

  ASSEMBLY_SESSION_TERMINOLOGY_REPLACEMENTS.each do |old_text, new_text|
    next_body = next_body.gsub(old_text, new_text)
  end

  QUALIFIED_MAJORITY_TERMINOLOGY_REPLACEMENTS.each do |old_text, new_text|
    next_body = next_body.gsub(old_text, new_text)
  end

  if ca_title.start_with?(ARTICLE8_TITLE_PREFIX)
    next_body = next_body.gsub("Joventuts de la Societat", "Joventuts")
    next_body = next_body.gsub(ARTICLE8_OLD_REGISTER_TEXT, ARTICLE8_NEW_REGISTER_TEXT)
  end

  if ca_title.start_with?(ARTICLE9_TITLE_PREFIX)
    next_body = next_body.gsub("atorgada per l’Assemblea General", "atorgada per acord de l’Assemblea General")
  end

  if ca_title.start_with?(ARTICLE10_TITLE_PREFIX)
    next_body = ARTICLE10_BODY
  end

  if ca_title.start_with?(ARTICLE13_TITLE_PREFIX) && !next_body.include?("Les persones que componen les Joventuts gaudiran")
    next_body = [next_body, ARTICLE13_YOUTH_RIGHTS_TEXT].join("\n\n")
  end

  if ca_title.start_with?(ARTICLE13_TITLE_PREFIX)
    next_body = next_body.sub(/\ATotes les Persones Associades/, "1. Totes les Persones Associades")
    next_body = next_body.gsub(
      %(<span class="sjma-change-marker">Les persones que componen les Joventuts),
      %(<span class="sjma-change-marker">2. Les persones que componen les Joventuts)
    )
  end

  if ca_title.start_with?(ARTICLE14_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE14_OLD_YOUTH_TEXT, ARTICLE14_NEW_YOUTH_DUTIES_TEXT)
  end

  if ca_title.start_with?(ARTICLE17_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE17_OLD_CREDIT_TEXT, ARTICLE17_NEW_CREDIT_TEXT)
    next_body = next_body.gsub(ARTICLE17_OLD_ELECTION_TEXT, ARTICLE17_NEW_ELECTION_TEXT)
  end

  if ca_title.start_with?(ARTICLE19_TITLE_PREFIX)
    next_body = ARTICLE19_NEW_BODY
  end

  if ca_title.start_with?(ARTICLE20_TITLE_PREFIX)
    next_body = ARTICLE20_BODY
  end

  if ca_title.start_with?(ARTICLE23_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE23_OLD_VOTE_TEXT, ARTICLE23_NEW_VOTE_TEXT)
  end

  if ca_title.start_with?(ARTICLE24_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE24_OLD_SIMPLE_MAJORITY_TEXT, ARTICLE24_NEW_SIMPLE_MAJORITY_TEXT)
    next_body = next_body.gsub(ARTICLE24_OLD_SPECIFIC_CALL_TEXT, ARTICLE24_NEW_SPECIFIC_CALL_TEXT)
  end

  if ca_title.start_with?(ARTICLE29_TITLE_PREFIX)
    next_title = ARTICLE29_TITLE
    next_body = ARTICLE29_BODY
  end

  if ca_title.start_with?(ARTICLE30_TITLE_PREFIX)
    next_body = ARTICLE30_BODY
  end

  if ca_title.start_with?(ARTICLE31_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE31_OLD_BOARD_COMPOSITION_TEXT, ARTICLE31_NEW_BOARD_COMPOSITION_TEXT)
  end

  if ca_title.start_with?(ARTICLE32_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE32_OLD_ANNUAL_ACCOUNTS_TEXT, ARTICLE32_NEW_ANNUAL_ACCOUNTS_TEXT)
    next_body = next_body.gsub(ARTICLE32_OLD_SCHOOL_STAFF_TEXT, ARTICLE32_NEW_SCHOOL_STAFF_TEXT)
  end

  if ca_title.start_with?(ARTICLE33_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE33_OLD_SCHOOL_STAFF_TEXT, ARTICLE33_NEW_SCHOOL_STAFF_TEXT)
  end

  if ca_title.start_with?(ARTICLE35_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE35_OLD_FORMAL_NOTICES_TEXT, ARTICLE35_NEW_FORMAL_NOTICES_TEXT)
    next_body = next_body.gsub(ARTICLE35_OLD_CERTIFICATES_TEXT, ARTICLE35_NEW_CERTIFICATES_TEXT)
  end

  if ca_title.start_with?(ARTICLE36_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE36_OLD_NO_VICESECRETARY_TEXT, ARTICLE36_NEW_NO_VICESECRETARY_TEXT)
  end

  if ca_title.start_with?(ARTICLE42_TITLE_PREFIX)
    next_body = ARTICLE42_BODY
  end

  ARTISTIC_ARTICLE_REPLACEMENTS.each do |prefix, replacement|
    next unless ca_title.start_with?(prefix)

    next_title, next_body = replacement
    break
  end

  if ca_title == "DISPOSICIÓ TRANSITÒRIA"
    next_title = TRANSITIONAL_TITLE
    next_body = TRANSITIONAL_BODY
  end

  if ca_title.start_with?(ARTICLE75_TITLE_PREFIX)
    next_title = ARTICLE75_TITLE
    next_body = ARTICLE75_BODY
  end

  if ca_title.start_with?("Article 61.")
    next_body = next_body.gsub(ARTICLE61_OLD_SCHOOL_PURPOSE_TEXT, ARTICLE61_NEW_SCHOOL_PURPOSE_TEXT)
    next_body = next_body.gsub(ARTICLE61_OLD_SCHOOL_ACCESS_TEXT, ARTICLE61_NEW_SCHOOL_ACCESS_TEXT)
  end

  if ca_title.start_with?("Article 62.")
    next_body = next_body.gsub(ARTICLE62_OLD_SCHOOL_DIRECTOR_STAFF_TEXT, ARTICLE62_NEW_SCHOOL_DIRECTOR_STAFF_TEXT)
    next_body = next_body.gsub(ARTICLE62_OLD_MANAGEMENT_STAFF_TEXT, ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT)
    next_body = next_body.gsub(ARTICLE62_INTERMEDIATE_MANAGEMENT_STAFF_TEXT, ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT)
    next_body = [next_body, ARTICLE62_COLLABORATORS_TEXT].join("\n\n") unless next_body.include?("Sense formar part de l’Equip Directiu de l’Escola")
  end

  next if next_title == ca_title && next_body == ca_body && next_level == proposal.participatory_text_level

  proposal.title = title.merge(LOCALE => next_title)
  proposal.body = body.merge(LOCALE => next_body)
  proposal.participatory_text_level = next_level
  proposal.save!
  updated << "#{proposal.id}: #{ca_title} -> #{next_title}"
end

scope.where(participatory_text_level: nil).where("title ->> ? = ?", LOCALE, "Article 31. De la composició de la Junta Directiva").destroy_all

puts "Updated #{updated.size} proposals"
updated.each { |line| puts line }
