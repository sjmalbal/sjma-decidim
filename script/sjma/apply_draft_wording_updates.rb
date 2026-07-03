#!/usr/bin/env ruby
# frozen_string_literal: true

COMPONENT_ID = ENV.fetch("DECIDIM_PROPOSALS_COMPONENT_ID", "7")
LOCALE = "ca"
ARTICLE3_TITLE_PREFIX = "Article 3."
ARTICLE4_TITLE_PREFIX = "Article 4."
ARTICLE8_TITLE_PREFIX = "Article 8."
ARTICLE9_TITLE_PREFIX = "Article 9."
ARTICLE10_TITLE_PREFIX = "Article 10."
ARTICLE11_TITLE_PREFIX = "Article 11."
ARTICLE13_TITLE_PREFIX = "Article 13."
ARTICLE14_TITLE_PREFIX = "Article 14."
ARTICLE17_TITLE_PREFIX = "Article 17."
ARTICLE18_TITLE_PREFIX = "Article 18."
ARTICLE19_TITLE_PREFIX = "Article 19."
ARTICLE20_TITLE_PREFIX = "Article 20."
ARTICLE22_TITLE_PREFIX = "Article 22."
ARTICLE23_TITLE_PREFIX = "Article 23."
ARTICLE24_TITLE_PREFIX = "Article 24."
ARTICLE28_TITLE_PREFIX = "Article 28."
ARTICLE29_TITLE_PREFIX = "Article 29."
ARTICLE30_TITLE_PREFIX = "Article 30."
ARTICLE31_TITLE_PREFIX = "Article 31."
ARTICLE32_TITLE_PREFIX = "Article 32."
ARTICLE33_TITLE_PREFIX = "Article 33."
ARTICLE35_TITLE_PREFIX = "Article 35."
ARTICLE36_TITLE_PREFIX = "Article 36."
ARTICLE42_TITLE_PREFIX = "Article 42."
ARTICLE44_TITLE_PREFIX = "Article 44."
ARTICLE66_TITLE_PREFIX = "Article 66."
INTERPRETATION_ARTICLE_PROPOSAL_ID = 574
REVIEW_AND_JURISDICTION_SECTION_PROPOSAL_ID = 585
BON_GOVERN_ARTICLE_PROPOSAL_ID = 584
REVISION_ARTICLE_PROPOSAL_ID = 586
JURISDICTIONAL_CHALLENGE_ARTICLE_PROPOSAL_ID = 587
DISCIPLINARY_RESPONSIBILITY_ARTICLE_PROPOSAL_ID = 589
DISCIPLINARY_GENERAL_ARTICLE_PROPOSAL_ID = 590
DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_PROPOSAL_ID = 591
VERY_SERIOUS_FAULTS_ARTICLE_PROPOSAL_ID = 592
SERIOUS_FAULTS_ARTICLE_PROPOSAL_ID = 593
MINOR_OFFENSES_ARTICLE_PROPOSAL_ID = 594
VERY_SERIOUS_SANCTIONS_ARTICLE_PROPOSAL_ID = 595
SERIOUS_SANCTIONS_ARTICLE_PROPOSAL_ID = 596
MINOR_SANCTIONS_ARTICLE_PROPOSAL_ID = 597
SANCTION_GRADUATION_ARTICLE_PROPOSAL_ID = 598
PRESCRIPTION_ARTICLE_PROPOSAL_ID = 599
BOARD_DISCIPLINE_ARTICLE_PROPOSAL_ID = 600
DISCIPLINARY_PROCEDURE_ARTICLE_PROPOSAL_ID = 601
INITIAL_ASSETS_ARTICLE_PROPOSAL_ID = 605
ASSETS_DESTINATION_ARTICLE_PROPOSAL_ID = 606
ECONOMIC_RESOURCES_ARTICLE_PROPOSAL_ID = 608
ACTIVITY_BENEFIT_ARTICLE_PROPOSAL_ID = 609
BUDGETS_AND_FISCAL_YEAR_ARTICLE_PROPOSAL_ID = 611
ORDINARY_BUDGETS_ARTICLE_PROPOSAL_ID = 612
EXTRAORDINARY_BUDGETS_ARTICLE_PROPOSAL_ID = 613
FINANCIAL_CONTROL_ARTICLE_PROPOSAL_ID = 614
STATUTES_AMENDMENT_PROCEDURE_ARTICLE_PROPOSAL_ID = 616
STATUTES_AMENDMENTS_ARTICLE_PROPOSAL_ID = 617
STATUTES_APPROVAL_ARTICLE_PROPOSAL_ID = 618
DISSOLUTION_CAUSES_ARTICLE_PROPOSAL_ID = 620
LIQUIDATION_ARTICLE_PROPOSAL_ID = 621
FINAL_DISPOSITION_PROPOSAL_ID = 623
ARTICLE_RENUMBER_BY_ID = {
  625 => 38,
  529 => 39,
  531 => 40,
  532 => 41,
  533 => 42,
  534 => 43,
  536 => 44,
  537 => 45,
  540 => 46,
  541 => 47,
  542 => 48,
  543 => 49,
  545 => 50,
  546 => 51,
  548 => 52,
  549 => 53,
  553 => 54,
  554 => 55,
  555 => 56,
  556 => 57,
  557 => 58,
  559 => 59,
  560 => 60,
  562 => 61,
  565 => 62,
  567 => 63,
  568 => 64,
  570 => 65,
  571 => 66,
  573 => 67,
  574 => 68,
  577 => 69,
  578 => 70,
  626 => 71,
  579 => 72,
  581 => 73,
  582 => 74,
  583 => 75,
  584 => 76,
  586 => 77,
  587 => 78,
  589 => 79,
  590 => 80,
  591 => 81,
  592 => 82,
  593 => 83,
  594 => 84,
  595 => 85,
  596 => 86,
  597 => 87,
  598 => 88,
  599 => 89,
  600 => 90,
  601 => 91,
  603 => 92,
  605 => 93,
  606 => 94,
  608 => 95,
  609 => 96,
  611 => 97,
  612 => 98,
  613 => 99,
  614 => 100,
  616 => 101,
  617 => 102,
  618 => 103,
  620 => 104,
  621 => 105
}.freeze

ARTISTIC_HEADINGS = {
  "CAPÍTOL TERCER: DELS ALTRES ÒRGANS DE PARTICIPACIÓ" => ["TÍTOL III: DE L’ACTIVITAT ARTÍSTICA", "section"],
  "Secció 1ª: De l’Assemblea de Músics" => ["CAPÍTOL PRIMER: DE LES AGRUPACIONS ARTÍSTIQUES TITULARS", "sub-section"],
  "Secció 2ª: De les Persones Delegades" => ["Secció 1ª: De les Persones Delegades", "sub-section"],
  "Secció 3ª: De l’Arxiu de la Societat" => ["CAPÍTOL SEGON: DE L’ARXIU DE LA SOCIETAT", "sub-section"],
  "CAPÍTOL PRIMER: DE LES AGRUPACIONS MUSICALS DE LA SOCIETAT" => ["Secció 1ª: De les Assemblees d’Agrupació", "sub-section"],
  "Secció 1ª: De l’estatut de les persones que les componen" => ["Secció 2ª: De la Comissió Mixta d’Agrupacions", "sub-section"],
  "Secció 2ª: De les agrupacions de la Societat" => ["Secció 3ª: Dels Reglaments de Règim Intern", "sub-section"],
  "CAPÍTOL SEGON: DE LA RESTA D’ACTIVITATS ARTÍSTIQUES I CULTURALS" => ["Secció 3ª: De la coordinació i seguiment de les Agrupacions", "sub-section"],
  "CAPÍTOL ÚNIC: DE L’ESCOLA DE MÚSICA" => ["CAPÍTOL ÚNIC: DE L’ESCOLA", "sub-section"]
}.freeze

ARTISTIC_HEADINGS_BY_ID = {
  544 => ["Secció 1ª: De les persones integrants actives i les Persones Delegades", "sub-section"],
  538 => ["TÍTOL III: DE L’ACTIVITAT ARTÍSTICA", "section"],
  550 => ["CAPÍTOL TERCER: DE L’ORGANITZACIÓ I COORDINACIÓ DE LES AGRUPACIONS", "sub-section"]
}.freeze

ARTISTIC_ORGANIZATION_REMOVED_IDS = [561].freeze

ARTISTIC_ORGANIZATION_ORDER = {
  551 => [74, "Secció 1ª: De les Assemblees d’Agrupació i les Persones Delegades", "sub-section"],
  553 => [75, "Article 54. De l’elecció de les Persones Delegades", "article"],
  554 => [76, "Article 55. De les Assemblees d’Agrupació", "article"],
  555 => [77, "Article 56. Del funcionament de les Assemblees d’Agrupació", "article"],
  556 => [78, "Article 57. Dels acords i posicionaments de les Assemblees d’Agrupació", "article"],
  558 => [79, "Secció 2ª: De l’organització interna i els béns de les Agrupacions", "sub-section"],
  557 => [80, "Article 58. Del dipòsit de béns mobles relacionats amb l’activitat artística propietat de la Societat", "article"],
  559 => [81, "Article 59. Dels Reglaments de Règim Intern de les Agrupacions", "article"],
  552 => [82, "Secció 3ª: De la coordinació i seguiment de les Agrupacions", "sub-section"],
  560 => [83, "Article 60. De la Comissió Mixta d’Agrupacions", "article"],
  562 => [84, "Article 61. Del seguiment de les Agrupacions Artístiques", "article"]
}.freeze

ARTICLE_TITLES_BY_ID = {
  494 => "Article 12. De la igualtat de drets i deures",
  498 => "Article 15. Dels òrgans de govern i representació",
  501 => "Article 16. De l’Assemblea General",
  502 => "Article 17. De les competències de l’Assemblea General",
  504 => "Article 18. De la representació en l’Assemblea General",
  514 => "Article 25. De la Junta Directiva",
  573 => "Article 67. De la normativa aplicable"
}.freeze

ARTICLE4_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Totes les activitats de la Societat estan obertes a la ciutadania en general. Les activitats realitzades per la Societat per a l’acompliment dels seus fins es destinaran a tot el poble d’Albal i no quedaran restringides exclusivament al benefici de les seues Persones Associades.</span>

  <span class="sjma-change-marker">Això s’entén sense perjudici dels drets de participació, condicions, beneficis o bonificacions que puguen correspondre legítimament a les Persones Associades, a les Joventuts o a altres persones en supòsits objectius aprovats per l’òrgan competent, d’acord amb aquests Estatuts, els reglaments interns i els acords dels òrgans competents.</span>
HTML

ARTICLE8_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Són Persones Associades les persones inscrites en la Societat com a sòcies de ple dret, amb interés pel desenvolupament dels fins de la Societat, la música i la convivència social.</span>

  <span class="sjma-change-marker">Podran associar-se les persones físiques majors d’edat i les persones jurídiques sense ànim de lucre, en aquest últim cas previ acord exprés del seu òrgan competent, que, en ambdós casos, no estiguen subjectes a cap condició legal per a l’exercici dels seus drets.</span>

  <span class="sjma-change-marker">2. Aquelles persones que, no havent assolit la majoria d’edat ni l’emancipació, s’integren en alguna Agrupació Artística Titular o participen en activitats de la Societat amb vinculació associativa, conformaran les Joventuts.</span>

  <span class="sjma-change-marker">Per a la seua inclusió a les Joventuts es requerirà l’autorització o consentiment de la persona o les persones que tinguen la pàtria potestat o tutela o que suplisquen la seua capacitat, i que aquesta o alguna d’aquestes estiga inscrita com a Persona Associada a la Societat.</span>

  <span class="sjma-change-marker">L’alumnat menor d’edat de l’Escola que no tinga aquesta vinculació associativa es regirà pel règim propi de l’Escola i per l’autorització o consentiment de les persones que n’exercisquen la representació legal, sense necessitat que aquestes tinguen la condició de Persona Associada.</span>

  <span class="sjma-change-marker">3. Les persones que conformen les Joventuts no tindran dret de vot en l’Assemblea General ni en els òrgans de govern de la Societat, ni podran accedir a càrrecs directius. En assolir la majoria d’edat i tindre plena capacitat d’obrar, podran sol·licitar la seua incorporació com a Persones Associades. La continuïtat com a persona integrant activa major d’edat d’una Agrupació Artística Titular requerirà tindre la condició de Persona Associada, d’acord amb aquests Estatuts.</span>

  <span class="sjma-change-marker">4. La condició de Persona Associada és intransmissible.</span>

  <span class="sjma-change-marker">5. Les Persones Associades i les Joventuts es relacionaran en un Llibre Registre, que podrà consistir en una base de dades informatitzada, sempre que permeta obtindre en qualsevol moment una relació nominal actualitzada.</span>

  <span class="sjma-change-marker">Les Joventuts constaran en una secció o apartat propi del Llibre Registre, sense assignació del número permanent reservat a les Persones Associades, llevat que reglamentàriament es dispose altra cosa.</span>

  <span class="sjma-change-marker">El Llibre Registre estarà conformat per dues seccions: el Registre Actiu i el Registre Històric. En el Registre Actiu constaran les Persones Associades en situació d’alta, a cadascuna de les quals se li assignarà un número seqüencial, permanent i intransmissible.</span>

  <span class="sjma-change-marker">Quan una Persona Associada cause baixa, passarà al Registre Històric, conservant en tot cas el número que tenia assignat. Aquest número no podrà ser reutilitzat ni assignat a cap altra Persona Associada. Les noves altes rebran el número correlatiu següent a l’últim número assignat, amb independència que les persones titulars dels números anteriors continuen en el Registre Actiu o hagen passat al Registre Històric.</span>

  <span class="sjma-change-marker">En el Registre Històric únicament es conservaran les dades mínimes necessàries per a identificar la persona i acreditar la seua relació històrica amb la Societat, sense perjudici dels drets que li corresponguen en matèria de protecció de dades personals, inclòs, si escau, el dret de supressió d’acord amb la normativa vigent aplicable.</span>
HTML

ARTICLE10_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les persones físiques o jurídiques que desitgen ingressar en la Societat com a Persones Associades hauran de sol·licitar-ho per escrit, mitjançant correu electrònic, formulari electrònic o altres canals habilitats per la Societat, dirigint la sol·licitud a la Junta Directiva.</span>

  <span class="sjma-change-marker">2. Es donarà publicitat interna a la petició, amb el nom i cognoms o denominació de la persona sol·licitant i, si escau, qualsevol altra identificació social estrictament necessària per a evitar confusions, durant el termini d’un mes, durant el qual podran presentar-se al·legacions. No es publicaran dades identificatives, de contacte o altres dades personals que no siguen necessàries per a aquesta finalitat. Transcorregut aquest termini, la persona sol·licitant passarà a integrar-se com a Persona Associada, llevat que la Junta Directiva haja comunicat motivadament la denegació de l’admissió o la suspensió de la decisió per causa justificada.</span>

  <span class="sjma-change-marker">3. La suspensió no podrà excedir d’un mes addicional. Transcorregut aquest termini sense denegació motivada, la persona sol·licitant passarà a integrar-se com a Persona Associada.</span>

  <span class="sjma-change-marker">4. La denegació de l’admissió podrà ser objecte de revisió interna en els termes previstos en l’article 77 d’aquestos Estatuts, sense perjudici de les accions d’impugnació que corresponguen davant l’ordre jurisdiccional civil.</span>

  <span class="sjma-change-marker">5. Les altes produïdes seran informades i sotmeses a ratificació en la següent Assemblea General ordinària. La ratificació tindrà efectes de control de regularitat i no suspendrà per si mateixa la condició de Persona Associada ja adquirida, sense perjudici que, si s’apreciara incompliment dels requisits estatutaris, es tramite la revisió o baixa que corresponga amb les garanties previstes en aquests Estatuts.</span>
HTML

ARTICLE29_OLD_ELECTORAL_ROLL_TEXT = "a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari."
ARTICLE29_NEW_ELECTORAL_ROLL_TEXT = <<~HTML.strip
  a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari.

  <span class="sjma-change-marker">A l’efecte de participar en les eleccions internes, només formaran part del cens electoral les persones que hagueren adquirit la condició de Persona Associada abans de la data de convocatòria de les eleccions.</span>
HTML

ARTICLE75_TITLE = "Article 76. De la revisió interna de les Resolucions de la Junta Directiva"
ARTICLE75_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Persones Associades podran sol·licitar la revisió interna de les Resolucions de la Junta Directiva que estimen contràries a la llei, als Estatuts o als Acords de l’Assemblea General, mitjançant escrit motivat presentat davant la mateixa Junta Directiva per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, en el termini de 30 dies des de la notificació de la Resolució o Resolucions de què es tracte.</span>

  <span class="sjma-change-marker">2. La sol·licitud de revisió interna obligarà la Junta Directiva a revisar la Resolució objecte de revisió i a dictar una nova Resolució motivada, confirmant-la, modificant-la o deixant-la sense efecte, en la primera reunió ordinària que celebre o, en tot cas, en el termini màxim de dos mesos des de la presentació de la sol·licitud.</span>

  <span class="sjma-change-marker">3. La sol·licitud de revisió interna no suspendrà per si mateixa l’eficàcia ni l’execució de la Resolució revisada. No obstant això, la Junta Directiva podrà acordar motivadament, d’ofici o a petició de la persona interessada, la suspensió total o parcial de la seua execució quan aquesta puga causar perjudicis de difícil o impossible reparació, sempre que la suspensió no perjudique greument l’interés de la Societat, els drets de terceres persones o el funcionament ordinari de l’entitat.</span>

  <span class="sjma-change-marker">4. Si la Junta Directiva confirma la Resolució revisada, totalment o parcialment, la Persona Associada interessada podrà promoure la sol·licitud de convocatòria d’una Assemblea General Extraordinària en els termes previstos en aquestos Estatuts, sempre que reunisca el suport mínim exigit per a la seua convocatòria.</span>

  <span class="sjma-change-marker">5. La sol·licitud de revisió interna no impedirà l’exercici directe de les accions d’impugnació que corresponguen davant l’ordre jurisdiccional civil, en els termes previstos en l’article següent i en la normativa aplicable, ni suspendrà per si mateixa els terminis per a exercir-les.</span>

  <span class="sjma-change-marker">6. De les sol·licituds de revisió interna que no siguen estimades íntegrament es donarà compte en la següent Assemblea General ordinària, amb la informació necessària i preservant les dades o circumstàncies que requerisquen reserva, perquè l’Assemblea puga conèixer-ne el criteri i, si escau, ratificar, revocar o instar la modificació de la Resolució revisada dins de les seues competències.</span>
HTML

JURISDICTIONAL_CHALLENGE_ARTICLE_TITLE = "Article 77. De la impugnació per via jurisdiccional"
JURISDICTIONAL_CHALLENGE_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Seran impugnables davant l’ordre jurisdiccional civil els Acords de l’Assemblea General i les Resolucions de la Junta Directiva quan siguen contraris a la llei, s’oposen als Estatuts o lesionen els interessos de la Societat, pels tràmits del judici que corresponga.</span>

  <span class="sjma-change-marker">2. Tindran legitimació per a exercir les accions d’impugnació qualsevol persona, siga associada o no, que acredite un interés legítim; les persones assistents a l’Assemblea General o a la Junta Directiva que hagueren fet constar en acta la seua oposició a la celebració de la sessió o reunió o el seu vot contra l’Acord o Resolució adoptada; les Persones Associades o Càrrecs absents; i aquelles persones que hagueren sigut il·legítimament privades d’emetre el seu vot.</span>

  <span class="sjma-change-marker">3. Les accions d’impugnació dels Acords i Resolucions contraris als Estatuts s’exerciran dins del termini de 40 dies comptats des de la data de la seua adopció, a través dels tràmits establerts en la normativa processal aplicable.</span>

  <span class="sjma-change-marker">4. Les accions relatives a Acords o Resolucions contraris a la llei, a l’ordre públic o a altres normes imperatives s’exerciran pels terminis, vies i efectes previstos en la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">5. De la impugnació judicial de Resolucions de la Junta Directiva es donarà compte a l’Assemblea General en la primera sessió ordinària que se celebre perquè, si escau i dins de les seues competències, acorde la ratificació o revocació de la Resolució impugnada, amb la informació necessària i preservant les dades o circumstàncies que requerisquen reserva.</span>
HTML

DISCIPLINARY_RESPONSIBILITY_ARTICLE_TITLE = "Article 78. De la responsabilitat disciplinària a la Societat"
DISCIPLINARY_RESPONSIBILITY_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Sense perjudici de les responsabilitats civils o penals en què pogueren incórrer pels actes o omissions que els siguen imputables en el marc de la vida social i de les activitats de la Societat, les Persones Associades estaran subjectes al règim disciplinari previst en aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. Les persones que componen les Joventuts, l’alumnat de l’Escola, les persones integrants actives no associades i les persones col·laboradores quedaran subjectes a les normes internes de convivència, organització i participació aplicables a l’activitat en què participen. Aquestes normes podran preveure mesures proporcionades a l’incompliment produït, incloent advertències, mesures educatives o restauratives, limitació temporal de participació en activitats determinades o pèrdua de la condició de participant en l’activitat corresponent, sense que tinguen la consideració de sancions disciplinàries pròpies de les Persones Associades.</span>

  <span class="sjma-change-marker">3. Quan les mesures afecten persones menors d’edat, s’adoptaran amb respecte als principis d’audiència, proporcionalitat, protecció de la persona menor i comunicació a les persones que n’exercisquen la representació legal quan corresponga.</span>

  <span class="sjma-change-marker">4. El personal contractat per la Societat es regirà pel règim laboral aplicable, inclosos l’Estatut dels Treballadors, els convenis col·lectius i la resta de normativa laboral. Les previsions d’aquest títol no substituiran el règim disciplinari laboral, sense perjudici que una persona contractada que també siga Persona Associada puga quedar subjecta al règim disciplinari estatutari pels fets comesos en aquesta condició i en l’àmbit associatiu.</span>
HTML

DISCIPLINARY_GENERAL_ARTICLE_TITLE = "Article 79. Disposicions generals del règim disciplinari"
DISCIPLINARY_GENERAL_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. No podrà sancionar-se cap acció ni omissió que no estiga prevista com a falta en aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. No podrà imposar-se cap sanció distinta de les previstes en aquestos Estatuts per a les faltes de la naturalesa corresponent.</span>

  <span class="sjma-change-marker">3. No podrà imposar-se ni executar-se cap sanció sense expedient previ resolt per l’òrgan competent, d’acord amb el procediment previst en aquestos Estatuts.</span>

  <span class="sjma-change-marker">4. El procediment disciplinari respectarà, en tot cas, els principis d’audiència, defensa, contradicció, presumpció d’innocència, responsabilitat, culpabilitat, proporcionalitat i resolució motivada.</span>

  <span class="sjma-change-marker">5. La suspensió de drets no podrà afectar els drets legals d’audiència, defensa, informació essencial, impugnació ni baixa voluntària.</span>

  <span class="sjma-change-marker">6. Les normes disciplinàries s’interpretaran de manera restrictiva i no s’aplicaran retroactivament, excepte quan resulten més favorables per a la persona afectada.</span>
HTML

DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_TITLE = "Article 80. De les faltes disciplinàries"
DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_BODY = '<span class="sjma-change-marker">Les faltes disciplinàries es classifiquen en molt greus, greus i lleus.</span>'

VERY_SERIOUS_FAULTS_ARTICLE_TITLE = "Article 81. De les faltes molt greus"
VERY_SERIOUS_FAULTS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Són faltes molt greus:</span>

  <span class="sjma-change-marker">a) Els actes o omissions vinculats a la Societat, a les seues activitats o a l’exercici dels drets i deures socials que pogueren constituir infracció penal qualificada com a delicte.</span>

  <span class="sjma-change-marker">b) L’actuació deshonesta o la falta de probitat en la custòdia, administració, gestió o recaptació dels fons socials o dels béns confiats per raó del càrrec o de la funció exercida.</span>

  <span class="sjma-change-marker">c) La desobediència greu als Acords i Resolucions dels òrgans de govern i de representació de la Societat, en l’àmbit de les seues competències i en l’exercici de les seues funcions.</span>

  <span class="sjma-change-marker">d) Pel que fa a les persones que componen la Junta Directiva, l’incompliment dolós de les disposicions estatutàries o dels Acords de l’Assemblea General.</span>

  <span class="sjma-change-marker">e) Causar dolosament danys o pèrdues als béns, materials, instal·lacions, instruments o altres pertinences de la Societat.</span>

  <span class="sjma-change-marker">f) L’impagament reiterat de les quotes, derrames o altres obligacions econòmiques aprovades per l’Assemblea General durant dos exercicis consecutius, quan haja existit requeriment previ de pagament i no s’haja regularitzat la situació ni comunicat la voluntat de causar baixa.</span>

  <span class="sjma-change-marker">g) La comissió de tres faltes greus no prescrites, sempre que les anteriors hagen sigut declarades per resolució disciplinària ferma.</span>

  <span class="sjma-change-marker">h) L’assetjament, agressió, intimidació, discriminació, vexació o qualsevol conducta que atempte greument contra la dignitat, integritat, llibertat o seguretat de les persones, especialment quan afecte persones menors d’edat o persones en situació de vulnerabilitat.</span>

  <span class="sjma-change-marker">i) L’accés no autoritzat, ús indegut greu, alteració, destrucció, ocultació o difusió indeguda de dades personals, documents, registres, credencials, sistemes d’informació o altres recursos digitals de la Societat, quan cause o puga causar un perjudici greu a la Societat o a terceres persones.</span>

  <span class="sjma-change-marker">j) L’apropiació, retenció injustificada, cessió a terceres persones, no devolució o ús no autoritzat d’instruments, material, uniformes, documents, claus, credencials, instal·lacions o altres béns de la Societat, quan cause o puga causar un perjudici greu.</span>

  <span class="sjma-change-marker">k) L’incompliment greu dels deures de confidencialitat, imparcialitat, abstenció per conflicte d’interés, custòdia, documentació o rendició de comptes per part de persones que exercisquen càrrecs, funcions delegades o responsabilitats encomanades per la Societat.</span>
HTML

SERIOUS_FAULTS_ARTICLE_TITLE = "Article 82. De les faltes greus"
SERIOUS_FAULTS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Són faltes greus:</span>

  <span class="sjma-change-marker">a) La desobediència als Acords i Resolucions dels òrgans de govern i de representació, o a les indicacions legítimes de les persones que exercisquen càrrecs o funcions dins de la Societat, quan no constituïsca falta molt greu.</span>

  <span class="sjma-change-marker">b) Els altercats o manifestacions injurioses, vexatòries, discriminatòries o greument ofensives cap als òrgans de govern i de representació, cap a altres Persones Associades o cap a persones vinculades a les activitats de la Societat.</span>

  <span class="sjma-change-marker">c) La falta de respecte i consideració greu cap a les direccions tècnic-artístiques, personal, persones participants o públic en general en els actes, activitats o espais de la Societat.</span>

  <span class="sjma-change-marker">d) Les conductes que perjudiquen greument la convivència, el bon nom, la dignitat o el normal funcionament de la Societat.</span>

  <span class="sjma-change-marker">e) L’impagament de les quotes, derrames o altres obligacions econòmiques aprovades per l’Assemblea General durant un exercici econòmic, quan haja existit requeriment previ de pagament i no s’haja regularitzat la situació ni comunicat la voluntat de causar baixa.</span>

  <span class="sjma-change-marker">f) La comissió de tres faltes lleus no prescrites, sempre que les anteriors hagen sigut declarades per resolució disciplinària ferma.</span>

  <span class="sjma-change-marker">g) L’incompliment greu de les normes d’organització, funcionament, convivència o disciplina de l’Escola, de les Agrupacions Artístiques Titulars, de les activitats socials o de les altres activitats organitzades per la Societat, quan no constituïsca falta molt greu.</span>

  <span class="sjma-change-marker">h) La inassistència, impuntualitat o abandonament injustificat d’actuacions, concerts, actes, desplaçaments, serveis, activitats o compromisos per als quals la Persona Associada haja confirmat o assumit la participació, quan cause un perjudici rellevant a l’Agrupació, a l’Escola, a la Societat o a terceres persones.</span>

  <span class="sjma-change-marker">i) L’ús no autoritzat, la mala custòdia, l’alteració, la cessió a terceres persones, la retenció injustificada o la no devolució d’instruments, material, uniformes, documents, claus, credencials, instal·lacions o altres béns de la Societat, quan no constituïsca falta molt greu.</span>

  <span class="sjma-change-marker">j) L’incompliment greu de les funcions, responsabilitats o encàrrecs assumits davant la Societat, incloses les funcions delegades, de representació, custòdia, coordinació, documentació o gestió, quan no constituïsca falta molt greu.</span>

  <span class="sjma-change-marker">k) L’ús indegut de canals de comunicació, xarxes socials, documents, dades, credencials, sistemes d’informació o altres recursos de la Societat, quan no constituïsca falta molt greu.</span>
HTML

MINOR_OFFENSES_ARTICLE_TITLE = "Article 83. De les faltes lleus"
MINOR_OFFENSES_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Són faltes lleus:</span>

  <span class="sjma-change-marker">a) La falta de consideració i respecte cap als càrrecs socials, direccions tècnic-artístiques, personal, Persones Associades o persones participants en les activitats de la Societat.</span>

  <span class="sjma-change-marker">b) La desobediència lleu als Acords, Resolucions o indicacions legítimes adoptades en l’àmbit de les competències corresponents.</span>

  <span class="sjma-change-marker">c) La falta lleu de cooperació en les tasques, activitats o obligacions assumides davant la Societat.</span>

  <span class="sjma-change-marker">d) La negligència lleu en l’acompliment de les funcions i obligacions socials d’acord amb aquestos Estatuts.</span>

  <span class="sjma-change-marker">e) Causar danys per negligència lleu als béns, materials, instruments o altres pertinences de la Societat.</span>

  <span class="sjma-change-marker">f) L’incompliment lleu de les normes internes d’organització, funcionament, convivència o participació de l’Escola, de les Agrupacions Artístiques Titulars, de les activitats socials o de les altres activitats organitzades per la Societat.</span>

  <span class="sjma-change-marker">g) L’ús negligent lleu o inadequat dels instruments, material, uniformes, documents, claus, credencials, instal·lacions o altres béns de la Societat, quan no constituïsca falta greu.</span>

  <span class="sjma-change-marker">h) L’incompliment lleu de les funcions, responsabilitats o encàrrecs assumits davant la Societat, quan no constituïsca falta greu.</span>
HTML

VERY_SERIOUS_SANCTIONS_ARTICLE_TITLE = "Article 84. De les sancions per faltes molt greus"
VERY_SERIOUS_SANCTIONS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Per raó de les faltes molt greus comeses es podran imposar les següents sancions:</span>

  <span class="sjma-change-marker">a) Expulsió de la Societat i pèrdua de la condició de Persona Associada, amb impossibilitat de readmissió durant un període de 4 a 8 anys.</span>

  <span class="sjma-change-marker">b) Inhabilitació per a ocupar càrrecs socials durant un període de 4 a 8 anys.</span>

  <span class="sjma-change-marker">c) Suspensió dels drets corresponents a les Persones Associades durant un període d’1 a 2 anys.</span>

  <span class="sjma-change-marker">L’expulsió de la Societat requerirà, en tot cas, ratificació de l’Assemblea General.</span>
HTML

SERIOUS_SANCTIONS_ARTICLE_TITLE = "Article 85. De les sancions per faltes greus"
SERIOUS_SANCTIONS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Per raó de les faltes greus comeses es podran imposar les següents sancions:</span>

  <span class="sjma-change-marker">a) Suspensió dels drets corresponents a les Persones Associades des d’un mes fins a un any.</span>

  <span class="sjma-change-marker">b) Inhabilitació per a ocupar càrrecs socials durant un període d’1 a 4 anys.</span>

  <span class="sjma-change-marker">c) Per al cas previst a l’apartat b) de l’article 83, prohibició total o parcial de participar en actes, activitats, projectes, desplaçaments, festivals, certàmens o altres esdeveniments que la Societat organitze, en què col·labore o en què participe, per un període d’un mes a un any.</span>

  <span class="sjma-change-marker">d) Exclusió temporal, total o parcial, de determinades activitats, assajos, actuacions, desplaçaments, projectes, serveis o espais de la Societat, per un període d’un mes a un any.</span>
HTML

MINOR_SANCTIONS_ARTICLE_TITLE = "Article 86. De les sancions per faltes lleus"
MINOR_SANCTIONS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Per raó de les faltes lleus comeses es podran imposar les següents sancions:</span>

  <span class="sjma-change-marker">a) Advertència.</span>

  <span class="sjma-change-marker">b) Suspensió dels drets corresponents a les Persones Associades des d’un dia fins a un mes.</span>

  <span class="sjma-change-marker">c) Exclusió puntual o temporal de determinades activitats, serveis o espais de la Societat, quan resulte proporcionat a la falta comesa, per un període màxim d’un mes.</span>
HTML

SANCTION_GRADUATION_ARTICLE_TITLE = "Article 87. De la graduació de les sancions"
SANCTION_GRADUATION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. En la imposició de les sancions es guardarà la deguda adequació entre la gravetat del fet constitutiu de la falta i la sanció aplicada.</span>

  <span class="sjma-change-marker">2. Per a la graduació de la sanció es tindran en compte, especialment, l’existència d’intencionalitat, la reiteració, la naturalesa dels perjudicis ocasionats, la reparació voluntària del dany, el reconeixement dels fets i la reincidència.</span>

  <span class="sjma-change-marker">3. Podrà acumular-se més d’una sanció per una mateixa falta únicament quan siguen compatibles entre si, resulte proporcionat i quede motivat en la resolució disciplinària.</span>

  <span class="sjma-change-marker">4. La sanció podrà limitar-se a l’àmbit afectat per la falta, com l’activitat artística, educativa, social, patrimonial o de gestió corresponent, quan això resulte més proporcionat que la suspensió general de drets.</span>
HTML

PRESCRIPTION_ARTICLE_TITLE = "Article 88. De la prescripció de les faltes i sancions"
PRESCRIPTION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les faltes prescriuen d’acord amb les següents condicions:</span>

  <span class="sjma-change-marker">a) Les molt greus, a l’any des de la data de la seua comissió.</span>

  <span class="sjma-change-marker">b) Les greus, als sis mesos des de la data de la seua comissió.</span>

  <span class="sjma-change-marker">c) Les lleus, als tres mesos des de la data de la seua comissió.</span>

  <span class="sjma-change-marker">2. L’execució de les sancions prescriurà d’acord amb les següents condicions:</span>

  <span class="sjma-change-marker">a) Les imposades per faltes molt greus, als sis mesos des que la resolució sancionadora siga ferma o executable.</span>

  <span class="sjma-change-marker">b) Les imposades per faltes greus, als tres mesos des que la resolució sancionadora siga ferma o executable.</span>

  <span class="sjma-change-marker">c) Les imposades per faltes lleus, al mes des que la resolució sancionadora siga ferma o executable.</span>
HTML

BOARD_DISCIPLINE_ARTICLE_TITLE = "Article 89. Del règim disciplinari de les persones que componen la Junta Directiva"
BOARD_DISCIPLINE_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les persones que componen la Junta Directiva estaran sotmeses al règim disciplinari general previst en aquestos Estatuts pels fets comesos com a Persones Associades o en l’exercici del càrrec.</span>

  <span class="sjma-change-marker">2. L’obertura d’un expedient disciplinari contra una persona que compose la Junta Directiva haurà de ser acordada per l’Assemblea General per majoria qualificada, amb identificació suficient dels fets que motiven l’expedient.</span>

  <span class="sjma-change-marker">3. En aquests supòsits s’aplicarà el règim d’abstenció previst en l’article 76 d’aquestos Estatuts, especialment respecte de la deliberació i votació dels Acords d’obertura, suspensió cautelar i resolució de l’expedient.</span>

  <span class="sjma-change-marker">4. En el mateix acord d’obertura, l’Assemblea General designarà una Comissió Instructora formada per tres Persones Associades majors d’edat, en ple exercici dels seus drets socials, que no formen part de la Junta Directiva, no estiguen afectades pels fets objecte de l’expedient i no tinguen conflicte d’interés.</span>

  <span class="sjma-change-marker">5. Les persones membres de la Comissió Instructora podran ser proposades per qualsevol Persona Associada amb dret a vot en la mateixa sessió de l’Assemblea General. Si no hi haguera prou persones candidates voluntàries, les places vacants es cobriran per sorteig entre les Persones Associades que complisquen els requisits previstos en aquest article.</span>

  <span class="sjma-change-marker">6. Les persones designades per sorteig hauran d’acceptar la designació, llevat que al·leguen causa justificada d’impossibilitat, conflicte d’interés o altra circumstància que impedisca l’exercici imparcial de la funció. En cas de no acceptació justificada, es procedirà a una nova designació pel mateix sistema.</span>

  <span class="sjma-change-marker">7. Si no fora possible constituir la Comissió Instructora amb tres Persones Associades, l’Assemblea General podrà designar una persona instructora externa i independent, que assumirà les funcions d’instrucció de l’expedient.</span>

  <span class="sjma-change-marker">8. La Comissió Instructora, o la persona instructora externa si escau, tramitarà l’expedient amb audiència de la persona afectada i formularà una proposta de resolució motivada.</span>

  <span class="sjma-change-marker">9. La resolució de l’expedient correspondrà a l’Assemblea General per majoria qualificada.</span>

  <span class="sjma-change-marker">10. L’obertura de l’expedient no comportarà per si mateixa el cessament en el càrrec. No obstant això, l’Assemblea General podrà acordar motivadament la suspensió cautelar, total o parcial, de l’exercici del càrrec mentre es tramite l’expedient, quan siga necessari per a protegir l’interés de la Societat, la instrucció de l’expedient o els drets de les persones afectades. Aquesta suspensió cautelar no tindrà caràcter sancionador.</span>

  <span class="sjma-change-marker">11. Quan l’expedient afecte la Presidència o la Secretaria, aquestes persones no podran dirigir, documentar ni certificar els punts, sessions o actuacions relacionades amb l’expedient. Aquestes funcions seran assumides per qui corresponga segons el règim de substitució previst en aquestos Estatuts o, si fora necessari, per la persona que designe l’Assemblea General.</span>

  <span class="sjma-change-marker">12. Les sancions imposades produiran els efectes que corresponguen sobre l’exercici del càrrec. Si comporten expulsió, inhabilitació o impossibilitat temporal d’exercir el càrrec, la vacant o suspensió es cobrirà d’acord amb el règim previst en aquestos Estatuts.</span>

  <span class="sjma-change-marker">13. Sense perjudici del que disposen els apartats anteriors, quan els fets exigisquen mesures immediates de protecció de persones, béns, documents, sistemes d’informació o interessos essencials de la Societat, la Junta Directiva, amb abstenció de les persones afectades o en conflicte d’interés, podrà adoptar les mesures provisionals urgents i imprescindibles de protecció o organització interna i convocar o sol·licitar la convocatòria de l’Assemblea General perquè decidisca sobre l’obertura de l’expedient i les mesures cautelars que corresponguen.</span>
HTML

DISCIPLINARY_PROCEDURE_ARTICLE_TITLE = "Article 90. Del procediment disciplinari"
DISCIPLINARY_PROCEDURE_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. El procediment disciplinari s’iniciarà per Resolució de la Junta Directiva, d’ofici o a instància de part, excepte en els supòsits en què aquestos Estatuts atribuïsquen aquesta competència a l’Assemblea General.</span>

  <span class="sjma-change-marker">2. Qualsevol Persona Associada o persona directament afectada pels fets podrà posar-los en coneixement de la Junta Directiva. La Junta Directiva acordarà motivadament l’inici de l’expedient o l’arxivament de les actuacions, sense perjudici de les mesures de protecció o organització interna que puguen correspondre.</span>

  <span class="sjma-change-marker">3. La Resolució d’inici haurà d’identificar suficientment els fets que motiven l’expedient, la falta que poguera correspondre, la persona afectada, la persona instructora o Comissió Instructora encarregada de la tramitació i, si escau, les mesures cautelars que s’adopten. Aquesta Resolució haurà de notificar-se a la persona afectada en el termini màxim de deu dies naturals des de la seua adopció.</span>

  <span class="sjma-change-marker">4. La instrucció correspondrà, amb caràcter general, a una persona instructora designada per l’òrgan que acorde l’inici de l’expedient, que no podrà formar part de l’òrgan competent per a resoldre ni intervindre en la resolució de l’expedient. Quan la naturalesa, complexitat o especial sensibilitat de l’expedient ho faça convenient, podrà designar-se una Comissió Instructora o una persona externa independent.</span>

  <span class="sjma-change-marker">5. La persona instructora o les persones membres de la Comissió Instructora hauran de ser Persones Associades majors d’edat, en ple exercici dels seus drets socials, o persones externes independents, i no podran formar part de l’òrgan que haja de resoldre l’expedient. Hauran d’actuar amb imparcialitat, confidencialitat i diligència, i no podran haver intervingut directament en els fets, tindre interés personal en l’assumpte, relació directa amb la persona afectada o amb la persona denunciant, ni incórrer en cap altra circumstància que puga comprometre la seua imparcialitat.</span>

  <span class="sjma-change-marker">6. La persona afectada haurà de ser informada dels fets que se li imputen, de la falta que poguera correspondre i de les sancions que pogueren imposar-se, i disposarà d’un termini de deu dies naturals, comptats des de la notificació de la Resolució d’inici del procediment, per a formular al·legacions i proposar les proves que estime oportunes.</span>

  <span class="sjma-change-marker">7. La persona instructora o Comissió Instructora practicarà les actuacions necessàries per a l’esclariment dels fets, admetrà les proves que siguen pertinents i podrà rebutjar motivadament les que siguen improcedents, innecessàries o desproporcionades.</span>

  <span class="sjma-change-marker">8. Finalitzada la instrucció, la persona instructora o Comissió Instructora formularà una proposta de resolució motivada, que haurà d’indicar els fets que es consideren provats, la falta que poguera correspondre, la sanció proposada o, si escau, l’arxivament de l’expedient. Aquesta proposta es comunicarà a la persona afectada, que disposarà d’un termini de set dies naturals per a formular al·legacions finals.</span>

  <span class="sjma-change-marker">9. La fase d’instrucció haurà de desenvolupar-se en el termini màxim de trenta dies naturals des de la finalització del termini inicial d’al·legacions. Aquest termini podrà ampliar-se motivadament per un màxim de trenta dies naturals addicionals quan la complexitat de l’expedient ho justifique.</span>

  <span class="sjma-change-marker">10. L’expedient haurà de resoldre’s en el termini màxim de tres mesos des de la Resolució d’inici, excepte suspensió justificada per causa legal, força major o actuacions davant l’autoritat competent.</span>

  <span class="sjma-change-marker">11. La resolució de l’expedient correspondrà a la Junta Directiva, excepte quan l’expedient afecte persones que componen la Junta Directiva o quan aquestos Estatuts atribuïsquen expressament la competència a l’Assemblea General.</span>

  <span class="sjma-change-marker">12. Les resolucions disciplinàries hauran de ser motivades i indicaran els fets provats, la falta comesa, la sanció imposada, la data a partir de la qual produirà efectes i les vies de revisió interna o impugnació judicial que procedisquen d’acord amb aquestos Estatuts i la normativa vigent.</span>

  <span class="sjma-change-marker">13. Quan la sanció siga l’expulsió de la Societat, la resolució de la Junta Directiva no serà executiva fins que siga ratificada per l’Assemblea General.</span>

  <span class="sjma-change-marker">14. Durant la tramitació de l’expedient, l’òrgan competent per a iniciar-lo podrà acordar motivadament mesures cautelars proporcionades, quan siguen necessàries per a protegir les persones, els béns de la Societat, el funcionament de les activitats o la correcta tramitació de l’expedient. Aquestes mesures no tindran caràcter sancionador, hauran de limitar-se al temps estrictament necessari i decauran en resoldre’s l’expedient.</span>

  <span class="sjma-change-marker">15. Si els fets pogueren ser constitutius d’infracció penal i s’haguera interposat denúncia o querella, la Societat no instruirà procediment disciplinari sobre aquests mateixos fets o, si ja s’haguera instruït, s’abstindrà de resoldre’l fins que recaiga sentència ferma, sobreseïment o arxivament, sense perjudici de les mesures cautelars o de protecció que resulten necessàries.</span>
HTML

INITIAL_ASSETS_ARTICLE_TITLE = "Article 92. Del patrimoni inicial i del patrimoni de la Societat"
INITIAL_ASSETS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. El patrimoni inicial de la Societat és el que consta en la seua documentació fundacional i registral, sense perjudici de les actualitzacions que resulten de l’inventari, la comptabilitat i la documentació econòmica vigent en cada moment.</span>

  <span class="sjma-change-marker">2. El patrimoni de la Societat estarà integrat pels béns, drets, instruments, mobiliari, equipaments, recursos econòmics i altres elements de la seua titularitat.</span>

  <span class="sjma-change-marker">3. La gestió, administració, inventari i comptabilització del patrimoni de la Societat es realitzarà d’acord amb aquestos Estatuts i amb la normativa vigent aplicable.</span>
HTML

ASSETS_DESTINATION_ARTICLE_TITLE = "Article 93. Del destí del patrimoni, rendes i ingressos"
ASSETS_DESTINATION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Societat destinarà el seu patrimoni, rendes i ingressos al compliment dels seus fins estatutaris de caràcter artístic, social, educatiu i cultural, en els termes, percentatges i terminis que exigisca la normativa vigent aplicable en cada moment.</span>

  <span class="sjma-change-marker">2. Els excedents que, si escau, no hagen de ser aplicats directament als fins estatutaris podran destinar-se a reserves, dotació patrimonial, inversions, millora de serveis, adquisició o conservació de béns, instruments, materials, instal·lacions o altres recursos necessaris per al desenvolupament de la Societat, sempre d’acord amb la normativa aplicable i sense repartiment entre les Persones Associades.</span>
HTML

ECONOMIC_RESOURCES_ARTICLE_TITLE = "Article 94. Dels recursos econòmics de la Societat"
ECONOMIC_RESOURCES_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Per al desenvolupament de les activitats de la Societat, aquesta disposarà dels següents mitjans o recursos econòmics:</span>

  <span class="sjma-change-marker">a) Les quotes que fixe l’Assemblea General a les Persones Associades, ja siguen d’entrada o ingrés, ja siguen quotes periòdiques.</span>

  <span class="sjma-change-marker">b) Les derrames extraordinàries que acorde l’Assemblea General.</span>

  <span class="sjma-change-marker">c) Els productes o rendes dels béns i drets que li corresponguen.</span>

  <span class="sjma-change-marker">d) Les subvencions i ajudes que obtinga de les Administracions Públiques, organismes públics i entitats del sector públic de qualsevol naturalesa.</span>

  <span class="sjma-change-marker">e) Els donatius, llegats, herències i liberalitats que se li atorguen per persones privades.</span>

  <span class="sjma-change-marker">f) Els ingressos que obtinga la Societat de les activitats, serveis, projectes o iniciatives lícites que realitze directament o a través de les seues Persones Associades, Agrupacions Artístiques, Escola o altres estructures pròpies.</span>

  <span class="sjma-change-marker">2. En el cas que la Societat siga titular, directa o indirectament, de participacions majoritàries en societats mercantils, ho comunicarà als òrgans administratius competents quan resulte exigible per la normativa vigent, acreditant que aquesta titularitat contribueix al millor compliment dels fins estatutaris i no vulnera els principis propis de les entitats sense ànim de lucre.</span>
HTML

ACTIVITY_BENEFIT_ARTICLE_TITLE = "Article 95. Del benefici de les activitats"
ACTIVITY_BENEFIT_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Els beneficis obtinguts derivats de l’exercici d’activitats econòmiques, incloses les prestacions de serveis, es destinaran exclusivament a l’acompliment dels fins de la Societat, sense que càpiga en cap cas el seu repartiment entre les Persones Associades ni entre els seus cònjuges o persones que convisquen amb aquelles amb anàloga relació d’afectivitat, ni entre els seus parents, ni la seua cessió gratuïta a persones físiques o jurídiques amb interés lucratiu.</span>
HTML

BUDGETS_AND_FISCAL_YEAR_ARTICLE_TITLE = "Article 96. De l’exercici econòmic i dels pressupostos"
BUDGETS_AND_FISCAL_YEAR_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Els Pressupostos de la Societat són l’instrument mitjançant el qual s’efectuen les previsions d’ingressos, despeses, projectes i inversions per a l’exercici econòmic.</span>

  <span class="sjma-change-marker">2. L’exercici econòmic de la Societat coincidirà amb l’any natural i quedarà tancat el 31 de desembre de cada any.</span>

  <span class="sjma-change-marker">3. Si començat l’exercici econòmic no s’haguera aprovat el Pressupost Ordinari corresponent, s’entendrà prorrogat provisionalment el pressupost de l’exercici anterior per a les despeses ordinàries, recurrents i imprescindibles de funcionament, fins que l’Assemblea General aprove el nou pressupost. Aquesta pròrroga no permetrà iniciar nous projectes, inversions o despeses extraordinàries no previstes, excepte quan siguen urgents i necessàries per a protegir persones, béns o la continuïtat essencial de l’activitat.</span>
HTML

ORDINARY_BUDGETS_ARTICLE_TITLE = "Article 97. Dels Pressupostos Ordinaris"
ORDINARY_BUDGETS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Tresoreria confeccionarà tècnicament el projecte de Pressupostos Ordinaris de la Societat per a cada exercici econòmic, d’acord amb les directrius, prioritats i planificació establides per la Junta Directiva, tenint en compte les despeses ordinàries previsibles, els ingressos estimats, les obligacions assumides i els objectius, activitats, projectes i inversions previstos per la Societat.</span>

  <span class="sjma-change-marker">2. La Junta Directiva revisarà el projecte de Pressupostos Ordinaris i, si escau, l’aprovarà com a proposta per a la seua elevació a l’Assemblea General.</span>

  <span class="sjma-change-marker">3. L’Assemblea General aprovarà els Pressupostos Ordinaris en la sessió ordinària econòmica corresponent.</span>
HTML

EXTRAORDINARY_BUDGETS_ARTICLE_TITLE = "Article 98. Dels Pressupostos Extraordinaris"
EXTRAORDINARY_BUDGETS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Assemblea General, a proposta de la Junta Directiva, podrà aprovar Pressupostos Extraordinaris quan sorgisquen necessitats, projectes, inversions o despeses no previstes en el Pressupost Ordinari i que, per la seua importància, naturalesa o quantia, requerisquen una aprovació específica.</span>

  <span class="sjma-change-marker">2. Els Pressupostos Extraordinaris hauran de tindre una finalitat concreta i identificar, almenys, la necessitat que els motiva, l’import previst i la forma de finançament.</span>

  <span class="sjma-change-marker">3. Podran finançar-se mitjançant reserves, subvencions, donacions, ingressos extraordinaris, operacions d’endeutament aprovades conforme a aquestos Estatuts, derrames extraordinàries acordades per l’Assemblea General o altres recursos lícits de la Societat.</span>

  <span class="sjma-change-marker">4. Els Pressupostos Extraordinaris no podran utilitzar-se per a substituir de manera ordinària el Pressupost Ordinari ni per a cobrir despeses corrents habituals de la Societat, llevat que concórrega una situació excepcional degudament justificada.</span>

  <span class="sjma-change-marker">5. En situacions urgents i imprescindibles, la Junta Directiva podrà autoritzar despeses no previstes que siguen necessàries per a protegir persones, béns, instal·lacions, documents, sistemes d’informació o la continuïtat essencial de l’activitat, donant compte a la següent Assemblea General. Aquesta previsió no habilita l’assumpció d’endeutament que requerisca autorització de l’Assemblea General d’acord amb aquests Estatuts.</span>
HTML

FINANCIAL_CONTROL_ARTICLE_TITLE = "Article 99. Del control financer i de la rendició de comptes"
FINANCIAL_CONTROL_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Societat portarà una comptabilitat ordenada que permeta obtindre una imatge fidel del seu patrimoni, del resultat econòmic, de la situació financera i de les activitats realitzades.</span>

  <span class="sjma-change-marker">2. Els Comptes Anuals estaran conformats, almenys, pel Balanç, el Compte de Resultats i la Memòria econòmica i d’activitats, sense perjudici d’altres documents que siguen exigibles per la normativa vigent o que la Tresoreria, la Junta Directiva o l’Assemblea General consideren convenients.</span>

  <span class="sjma-change-marker">3. La Junta Directiva presentarà els Comptes Anuals a l’Assemblea General per a la seua aprovació en la sessió ordinària econòmica corresponent.</span>

  <span class="sjma-change-marker">4. La Societat se sotmetrà a auditoria, revisió externa o altres formes de control financer quan siga legalment exigible, quan ho acorde l’Assemblea General o quan la Junta Directiva ho considere convenient per raó del volum econòmic, la naturalesa dels recursos gestionats, l’existència de subvencions o ajudes públiques, o la importància de determinades operacions.</span>

  <span class="sjma-change-marker">5. Si la Societat és declarada d’utilitat pública, d’interés públic o queda sotmesa a obligacions específiques de rendició de comptes per qualsevol normativa aplicable, la Junta Directiva haurà de formular, signar, presentar o depositar els comptes, memòries, justificacions i documents que corresponguen en els terminis legalment exigibles, i sotmetre’ls a aprovació de l’Assemblea General quan siga exigible.</span>
HTML

STATUTES_AMENDMENT_PROCEDURE_ARTICLE_TITLE = "Article 100. Del procediment de modificació dels Estatuts"
STATUTES_AMENDMENT_PROCEDURE_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La modificació dels Estatuts haurà de ser aprovada per l’Assemblea General convocada específicament amb aquesta finalitat, d’acord amb aquestos Estatuts i amb la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">2. La proposta de modificació podrà ser presentada per Resolució de la Junta Directiva o per iniciativa conjunta d’un 10 per cent de les Persones Associades.</span>

  <span class="sjma-change-marker">3. Quan la proposta haja sigut presentada per iniciativa conjunta de Persones Associades, les persones promotores tindran dret a designar una persona representant per a defensar-la davant l’Assemblea General i en el procés previ de participació. La Junta Directiva haurà d’ordenar la tramitació del procés, sense perjudici que puga advertir motivadament les deficiències legals, estatutàries o tècniques que aprecie.</span>

  <span class="sjma-change-marker">4. La proposta inicial haurà d’anar acompanyada d’un calendari del procés, que indicarà, almenys, el termini de participació, els canals habilitats, la forma de publicitat interna de les esmenes, el moment previst per a la publicació de la proposta definitiva i la data o període previst per a la celebració de l’Assemblea General.</span>

  <span class="sjma-change-marker">5. Abans de la celebració de l’Assemblea General s’obrirà un període previ de participació, debat i presentació d’esmenes. Aquest període tindrà una durada mínima de 15 dies naturals, sense perjudici que la Junta Directiva puga establir un termini superior atenent la importància, extensió o complexitat de la modificació proposada.</span>

  <span class="sjma-change-marker">6. El procés podrà desenvolupar-se mitjançant plataforma electrònica de participació, formularis electrònics, correu electrònic, presentació presencial, documentació en paper o altres canals habilitats per la Societat, garantint en tot cas la identificació de les Persones Associades participants, la constància de les esmenes presentades i la publicitat interna suficient del procés.</span>

  <span class="sjma-change-marker">7. Quan s’utilitzen canals electrònics de participació, la Societat haurà d’habilitar almenys una via no digital i suport bàsic perquè les Persones Associades que tinguen dificultats tecnològiques puguen conèixer la proposta i participar en el procés.</span>
HTML

STATUTES_AMENDMENTS_ARTICLE_TITLE = "Article 101. De les esmenes i de la participació de les Persones Associades"
STATUTES_AMENDMENTS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les esmenes són l’instrument mitjançant el qual les Persones Associades podran proposar addicions, supressions o modificacions al text de reforma estatutària.</span>

  <span class="sjma-change-marker">2. La presentació d’esmenes no requerirà suport mínim previ. No obstant això, perquè una esmena no incorporada al text proposat haja de ser sotmesa necessàriament a votació separada en l’Assemblea General, haurà d’obtindre el suport mínim previst en aquestos Estatuts.</span>

  <span class="sjma-change-marker">3. Quan s’utilitze una plataforma electrònica de participació, la Societat facilitarà a les Persones Associades les credencials o mitjans d’accés necessaris. La plataforma haurà de permetre, en la mesura de les seues funcionalitats, consultar les esmenes presentades, formular comentaris, registrar suports pels canals habilitats i participar en el debat previ.</span>

  <span class="sjma-change-marker">4. Quan no s’utilitze una plataforma electrònica col·laborativa, la Junta Directiva habilitarà un registre intern d’esmenes i donarà publicitat a les esmenes rebudes pels canals habituals de comunicació interna de la Societat, de manera actualitzada o periòdica i, en tot cas, abans de la finalització del període de participació, preservant les dades personals que corresponga. Les Persones Associades podran adherir-se a les esmenes publicades o formular observacions dins d’aquest mateix període.</span>

  <span class="sjma-change-marker">5. La Junta Directiva podrà ordenar, agrupar o refondre les esmenes que tinguen contingut equivalent, complementari o contradictori, sense alterar-ne el sentit substancial, deixant constància de les esmenes originals de què provenen i comunicant-ho, quan siga possible, a les persones proponents.</span>

  <span class="sjma-change-marker">6. Les actuacions del període participatiu tindran caràcter personal, sense perjudici que les Persones Associades puguen rebre assistència tècnica o acompanyament per utilitzar els canals habilitats.</span>

  <span class="sjma-change-marker">7. Les esmenes, suports registrats, observacions i debats del període previ tindran caràcter participatiu i deliberatiu. La decisió sobre la modificació estatutària correspondrà en tot cas a l’Assemblea General.</span>
HTML

STATUTES_APPROVAL_ARTICLE_TITLE = "Article 102. De la proposta definitiva i de l’aprovació del text"
STATUTES_APPROVAL_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Finalitzat el període de participació, la Junta Directiva confeccionarà la proposta definitiva de modificació estatutària que serà sotmesa a l’Assemblea General.</span>

  <span class="sjma-change-marker">2. La proposta definitiva haurà d’indicar, de manera clara, els articles que es proposa modificar, afegir o suprimir, el text proposat, les esmenes incorporades directament, les esmenes agrupades o refoses, les esmenes que es proposen sotmetre a votació separada i les esmenes no incorporades, amb indicació sintètica del criteri seguit en cada cas. Aquesta proposta anirà acompanyada d’un informe breu de retorn del procés participatiu.</span>

  <span class="sjma-change-marker">3. Les esmenes no incorporades al text proposat hauran de quedar documentades, amb indicació sintètica del criteri seguit per la Junta Directiva. Hauran de sotmetre’s a votació separada quan hagen obtingut el suport registrat d’almenys el 10 per cent de les Persones Associades amb dret de vot en la data de finalització del període de participació. També podran sotmetre’s a votació separada quan així ho propose la Junta Directiva.</span>

  <span class="sjma-change-marker">4. La votació separada podrà plantejar-se com a inclusió o no inclusió, supressió o manteniment, o elecció entre redaccions alternatives. Quan existisquen esmenes o alternatives incompatibles entre si, la proposta definitiva indicarà l’ordre de votació i l’efecte de cada vot sobre el text final.</span>

  <span class="sjma-change-marker">5. La proposta definitiva haurà de ser comunicada a les Persones Associades amb una antelació mínima de 15 dies naturals abans de la celebració de l’Assemblea General que haja de votar la modificació estatutària. El calendari del procés podrà establir una antelació superior.</span>

  <span class="sjma-change-marker">6. En l’Assemblea General, la Presidència o la persona designada per la Junta Directiva exposarà la proposta definitiva, les esmenes incorporades, les esmenes sotmeses a votació separada i els criteris seguits per la Junta Directiva en la confecció del text proposat. Quan la proposta haja sigut presentada per iniciativa conjunta de Persones Associades, la persona representant designada per les promotores tindrà dret a defensar-la davant l’Assemblea General. Les esmenes sotmeses a votació separada podran ser defensades breument davant l’Assemblea General per la persona proponent o per la representant que aquesta designe.</span>

  <span class="sjma-change-marker">7. L’Assemblea General podrà votar separadament les esmenes, blocs, articles o alternatives que consten en la proposta definitiva, quan això facilite una deliberació i decisió més clara.</span>

  <span class="sjma-change-marker">8. Una vegada realitzades les votacions que corresponguen, l’Assemblea General aprovarà, si escau, el text definitiu de modificació dels Estatuts resultant de les votacions efectuades.</span>

  <span class="sjma-change-marker">9. El text definitiu aprovat per l’Assemblea General serà el que es presente al Registre d’Associacions, junt amb la documentació que exigisca la normativa vigent, dins del termini d’un mes quan afecte contingut inscriptible o en el termini que determine la normativa aplicable.</span>
HTML

DISSOLUTION_CAUSES_ARTICLE_TITLE = "Article 104. De les causes de dissolució"
DISSOLUTION_CAUSES_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">La Societat es dissoldrà per les següents causes:</span>

  <span class="sjma-change-marker">a) Per Acord de l’Assemblea General, convocada expressament amb aquesta finalitat, amb el vot favorable de la majoria absoluta de l’Assemblea General.</span>

  <span class="sjma-change-marker">b) Per reducció del nombre de Persones Associades a menys de tres.</span>

  <span class="sjma-change-marker">c) Per les causes previstes en aquestos Estatuts.</span>

  <span class="sjma-change-marker">d) Per les causes determinades a l’article 39 del Codi Civil i la resta de normativa aplicable.</span>

  <span class="sjma-change-marker">e) Per sentència judicial ferma.</span>
HTML

LIQUIDATION_ARTICLE_TITLE = "Article 105. De la liquidació"
LIQUIDATION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Una vegada acordada o declarada la dissolució, s’obrirà el període de liquidació, durant el qual la Societat conservarà la seua personalitat jurídica fins a la finalització de les operacions de liquidació i la cancel·lació dels assentaments registrals.</span>

  <span class="sjma-change-marker">2. L’Assemblea General podrà designar una Comissió Liquidadora. Si no la designara, actuaran com a persones liquidadores les persones que componguen la Junta Directiva en el moment de la dissolució, llevat que l’Assemblea General o l’autoritat judicial competent acorde altra cosa.</span>

  <span class="sjma-change-marker">3. Correspon a les persones liquidadores:</span>

  <span class="sjma-change-marker">a) Vetlar per la integritat del patrimoni de la Societat i portar-ne els comptes.</span>

  <span class="sjma-change-marker">b) Concloure les operacions pendents i efectuar les noves que siguen necessàries per a la liquidació.</span>

  <span class="sjma-change-marker">c) Cobrar els crèdits de la Societat.</span>

  <span class="sjma-change-marker">d) Liquidar el patrimoni i pagar les persones creditores.</span>

  <span class="sjma-change-marker">e) Aplicar els béns sobrants de la Societat al destí previst en aquestos Estatuts i en la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">f) Sol·licitar la cancel·lació dels assentaments del Registre d’Associacions.</span>

  <span class="sjma-change-marker">4. El romanent net que resulte de la liquidació, si n’hi haguera, es destinarà a entitats sense ànim de lucre o entitats públiques que perseguisquen finalitats culturals, musicals, educatives, socials o d’interés general anàlogues a les de la Societat, preferentment vinculades al municipi d’Albal o al moviment associatiu musical valencià, d’acord amb el que determine l’Assemblea General i amb respecte a la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">5. En cap cas el romanent podrà repartir-se entre les Persones Associades ni entre persones físiques o jurídiques amb interés lucratiu.</span>

  <span class="sjma-change-marker">6. En cas d’insolvència de la Societat, la Junta Directiva, la Comissió Liquidadora o les persones liquidadores promouran immediatament el procediment que corresponga davant l’òrgan competent.</span>
HTML

INTERPRETATION_ARTICLE_TITLE = "Article 68. De la interpretació dels Estatuts"
INTERPRETATION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">La interpretació operativa i provisional de les normes estatutàries correspondrà a la Junta Directiva, que haurà d’aplicar criteris de bona fe, coherència interna dels Estatuts, finalitat de la norma i respecte a la normativa vigent. Les resolucions i decisions que en aquest sentit prenga seran vàlides mentre no siguen modificades per l’Assemblea General, revisades internament o resoltes les impugnacions que corresponguen.</span>
HTML

SUPPLEMENTARY_LAW_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Per a tot allò que no estiga expressament previst en aquests Estatuts s’aplicarà la normativa d’associacions vigent i, subsidiàriament, el Dret comú.</span>

  <span class="sjma-change-marker">La normativa de la Federació de Societats Musicals de la Comunitat Valenciana serà aplicable per raó de pertinença en els termes que corresponga, sempre que no contradiga aquests Estatuts ni la normativa vigent aplicable.</span>
HTML

REVIEW_AND_JURISDICTION_SECTION_TITLE = "Secció 3ª: De la revisió interna i de la impugnació per via jurisdiccional"

BON_GOVERN_ARTICLE_TITLE = "Article 75. Del Bon Govern de la Societat"
BON_GOVERN_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Els òrgans de govern i de representació actuaran amb respecte a la legalitat vigent i d’acord amb els principis d’eficiència, responsabilitat, transparència, sostenibilitat, austeritat, proximitat, igualtat d’oportunitats i bon servei a les Persones Associades.</span>

  <span class="sjma-change-marker">2. Les persones que componen els òrgans de govern i de representació hauran d’exercir les seues funcions amb honestedat, objectivitat, imparcialitat, confidencialitat i respecte, facilitant l’exercici dels drets de les Persones Associades i el compliment de les seues obligacions.</span>

  <span class="sjma-change-marker">3. Les persones que formen part de la Junta Directiva o actuen per delegació d’aquesta hauran d’actuar sempre en interés de la Societat i no podran utilitzar el seu càrrec, funcions, informació o capacitat de decisió per a afavorir interessos privats, propis o de terceres persones. Quan una decisió els afecte de manera directa, singular i diferenciada respecte de la resta de Persones Associades, hauran de comunicar-ho i abstindre’s d’intervindre en la deliberació, decisió i execució corresponent.</span>

  <span class="sjma-change-marker">4. En l’Assemblea General, les Persones Associades conservaran el seu dret de veu i vot en els assumptes d’interés general de la Societat, encara que els afecten com a membres d’aquesta. Hauran d’abstindre’s quan es troben en conflicte d’interés amb la Societat, especialment quan l’Acord afecte de manera directa, singular i diferenciada la seua situació individual davant la Societat.</span>

  <span class="sjma-change-marker">5. La Societat podrà habilitar canals perquè les Persones Associades formulen suggeriments, queixes o felicitacions relacionades amb el funcionament de la Societat, procurant donar-los resposta de manera adequada.</span>

  <span class="sjma-change-marker">6. La Junta Directiva promourà, quan siga possible, la prevenció i resolució dialogada dels conflictes que sorgisquen en la vida associativa, sense perjudici dels drets, garanties i procediments previstos en aquests Estatuts.</span>

  <span class="sjma-change-marker">7. Les previsions d’aquest article podran desenvolupar-se mitjançant un Codi de Bon Govern de la Societat, proposat per la Junta Directiva a l’Assemblea General per a la seua aprovació o modificació.</span>
HTML

COMMERCIAL_RELATIONSHIPS_TITLE = "Article 71. Del registre de relacions comercials habituals"
COMMERCIAL_RELATIONSHIPS_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva haurà de mantindre registrada la informació essencial sobre les relacions comercials habituals de la Societat amb tercers, tant quan afecten béns, serveis, subministraments o prestacions necessàries per al funcionament ordinari o per a activitats recurrents, com quan es referisquen a actuacions, serveis o activitats contractades a la Societat.</span>

  <span class="sjma-change-marker">2. Aquesta informació inclourà, com a mínim, la identificació de les persones, entitats o col·lectius amb què es mantinga la relació, les dades de contacte disponibles, els béns, serveis, actuacions o activitats relacionades, les condicions essencials acordades, les dates de renovació, finalització o cancel·lació quan existisquen, la persona o àrea responsable de la relació i la documentació vinculada que siga necessària per a facilitar la continuïtat de la gestió.</span>

  <span class="sjma-change-marker">3. Aquest registre no comprendrà la gestió ordinària de l’alumnat de l’Escola ni de les Persones Associades o de les Joventuts, que es regiran pels seus propis sistemes de registre, administració i protecció de dades.</span>

  <span class="sjma-change-marker">4. La informació registrada tindrà caràcter intern i haurà de conservar-se de manera ordenada, actualitzada i accessible per a les persones autoritzades, respectant en tot cas la normativa vigent en matèria de protecció de dades, contractació, fiscalitat i documentació comptable.</span>
HTML

INTERNAL_PUBLICITY_ARTICLE_PROPOSAL_ID = 579
INTERNAL_PUBLICITY_ARTICLE_TITLE = "Article 71. De la publicitat interna dels actes dels òrgans socials"
INTERNAL_PUBLICITY_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva garantirà que les Persones Associades puguen conèixer els Acords de l’Assemblea General i les Resolucions de la Junta Directiva que siguen rellevants per a la vida social, l’activitat ordinària o el funcionament de la Societat.</span>

  <span class="sjma-change-marker">2. Aquesta publicitat interna es realitzarà pels canals habituals de comunicació de la Societat, que podran incloure el tauler d’anuncis, el correu electrònic, la pàgina web, aplicacions de gestió o altres mitjans electrònics habilitats.</span>

  <span class="sjma-change-marker">3. La publicació haurà d’identificar, almenys, l’òrgan que adopta l’Acord o Resolució, la data, l’assumpte tractat i el contingut essencial de la decisió.</span>

  <span class="sjma-change-marker">4. La Junta Directiva podrà utilitzar els mateixos canals per a difondre comunicacions internes, avisos o informacions rellevants per a les Persones Associades o per a les activitats de la Societat.</span>

  <span class="sjma-change-marker">5. Quan la informació afecte dades personals, assumptes disciplinaris, informació econòmica sensible o altres matèries que requerisquen reserva, la Junta Directiva podrà publicar-ne una versió resumida, anonimitzada o limitada, indicant aquesta circumstància.</span>
HTML

TRANSPARENCY_ARTICLE_PROPOSAL_ID = 581
TRANSPARENCY_ARTICLE_TITLE = "Article 72. De la transparència a la Societat"
TRANSPARENCY_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Societat assumix el principi de transparència com a criteri general del seu govern, administració i rendició de comptes davant les Persones Associades.</span>

  <span class="sjma-change-marker">2. Els òrgans de govern i de representació hauran d’actuar de manera que les Persones Associades puguen conèixer, de forma clara i comprensible, la informació essencial sobre el funcionament de la Societat, la gestió dels seus recursos i l’execució dels seus acords.</span>

  <span class="sjma-change-marker">3. La transparència s’exercirà sense perjudici dels límits derivats de la protecció de dades personals, la confidencialitat, els assumptes disciplinaris, la informació econòmica sensible o altres matèries que requerisquen reserva.</span>

  <span class="sjma-change-marker">4. La transparència de la Societat inclourà també el compliment de les obligacions de publicitat, justificació, rendició de comptes o informació que deriven de subvencions, convenis, contractes, declaracions d’utilitat pública, reconeixements d’interés públic o qualsevol altra normativa aplicable.</span>

  <span class="sjma-change-marker">5. Les previsions d’aquest article podran desenvolupar-se mitjançant un Reglament de Transparència de la Societat, proposat per la Junta Directiva a l’Assemblea General per a la seua aprovació o modificació.</span>
HTML

DATA_PROTECTION_ARTICLE_PROPOSAL_ID = 582
DATA_PROTECTION_ARTICLE_TITLE = "Article 73. De la protecció de dades personals"
DATA_PROTECTION_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Societat tractarà les dades personals que siguen necessàries per al desenvolupament de les seues finalitats socials, educatives, artístiques, administratives i de gestió, d’acord amb la normativa vigent aplicable en cada moment.</span>

  <span class="sjma-change-marker">2. La Societat assumirà les responsabilitats que li corresponguen respecte dels tractaments de dades personals que realitze. La Junta Directiva organitzarà la gestió interna d’aquesta matèria i podrà assignar o contractar els mitjans personals, tècnics o professionals que siguen necessaris.</span>

  <span class="sjma-change-marker">3. El tractament de dades personals haurà de realitzar-se amb les garanties exigibles en cada moment, especialment pel que fa a la informació a les persones afectades, la seguretat, la confidencialitat, la conservació de les dades i l’exercici dels drets que corresponguen.</span>

  <span class="sjma-change-marker">4. La Junta Directiva podrà aprovar, actualitzar o adaptar les normes internes, formularis, avisos, polítiques de privacitat i altres instruments necessaris per a la correcta gestió de les dades personals de la Societat.</span>
HTML

SOCIAL_INFORMATION_ACCESS_ARTICLE_PROPOSAL_ID = 583
SOCIAL_INFORMATION_ACCESS_ARTICLE_TITLE = "Article 74. Del dret d’accés a la informació social"
SOCIAL_INFORMATION_ACCESS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Persones Associades tenen dret a sol·licitar i obtindre informació social suficient per a conèixer el funcionament de la Societat, participar en la seua vida associativa i exercir els drets que els reconeixen aquests Estatuts i la normativa vigent.</span>

  <span class="sjma-change-marker">2. A aquests efectes, s’entén per informació social la documentació institucional, econòmica, organitzativa o d’activitat que reflectisca el funcionament general de la Societat, els Acords de l’Assemblea General, les Resolucions de la Junta Directiva, la gestió dels seus recursos i l’execució de les seues activitats.</span>

  <span class="sjma-change-marker">3. L’accés a la informació social haurà de sol·licitar-se pels canals habilitats per la Societat. La Junta Directiva, directament o a través de la Secretaria o de la persona que designe, tramitarà la sol·licitud i facilitarà l’accés en el termini màxim d’un mes des de la recepció de la sol·licitud. Quan la naturalesa o el volum de la informació sol·licitada ho impedisca, la Junta Directiva podrà comunicar motivadament una ampliació del termini per un mes addicional.</span>

  <span class="sjma-change-marker">4. El dret d’accés podrà ser limitat motivadament quan afecte dades personals, assumptes disciplinaris, informació econòmica sensible, confidencialitat, drets de terceres persones o altres matèries que requerisquen reserva. Quan siga possible, es facilitarà l’accés parcial, resumit o anonimitzat, indicant aquesta circumstància.</span>

  <span class="sjma-change-marker">5. Aquest dret no empara l’accés indiscriminat a comunicacions internes, documents preparatoris, dades individuals de Persones Associades, alumnat, personal, proveïdors o terceres persones, ni sol·licituds abusives, repetitives o desproporcionades.</span>
HTML

ARTICLE13_YOUTH_RIGHTS_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">2. Les persones que componen les Joventuts gaudiran, en general, dels drets que se’n deriven de la seua capacitat d’obrar i de les disposicions normatives vigents. En particular, gaudiran únicament dels drets previstos als apartats a), b), d) i e) d’aquest article, i, respecte de les mesures internes que els puguen afectar, de les garanties previstes a l’apartat f).</span>
HTML

ARTICLE8_OLD_ADULT_CONVERSION_TEXT = "3. Les persones que conformen les Joventuts no tindran dret a vot ni podran accedir a càrrecs directius fins que assolisquen la majoria d’edat i tinguen la plena capacitat d’obrar, moment en el qual passaran a ser Persones Associades."
ARTICLE8_NEW_ADULT_CONVERSION_TEXT = '<span class="sjma-change-marker">3. Les persones que conformen les Joventuts no tindran dret a vot ni podran accedir a càrrecs directius. En assolir la majoria d’edat i tindre plena capacitat d’obrar, podran sol·licitar la seua incorporació com a Persones Associades. La continuïtat com a persona integrant activa major d’edat d’una Agrupació Artística Titular requerirà tindre la condició de Persona Associada, d’acord amb aquests Estatuts.</span>'

ARTICLE11_OLD_UNPAID_DROP_TEXT = "c) No satisfer les quotes ordinàries i derrames extraordinàries acordades per l’Assemblea General per un període de 2 anys."
ARTICLE11_NEW_UNPAID_DROP_TEXT = '<span class="sjma-change-marker">c) No satisfer les quotes ordinàries, derrames extraordinàries o altres obligacions econòmiques aprovades per l’Assemblea General durant un període de 2 anys, amb requeriment previ de pagament i Acord de l’Assemblea General quan comporte la separació definitiva de la Societat.</span>'

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
ARTICLE17_ASSEMBLY_RATIFICATION_TEXT = '<span class="sjma-change-marker">l) Ratificar les altes de Persones Associades i acordar, quan corresponga, la separació definitiva de Persones Associades en els supòsits previstos en aquests Estatuts.</span>'

ARTICLE18_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Assemblea General celebrarà sessions ordinàries i extraordinàries.</span>

  <span class="sjma-change-marker">2. Per a les sessions que celebre l’Assemblea General, les Persones Associades podran representar altres Persones Associades amb veu i vot, amb un màxim de tres representacions per Persona Associada representant, sense comptar la representació legal quan la persona representada tinga dret de vot d’acord amb aquests Estatuts i la normativa aplicable.</span>

  <span class="sjma-change-marker">3. La representació haurà d’acreditar-se mitjançant autorització presentada a la Secretaria de l’Assemblea a l’inici de cada sessió, en paper, per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, amb identificació suficient de la persona representada i de la persona representant. Només s’exigirà còpia del document identificatiu quan siga necessària per a verificar la representació o resoldre dubtes raonables sobre la identitat.</span>

  <span class="sjma-change-marker">4. L’autorització haurà de contindre, almenys, el nom i cognoms de la persona representada i de la representant, una identificació suficient d’ambdues, la sessió per a la qual s’atorga la representació i la signatura o validació equivalent de la persona representada.</span>
HTML

ARTICLE22_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La sessió serà dirigida per la Presidència i la Secretaria de l’Assemblea General. Exerciran aquestes funcions les persones que ocupen la Presidència i la Secretaria de la Junta Directiva.</span>

  <span class="sjma-change-marker">2. La Secretaria redactarà l’Acta de cada sessió, la qual reflectirà les persones assistents, les circumstàncies de lloc i temps, els assumptes tractats, un extracte de les principals deliberacions, el text dels acords que s’hagen adoptat i el resultat numèric de les votacions. Qualsevol Persona Associada podrà sol·licitar la incorporació de la seua intervenció o proposta a l’Acta en la forma que determine la Secretaria de l’Assemblea. Al començament de cada sessió de l’Assemblea es sotmetrà a aprovació la redacció de l’Acta de la sessió anterior, sense perjuí de l’executivitat dels Acords que en aquella s’hi adopten.</span>

  <span class="sjma-change-marker">3. L’Assemblea queda vàlidament constituïda en primera convocatòria quan hi concórrega un terç de les Persones Associades. Si en primera convocatòria no concorreguera aquest quòrum, es procedirà a la segona convocatòria prevista en el mateix escrit de convocatòria, sense subjecció a quòrum.</span>

  <span class="sjma-change-marker">Si la segona convocatòria no haguera estat prevista en l’escrit de convocatòria, haurà de realitzar-se una nova convocatòria d’acord amb el règim ordinari de convocatòria de l’Assemblea General previst en aquests Estatuts.</span>
HTML

ARTICLE20_OLD_EXTRAORDINARY_AGENDA_TEXT = "3. En les Assemblees Generals Extraordinàries no podran ser tractats més assumptes que els expressats en la Convocatòria."
ARTICLE20_NEW_EXTRAORDINARY_AGENDA_TEXT = '<span class="sjma-change-marker">3. En les Assemblees Generals Extraordinàries no es podrà alterar l’Ordre del Dia expressat en la Convocatòria.</span>'

ARTICLE23_OLD_VOTE_TEXT = "2. L’Assemblea General adopta els seus acords pel principi majoritari o de democràcia interna, corresponent un vot a cada Persona Associada present o representada."
ARTICLE23_NEW_VOTE_TEXT = '<span class="sjma-change-marker">2. En l’Assemblea General correspon un vot a cada Persona Associada present o representada.</span>'
ARTICLE23_OLD_INVALID_ACTS_TEXT = "3. Mancaran de validesa totes les disposicions i actes de la resta d’òrgans de representació i administració que contradiguen els Acords de l’Assemblea General, no sent considerats com a realitzats per la Societat i sent assumits en qualsevol cas per la persona que ocupe en el seu moment l’òrgan que els adopte."
ARTICLE23_NEW_INVALID_ACTS_TEXT = '<span class="sjma-change-marker">3. Mancaran de validesa interna totes les disposicions i actes de la resta d’òrgans de representació i administració que contradiguen els Acords de l’Assemblea General, i no vincularan internament la Societat, sense perjudici dels efectes davant de terceres persones de bona fe i del règim legal de responsabilitat que corresponga.</span>'

ARTICLE24_OLD_SIMPLE_MAJORITY_TEXT = "1. Els Acords de l’Assemblea General s’adoptaran en general per majoria simple de les Persones Associades presents quan els vots afirmatius superen als negatius, excepte en aquells casos en que els presents Estatuts determinen altra cosa."
ARTICLE24_NEW_SIMPLE_MAJORITY_TEXT = '<span class="sjma-change-marker">1. Els Acords de l’Assemblea General s’adoptaran en general per majoria simple de les Persones Associades presents i representades vàlidament quan els vots afirmatius superen els negatius, excepte en aquells casos en què els presents Estatuts determinen altra cosa.</span>'
ARTICLE24_OLD_QUALIFIED_MAJORITY_TEXT = "2. Requeriran de majoria absoluta, que resultarà quan els vots afirmatius superen la mitat dels vots emesos, els següents assumptes:"
ARTICLE24_NEW_QUALIFIED_MAJORITY_TEXT = '<span class="sjma-change-marker">2. Requeriran majoria qualificada els següents assumptes. Hi haurà majoria qualificada quan els vots afirmatius superen la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot:</span>'
ARTICLE24_OLD_SPECIFIC_CALL_TEXT = "3. En qualsevol cas, els Acords relatius als punts esmentats a l’apartat anterior requeriran que s’haja convocat específicament amb tal objecte l’Assemblea General corresponent."
ARTICLE24_NEW_SPECIFIC_CALL_TEXT = '<span class="sjma-change-marker">3. En qualsevol cas, els Acords relatius al punt d) de l’apartat anterior i als acords de dissolució previstos en l’article 104 requeriran que s’haja convocat específicament amb tal objecte l’Assemblea General corresponent.</span>'

ARTICLE28_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les persones que formen part de la Junta Directiva tenen el deure d’exercir fidelment les obligacions dels càrrecs per als quals han estat escollides i que han acceptat.</span>

  <span class="sjma-change-marker">2. Les persones que formen part de la Junta Directiva, de ple dret, amb veu i vot, exerciran el seu càrrec gratuïtament, sense que en cap cas es puguen percebre retribucions de cap mena per l’exercici de les seues funcions. Aquesta gratuïtat no impedirà que puguen percebre contraprestacions per serveis professionals o treballs prestats a la Societat diferents de les funcions pròpies del càrrec, sempre que siguen aprovades per l’òrgan competent, s’ajusten a la normativa aplicable, es respecte el règim de conflicte d’interés i, quan la Societat reba fons públics o estiga sotmesa a limitacions específiques, siguen compatibles amb el règim jurídic aplicable.</span>
HTML

ARTICLE103_OLD_DISSOLUTION_MAJORITY_TEXT = "a) Per Acord de l’Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria absoluta de les Persones Associades assistents amb dret a vot."
ARTICLE103_NEW_DISSOLUTION_MAJORITY_TEXT = '<span class="sjma-change-marker">a) Per Acord de l’Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria qualificada de les Persones Associades assistents amb dret a vot.</span>'

ARTICLE31_OLD_BOARD_COMPOSITION_TEXT = "1. La Junta Directiva haurà de comptar en tot cas amb la Presidència, una Secretaria, una Tresoreria i un número de Vocals no inferior a 5 ni superior a 20. Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, i amb una Vicesecretaria."
ARTICLE31_NEW_BOARD_COMPOSITION_TEXT = '<span class="sjma-change-marker">1. La Junta Directiva haurà de comptar en tot cas amb la Presidència, una Secretaria, una Tresoreria i un número de Vocals no inferior a 5 ni superior a 20. Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, amb una Vicesecretaria i amb una Vicetresoreria.</span>'
ARTICLE31_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva haurà de comptar en tot cas amb la Presidència, una Secretaria, una Tresoreria i un nombre de Vocalies no inferior a 5 ni superior a 20. Amb caràcter facultatiu, podrà comptar amb una o fins a tres Vicepresidències, amb una Vicesecretaria i amb una Vicetresoreria.</span>

  <span class="sjma-change-marker">2. La Junta Directiva podrà designar o convidar persones assessores tècniques, artístiques, educatives o de gestió perquè assistisquen a reunions o punts concrets amb veu i sense vot, sense integrar-se en l’òrgan de representació.</span>

  <span class="sjma-change-marker">3. La Junta Directiva podrà convidar puntualment altres Persones Associades o persones vinculades a la Societat a les reunions per raons d’interés de la Societat i de les seues activitats artístiques, educatives i socials, amb veu i sense vot.</span>
HTML

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
ARTICLE32_FULL_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva, en tot allò que no estiga expressament prescrit per aquestos Estatuts, podrà establir el seu propi Reglament orgànic i funcional mitjançant Resolució aprovada en reunió, que serà vigent durant el seu mandat. Mitjançant aquest, podrà determinar l’organització de la Junta Directiva i concretar el repartiment del treball i de les funcions inherents a l’òrgan entre les persones que la componen.</span>

  <span class="sjma-change-marker">2. La Junta Directiva podrà encomanar a Persones Associades, comissions, Persones Delegades, persones col·laboradores, professionals o altres persones vinculades a la Societat, quan resulte necessari, tasques concretes de gestió, representació, administració, coordinació o suport vinculades a les seues funcions.</span>

  <span class="sjma-change-marker">L’encomana haurà d’indicar què es pot fer, amb quins límits i durant quin termini, i podrà ser revocada en qualsevol moment per la Junta Directiva. Quan comporte representar formalment la Societat davant una federació, administració, entitat o tercer, haurà de constar mitjançant Resolució, apoderament, autorització o document acreditatiu suficient.</span>

  <span class="sjma-change-marker">Aquesta encomana no podrà substituir la Junta Directiva en l’adopció de decisions que corresponguen a aquest òrgan, ni permetre l’exercici de competències reservades a l’Assemblea General.</span>

  <span class="sjma-change-marker">La persona o persones encomanades hauran d’actuar en interés de la Societat, dins dels límits rebuts, i hauran de donar compte de la seua actuació a la Junta Directiva.</span>

  <span class="sjma-change-marker">3. En tot cas, correspon a la Junta Directiva les següents funcions:</span>

  <span class="sjma-change-marker">a) Vetlar per l’acompliment d’aquestos Estatuts i dels fins socials, convocar les Assemblees Generals i complir i fer complir els Acords adoptats en aquestes.</span>

  <span class="sjma-change-marker">b) Proposar a l’Assemblea General l’establiment de les quotes que les Persones Associades hagen de pagar.</span>

  <span class="sjma-change-marker">c) Presentar a l’Assemblea General els Comptes Anuals de cada exercici.</span>

  <span class="sjma-change-marker">d) Portar una comptabilitat conforme a les normes específiques que permeta obtindre la imatge fidel del patrimoni, del resultat i de la situació financera de la Societat.</span>

  <span class="sjma-change-marker">e) Acordar sobre l’exercici d’accions judicials de qualsevol ordre i recursos administratius, així com decidir sobre totes les intervencions i actuacions que se’n deriven.</span>

  <span class="sjma-change-marker">f) Tramitar i resoldre inicialment sobre les sol·licituds d’admissió de Persones Associades, dur-ne la relació actualitzada i elevar les altes i separacions definitives a l’Assemblea General quan corresponga d’acord amb aquests Estatuts.</span>

  <span class="sjma-change-marker">g) Nomenar, contractar, separar o acordar l’extinció que corresponga de les Direccions tècnic-artístiques de les Agrupacions Artístiques Titulars, així com nomenar o separar els càrrecs que conformen l’Equip Directiu de l’Escola de la Societat.</span>

  <span class="sjma-change-marker">En el cas de les Direccions tècnic-artístiques de les Agrupacions Artístiques Titulars, la Junta Directiva haurà d’escoltar prèviament la Comissió Mixta d’Agrupacions o les Persones Delegades de l’Agrupació afectada, sempre que la naturalesa de la decisió ho permeta, sense perjudici de la normativa laboral i de la confidencialitat que corresponga.</span>

  <span class="sjma-change-marker">h) Contractar o acomiadar el personal de l’Escola a proposta de l’Equip Directiu de l’Escola.</span>

  <span class="sjma-change-marker">i) Programar les activitats que s’hagen de desenvolupar, i organitzar, impulsar, ordenar i controlar tots els assumptes referents a les Agrupacions Artístiques Titulars, l’Escola i altres seccions i comissions culturals creades al si de la Societat.</span>

  <span class="sjma-change-marker">j) Aprovar les operacions que impliquen contraprestacions econòmiques a satisfer per part de la Societat que siguen iguals o superiors a la quantitat de 1.000 €, sense perjudici de les competències reservades a l’Assemblea General.</span>

  <span class="sjma-change-marker">k) Aprovar els reglaments interns que desenvolupen aquestos Estatuts quan no siga competència de l’Assemblea General.</span>

  <span class="sjma-change-marker">l) Convocar i dirigir consultes internes al conjunt de Persones Associades.</span>

  <span class="sjma-change-marker">m) Qualsevol altra facultat que no estiga expressament i específicament atribuïda a cap altre òrgan de govern i administració de la Societat, o que se delegue de manera expressa a la Junta Directiva.</span>
HTML

ARTICLE33_OLD_SCHOOL_STAFF_TEXT = <<~HTML.strip
  <span class="sjma-change-marker">e) Contractar o acomiadar al personal de l’Escola a proposta de l’Equip Directiu de l’Escola.</span>

  f) Totes aquelles que li corresponen d’acord amb els presents Estatuts.
HTML

ARTICLE33_NEW_SCHOOL_STAFF_TEXT = "e) Totes aquelles que li corresponen d’acord amb els presents Estatuts."
ARTICLE33_OLD_RESIDUAL_TEXT = "c) Totes aquelles competències de caràcter residual, no reservades expressament a l’Assemblea General o a la Junta Directiva, que foren necessàries per a l’acompliment dels fins de la Societat."
ARTICLE33_NEW_RESIDUAL_TEXT = '<span class="sjma-change-marker">c) Adoptar les mesures ordinàries o urgents necessàries per a executar els Acords de l’Assemblea General i les Resolucions de la Junta Directiva, donant compte a la Junta Directiva en la primera reunió que se celebre, sense assumir competències reservades a l’Assemblea General o a la Junta Directiva.</span>'

ARTICLE35_OLD_FORMAL_NOTICES_TEXT = "b) Autoritzar les citacions."
ARTICLE35_NEW_FORMAL_NOTICES_TEXT = '<span class="sjma-change-marker">b) Autoritzar, junt amb la Presidència, les convocatòries, citacions i comunicacions formals de la Societat quan corresponga.</span>'
ARTICLE35_OLD_CERTIFICATES_TEXT = "e) Autoritzar els títols socials."
ARTICLE35_NEW_CERTIFICATES_TEXT = '<span class="sjma-change-marker">e) Autoritzar les certificacions, credencials o documents acreditatius expedits per la Societat.</span>'

ARTICLE36_OLD_NO_VICESECRETARY_TEXT = '<span class="sjma-change-marker">En el supòsit de no haver designat cap Vicepresidència, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Presidència de la Junta Directiva.</span>'
ARTICLE36_NEW_NO_VICESECRETARY_TEXT = '<span class="sjma-change-marker">En el supòsit de no haver designat cap Vicesecretaria, assumirà les funcions descrites la persona que corresponga d’acord amb el règim previst en l’article 41.</span>'

VICETRESORERIA_TITLE = "Article 38. De la Vicetresoreria"
VICETRESORERIA_BODY = <<~HTML.strip
  <span class="sjma-change-marker">La persona que, en el seu cas, assumisca la Vicetresoreria substituirà la Tresoreria per raons justificades de malaltia, absència, impossibilitat o per delegació expressa de la Tresoreria, sense perjuí d’ulteriors delegacions o apoderaments per part d’altres components de la Junta Directiva.</span>

  <span class="sjma-change-marker">En el supòsit de no haver designat cap Vicetresoreria, assumirà les funcions descrites la persona que corresponga d’acord amb el règim previst en l’article 41.</span>
HTML

ARTICLE20_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Assemblea General celebrarà sessió extraordinària quan ho sol·licite la Presidència, un terç dels membres de la Junta Directiva o un 10 per cent de les Persones Associades. La sol·licitud serà dirigida a la Presidència de la Societat mitjançant escrit, que podrà presentar-se per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, i en el qual s’expressaran de manera concreta les causes que motiven la sol·licitud i l’Ordre del Dia que haurà de ser objecte de la Convocatòria.</span>

  <span class="sjma-change-marker">2. Les sessions extraordinàries de l’Assemblea General es convocaran dins dels 15 dies següents a la sol·licitud i s’hauran de celebrar necessàriament dins dels 30 dies naturals posteriors a la data de la sol·licitud, excepte quan tinguen per objecte la modificació dels Estatuts, que es tramitaran pels terminis específics previstos en aquests Estatuts.</span>

  <span class="sjma-change-marker">3. En les Assemblees Generals Extraordinàries no es podrà alterar l’Ordre del Dia expressat en la Convocatòria.</span>
HTML

ARTICLE22_NEW_MINUTES_APPROVAL_TEXT = '<span class="sjma-change-marker">2. La Secretaria redactarà l’Acta de cada sessió, la qual reflectirà les persones assistents, les circumstàncies de lloc i temps, els assumptes tractats, un extracte de les principals deliberacions, el text dels acords que s’hagen adoptat i el resultat numèric de les votacions. Al començament de cada sessió de l’Assemblea es sotmetrà a aprovació la redacció de l’Acta de la sessió anterior, sense perjuí de l’executivitat dels Acords que en aquella s’hi adopten.</span>'

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
  <span class="sjma-change-marker">1. L’Assemblea General celebrarà sessions ordinàries dues vegades a l’any. La primera sessió, denominada econòmica, haurà de celebrar-se en el primer trimestre, i la segona sessió, denominada social, en el tercer trimestre.</span>

  <span class="sjma-change-marker">2. L’Ordre del Dia de la sessió econòmica de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovació de l’acta de la sessió anterior de l’Assemblea General.</span>

  <span class="sjma-change-marker">b) Aprovació dels Comptes Anuals de la Societat presentats per la Junta Directiva.</span>

  <span class="sjma-change-marker">c) Aprovació dels pressupostos ordinaris proposats per la Junta Directiva.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  <span class="sjma-change-marker">3. L’Ordre del Dia de la sessió social de l’Assemblea comprendrà, almenys, els següents punts:</span>

  <span class="sjma-change-marker">a) Aprovació de l’acta de la sessió anterior de l’Assemblea General.</span>

  <span class="sjma-change-marker">b) Aprovació de la Memòria d’activitats del darrer curs.</span>

  <span class="sjma-change-marker">c) Elecció i cessament de la Junta Directiva, quan siga procedent de conformitat amb aquestos Estatuts.</span>

  <span class="sjma-change-marker">d) Precs i preguntes.</span>

  4. Podran ampliar-se els punts de l’Ordre del Dia de les Assemblees Generals amb les altres matèries de competència de l’Assemblea General que es relacionen en l’article 17.1 d’aquestos Estatuts.
HTML

ARTICLE29_TITLE = "Article 29. De l’elecció de la Junta Directiva"
ARTICLE29_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva serà escollida per l’Assemblea General mitjançant candidatures completes en llista tancada, d’acord amb el que establixen aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. El procediment electoral per a triar la Junta Directiva es regirà per les següents normes:</span>

  a) Conformaran el cos electoral totes les Persones Associades que no hagen estat privades del dret de votació per procediment legal o disciplinari.

  <span class="sjma-change-marker">A l’efecte de participar en les eleccions internes, només formaran part del cens electoral les persones que hagueren adquirit la condició de Persona Associada abans de la data de convocatòria de les eleccions.</span>

  <span class="sjma-change-marker">b) Les candidatures es presentaran com a llistes tancades a la Junta Directiva en el termini de 7 dies naturals comptats des de l’endemà de la convocatòria de l’Assemblea en què es vaja a celebrar l’elecció, mitjançant escrit presentat a la Junta Directiva, per correu electrònic, formulari electrònic o altres canals habilitats per la Societat.</span>

  <span class="sjma-change-marker">En aquest escrit haurà de figurar la relació completa de persones que integren la candidatura i el càrrec que desenvoluparà cadascuna dins de la Junta Directiva.</span>

  <span class="sjma-change-marker">En cap cas es tractarà d’una llista oberta ni d’una elecció separada per càrrecs, de manera que el vot recaurà sobre la candidatura completa a la Junta Directiva.</span>

  <span class="sjma-change-marker">El dia natural següent a la finalització del termini de presentació, la Junta Directiva farà publicitat de les candidatures presentades al Tauler d’Anuncis de la Societat, per correu electrònic i pels altres canals habituals de comunicació de la Societat.</span>

  <span class="sjma-change-marker">Entre la publicació de les candidatures i la sessió de l’Assemblea en què s’haja de votar hauran de transcórrer, almenys, 7 dies naturals, perquè les Persones Associades que formen part del cens electoral puguen conèixer les candidatures i formar el seu criteri de vot.</span>

  <span class="sjma-change-marker">c) Abans d’efectuar la votació, les candidatures exposaran les seues propostes i projectes per a la Societat. A més, hauran de presentar totes les persones que integren la candidatura i els càrrecs que desenvoluparan. A partir d’aquestos punts, podran debatre i confrontar posicions amb les restants candidatures.</span>

  <span class="sjma-change-marker">Correspondrà a la Persona Associada de major edat present en la sessió moderar les intervencions i el debat, per al qual passarà a formar part de la Mesa de l’Assemblea General com a Moderador. En cas que aquesta Persona Associada integrara també una candidatura a la Junta Directiva, exercirà la funció de Moderador la següent Persona Associada de més edat, i així successivament.</span>

  <span class="sjma-change-marker">d) L’elecció de la Junta Directiva es realitzarà sempre mitjançant votació secreta, inclús quan només s’haja presentat una única candidatura.</span>

  <span class="sjma-change-marker">El sistema de votació haurà de permetre identificar de manera clara les candidatures presentades i preservar en tot cas el caràcter secret del vot.</span>

  <span class="sjma-change-marker">e) Serà escollida la candidatura a la Junta Directiva que obtinga el major nombre de vots de les Persones Associades presents o representades.</span>

  <span class="sjma-change-marker">En cas d’empat entre les candidatures amb major nombre de vots, es farà una nova votació entre aquestes candidatures en la mateixa sessió; si l’empat persistira, l’Assemblea General acordarà la continuïtat del procés electoral d’acord amb aquests Estatuts.</span>

  <span class="sjma-change-marker">f) Les Persones Associades podran delegar el seu dret de votació en les eleccions a la Junta Directiva en altra Persona Associada representant en els termes previstos en aquestos Estatuts. L’autorització de la representació haurà de contindre únicament les dades exigides amb caràcter general per a la delegació de veu i vot, sense indicar el sentit del vot de la persona representada.</span>

  <span class="sjma-change-marker">En les votacions secretes, la Persona Associada representant podrà emetre el seu vot i els vots corresponents a les Persones Associades que represente, preservant en tot cas el caràcter secret del vot.</span>

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

  <span class="sjma-change-marker">d) Cessament motivat acordat per l’Assemblea General, amb audiència prèvia de la persona o persones afectades, en els termes previstos en aquestos Estatuts i en la normativa aplicable.</span>

  <span class="sjma-change-marker">e) Les restants causes previstes en aquestos Estatuts.</span>

  <span class="sjma-change-marker">4. Quan es produïsquen vacants en una Junta Directiva distintes a la Presidència, la Junta Directiva podrà designar provisionalment, mitjançant Resolució adoptada en reunió, la Persona Associada que assumirà el càrrec vacant fins a la següent sessió de l’Assemblea General.</span>

  <span class="sjma-change-marker">En la primera sessió de l’Assemblea General que se celebre, la vacant serà coberta formalment mitjançant votació de l’Assemblea General, a proposta de la Junta Directiva, pel temps que reste del mandat. Si la proposta no resultara aprovada, la Junta Directiva haurà de formular una nova proposta o mantindre la cobertura provisional fins a la següent sessió de l’Assemblea General, dins dels límits d’interinitat previstos en aquests Estatuts.</span>

  <span class="sjma-change-marker">Quan es produïsca vacant en la Presidència, un terç de les persones que formen part de la Junta Directiva i continuen en el càrrec convocaran sessió extraordinària de l’Assemblea General, sessió en la qual finalitzarà la Junta Directiva en eixe moment i es triarà una nova Junta Directiva mitjançant candidatura de llista tancada en els termes previstos en aquestos Estatuts.</span>

  <span class="sjma-change-marker">5. Quan a les eleccions a Junta Directiva no es presentara cap candidatura completa, la Junta Directiva del mandat finalitzat continuarà en el règim d’interinitat previst a l’article 42 d’aquestos Estatuts durant un període màxim inicial de 3 mesos.</span>

  <span class="sjma-change-marker">Si finalitzat aquest període persistira l’absència de candidatures, la Junta Directiva interina haurà de convocar una Assemblea General perquè decidisca les mesures que cal adoptar, que podran incloure la continuïtat temporal de la interinitat, l’obertura d’un nou procés electoral, mesures per a promoure candidatures o, si no fora possible assegurar el funcionament de la Societat, l’inici del procediment de dissolució en els termes previstos en aquests Estatuts i en la normativa aplicable.</span>
HTML

ARTICLE42_BODY = <<~HTML.strip
  <span class="sjma-change-marker">En els casos previstos per aquestos Estatuts, la Junta Directiva podrà funcionar en règim d’interinitat. Durant aquestos períodes, les funcions de la Junta Directiva es reduiran a mantindre les activitats essencials de la Societat i a donar acompliment a les seues obligacions bàsiques, i tindrà com a missió fonamental treballar per a la presentació de noves candidatures que posen fi al període d’interinitat.</span>
HTML

ARTICLE43_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva retrà comptes de la seua gestió i actuació davant de l’Assemblea General en els termes previstos en aquestos Estatuts.</span>

  <span class="sjma-change-marker">2. La Presidència, en nom de la Junta Directiva i prèvia deliberació d’aquesta en reunió, podrà plantejar davant l’Assemblea General en sessió ordinària un vot de confiança sobre la gestió i actuació de la Junta Directiva.</span>

  <span class="sjma-change-marker">La confiança s’entendrà atorgada quan vote a favor d’aquesta la majoria simple de les persones presents o representades vàlidament amb dret de vot. Si no s’atorga, s’entendrà revocada la confiança en la Junta Directiva i cessades totes les persones que la componen. La Junta Directiva cessada continuarà en funcions en règim d’interinitat fins que l’Assemblea General trie una nova Junta Directiva.</span>

  <span class="sjma-change-marker">3. L’Assemblea General podrà revocar en sessió extraordinària la confiança en la Junta Directiva mitjançant vot de censura. El vot de censura haurà de ser proposat per almenys un 10 per cent de les Persones Associades amb dret a vot i haurà d’incloure una candidatura completa de Junta Directiva en llista tancada.</span>

  <span class="sjma-change-marker">El vot de censura s’entendrà aprovat quan vote a favor d’aquest la majoria qualificada de les persones presents o representades vàlidament amb dret de vot. Si s’aprova, cessarà la Junta Directiva existent i quedarà escollida com a nova Junta Directiva la candidatura proposada en el vot de censura.</span>

  <span class="sjma-change-marker">Els cessaments derivats del vot de confiança o del vot de censura hauran de ser motivats i garantir l’audiència prèvia de les persones afectades, en els termes exigits per la normativa aplicable.</span>
HTML

ARTICLE44_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Els acords que, d’acord amb aquests Estatuts, haja d’adoptar la Junta Directiva, i aquells que aquesta estime convenient adoptar, es materialitzaran en Resolucions, sense perjudici del seu enregistrament en les actes de les reunions en què s’adopten.</span>

  <span class="sjma-change-marker">2. Les Resolucions vàlidament adoptades seran aplicables a l’activitat de la Societat i a les Persones Associades en l’àmbit de les competències de la Junta Directiva.</span>
HTML

ARTICLE45_RESOLUTIONS_APPROVAL_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Resolucions s’aprovaran per majoria simple de les persones assistents amb dret de vot, sense perjudici del vot de qualitat de la Presidència en cas d’empat.</span>

  <span class="sjma-change-marker">2. El procediment de votació podrà ser a mà alçada, per vot nominal públic, amb constància del sentit del vot de cada persona, o per votació secreta mitjançant papereta o sistema equivalent, quan així ho acorde la Junta Directiva o ho exigisquen aquests Estatuts.</span>
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

  <span class="sjma-change-marker">3. Les Agrupacions Artístiques Titulars seran creades per Resolució de la Junta Directiva. La Resolució de creació indicarà, almenys, la finalitat, naturalesa i activitat principal de l’Agrupació, la seua Direcció tècnic-artística inicial, la vinculació amb l’Escola quan corresponga i el règim inicial de Persones Delegades d’acord amb aquests Estatuts.</span>

  <span class="sjma-change-marker">4. La Junta Directiva podrà modificar, suspendre o extingir una Agrupació Artística Titular mitjançant Resolució motivada, escoltada la Direcció tècnic-artística i, quan siga possible, les Persones Delegades o les persones integrants actives afectades.</span>
HTML

ARTICLE46_TITLE = "Article 46. De la doble vessant artística i educativa"
ARTICLE46_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Les Agrupacions Artístiques Titulars podran tindre una vessant artística i una vessant educativa o pedagògica quan així ho preveja la planificació educativa de l’Escola de la Societat i ho aprove la Junta Directiva mitjançant Resolució, d’acord amb els instruments pedagògics, organitzatius i acadèmics que corresponguen segons la normativa vigent aplicable, sense alterar la seua condició d’Agrupació Artística Titular.</span>
HTML

ARTICLE47_TITLE = "Article 47. De l’exercici artístic"
ARTICLE47_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’exercici artístic de les Agrupacions Artístiques Titulars és el període anual en què aquestes desenvolupen la seua activitat ordinària, i comprendrà de l’1 de setembre al 31 d’agost de l’any següent.</span>

  <span class="sjma-change-marker">2. La programació concreta de cada Agrupació dins de l’exercici artístic s’adaptarà a la seua naturalesa, calendari i necessitats, i haurà de coordinar-se amb la programació general de la Societat i de l’Escola per afavorir una planificació coherent, evitar solapaments i facilitar projectes, cicles o festivals comuns.</span>
HTML

ARTICLE48_TITLE = "Article 48. De la direcció artística i tècnica"
ARTICLE48_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Cada Agrupació Artística Titular comptarà, com a mínim, amb una Direcció tècnic-artística, exercida per una persona contractada per la Societat.</span>

  <span class="sjma-change-marker">2. Quan la naturalesa, dimensió, activitat o projecció de l’Agrupació ho requerisca, la Junta Directiva podrà ampliar, modificar o reduir mitjançant Resolució l’estructura de direcció artística i tècnica de l’Agrupació, que podrà estar integrada per una o diverses persones contractades per la Societat, diferenciant, si escau, funcions de direcció artística, direcció tècnica o titular, o altres responsabilitats tècnic-artístiques contractades. La Resolució delimitarà les funcions atribuïdes a cada persona i, si escau, la persona responsable de la coordinació tècnic-artística de l’Agrupació.</span>

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

  <span class="sjma-change-marker">4. Les Persones Delegades Junior tindran com a funció principal traslladar la visió, opinions, necessitats i inquietuds de les persones menors d’edat de l’Agrupació. Participaran en les funcions de comunicació, coordinació i proposta d’acord amb la seua edat i capacitat, sense assumir funcions de representació legal ni responsabilitats reservades a persones majors d’edat.</span>

  <span class="sjma-change-marker">5. Correspon a les Persones Delegades:</span>

  <span class="sjma-change-marker">a) Facilitar la comunicació interna de l’Agrupació.</span>

  <span class="sjma-change-marker">b) Participar en la coordinació operativa de les activitats, concerts, desplaçaments i projectes especials que els siga encomanada o assumisquen, amb el suport i aprovació de la Junta Directiva i de la Direcció tècnic-artística quan corresponga.</span>

  <span class="sjma-change-marker">c) Donar suport a la Direcció tècnic-artística en assumptes artístics, organitzatius i socials de l’Agrupació, inclosa la detecció de necessitats de les diferents seccions i la millora de la seua dinàmica interna.</span>

  <span class="sjma-change-marker">d) Representar en la Comissió Mixta d’Agrupacions la visió general de l’Agrupació, traslladant-hi les seues propostes, necessitats, inquietuds, projectes i incidències, així com aquells assumptes que resulten rellevants per a la coordinació general de la Societat.</span>

  <span class="sjma-change-marker">e) Contribuir a mantindre un bon clima humà, de treball i de convivència dins de l’Agrupació.</span>

  <span class="sjma-change-marker">f) Les altres funcions que els atribuïsquen aquests Estatuts o les normes internes de la Societat.</span>
HTML

ARTICLE51_TITLE = "Article 51. Definició i finalitats"
ARTICLE51_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Arxiu de la Societat és el servei intern destinat a reunir, ordenar, descriure, inventariar, conservar i preservar el patrimoni documental de la Societat, siga quina siga la seua data, forma o suport, i a catalogar-lo quan corresponga.</span>

  <span class="sjma-change-marker">2. L’Arxiu actua també com a centre de documentació del patrimoni musical, artístic, educatiu, social i institucional de la Societat, i podrà facilitar-ne la consulta, l’estudi i la difusió quan corresponga.</span>

  <span class="sjma-change-marker">3. Formen part de l’Arxiu els fons, col·leccions i documents produïts, rebuts, adquirits, donats, llegats, cedits en depòsit o conservats per la Societat que tinguen valor històric, musical, artístic, educatiu, social, institucional o administratiu permanent.</span>

  <span class="sjma-change-marker">4. L’Arxiu tindrà com a finalitats principals preservar la memòria històrica de la Societat, donar suport a la seua activitat ordinària, afavorir la investigació i la difusió cultural, i garantir la transmissió del seu patrimoni documental a les generacions futures.</span>
HTML

ARTICLE52_TITLE = "Article 52. De la conservació i gestió de l’Arxiu"
ARTICLE52_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. L’Arxiu s’organitzarà, preferentment, en els següents fons o seccions documentals:</span>

  <span class="sjma-change-marker">a) El fons musical, artístic i audiovisual, format per partitures, arranjaments, particel·les, enregistraments sonors i audiovisuals, documentació de repertori, programes de mà, cartells, fotografies, materials de difusió i altres documents vinculats a l’activitat artística de la Societat.</span>

  <span class="sjma-change-marker">b) El fons social i institucional, format per actes, estatuts històrics, llibres i registres socials, correspondència institucional, documentació econòmica i administrativa amb valor històric o permanent, premsa, publicacions i altra documentació relativa a la vida associativa de la Societat.</span>

  <span class="sjma-change-marker">c) El fons educatiu i pedagògic, format per documentació històrica o permanent vinculada a l’Escola, al seu projecte educatiu, planificació educativa, programacions, activitats formatives, materials pedagògics, memòries i altres documents relacionats amb la formació artística desenvolupada per la Societat.</span>

  <span class="sjma-change-marker">d) El fons de memòria social i oral, format per testimonis orals, entrevistes, relats biogràfics, llegats personals, col·leccions familiars i altres materials no estrictament artístics que contribuïsquen a preservar la memòria humana, social i institucional de la Societat.</span>

  <span class="sjma-change-marker">2. La Junta Directiva vetlarà per la conservació, ordenació i gestió adequada de l’Arxiu, d’acord amb criteris tècnics, de seguretat, conservació, procedència, integritat dels fons, eficiència, accessibilitat i preservació digital.</span>

  <span class="sjma-change-marker">3. La Junta Directiva podrà encomanar la coordinació de l’Arxiu a la Secretaria, a una vocalia, a una comissió o a una persona responsable designada a aquest efecte, i podrà comptar amb la col·laboració de Persones Associades, persones voluntàries, personal contractat, persones en pràctiques o professionals amb formació adequada.</span>

  <span class="sjma-change-marker">4. L’accés i consulta dels fons podrà facilitar-se a les Persones Associades i, quan siga procedent, a persones investigadores o entitats externes, amb respecte en tot cas a la normativa de protecció de dades personals, propietat intel·lectual, confidencialitat, conservació dels materials, seguretat dels fons i altres límits legalment aplicables.</span>

  <span class="sjma-change-marker">5. La Junta Directiva podrà aprovar un Reglament de l’Arxiu de la Societat, que desenvolupe el règim d’ingrés de materials, descripció, inventari, catalogació, conservació, digitalització, consulta, reproducció, préstec, difusió, eliminació o expurgació quan procedisca, i ús dels fons. L’eliminació o expurgació de documentació haurà d’ajustar-se a criteris tècnics, terminis de conservació, valor històric o permanent, protecció de dades personals, propietat intel·lectual i la resta de límits legals aplicables.</span>
HTML

ARTICLE53_TITLE = "Article 53. De l’elecció de les Persones Delegades"
ARTICLE53_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Persones Delegades tindran una vigència d’un exercici artístic i podran ser reelegides. Si no es presentaren candidatures suficients, si alguna Persona Delegada dimitira o si deixara de ser persona integrant activa de l’Agrupació, la Junta Directiva podrà designar provisionalment, escoltada la Direcció tècnic-artística, les persones necessàries fins a la següent Assemblea d’Agrupació.</span>

  <span class="sjma-change-marker">2. Cada Agrupació Artística Titular celebrarà, almenys una vegada a l’any, una Assemblea d’Agrupació per a l’elecció de les seues Persones Delegades i per a tractar altres assumptes propis de l’Agrupació.</span>

  <span class="sjma-change-marker">3. L’elecció de les Persones Delegades haurà de celebrar-se durant el tercer trimestre de l’any natural, coincidint amb la finalització d’un exercici artístic i la preparació del següent.</span>

  <span class="sjma-change-marker">4. La convocatòria haurà d’indicar, almenys, data, hora, lloc o mitjà de celebració, Ordre del Dia, nombre de Persones Delegades a escollir i termini de presentació de candidatures.</span>

  <span class="sjma-change-marker">5. La convocatòria haurà de realitzar-se amb una antelació mínima de 15 dies naturals. Les candidatures podran presentar-se durant els 7 dies naturals següents a la convocatòria.</span>

  <span class="sjma-change-marker">6. El dia natural següent a la finalització del termini de presentació es farà pública la relació de candidatures presentades pels mitjans habituals de comunicació interna de l’Agrupació.</span>

  <span class="sjma-change-marker">7. Resultaran escollides les persones candidates que obtinguen major nombre de vots fins a cobrir el nombre de Persones Delegades que corresponga a l’Agrupació. En cas d’empat que impedisca cobrir l’última plaça, es farà una nova votació entre les persones candidates empatades.</span>

  <span class="sjma-change-marker">8. Les Persones Delegades júnior, quan corresponguen, s’escolliran en la mateixa Assemblea d’Agrupació, en votació separada i entre les persones candidates que complisquen els requisits de l’article 51.3. Tindran dret de vot totes les persones integrants actives assistents amb dret de vot d’acord amb l’article 56.</span>

  <span class="sjma-change-marker">9. Durant el primer exercici artístic de funcionament d’una Agrupació Artística Titular, les Persones Delegades seran designades provisionalment per Resolució de la Junta Directiva, escoltada la Direcció tècnic-artística, una vegada transcorregut un període inicial suficient per a valorar la participació i implicació de les persones que la integren.</span>

  <span class="sjma-change-marker">10. Si finalitzat el tercer trimestre no s’haguera convocat l’Assemblea d’Agrupació per a l’elecció de Persones Delegades, la Direcció tècnic-artística haurà de convocar-la, amb el vistiplau de la Junta Directiva.</span>
HTML

ARTICLE54_TITLE = "Article 54. De les Assemblees d’Agrupació"
ARTICLE54_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació són espais interns de deliberació i proposta de les persones integrants actives de cada Agrupació Artística Titular.</span>

  <span class="sjma-change-marker">2. No tenen la consideració d’òrgans de govern de la Societat i els seus acords o posicionaments tindran caràcter intern i no vinculant.</span>

  <span class="sjma-change-marker">3. La Direcció tècnic-artística i les persones representants de la Junta Directiva podran assistir-hi, amb veu i sense vot, quan siguen convidades per les Persones Delegades o per acord de la mateixa Assemblea d’Agrupació.</span>

  <span class="sjma-change-marker">4. La Direcció tècnic-artística o la Junta Directiva podran sol·licitar a les Persones Delegades la convocatòria d’una Assemblea d’Agrupació quan consideren necessari tractar amb l’Agrupació projectes, necessitats, incidències o assumptes d’especial rellevància. En aquest cas, les Persones Delegades hauran de convocar-la en un termini raonable i, en tot cas, dins dels 15 dies naturals següents a la sol·licitud. Si no ho feren, podrà convocar-la la Direcció tècnic-artística amb el vistiplau de la Junta Directiva. La Direcció tècnic-artística o les persones representants de la Junta Directiva sol·licitants podran assistir-hi amb veu i sense vot.</span>
HTML

ARTICLE55_TITLE = "Article 55. Del funcionament de les Assemblees d’Agrupació"
ARTICLE55_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació seran convocades per les Persones Delegades, d’acord amb aquests Estatuts i amb les normes internes de cada Agrupació.</span>

  <span class="sjma-change-marker">2. La convocatòria haurà de fer-se pública pels mitjans habituals de comunicació interna de l’Agrupació i haurà d’indicar, almenys, la data, hora, lloc o mitjà de celebració i l’Ordre del Dia.</span>

  <span class="sjma-change-marker">3. Les Assemblees d’Agrupació quedaran vàlidament constituïdes amb les persones integrants actives que hi assistisquen, sense exigència de quòrum mínim, llevat que el Reglament de Règim Intern de l’Agrupació establisca una altra previsió compatible amb aquests Estatuts.</span>

  <span class="sjma-change-marker">4. Les votacions es realitzaran per majoria simple de les persones integrants actives assistents amb dret a vot. Tindran dret de vot les persones integrants actives que tinguen la condició de Persona Associada o que formen part de les Joventuts. La resta de persones integrants actives podran participar amb veu, sense perjudici que el Reglament de Règim Intern puga concretar altres formes de participació interna compatibles amb aquests Estatuts.</span>
HTML

ARTICLE56_TITLE = "Article 56. Dels acords i posicionaments de les Assemblees d’Agrupació"
ARTICLE56_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Assemblees d’Agrupació podran adoptar acords o posicionaments interns sobre els assumptes propis de l’Agrupació.</span>

  <span class="sjma-change-marker">2. Aquests acords o posicionaments no tindran caràcter vinculant per als òrgans de govern de la Societat, sense perjudici que hagen de ser traslladats a la Direcció tècnic-artística, a la Comissió Mixta d’Agrupacions o a la Junta Directiva quan corresponga.</span>
HTML

ARTICLE57_TITLE = "Article 57. Del dipòsit de béns mobles relacionats amb l’activitat artística propietat de la Societat"
ARTICLE57_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Quan la Societat deixe a disposició d’una persona integrant activa un instrument, uniforme o qualsevol altre bé de la seua propietat, la persona receptora el rebrà en qualitat de dipositària i haurà de custodiar-lo i utilitzar-lo d’acord amb les condicions que determine la Junta Directiva per escrit, per mitjans electrònics o per altres canals que en deixen constància.</span>

  <span class="sjma-change-marker">Els béns cedits estaran sempre a disposició de la Junta Directiva, que podrà requerir-ne la devolució quan així ho acorde. En aquest cas, la persona dipositària haurà de lliurar-los immediatament o en el termini que se li indique. Si no ho fera, podrà incórrer en les responsabilitats que legalment corresponguen.</span>

  <span class="sjma-change-marker">Per a la resta de qüestions no previstes, serà aplicable el règim del dipòsit previst al Codi Civil.</span>

  <span class="sjma-change-marker">2. Les persones que, per qualsevol circumstància, deixen de ser persones integrants actives de l’Agrupació, hauran de retornar tots els béns de la Societat que tinguen al seu càrrec en un termini no superior a un mes, amb notificació prèvia de la Junta Directiva.</span>
HTML

ARTICLE58_TITLE = "Article 58. Dels Reglaments de Règim Intern de les Agrupacions"
ARTICLE58_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les Agrupacions Artístiques Titulars podran comptar amb Reglaments de Règim Intern que desenvolupen la seua organització i funcionament, sempre que no contradiguen aquests Estatuts, els Acords de l’Assemblea General ni les Resolucions de la Junta Directiva.</span>

  <span class="sjma-change-marker">2. L’elaboració o modificació dels Reglaments de Règim Intern es farà de manera participada entre la Junta Directiva, la Direcció tècnic-artística, les Persones Delegades i les persones integrants actives de l’Agrupació.</span>

  <span class="sjma-change-marker">3. Abans de la seua aprovació, el text proposat haurà de fer-se públic entre les persones integrants actives de l’Agrupació durant un termini mínim de 7 dies naturals, perquè puguen formular aportacions.</span>

  <span class="sjma-change-marker">4. L’aprovació dels Reglaments de Règim Intern correspondrà en tot cas a la Junta Directiva mitjançant Resolució.</span>

  <span class="sjma-change-marker">5. Una vegada aprovats, els Reglaments de Règim Intern es faran públics entre les persones integrants actives de l’Agrupació pels mitjans habituals de comunicació interna. Quan afecten persones menors d’edat, es comunicaran també a les seues persones representants legals pels canals habilitats.</span>
HTML

ARTICLE59_TITLE = "Article 59. De la Comissió Mixta d’Agrupacions"
ARTICLE59_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Comissió Mixta d’Agrupacions és l’espai de coordinació entre les Agrupacions Artístiques Titulars, les agrupacions i conjunts de l’Escola i la Junta Directiva.</span>

  <span class="sjma-change-marker">2. La Comissió Mixta d’Agrupacions tindrà caràcter consultiu, de coordinació i seguiment, sense facultats decisòries pròpies.</span>

  <span class="sjma-change-marker">3. Estarà integrada per les Persones Delegades de les Agrupacions Artístiques Titulars, les persones representants de les agrupacions i conjunts de l’Escola i almenys dues persones representants de la Junta Directiva.</span>

  <span class="sjma-change-marker">4. Es reunirà, almenys, una vegada al mes durant els períodes d’activitat ordinària, i en tot cas quan ho requerisca la coordinació de projectes, actuacions o necessitats comunes. Una de les persones representants de la Junta Directiva dirigirà les reunions i una altra prendrà acta.</span>
HTML

ARTICLE60_TITLE = "Article 60. Del seguiment de les Agrupacions Artístiques"
ARTICLE60_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. En la primera reunió ordinària de la Junta Directiva posterior a cada reunió de la Comissió Mixta d’Agrupacions s’inclourà un punt específic de l’Ordre del Dia denominat “Seguiment de les Agrupacions Artístiques”, en el qual es donarà compte dels assumptes tractats en la Comissió.</span>

  <span class="sjma-change-marker">2. La Junta Directiva podrà convidar les persones membres de la Comissió Mixta d’Agrupacions a les seues reunions, amb veu i sense vot, quan s’hi tracten assumptes d’especial rellevància per a les agrupacions que representen o coordinen, especialment quan aquests assumptes hagen sigut tractats prèviament en la Comissió i s’haja determinat així.</span>
HTML

ARTICLE65_TITLE = "Article 65. De les agrupacions i conjunts de l’Escola"
ARTICLE65_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Les agrupacions i conjunts de l’Escola es regiran per la planificació educativa de l’Escola de la Societat i pels instruments pedagògics, organitzatius i acadèmics que corresponguen segons la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">2. Les agrupacions i conjunts de l’Escola estaran representats en la Comissió Mixta d’Agrupacions per la Direcció de l’Escola o per les persones responsables que aquesta designe d’acord amb l’organització educativa vigent.</span>

  <span class="sjma-change-marker">3. L’alumnat de l’Escola, quan reunisca les condicions d’aptitud suficients d’acord amb el criteri de la Direcció tècnic-artística i del professorat corresponent, podrà incorporar-se a les Agrupacions Artístiques Titulars d’acord amb el procediment que, si escau, siga treballat en la Comissió Mixta d’Agrupacions i aprovat per Resolució de la Junta Directiva a proposta d’aquesta.</span>
HTML

ARTICLE61_OLD_SCHOOL_PURPOSE_TEXT = "1. Per a fomentar l’art musical, aquesta Societat tindrà com a interés primordial la creació, organització i gestió d’una Escola i el seu manteniment."
ARTICLE61_NEW_SCHOOL_PURPOSE_TEXT = '<span class="sjma-change-marker">1. Per a fomentar l’art musical i altres disciplines artístiques, aquesta Societat tindrà com a interés primordial la creació, organització, gestió i manteniment d’una Escola.</span>'
ARTICLE61_OLD_SCHOOL_ACCESS_TEXT = '2. Totes les Persones Associades <span class="sjma-change-marker">i aquelles que componen les Joventuts</span> podran ingressar en l’Escola <span class="sjma-change-marker">en els termes que reglamentàriament es disposen</span>.'
ARTICLE61_NEW_SCHOOL_ACCESS_TEXT = '<span class="sjma-change-marker">2. L’Escola estarà oberta a les Persones Associades, a les persones que componen les Joventuts i a persones no associades, en els termes que reglamentàriament es disposen. Les Persones Associades i les Joventuts podran gaudir de les condicions, beneficis o bonificacions que aprove l’òrgan competent de la Societat.</span>'
ARTICLE62_EDUCATIONAL_DISCIPLINES_TEXT = '<span class="sjma-change-marker">4. L’ampliació de l’activitat educativa de l’Escola a altres disciplines artístiques s’haurà d’ajustar a la normativa educativa, organitzativa i registral que siga aplicable en cada moment.</span>'
ARTICLE62_GENERAL_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. Per a fomentar l’art musical i altres disciplines artístiques, aquesta Societat tindrà com a interés primordial la creació, organització, gestió i manteniment d’una Escola.</span>

  <span class="sjma-change-marker">2. L’Escola estarà oberta a les Persones Associades, a les persones que componen les Joventuts i a persones no associades, en els termes que reglamentàriament es disposen. Les Persones Associades i les Joventuts podran gaudir de les condicions, beneficis o bonificacions que aprove l’òrgan competent de la Societat.</span>

  <span class="sjma-change-marker">3. Sense perjuí del que disposen aquestos Estatuts, l’Escola de la Societat podrà establir convenis o instruments de col·laboració puntual o permanent amb altres entitats culturals o educatives. En el cas de col·laboració permanent, la planificació educativa i el règim orgànic i funcional de l’Escola de la Societat s’adaptaran al que es convinga en cada cas al corresponent conveni o instrument de col·laboració, sempre que no contradiga aquests Estatuts, la normativa educativa aplicable ni les competències dels òrgans de la Societat.</span>

  #{ARTICLE62_EDUCATIONAL_DISCIPLINES_TEXT}
HTML
ARTICLE62_OLD_SCHOOL_DIRECTOR_STAFF_TEXT = '<span class="sjma-change-marker">3. Podrà assumir la Direcció de l’Escola qualsevol de les persones contractades per la Societat que exercisquen la funció docent a l’Escola.</span>'
ARTICLE62_NEW_SCHOOL_DIRECTOR_STAFF_TEXT = '<span class="sjma-change-marker">3. Podrà assumir la Direcció de l’Escola qualsevol persona contractada per la Societat que forme part del claustre de l’Escola i complisca els requisits exigits per la normativa vigent aplicable.</span>'
ARTICLE62_OLD_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola qualsevol persona d’entre les contractades per la Societat que exercisquen la funció docent a l’Escola, qualsevol dels components de la Junta Directiva i qualsevol altra persona que, per raó del seu mèrit i capacitat, es considere convenient per a l’Escola que hi forme part.</span>'
ARTICLE62_INTERMEDIATE_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola qualsevol persona d’entre les contractades per la Societat que exercisquen la funció docent o de gestió a l’Escola, qualsevol dels components de la Junta Directiva i qualsevol altra persona que, per raó del seu mèrit i capacitat, es considere convenient per a l’Escola que hi forme part.</span>'
ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT = '<span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola les persones contractades per la Societat que exercisquen funcions docents, de gestió administrativa o de gestió acadèmica a l’Escola, d’acord amb la planificació i organització educativa vigent.</span>'
ARTICLE62_COLLABORATORS_TEXT = '<span class="sjma-change-marker">5. Sense formar part de l’Equip Directiu de l’Escola, la Junta Directiva, la Direcció de l’Escola o l’Equip Directiu podran encomanar tasques concretes de col·laboració, suport o coordinació a persones membres de la Junta Directiva, Persones Associades, famílies de l’alumnat o altres persones vinculades a la Societat, quan resulte convenient per al funcionament de l’Escola.</span>'
ARTICLE63_TITLE = "Article 63. De la planificació educativa de l’Escola"
ARTICLE63_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La planificació educativa de l’Escola s’articularà d’acord amb la normativa vigent aplicable mitjançant els instruments pedagògics, organitzatius i acadèmics que aquesta exigisca o permeta en cada moment, inclosos, si escau, el Projecte Educatiu de Centre, els programes d’aprenentatge, les programacions didàctiques, la Programació General Anual o els documents equivalents que els substituïsquen o desenvolupen.</span>

  <span class="sjma-change-marker">2. Aquests instruments seran elaborats, revisats o proposats per l’Equip Directiu de l’Escola, amb la participació del claustre en els termes que corresponguen, i aprovats per la Junta Directiva mitjançant Resolució quan afecten l’organització general de l’Escola, l’oferta formativa, la gestió econòmica o els compromisos institucionals de la Societat.</span>

  <span class="sjma-change-marker">3. La Junta Directiva respectarà l’autonomia pedagògica i organitzativa de l’Escola i la competència tècnica del seu Equip Directiu i del claustre, sense perjudici de la responsabilitat de la Societat com a titular de l’Escola.</span>
HTML

ARTICLE69_TITLE = "Article 69. De la gestió dels sistemes d’informació"
ARTICLE69_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva vetlarà per assegurar la continuïtat, la seguretat i el traspàs ordenat dels sistemes d’informació de la Societat a les persones que ocupen els càrrecs de la Junta Directiva en el futur.</span>

  <span class="sjma-change-marker">2. La Junta Directiva haurà de mantindre registrats, com a mínim, els següents elements:</span>

  <span class="sjma-change-marker">a) Equips físics de processament de la informació que siguen operatius en les dependències de la Societat.</span>

  <span class="sjma-change-marker">b) Programaris i aplicacions web que siguen emprades per a la gestió i administració de la Societat.</span>

  <span class="sjma-change-marker">c) Comptes en xarxes socials, dominis web, correus corporatius, allotjaments web, repositoris, serveis d’emmagatzematge, subscripcions, plataformes i còpies digitals essencials emprades en l’activitat de la Societat.</span>

  <span class="sjma-change-marker">3. Les credencials d’accés als elements registrats hauran d’estar emmagatzemades en un sistema segur de gestió de credencials que n’assegure la seguretat, el control d’accés i la transferibilitat entre les persones autoritzades.</span>

  <span class="sjma-change-marker">4. La Junta Directiva haurà de mantindre mesures bàsiques de còpia de seguretat, recuperació, revisió d’accessos i traspàs ordenat dels sistemes d’informació quan es produïsca el relleu de càrrecs o persones responsables.</span>
HTML

ARTISTIC_ARTICLE_REPLACEMENTS = {
  "Article 45." => [ARTICLE45_TITLE, ARTICLE45_BODY],
  "Article 46." => [ARTICLE46_TITLE, ARTICLE46_BODY],
  "Article 47." => [ARTICLE47_TITLE, ARTICLE47_BODY],
  "Article 48." => [ARTICLE48_TITLE, ARTICLE48_BODY],
  "Article 49." => [ARTICLE49_TITLE, ARTICLE49_BODY],
  "Article 50." => [ARTICLE50_TITLE, ARTICLE50_BODY],
  "Article 51." => [ARTICLE51_TITLE, ARTICLE51_BODY],
  "Article 52." => [ARTICLE52_TITLE, ARTICLE52_BODY],
  "Article 53." => [ARTICLE53_TITLE, ARTICLE53_BODY],
  "Article 54." => [ARTICLE54_TITLE, ARTICLE54_BODY],
  "Article 55." => [ARTICLE55_TITLE, ARTICLE55_BODY],
  "Article 56." => [ARTICLE56_TITLE, ARTICLE56_BODY],
  "Article 57." => [ARTICLE57_TITLE, ARTICLE57_BODY],
  "Article 58." => [ARTICLE58_TITLE, ARTICLE58_BODY],
  "Article 59." => [ARTICLE59_TITLE, ARTICLE59_BODY],
  "Article 60." => [ARTICLE60_TITLE, ARTICLE60_BODY],
  "Article 63." => [ARTICLE63_TITLE, ARTICLE63_BODY],
  "Article 65." => [ARTICLE65_TITLE, ARTICLE65_BODY],
  "Article 69." => [ARTICLE69_TITLE, ARTICLE69_BODY]
}.freeze

ARTICLE62_TITLE = "Article 63. De l’Equip Directiu de l’Escola"
ARTICLE62_BODY = <<~HTML.strip
  <span class="sjma-change-marker">1. La Junta Directiva nomenarà mitjançant Resolució una persona que assumisca la Direcció de l’Escola de la manera que reglamentàriament es determine o, supletòriament, per designació de la Junta Directiva.</span>

  <span class="sjma-change-marker">2. La Junta Directiva nomenarà, d’entre les persones que propose la Direcció de l’Escola, els restants càrrecs que, d’acord amb la planificació i organització educativa vigent en eixe moment a l’Escola, conformen l’Equip Directiu de l’Escola. Ho farà de la manera que reglamentàriament es determine o, supletòriament, per designació de la Junta Directiva.</span>

  <span class="sjma-change-marker">3. Podrà assumir la Direcció de l’Escola qualsevol persona contractada per la Societat que forme part del claustre de l’Escola i complisca els requisits exigits per la normativa vigent aplicable.</span>

  <span class="sjma-change-marker">4. Podran assumir els restants càrrecs de l’Equip Directiu de l’Escola les persones contractades per la Societat que exercisquen funcions docents, de gestió administrativa o de gestió acadèmica a l’Escola, d’acord amb la planificació i organització educativa vigent.</span>

  <span class="sjma-change-marker">5. Sense formar part de l’Equip Directiu de l’Escola, la Junta Directiva, la Direcció de l’Escola o l’Equip Directiu podran encomanar tasques concretes de col·laboració, suport o coordinació a persones membres de la Junta Directiva, Persones Associades, famílies de l’alumnat o altres persones vinculades a la Societat, quan resulte convenient per al funcionament de l’Escola.</span>
HTML

SCHOOL_INTERNAL_RULES_ARTICLE_TITLE = "Article 65. Del règim orgànic, funcional i disciplinari de l’Escola"
SCHOOL_INTERNAL_RULES_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">L’Escola es regirà per unes normes d’organització, funcionament i disciplina de l’alumnat que, proposades per la Direcció de l’Escola, seran aprovades per la Junta Directiva mitjançant Resolució.</span>
HTML

ACCOUNTING_DOCUMENTS_ARTICLE_TITLE = "Article 69. De les obligacions comptables i documentals"
ACCOUNTING_DOCUMENTS_ARTICLE_BODY = <<~HTML.strip
  <span class="sjma-change-marker">La Societat haurà de disposar necessàriament dels següents documents:</span>

  <span class="sjma-change-marker">a) Relació actualitzada de les Persones Associades i de les Joventuts al Llibre Registre.</span>

  <span class="sjma-change-marker">b) Comptabilitat, d’acord amb els principis comptables i normativa vigent aplicables, que permetrà obtindre la imatge fidel del seu patrimoni, del resultat i de la seua situació financera, així com el seguiment cronològic de les operacions realitzades.</span>

  <span class="sjma-change-marker">c) Inventari dels seus béns.</span>

  <span class="sjma-change-marker">d) Llibre d’Actes de les sessions o reunions dels seus òrgans de govern i representació.</span>

  <span class="sjma-change-marker">e) Pressupostos i liquidacions anuals.</span>
HTML

ARTICLE_REPLACEMENTS_BY_ID = {
  533 => ["Article 42. De la interinitat de la Junta Directiva", ARTICLE42_BODY],
  534 => ["Article 43. De la responsabilitat de la Junta Directiva de la seua gestió davant de l’Assemblea General", ARTICLE43_BODY],
  536 => ["Article 44. De les Resolucions", ARTICLE44_BODY],
  537 => ["Article 45. De l’aprovació de les Resolucions", ARTICLE45_RESOLUTIONS_APPROVAL_BODY],
  540 => ["Article 46. De les Agrupacions Artístiques Titulars", ARTICLE45_BODY],
  541 => ["Article 47. De la doble vessant artística i educativa", ARTICLE46_BODY],
  542 => ["Article 48. De l’exercici artístic", ARTICLE47_BODY],
  543 => ["Article 49. De la direcció artística i tècnica", ARTICLE48_BODY],
  545 => ["Article 50. De les persones integrants actives", ARTICLE49_BODY],
  546 => ["Article 51. De les Persones Delegades", ARTICLE50_BODY],
  548 => ["Article 52. Definició i finalitats", ARTICLE51_BODY],
  549 => ["Article 53. De la conservació i gestió de l’Arxiu", ARTICLE52_BODY],
  553 => ["Article 54. De l’elecció de les Persones Delegades", ARTICLE53_BODY],
  554 => ["Article 55. De les Assemblees d’Agrupació", ARTICLE54_BODY],
  555 => ["Article 56. Del funcionament de les Assemblees d’Agrupació", ARTICLE55_BODY],
  556 => ["Article 57. Dels acords i posicionaments de les Assemblees d’Agrupació", ARTICLE56_BODY],
  557 => ["Article 58. Del dipòsit de béns mobles relacionats amb l’activitat artística propietat de la Societat", ARTICLE57_BODY],
  559 => ["Article 59. Dels Reglaments de Règim Intern de les Agrupacions", ARTICLE58_BODY],
  560 => ["Article 60. De la Comissió Mixta d’Agrupacions", ARTICLE59_BODY],
  562 => ["Article 61. Del seguiment de les Agrupacions Artístiques", ARTICLE60_BODY],
  567 => [ARTICLE62_TITLE, ARTICLE62_BODY],
  568 => ["Article 64. De la planificació educativa de l’Escola", ARTICLE63_BODY],
  570 => [SCHOOL_INTERNAL_RULES_ARTICLE_TITLE, SCHOOL_INTERNAL_RULES_ARTICLE_BODY],
  571 => ["Article 66. De les agrupacions i conjunts de l’Escola", ARTICLE65_BODY],
  577 => [ACCOUNTING_DOCUMENTS_ARTICLE_TITLE, ACCOUNTING_DOCUMENTS_ARTICLE_BODY],
  578 => ["Article 70. De la gestió dels sistemes d’informació", ARTICLE69_BODY]
}.freeze

TRANSITIONAL_TITLE = "DISPOSICIÓ TRANSITÒRIA ÚNICA"
TRANSITIONAL_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Les Agrupacions Artístiques Titulars existents en el moment d’entrada en vigor d’aquestos Estatuts comptaran inicialment amb el següent nombre de Persones Delegades:</span>

  <span class="sjma-change-marker">a) Banda Simfònica: 3 Persones Delegades.</span>

  <span class="sjma-change-marker">b) Colla de Dolçaina i Percussió: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">c) Orquestra: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">d) Cor d’Adults: 1 Persona Delegada.</span>

  <span class="sjma-change-marker">Aquest nombre podrà ser modificat posteriorment per Resolució de la Junta Directiva en els termes previstos en aquestos Estatuts.</span>
HTML

FINAL_DISPOSITION_TITLE = "DISPOSICIÓ FINAL"
FINAL_DISPOSITION_BODY = <<~HTML.strip
  <span class="sjma-change-marker">Aquests Estatuts entraran en vigor des de la data de la seua aprovació per l’Assemblea General i tindran efectes davant de terceres persones des de la seua inscripció en el Registre d’Associacions de la Comunitat Valenciana quan aquesta siga preceptiva.</span>
HTML

def ensure_vicetresoreria_article!(component)
  scope = Decidim::Proposals::Proposal.where(component:)
  existing = scope.find { |proposal| proposal.title.fetch(LOCALE, "").include?("Vicetresoreria") }

  if existing
    existing.update!(
      title: existing.title.merge(LOCALE => VICETRESORERIA_TITLE),
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

def ensure_commercial_relationships_article!(component)
  scope = Decidim::Proposals::Proposal.where(component:)
  existing = scope.find { |proposal| proposal.title.fetch(LOCALE, "").include?("registre de relacions comercials habituals") }

  if existing
    existing.update!(
      title: existing.title.merge(LOCALE => COMMERCIAL_RELATIONSHIPS_TITLE),
      body: existing.body.merge(LOCALE => COMMERCIAL_RELATIONSHIPS_BODY),
      participatory_text_level: "article"
    )
    return
  end

  article69 = scope.find { |proposal| proposal.title.fetch(LOCALE, "").start_with?("Article 69.") }
  raise "Article 69 not found; cannot insert #{COMMERCIAL_RELATIONSHIPS_TITLE}" unless article69

  insert_position = article69.position + 1

  Decidim::Proposals::Proposal.transaction do
    proposal = Decidim::Proposals::Proposal.new(
      component:,
      title: { LOCALE => COMMERCIAL_RELATIONSHIPS_TITLE },
      body: { LOCALE => COMMERCIAL_RELATIONSHIPS_BODY },
      participatory_text_level: "article",
      position: insert_position,
      published_at: article69.published_at,
      created_in_meeting: false
    )
    proposal.coauthorships.build(
      decidim_author_id: component.organization.id,
      decidim_author_type: "Decidim::Organization"
    )
    proposal.save!
  end
end

def renumber_article_title(title, target_number)
  title.sub(/\AArticle\s+\d+\./, "Article #{target_number}.")
end

component = Decidim::Component.find(COMPONENT_ID)
ensure_vicetresoreria_article!(component)
ensure_commercial_relationships_article!(component)
scope = Decidim::Proposals::Proposal.where(component:)

updated = []

scope.find_each do |proposal|
  if ARTISTIC_ORGANIZATION_REMOVED_IDS.include?(proposal.id)
    updated << "#{proposal.id}: #{proposal.title.fetch(LOCALE, "")} -> removed"
    proposal.destroy!
    next
  end

  title = proposal.title || {}
  body = proposal.body || {}
  ca_title = title.fetch(LOCALE, "")
  ca_body = body.fetch(LOCALE, "")

  next_title = ca_title.gsub("Escola de Música", "Escola")
  next_body = ca_body.gsub("Escola de Música", "Escola")
  next_title = next_title.gsub("Joventuts de la Societat", "Joventuts")
  next_body = next_body.gsub("Joventuts de la Societat", "Joventuts")
  next_level = proposal.participatory_text_level
  next_position = proposal.position

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

  next_body = next_body.gsub("obtindré", "obtindre")

  if ca_title.start_with?(ARTICLE4_TITLE_PREFIX)
    next_body = ARTICLE4_BODY
  end

  if ca_title.start_with?(ARTICLE8_TITLE_PREFIX)
    next_body = ARTICLE8_BODY
  end

  if ca_title.start_with?(ARTICLE3_TITLE_PREFIX) && !next_body.include?("patrimoni documental, musical, artístic, educatiu, social i institucional")
    next_body = [
      next_body.strip,
      '<span class="sjma-change-marker">d) La conservació, catalogació, estudi, digitalització i difusió del patrimoni documental, musical, artístic, educatiu, social i institucional de la Societat, com a testimoni de la seua trajectòria històrica i com a mitjà de transmissió cultural a la comunitat.</span>'
    ].join("\n\n")
  end

  if ca_title.start_with?(ARTICLE9_TITLE_PREFIX)
    next_body = next_body.gsub("atorgada per l’Assemblea General", "atorgada per acord de l’Assemblea General")
  end

  if ca_title.start_with?(ARTICLE10_TITLE_PREFIX)
    next_body = ARTICLE10_BODY
  end

  if ca_title.start_with?(ARTICLE11_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE11_OLD_UNPAID_DROP_TEXT, ARTICLE11_NEW_UNPAID_DROP_TEXT)
  end

  if ca_title.start_with?(ARTICLE13_TITLE_PREFIX) && !next_body.include?("Les persones que componen les Joventuts gaudiran")
    next_body = [next_body, ARTICLE13_YOUTH_RIGHTS_TEXT].join("\n\n")
  end

  if ca_title.start_with?(ARTICLE13_TITLE_PREFIX)
    next_body = next_body.sub(/\ATotes les Persones Associades/, "1. Totes les Persones Associades")
    next_body = next_body.gsub("Assembles Generals", "Assemblees Generals")
    unless next_body.include?("A obtindre còpia dels Estatuts")
      next_body = next_body.gsub(
        "h) Tots aquells que se’n deriven de les disposicions d’aquestos Estatuts.",
        '<span class="sjma-change-marker">h) A obtindre còpia dels Estatuts i de les normes internes vigents, i a consultar els llibres i registres de la Societat en els termes previstos en aquests Estatuts i en la normativa aplicable.</span>' + "\n\n" \
          "i) Tots aquells que se’n deriven de les disposicions d’aquestos Estatuts."
      )
    end
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
    next_body = next_body.gsub("k) Totes aquelles que els presents Estatuts disposen.", "k) Totes aquelles que els presents Estatuts disposen.\n\n#{ARTICLE17_ASSEMBLY_RATIFICATION_TEXT}") unless next_body.include?("Ratificar les altes de Persones Associades")
  end

  if ca_title.start_with?(ARTICLE18_TITLE_PREFIX)
    next_body = ARTICLE18_BODY
  end

  if ca_title.start_with?(ARTICLE19_TITLE_PREFIX)
    next_body = ARTICLE19_NEW_BODY
  end

  if ca_title.start_with?(ARTICLE20_TITLE_PREFIX)
    next_body = ARTICLE20_BODY
  end

  if ca_title.start_with?(ARTICLE22_TITLE_PREFIX)
    next_body = ARTICLE22_BODY
  end

  if ca_title.start_with?(ARTICLE23_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE23_OLD_VOTE_TEXT, ARTICLE23_NEW_VOTE_TEXT)
    next_body = next_body.gsub(ARTICLE23_OLD_INVALID_ACTS_TEXT, ARTICLE23_NEW_INVALID_ACTS_TEXT)
  end

  if ca_title.start_with?(ARTICLE24_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE24_OLD_SIMPLE_MAJORITY_TEXT, ARTICLE24_NEW_SIMPLE_MAJORITY_TEXT)
    next_body = next_body.gsub(ARTICLE24_OLD_QUALIFIED_MAJORITY_TEXT, ARTICLE24_NEW_QUALIFIED_MAJORITY_TEXT)
    next_body = next_body.gsub("la mitat dels vots emesos", "la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot")
    next_body = next_body.gsub("la meitat de les Persones Associades presents i representades vàlidament amb dret de vot", "la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot")
    next_body = next_body.gsub(ARTICLE24_OLD_SPECIFIC_CALL_TEXT, ARTICLE24_NEW_SPECIFIC_CALL_TEXT)
  end

  if ca_title.start_with?(ARTICLE28_TITLE_PREFIX)
    next_body = ARTICLE28_BODY
  end

  if ca_title.start_with?(ARTICLE29_TITLE_PREFIX)
    next_title = ARTICLE29_TITLE
    next_body = ARTICLE29_BODY
  end

  if ca_title.start_with?(ARTICLE30_TITLE_PREFIX)
    next_body = ARTICLE30_BODY
  end

  if ca_title.start_with?(ARTICLE31_TITLE_PREFIX)
    next_body = ARTICLE31_BODY
  end

  if ca_title.start_with?(ARTICLE32_TITLE_PREFIX)
    next_body = ARTICLE32_FULL_BODY
  end

  if ca_title.start_with?(ARTICLE33_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE33_OLD_SCHOOL_STAFF_TEXT, ARTICLE33_NEW_SCHOOL_STAFF_TEXT)
    next_body = next_body.gsub(ARTICLE33_OLD_RESIDUAL_TEXT, ARTICLE33_NEW_RESIDUAL_TEXT)
  end

  if ca_title.start_with?(ARTICLE35_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE35_OLD_FORMAL_NOTICES_TEXT, ARTICLE35_NEW_FORMAL_NOTICES_TEXT)
    next_body = next_body.gsub(ARTICLE35_OLD_CERTIFICATES_TEXT, ARTICLE35_NEW_CERTIFICATES_TEXT)
  end

  if ca_title.start_with?(ARTICLE36_TITLE_PREFIX)
    next_body = next_body.gsub(ARTICLE36_OLD_NO_VICESECRETARY_TEXT, ARTICLE36_NEW_NO_VICESECRETARY_TEXT)
  end

  if ARTICLE_REPLACEMENTS_BY_ID.key?(proposal.id)
    next_title, next_body = ARTICLE_REPLACEMENTS_BY_ID.fetch(proposal.id)
  end

  if ca_title == "DISPOSICIÓ TRANSITÒRIA" || ca_title == "DISPOSICIONS TRANSITÒRIES" || ca_title == TRANSITIONAL_TITLE
    next_title = TRANSITIONAL_TITLE
    next_body = TRANSITIONAL_BODY
  end

  if proposal.id == FINAL_DISPOSITION_PROPOSAL_ID
    next_title = FINAL_DISPOSITION_TITLE
    next_body = FINAL_DISPOSITION_BODY
  end

  if proposal.id == BON_GOVERN_ARTICLE_PROPOSAL_ID
    next_title = BON_GOVERN_ARTICLE_TITLE
    next_body = BON_GOVERN_ARTICLE_BODY
  end

  if proposal.id == REVISION_ARTICLE_PROPOSAL_ID
    next_title = ARTICLE75_TITLE
    next_body = ARTICLE75_BODY
  end

  if proposal.id == JURISDICTIONAL_CHALLENGE_ARTICLE_PROPOSAL_ID
    next_title = JURISDICTIONAL_CHALLENGE_ARTICLE_TITLE
    next_body = JURISDICTIONAL_CHALLENGE_ARTICLE_BODY
  end

  if proposal.id == INTERPRETATION_ARTICLE_PROPOSAL_ID
    next_title = INTERPRETATION_ARTICLE_TITLE
    next_body = INTERPRETATION_ARTICLE_BODY
  end

  if proposal.id == 573
    next_body = SUPPLEMENTARY_LAW_ARTICLE_BODY
  end

  if proposal.id == REVIEW_AND_JURISDICTION_SECTION_PROPOSAL_ID
    next_title = REVIEW_AND_JURISDICTION_SECTION_TITLE
    next_body = REVIEW_AND_JURISDICTION_SECTION_TITLE
    next_level = "sub-section"
  end

  if proposal.id == INTERNAL_PUBLICITY_ARTICLE_PROPOSAL_ID
    next_title = INTERNAL_PUBLICITY_ARTICLE_TITLE
    next_body = INTERNAL_PUBLICITY_ARTICLE_BODY
  end

  if proposal.id == TRANSPARENCY_ARTICLE_PROPOSAL_ID
    next_title = TRANSPARENCY_ARTICLE_TITLE
    next_body = TRANSPARENCY_ARTICLE_BODY
  end

  if proposal.id == DATA_PROTECTION_ARTICLE_PROPOSAL_ID
    next_title = DATA_PROTECTION_ARTICLE_TITLE
    next_body = DATA_PROTECTION_ARTICLE_BODY
  end

  if proposal.id == SOCIAL_INFORMATION_ACCESS_ARTICLE_PROPOSAL_ID
    next_title = SOCIAL_INFORMATION_ACCESS_ARTICLE_TITLE
    next_body = SOCIAL_INFORMATION_ACCESS_ARTICLE_BODY
  end

  if proposal.id == DISCIPLINARY_RESPONSIBILITY_ARTICLE_PROPOSAL_ID
    next_title = DISCIPLINARY_RESPONSIBILITY_ARTICLE_TITLE
    next_body = DISCIPLINARY_RESPONSIBILITY_ARTICLE_BODY
  end

  if proposal.id == DISCIPLINARY_GENERAL_ARTICLE_PROPOSAL_ID
    next_title = DISCIPLINARY_GENERAL_ARTICLE_TITLE
    next_body = DISCIPLINARY_GENERAL_ARTICLE_BODY
  end

  if proposal.id == DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_PROPOSAL_ID
    next_title = DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_TITLE
    next_body = DISCIPLINARY_FAULTS_CLASSIFICATION_ARTICLE_BODY
  end

  if proposal.id == VERY_SERIOUS_FAULTS_ARTICLE_PROPOSAL_ID
    next_title = VERY_SERIOUS_FAULTS_ARTICLE_TITLE
    next_body = VERY_SERIOUS_FAULTS_ARTICLE_BODY
  end

  if proposal.id == SERIOUS_FAULTS_ARTICLE_PROPOSAL_ID
    next_title = SERIOUS_FAULTS_ARTICLE_TITLE
    next_body = SERIOUS_FAULTS_ARTICLE_BODY
  end

  if proposal.id == MINOR_OFFENSES_ARTICLE_PROPOSAL_ID
    next_title = MINOR_OFFENSES_ARTICLE_TITLE
    next_body = MINOR_OFFENSES_ARTICLE_BODY
  end

  if proposal.id == VERY_SERIOUS_SANCTIONS_ARTICLE_PROPOSAL_ID
    next_title = VERY_SERIOUS_SANCTIONS_ARTICLE_TITLE
    next_body = VERY_SERIOUS_SANCTIONS_ARTICLE_BODY
  end

  if proposal.id == SERIOUS_SANCTIONS_ARTICLE_PROPOSAL_ID
    next_title = SERIOUS_SANCTIONS_ARTICLE_TITLE
    next_body = SERIOUS_SANCTIONS_ARTICLE_BODY
  end

  if proposal.id == MINOR_SANCTIONS_ARTICLE_PROPOSAL_ID
    next_title = MINOR_SANCTIONS_ARTICLE_TITLE
    next_body = MINOR_SANCTIONS_ARTICLE_BODY
  end

  if proposal.id == SANCTION_GRADUATION_ARTICLE_PROPOSAL_ID
    next_title = SANCTION_GRADUATION_ARTICLE_TITLE
    next_body = SANCTION_GRADUATION_ARTICLE_BODY
  end

  if proposal.id == PRESCRIPTION_ARTICLE_PROPOSAL_ID
    next_title = PRESCRIPTION_ARTICLE_TITLE
    next_body = PRESCRIPTION_ARTICLE_BODY
  end

  if proposal.id == BOARD_DISCIPLINE_ARTICLE_PROPOSAL_ID
    next_title = BOARD_DISCIPLINE_ARTICLE_TITLE
    next_body = BOARD_DISCIPLINE_ARTICLE_BODY
  end

  if proposal.id == DISCIPLINARY_PROCEDURE_ARTICLE_PROPOSAL_ID
    next_title = DISCIPLINARY_PROCEDURE_ARTICLE_TITLE
    next_body = DISCIPLINARY_PROCEDURE_ARTICLE_BODY
  end

  if proposal.id == INITIAL_ASSETS_ARTICLE_PROPOSAL_ID
    next_title = INITIAL_ASSETS_ARTICLE_TITLE
    next_body = INITIAL_ASSETS_ARTICLE_BODY
  end

  if proposal.id == ASSETS_DESTINATION_ARTICLE_PROPOSAL_ID
    next_title = ASSETS_DESTINATION_ARTICLE_TITLE
    next_body = ASSETS_DESTINATION_ARTICLE_BODY
  end

  if proposal.id == ECONOMIC_RESOURCES_ARTICLE_PROPOSAL_ID
    next_title = ECONOMIC_RESOURCES_ARTICLE_TITLE
    next_body = ECONOMIC_RESOURCES_ARTICLE_BODY
  end

  if proposal.id == ACTIVITY_BENEFIT_ARTICLE_PROPOSAL_ID
    next_title = ACTIVITY_BENEFIT_ARTICLE_TITLE
    next_body = ACTIVITY_BENEFIT_ARTICLE_BODY
  end

  if proposal.id == BUDGETS_AND_FISCAL_YEAR_ARTICLE_PROPOSAL_ID
    next_title = BUDGETS_AND_FISCAL_YEAR_ARTICLE_TITLE
    next_body = BUDGETS_AND_FISCAL_YEAR_ARTICLE_BODY
  end

  if proposal.id == ORDINARY_BUDGETS_ARTICLE_PROPOSAL_ID
    next_title = ORDINARY_BUDGETS_ARTICLE_TITLE
    next_body = ORDINARY_BUDGETS_ARTICLE_BODY
  end

  if proposal.id == EXTRAORDINARY_BUDGETS_ARTICLE_PROPOSAL_ID
    next_title = EXTRAORDINARY_BUDGETS_ARTICLE_TITLE
    next_body = EXTRAORDINARY_BUDGETS_ARTICLE_BODY
  end

  if proposal.id == FINANCIAL_CONTROL_ARTICLE_PROPOSAL_ID
    next_title = FINANCIAL_CONTROL_ARTICLE_TITLE
    next_body = FINANCIAL_CONTROL_ARTICLE_BODY
  end

  if proposal.id == STATUTES_AMENDMENT_PROCEDURE_ARTICLE_PROPOSAL_ID
    next_title = STATUTES_AMENDMENT_PROCEDURE_ARTICLE_TITLE
    next_body = STATUTES_AMENDMENT_PROCEDURE_ARTICLE_BODY
  end

  if proposal.id == STATUTES_AMENDMENTS_ARTICLE_PROPOSAL_ID
    next_title = STATUTES_AMENDMENTS_ARTICLE_TITLE
    next_body = STATUTES_AMENDMENTS_ARTICLE_BODY
  end

  if proposal.id == STATUTES_APPROVAL_ARTICLE_PROPOSAL_ID
    next_title = STATUTES_APPROVAL_ARTICLE_TITLE
    next_body = STATUTES_APPROVAL_ARTICLE_BODY
  end

  if proposal.id == DISSOLUTION_CAUSES_ARTICLE_PROPOSAL_ID
    next_title = DISSOLUTION_CAUSES_ARTICLE_TITLE
    next_body = DISSOLUTION_CAUSES_ARTICLE_BODY
  end

  if proposal.id == LIQUIDATION_ARTICLE_PROPOSAL_ID
    next_title = LIQUIDATION_ARTICLE_TITLE
    next_body = LIQUIDATION_ARTICLE_BODY
  end

  if proposal.id == 565
    next_body = ARTICLE62_GENERAL_BODY
  end

  if proposal.id == 567
    next_body = next_body.gsub(ARTICLE62_OLD_SCHOOL_DIRECTOR_STAFF_TEXT, ARTICLE62_NEW_SCHOOL_DIRECTOR_STAFF_TEXT)
    next_body = next_body.gsub(ARTICLE62_OLD_MANAGEMENT_STAFF_TEXT, ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT)
    next_body = next_body.gsub(ARTICLE62_INTERMEDIATE_MANAGEMENT_STAFF_TEXT, ARTICLE62_NEW_MANAGEMENT_STAFF_TEXT)
    next_body = [next_body, ARTICLE62_COLLABORATORS_TEXT].join("\n\n") unless next_body.include?("Sense formar part de l’Equip Directiu de l’Escola")
  end

  if ARTICLE_RENUMBER_BY_ID.key?(proposal.id)
    next_title = renumber_article_title(next_title, ARTICLE_RENUMBER_BY_ID.fetch(proposal.id))
  end

  if ARTICLE_TITLES_BY_ID.key?(proposal.id)
    next_title = ARTICLE_TITLES_BY_ID.fetch(proposal.id)
  end

  final_text_replacements = {
    "demés" => "altres",
    "bens immobles" => "béns immobles",
    "dels seus bens" => "dels seus béns",
    "l'Escola" => "l’Escola",
    "d'exposicions" => "d’exposicions",
    "a altre lloc" => "a un altre lloc",
    "podrà citar-se de segona Convocatòria" => "podrà citar-se una segona convocatòria",
    "Requeriran de majoria qualificada" => "Requeriran majoria qualificada",
    "2. Requeriran majoria qualificada, que resultarà quan els vots afirmatius superen la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot, els següents assumptes:" =>
      "2. Requeriran majoria qualificada els següents assumptes. Hi haurà majoria qualificada quan els vots afirmatius superen la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot:",
    "Estarà composada per totes les persones" => "Estarà composta per totes les persones",
    "substituirà a la Presidència" => "substituirà la Presidència",
    "substituirà a la Secretaria" => "substituirà la Secretaria",
    "substituirà a la Tresoreria" => "substituirà la Tresoreria",
    "estarà al front de la gestió" => "estarà al capdavant de la gestió",
    "nomenarà mitjançant Resolució a una persona" => "nomenarà mitjançant Resolució una persona",
    "nomenarà, d’entre les persones que propose la Direcció de l’Escola, als restants càrrecs" =>
      "nomenarà, d’entre les persones que propose la Direcció de l’Escola, els restants càrrecs",
    "altres legislació aplicable" => "altra legislació aplicable",
    "sense perjuí de que" => "sense perjuí que",
    "Son causa de baixa" => "Són causes de baixa",
    "l’acord en que" => "l’acord en què",
    "actes del òrgans" => "actes dels òrgans",
    "que hagen de satisfer els socis a proposta de la Junta Directiva" => "que les Persones Associades hagen de satisfer a proposta de la Junta Directiva",
    "s’expressarà de manera concreta les causes" => "s’expressaran de manera concreta les causes",
    "excepte quan tinguen per objecte la modificació dels Estatuts, que es tramitaran pels terminis específics previstos" =>
      "excepte quan tinguen per objecte la modificació dels Estatuts, cas en què s’aplicaran els terminis específics previstos",
    "lloc, dia i hora on es vagen a celebrar" => "el lloc, el dia i l’hora en què se celebraran",
    "la data en que es publicara" => "la data en què es publicara",
    "els Acords que en aquella s’hi adopten" => "els Acords que s’hi adoptaren",
    "les sessions en les que s’hi adopten" => "les sessions en què s’hi adopten",
    "superen als negatius" => "superen els negatius",
    "casos en que" => "casos en què",
    "als esmentats al capítol 4 del títol V" => "als acords de dissolució previstos en l’article 104",
    "acords de dissolució previstos en l’article 103" => "acords de dissolució previstos en l’article 104",
    "baix sanció" => "sota sanció",
    "com a Moderador" => "com a persona moderadora",
    "funció de Moderador" => "funció de persona moderadora",
    "sempre i quan" => "sempre que",
    "en la que" => "en què",
    "Programaris i aplicacions web que siguen emprades" => "Programari i aplicacions web que siguen emprats",
    "una persona que compose la Junta Directiva" => "una persona que forme part de la Junta Directiva",
    "persones que componen la Junta Directiva" => "persones que formen part de la Junta Directiva",
    "Les persones que componen els òrgans de govern i de representació" => "Les persones que formen part dels òrgans de govern i de representació",
    "sense que càpiga en cap cas el seu repartiment" => "sense que en cap cas puga produir-se el seu repartiment",
    "En tot cas, correspon a la Junta Directiva les següents funcions:" => "En tot cas, corresponen a la Junta Directiva les funcions següents:",
    "de òrgans" => "d’òrgans",
    "apertura" => "obertura",
    "pertinència" => "pertinença",
    "per a que" => "perquè",
    "al menys" => "almenys",
    "aquells que aquesta estime convenient</span>" => "aquells que aquesta estime convenient adoptar</span>",
    "sous bancaris" => "saldos bancaris",
    "front a" => "davant de",
    "reflexarà" => "reflectirà",
    "assumix" => "assumeix",
    "Aquesta Societat estarà regida per l’Assemblea General i la Junta Directiva." =>
      '<span class="sjma-change-marker">La Societat s’organitza mitjançant l’Assemblea General i la Junta Directiva, d’acord amb les competències i funcions que estableixen aquests Estatuts.</span>',
    "Adoptar els acords referents a la constitució de federacions o d’integració o separació d’aquestes, a la sol·licitud de declaració d’utilitat pública i de remuneració, en el seu cas, dels membres de l’òrgan de representació." =>
      "Adoptar els acords referents a la constitució de federacions, a la integració o separació d’aquestes, a la sol·licitud de declaració d’utilitat pública i, si escau, a l’aprovació de contraprestacions per serveis professionals o treballs prestats a la Societat per persones que formen part de la Junta Directiva, sempre que siguen diferents de les funcions pròpies del càrrec i es respecte el règim de conflicte d’interés.",
    "Remuneració de les persones que composen la Junta Directiva." =>
      "Aprovació, si escau, de contraprestacions per serveis professionals o treballs prestats a la Societat per persones que formen part de la Junta Directiva, sempre que siguen diferents de les funcions pròpies del càrrec.",
    "En el supòsit de no haver designat cap Vicepresidència, assumirà les funcions descrites la persona que assumisca la Secretaria o altra persona designada per la Presidència de la Junta Directiva." =>
      "En el supòsit de no haver designat cap Vicepresidència, substituirà la Presidència la Secretaria; si això no fora possible, la Vocalia de major edat o altra persona designada per la Junta Directiva.",
    "En el supòsit de no haver designat cap Vicesecretaria, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Junta Directiva." =>
      "En el supòsit de no haver designat cap Vicesecretaria, assumirà les funcions descrites la persona que corresponga d’acord amb el règim previst en l’article 41.",
    "Sense perjudici del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, la Presidència, la Secretaria i/o la Tresoreria respectivament." =>
    "Sense perjudici del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran, pel seu ordre si aquest estiguera establit i, si no ho estiguera, per ordre d’edat, la Secretaria i/o la Tresoreria respectivament. La substitució de la Presidència es regirà pel que disposa l’article 34.",
    "règim previst en l’article 40" => "règim previst en l’article 41",
    "Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, en el seu defecte, per ordre d’edat, a la Presidència, a la Secretaria i/o a la Tresoreria respectivament." =>
      "Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran, pel seu ordre si aquest estiguera establit i, si no ho estiguera, per ordre d’edat, la Secretaria i/o la Tresoreria respectivament. La substitució de la Presidència es regirà pel que disposa l’article 34.",
    "Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran pel seu ordre, si n’hi haguera, o, a falta d’aquestes, per ordre d’edat, la Secretaria i/o la Tresoreria respectivament. La substitució de la Presidència es regirà pel que disposa l’article 34." =>
      "Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, en els casos de malaltia, absència i/o impossibilitat les Vocalies supliran, pel seu ordre si aquest estiguera establit i, si no ho estiguera, per ordre d’edat, la Secretaria i/o la Tresoreria respectivament. La substitució de la Presidència es regirà pel que disposa l’article 34.",
    "s’adaptaran al que es convinga en cada cas al corresponent Acord." =>
      "s’adaptaran al que es convinga en cada cas al corresponent Acord, sempre que no contradiga aquests Estatuts, la normativa educativa aplicable ni les competències dels òrgans de la Societat.",
    "l’Escola de la Societat podrà establir Acords de col·laboració puntual o permanent" =>
      "l’Escola de la Societat podrà establir convenis o instruments de col·laboració puntual o permanent",
    "al corresponent Acord, sempre que no contradiga" =>
      "al corresponent conveni o instrument de col·laboració, sempre que no contradiga",
    "Persones Delegades Junior" => "Persones Delegades júnior",
    "Persones Delegades júnior, que hauran de ser majors de 15 anys i menors d’edat" =>
      "Persones Delegades júnior, que tindran com a paper principal representar les persones menors d’edat de l’Agrupació i hauran de ser majors de 15 anys i menors d’edat",
    "Delegades Junior" => "Delegades júnior",
    "Llibre d’Actes de les reunions dels seus òrgans de govern i representació." =>
      "Llibre d’Actes de les sessions o reunions dels seus òrgans de govern i representació.",
    "per raons justificades de malaltia, absència i/o impossibilitat, quan concórreguen les causes previstes a l’Article 31.3 apartats a) o c), o per delegació expressa" =>
      "per raons justificades de malaltia, absència, impossibilitat o per delegació expressa",
    "confeccionar el projecte de Pressupost anual" =>
      "confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 98",
    "d’acord amb l’article 97" => "d’acord amb l’article 98",
    '<span class="sjma-change-marker">confeccionar</span> el projecte de Pressupost anual' =>
      '<span class="sjma-change-marker">confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 98</span>',
    "a) Gestionar la comptabilitat de la Societat; <span class=\"sjma-change-marker\">confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 97</span>, <span class=\"sjma-change-marker\">sol·licitar els antecedents necessaris de les distintes seccions del Pressupost,</span> i presentar els Comptes Anuals per a ser sotmesos a l’Assemblea General prèvia aprovació de la Junta Directiva." =>
      "a) Gestionar la comptabilitat de la Societat; <span class=\"sjma-change-marker\">confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 98</span>; <span class=\"sjma-change-marker\">sol·licitar els antecedents necessaris de les distintes seccions del Pressupost</span>; i <span class=\"sjma-change-marker\">preparar els Comptes Anuals perquè la Junta Directiva els presente a l’Assemblea General per a la seua aprovació</span>.",
    "gestionar la comptabilitat de la Societat; confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 97, sol·licitar els antecedents necessaris de les distintes seccions del Pressupost, i presentar els Comptes Anuals per a ser sotmesos a l’Assemblea General prèvia aprovació de la Junta Directiva." =>
      "gestionar la comptabilitat de la Societat; confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 98; sol·licitar els antecedents necessaris de les distintes seccions del Pressupost; i preparar els Comptes Anuals perquè la Junta Directiva els presente a l’Assemblea General per a la seua aprovació.",
    "Gestionar la comptabilitat de la Societat; confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 97, sol·licitar els antecedents necessaris de les distintes seccions del Pressupost, i presentar els Comptes Anuals per a ser sotmesos a l’Assemblea General prèvia aprovació de la Junta Directiva." =>
      "Gestionar la comptabilitat de la Societat; confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 98; sol·licitar els antecedents necessaris de les distintes seccions del Pressupost; i preparar els Comptes Anuals perquè la Junta Directiva els presente a l’Assemblea General per a la seua aprovació.",
    "denominada SOCIETAT JOVENTUT MUSICAL D’ALBAL, en avant referida" =>
      "denominada SOCIETAT JOVENTUT MUSICAL D’ALBAL, d’ara en avant referida",
    "d’ara d’ara d’ara en avant referida" => "d’ara en avant referida",
    "normes d’organització i funcionament aprovats" => "normes d’organització i funcionament aprovades",
    "un número de Vocalies" => "un nombre de Vocalies",
    "d’ara d’ara en avant referida" => "d’ara en avant referida",
    "podrà reconèixer a totes aquelles persones" => "podrà reconèixer totes aquelles persones",
    "serveis prestats a la Societat mitjançant Menció d’Honor" => "serveis prestats a la Societat amb una Menció d’Honor",
    "havent de ser en tot cas motivat l’acord en què, en el seu cas, s’impose la sanció" =>
      "i l’acord en què, si escau, s’impose la sanció haurà de ser motivat en tot cas",
    "haurà de celebrar-se al primer trimestre" => "haurà de celebrar-se en el primer trimestre",
    "al tercer trimestre" => "en el tercer trimestre",
    "establixen aquestos Estatuts" => "estableixen aquests Estatuts",
    "puguen conèixer" => "puguen conéixer",
    "a conèixer" => "a conéixer",
    "per a conèixer" => "per a conéixer",
    "vacants en una Junta Directiva distintes a la Presidència" => "vacants en una Junta Directiva distintes de la Presidència",
    "continuarà en règim d’interinitat previst" => "continuarà en el règim d’interinitat previst",
    "les persones que les componen" => "les persones que la componen",
    "tots els punts que d’acord amb aquestos Estatuts li corresponga" =>
      "tots els punts que d’acord amb aquestos Estatuts li corresponguen",
    "la mitat més u" => "la meitat més un",
    "per designació per la Junta Directiva" => "per designació de la Junta Directiva",
    "DILIGÈNCIA MODIFICACIÓ" => "DILIGÈNCIA DE MODIFICACIÓ"
  }

  final_text_replacements.each do |old_text, new_text|
    next_title = next_title.gsub(old_text, new_text)
    next_body = next_body.gsub(old_text, new_text)
  end

  if ARTISTIC_ORGANIZATION_ORDER.key?(proposal.id)
    next_position, ordered_title, next_level = ARTISTIC_ORGANIZATION_ORDER.fetch(proposal.id)
    next_title = ordered_title
    next_body = ordered_title if next_level != "article"
  end

  next if next_title == ca_title && next_body == ca_body && next_level == proposal.participatory_text_level && next_position == proposal.position

  proposal.title = title.merge(LOCALE => next_title)
  proposal.body = body.merge(LOCALE => next_body)
  proposal.participatory_text_level = next_level
  proposal.position = next_position
  proposal.save!
  updated << "#{proposal.id}: #{ca_title} -> #{next_title}"
end

scope.where(participatory_text_level: nil).where("title ->> ? = ?", LOCALE, "Article 31. De la composició de la Junta Directiva").destroy_all

puts "Updated #{updated.size} proposals"
updated.each { |line| puts line }
