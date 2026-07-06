#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "i18n"
require "set"

OCR_PATH = Rails.root.join(".analysis/original_ocr/estatuts-originals-ocr.txt")
OUTPUT_PATH = Rails.root.join("config/sjma_statute_change_notes.yml")
VICETRESORERIA_TITLE = "Article 41. De la Vicetresoreria"

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
  28 => [25],
  29 => [27],
  30 => [26],
  31 => [25],
  32 => [29, 30],
  33 => [31],
  34 => [32],
  35 => [33],
  36 => [33],
  37 => [34],
  38 => [35],
  39 => [28],
  40 => [35],
  42 => [20, 21],
  43 => [28],
  44 => [28],
  48 => [45, 46],
  49 => [44, 47],
  57 => [49, 50],
  58 => [51],
  59 => [44, 45],
  61 => [39, 40],
  63 => [41],
  64 => [43],
  65 => [42],
  66 => [60],
  67 => [58],
  68 => [7],
  76 => [59],
  77 => [38],
  78 => [14],
  79 => [14, 58, 60],
  90 => [14],
  91 => [57],
  92 => [52],
  93 => [52],
  94 => [53, 54],
  95 => [54],
  96 => [55, 56],
  97 => [55],
  98 => [56],
  99 => [55, 56],
  103 => [61],
  104 => [62]
}.freeze

ARTICLE_JUSTIFICATIONS = {
  1 => "modifica la denominació estatutària única de l'entitat. No es tracta només d'una adaptació lingüística del text, sinó que amb aquests Estatuts la denominació oficial passa a ser en valencià, Societat Joventut Musical d'Albal, que és la forma utilitzada habitualment per la Societat.",
  3 => "reubica en l'article dedicat a l'activitat i els fins de la Societat la declaració que ja figurava en l'article 2 anterior sobre la naturalesa cultural i l'absència d'ànim de lucre; actualitza les finalitats artístiques i educatives de la Societat; i incorpora expressament la conservació, catalogació, estudi, digitalització i difusió del seu patrimoni documental, musical, artístic, educatiu, social i institucional.",
  4 => "manté el principi d'interés general i d'obertura de les activitats a la ciutadania, però elimina una formulació massa absoluta que podia impedir beneficis, condicions o bonificacions legítimes per a Persones Associades, Joventuts o altres persones vinculades a la Societat.",
  5 => "actualitza la identificació del domicili social i deixa el redactat adaptat a la ubicació real de la Societat.",
  7 => "reubica en el nou Article 7 la previsió de durada indefinida que abans figurava en l'Article 61. La resta del règim de dissolució d'aquell article antic se separa i es reordena en el títol final perquè siga més fàcil de localitzar.",
  8 => "simplifica les classes de socis i adapta la terminologia al model del nou esborrany: els antics Socis Numeraris passen a regular-se com a Persones Associades i els antics Socis Juvenils passen a integrar-se en les Joventuts. També separa el règim de les Joventuts del de l'alumnat menor no associat de l'Escola, precisa que no tenen vot en l'Assemblea General ni en els òrgans de govern, sense impedir la seua participació interna en les Agrupacions quan els Estatuts ho preveuen, evita que el pas a Persona Associada siga automàtic en arribar a la majoria d'edat i vincula la continuïtat com a integrant activa major d'edat d'una Agrupació Artística Titular a la condició de Persona Associada.",
  9 => "substitueix les categories antigues de Socis Honoraris i Socis Protectors per un sistema més flexible: els reconeixements honorífics passen a ser Mencions d'Honor que es poden atorgar a persones associades o no associades, i la col·laboració especial dels antics protectors passa a articular-se mitjançant convenis de col·laboració, protecció, patrocini o mecenatge amb persones físiques o jurídiques.",
  10 => "actualitza el procediment d'ingrés perquè la sol·licitud puga presentar-se pels canals habilitats per la Societat, amplia el termini de publicitat a un mes amb dades mínimes d'identificació social i sense publicar dades de contacte o identificatives innecessàries, preveu l'alta automàtica si no hi ha denegació o suspensió motivada, remet la denegació al règim de revisió interna i sotmet les altes a ratificació posterior de l'Assemblea General com a control de regularitat.",
  15 => "precisa que la Societat s'organitza mitjançant l'Assemblea General i la Junta Directiva, evitant presentar la Junta Directiva com a òrgan que regeix la Societat al mateix nivell que l'Assemblea General.",
  11 => "actualitza les causes de baixa i pèrdua de la condició de Persona Associada, exigeix requeriment previ en els impagaments i reserva a l'Assemblea General la separació definitiva quan corresponga.",
  13 => "ordena els drets de les Persones Associades, reubica en aquest article els drets reconeguts a les Joventuts i reforça el dret a obtindre còpia dels Estatuts i normes internes i a consultar llibres i registres socials en els termes aplicables.",
  14 => "reformula els deures de les persones associades amb llenguatge actual, perspectiva inclusiva i coherència amb la nova estructura d'obligacions socials, deixant en aquest article només els deures de les Joventuts i traslladant els seus drets a l'article 16.",
  17 => "actualitza les competències de l'Assemblea General, substitueix l'elecció separada de la Presidència per l'elecció de la Junta Directiva mitjançant candidatura de llista tancada, modifica el règim d'aprovació d'operacions d'endeutament, incorpora la ratificació assembleària d'altes i separacions definitives i atribueix a l'Assemblea l'aprovació de contraprestacions per serveis professionals prestats per persones de la Junta Directiva diferents de les funcions pròpies del càrrec.",
  18 => "actualitza la representació en l'Assemblea General, limita l'acumulació de representacions, redueix la recollida innecessària de còpies de documents d'identitat i manté mecanismes suficients per verificar la representació.",
  20 => "actualitza el règim de les Assemblees Generals Extraordinàries, permet la sol·licitud per canals habilitats i excepciona les modificacions estatutàries perquè es tramiten pels terminis específics de participació, esmenes i comunicació del text definitiu.",
  22 => "actualitza el règim de constitució de l'Assemblea General, concreta la redacció de l'acta de cada sessió i elimina la possibilitat de celebrar una segona convocatòria no prevista amb només dos dies d'antelació, remetent-la al règim ordinari de convocatòria.",
  24 => "actualitza el règim d'adopció d'acords de l'Assemblea General, incorporant el vot de les Persones Associades representades, definint la majoria qualificada sobre els vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot i remetent els acords de dissolució a l'article 105 per evitar referències internes fràgils.",
  28 => "manté la gratuïtat dels càrrecs de la Junta Directiva per l'exercici de les seues funcions, però permet contraprestacions per serveis professionals o treballs prestats a la Societat quan siguen diferents del càrrec, aprovats per l'òrgan competent i sotmesos al règim de conflicte d'interés.",
  29 => "actualitza el règim electoral de la Junta Directiva, substitueix el model d'elecció individual de Presidència per candidatures completes de llista tancada, fixa terminis de presentació i publicitat de candidatures i estableix el vot secret en tota elecció de Junta Directiva.",
  30 => "actualitza el règim de durada, cessament i cobertura de vacants de la Junta Directiva, adaptant-lo a l'elecció per candidatura de llista tancada, regulant les vacants produïdes durant el mandat i evitant que l'absència temporal de candidatures comporte automàticament la dissolució de la Societat.",
  31 => "reordena la composició de la Junta Directiva, incorpora la Vicetresoreria i clarifica que les persones assessores poden assistir amb veu i sense vot però no s'integren en l'òrgan de representació.",
  32 => "ordena les funcions de la Junta Directiva, substitueix la delegació genèrica de facultats per encomanes concretes de gestió o suport que no substitueixen l'òrgan col·legiat, atribueix a la Junta la tramitació inicial d'altes amb ratificació assembleària quan corresponga, exigeix escoltar la Comissió Mixta d'Agrupacions o les Persones Delegades abans de decisions sobre Direccions tècnic-artístiques quan siga possible, i manté un llindar econòmic concret de 1.000 € per a l'aprovació d'operacions per la Junta.",
  33 => "actualitza les funcions de la Presidència, limita les competències residuals generals i centra la Presidència en representació, direcció, execució d'acords i mesures ordinàries o urgents amb dació de compte a la Junta Directiva.",
  34 => "ordena les funcions de la Vicepresidència i supletorietats per donar resposta a absències, delegacions i organització interna.",
  35 => "reordena les funcions de la Secretaria i les adapta a les obligacions documentals, registrals i de comunicació actuals.",
  36 => "introdueix la Vicesecretaria per donar continuïtat i suport a les funcions documentals i administratives.",
  37 => "actualitza les funcions de Tresoreria, les vincula a pressupostos, comptabilitat i control econòmic, i precisa que la Tresoreria confecciona tècnicament el projecte pressupostari d'acord amb la planificació de la Junta Directiva.",
  38 => "defineix millor el paper de les Vocalies dins d'una Junta Directiva més flexible i distribuïda.",
  39 => "actualitza el règim de reunions de la Junta Directiva, incloent formes de convocatòria i funcionament més adaptades a la pràctica actual.",
  40 => "actualitza el règim de substitució de càrrecs de la Junta Directiva, incloent la Vicetresoreria i ordenant les suplències per evitar buits de funcionament.",
  41 => "preveu escenaris sense candidatures o amb òrgans provisionals, una situació que els estatuts vigents no regulaven amb prou detall.",
  42 => "reforça la responsabilitat de la Junta Directiva davant l'Assemblea General, ordena el control polític de la seua gestió i fa coherent el vot de confiança i censura amb el règim general de representació en Assemblea.",
  45 => "defineix les Agrupacions Artístiques Titulars com a agrupacions estables i representatives de la Societat, reconeix el paper històric de la Banda Simfònica sense restar rellevància a la resta d'agrupacions i regula el contingut mínim de la resolució de creació, modificació, suspensió o extinció d'una agrupació.",
  46 => "permet que una Agrupació Artística Titular puga tindre també vessant educativa o pedagògica quan ho preveja la planificació educativa de l'Escola i ho aprove la Junta Directiva, sense alterar la seua condició d'Agrupació Artística Titular.",
  47 => "defineix l'exercici artístic de les Agrupacions Artístiques Titulars i el vincula a una planificació coordinada amb la Societat i l'Escola.",
  48 => "obre la direcció de les agrupacions a estructures artístiques i tècniques flexibles, sempre exercides per personal contractat per la Societat, i exigeix que la resolució que amplie l'estructura delimite les funcions i, si escau, la coordinació tècnic-artística.",
  49 => "substitueix la regulació centrada només en músics per una definició més inclusiva de persones integrants actives, aplicable també a agrupacions no estrictament instrumentals, i integra en la nova regulació el deure d'assistència als assajos i actes.",
  50 => "regula les Persones Delegades, incloses les Persones Delegades Junior, com a canal estable de comunicació, coordinació i proposta de les Agrupacions Artístiques Titulars, i delimita la seua participació en la coordinació operativa perquè no assumisquen estatutàriament tota la responsabilitat logística.",
  51 => "reformula l'antic arxiu musical com a Arxiu de la Societat i centre de documentació del patrimoni musical, artístic, educatiu, social i institucional, ampliant-ne la finalitat sense crear un òrgan nou ni una estructura insostenible.",
  52 => "desenvolupa la conservació i gestió de l'Arxiu amb quatre fons o seccions documentals, criteris tècnics bàsics, possibilitat de coordinació flexible, límits d'accés per protecció de dades, propietat intel·lectual, confidencialitat i conservació dels materials, i condiciona l'eliminació o expurgació documental a criteris tècnics i legals.",
  53 => "ordena l'elecció anual de les Persones Delegades, fixa terminis clars de convocatòria i candidatures, regula l'elecció separada de les Persones Delegades júnior per vot de les persones integrants actives amb dret de vot intern, preveu una convocatòria subsidiària si no s'ha celebrat dins del tercer trimestre i permet designacions provisionals quan no hi haja candidatures suficients o es produïsquen vacants.",
  54 => "crea Assemblees d'Agrupació com a espais interns de deliberació i proposta de cada Agrupació Artística Titular, i concreta el termini i la convocatòria subsidiària quan la Junta Directiva o la Direcció tècnic-artística sol·liciten una assemblea.",
  55 => "concreta les regles bàsiques de convocatòria, constitució i votació de les Assemblees d'Agrupació, permetent el vot de les persones integrants actives que siguen Persones Associades o formen part de les Joventuts en assumptes interns de l'Agrupació.",
  56 => "clarifica el valor intern i no vinculant dels acords o posicionaments de les Assemblees d'Agrupació i el seu trasllat a la Direcció, a la Comissió Mixta o a la Junta Directiva.",
  57 => "regula el dipòsit d'instruments, uniformes i altres béns artístics de la Societat per donar seguretat sobre el seu ús, custòdia, devolució i conservació, i substitueix l'autorització prèvia genèrica i la prohibició absoluta d'actuar en altres agrupacions per un ús condicionat a no perjudicar l'activitat de la Societat ni contradir les condicions de cessió.",
  58 => "preveu Reglaments de Règim Intern de les Agrupacions Artístiques Titulars, elaborats de manera participada, aprovats per la Junta Directiva i comunicats també a les persones representants legals quan afecten menors d'edat.",
  59 => "crea la Comissió Mixta d'Agrupacions com a espai consultiu i de coordinació entre les agrupacions titulars, les agrupacions de l'Escola i la Junta Directiva, amb periodicitat mensual durant els períodes d'activitat ordinària.",
  60 => "estableix el seguiment ordinari de les Agrupacions Artístiques en la Junta Directiva i permet convidar membres de la Comissió Mixta quan es tracten assumptes rellevants.",
  61 => "reordena la regulació de l'Escola, la connecta amb els òrgans de govern i la normativa aplicable, obri l'accés també a persones no associades i limita els acords de col·laboració perquè no contradiguen els Estatuts, la normativa educativa aplicable ni les competències dels òrgans de la Societat.",
  62 => "introdueix l'Equip Directiu de l'Escola per reflectir millor la seua gestió real.",
  63 => "substitueix el concepte rígid de Pla d'Estudis per una planificació educativa flexible, adaptada als instruments pedagògics, organitzatius i acadèmics que preveja la normativa vigent en cada moment.",
  65 => "ordena les agrupacions i conjunts de l'Escola dins de la planificació educativa, connecta la seua representació amb la Comissió Mixta d'Agrupacions i preveu que el procediment d'incorporació de l'alumnat a Agrupacions Artístiques Titulars siga treballat en aquesta Comissió i aprovat per Resolució de la Junta Directiva.",
  66 => "substitueix la supletorietat general dels Estatuts de la Federació de Societats Musicals de la Comunitat Valenciana per una aplicació per raó de pertinença i només en allò que no contradiga aquests Estatuts ni la normativa vigent aplicable.",
  67 => "substitueix la interpretació autèntica de la Junta Directiva per una interpretació operativa i provisional, sense perjudici de l'Assemblea General, de la revisió interna i de les impugnacions que corresponguen.",
  68 => "reubica en el nou Article 70 el contingut de l'antic Article 7 sobre obligacions documentals i comptables, l'actualitza a la normativa vigent i precisa que el Llibre d'Actes recull sessions o reunions segons l'òrgan de què es tracte.",
  69 => "incorpora la gestió dels sistemes d'informació per assegurar la continuïtat entre juntes, evitar pèrdua d'accessos o documentació, exigir gestió segura de credencials i incloure dominis, correus corporatius, serveis en núvol, repositoris i còpies digitals essencials.",
  70 => "incorpora un registre intern de relacions comercials habituals amb informació mínima per facilitar la continuïtat de la gestió de proveïdors, contractants i altres tercers recurrents, sense incloure l'alumnat, les Persones Associades ni les Joventuts.",
  71 => "concreta la publicitat interna dels Acords de l'Assemblea General i les Resolucions de la Junta Directiva, fixant canals, contingut mínim i límits quan hi haja dades o matèries que requerisquen reserva.",
  72 => "defineix la transparència com a criteri general de govern, administració i rendició de comptes davant les Persones Associades, concretant la informació essencial, els límits derivats de la reserva o protecció de dades i les obligacions que deriven de subvencions, convenis, utilitat pública o interés públic.",
  73 => "ordena el tractament de dades personals necessari per a les finalitats socials, educatives, artístiques, administratives i de gestió, i atribueix a la Junta Directiva l'organització dels mitjans interns o professionals necessaris.",
  74 => "concreta el dret d'accés a la informació social, definint-ne l'abast, el canal de sol·licitud, el termini de resposta, l'obligació de motivar els límits per reserva o protecció de tercers i les exclusions davant accessos indiscriminats o desproporcionats.",
  75 => "estableix principis de bon govern, concreta deures d'actuació responsable i regula criteris d'abstenció davant conflictes d'interés amb la Societat, diferenciant les decisions de la Junta Directiva del dret de veu i vot en l'Assemblea General en assumptes d'interés general.",
  76 => "substitueix el recurs d'alçada per una revisió interna de les Resolucions de la Junta Directiva davant la mateixa Junta, concreta els seus efectes, la possible suspensió motivada, la relació amb la via assembleària i judicial i la dació de compte a l'Assemblea General de les revisions no estimades íntegrament.",
  77 => "clarifica la impugnació per via jurisdiccional, diferencia els acords contraris als Estatuts dels contraris a la llei o a normes imperatives i preveu que es done compte a l'Assemblea General de les impugnacions judicials de Resolucions de la Junta Directiva perquè, si escau, puga ratificar-les o revocar-les dins de les seues competències.",
  78 => "actualitza l'àmbit de la responsabilitat disciplinària, diferenciant el règim aplicable a les Persones Associades de les mesures internes de convivència aplicables a Joventuts, alumnat, participants no associats i persones col·laboradores, i precisa que el personal contractat es regeix pel règim laboral aplicable sense que aquest títol substituïsca l'Estatut dels Treballadors, els convenis col·lectius o la normativa laboral.",
  79 => "reforça els principis generals del règim disciplinari, incloent legalitat, expedient previ, audiència, defensa, presumpció d'innocència, proporcionalitat i irretroactivitat desfavorable.",
  80 => "classifica expressament les faltes disciplinàries per donar una base clara a l'aplicació del règim disciplinari.",
  81 => "defineix les faltes molt greus amb major precisió, incloent conductes penals vinculades a la Societat, danys dolosos, acumulació de faltes greus fermes no prescrites, protecció de persones, dades, sistemes, patrimoni i responsabilitats delegades.",
  82 => "defineix les faltes greus i diferencia millor la desobediència, els altercats, la falta de respecte, el perjudici a la convivència, els impagaments, l'acumulació de faltes lleus fermes no prescrites i els incompliments greus en Escola, agrupacions, activitats, béns, canals i funcions encomanades.",
  83 => "defineix les faltes lleus i separa les conductes de falta de respecte, desobediència lleu, falta de cooperació, negligència lleu, danys lleus i incompliments lleus de normes internes, béns o responsabilitats assumides.",
  84 => "substitueix la previsió genèrica de baixa per sanció disciplinària i expulsió per un règim graduat de sancions per faltes molt greus, amb expulsió, inhabilitació temporal, suspensió temporal de drets i ratificació assembleària de l'expulsió.",
  85 => "concreta les sancions per faltes greus, amplia la prohibició o exclusió temporal a actes, activitats, projectes, serveis, espais i altres esdeveniments de la Societat i limita la seua durada a un període proporcionat.",
  86 => "concreta les sancions per faltes lleus, situant l'advertència com a sanció bàsica, mantenint la suspensió temporal de drets i afegint l'exclusió puntual o temporal d'activitats, serveis o espais amb un límit màxim d'un mes.",
  87 => "afegeix criteris de graduació perquè les sancions siguen proporcionades, limita l'acumulació de sancions als casos compatibles, motivats i proporcionats, i permet limitar la sanció a l'àmbit afectat.",
  88 => "regula la prescripció de les faltes i de l'execució de les sancions per donar seguretat temporal al règim disciplinari.",
  89 => "estableix un règim específic per a les persones que componen la Junta Directiva, amb abstenció per conflicte d'interés, instrucció separada, garanties d'audiència, suspensió cautelar motivada, resolució per l'Assemblea General i mesures provisionals urgents i imprescindibles de protecció quan siguen necessàries.",
  90 => "substitueix la remissió a un reglament del procediment sancionador per un procediment disciplinari complet dins dels Estatuts, amb inici, arxivament, instrucció separada de l'òrgan que resol, criteris d'imparcialitat, al·legacions, prova, proposta de resolució, terminis, mesures cautelars, resolució motivada, ratificació assembleària de l'expulsió i abstenció de resoldre sobre els mateixos fets quan hi haja denúncia o querella penal fins que recaiga resolució ferma, sobreseïment o arxivament.",
  91 => "actualitza la responsabilitat patrimonial de la Societat i de les Persones Associades.",
  92 => "manté la referència al patrimoni inicial, però suprimeix la quantia concreta perquè el valor real ha de resultar de l'inventari, la comptabilitat i la documentació econòmica vigent en cada moment.",
  93 => "substitueix percentatges i terminis concrets, que poden quedar desfasats si canvia la normativa, per una remissió estable a la normativa vigent aplicable i concreta que els excedents s'han de reinvertir en la Societat sense repartiment entre les Persones Associades.",
  94 => "dona títol propi a l'article, actualitza els recursos econòmics, substitueix referències fundacionals per fins estatutaris i elimina expressions ambigües com unitats culturals.",
  95 => "manté el principi de destinació exclusiva dels beneficis als fins de la Societat i corregeix l'expressió successió gratuïta per cessió gratuïta.",
  96 => "dona títol propi a l'article, reubica conjuntament el règim general dels pressupostos i de l'exercici econòmic, i preveu la pròrroga provisional del pressupost anterior per evitar bloquejos en despeses ordinàries i imprescindibles.",
  97 => "ordena els pressupostos ordinaris separant la confecció tècnica de Tresoreria, les directrius i planificació de la Junta Directiva i l'aprovació final per l'Assemblea General.",
  98 => "diferencia els pressupostos extraordinaris per a necessitats no ordinàries, concreta la seua finalitat, amplia les formes de finançament, evita que substituïsquen el pressupost ordinari i permet atendre despeses urgents imprescindibles amb dació de compte posterior.",
  99 => "reforça la comptabilitat ordenada, la rendició de comptes davant l'Assemblea General, el control extern quan siga exigible, acordat o convenient, i precisa que la Junta formula, signa, presenta o deposita els documents exigibles sense substituir l'aprovació assembleària quan aquesta corresponga.",
  100 => "desenvolupa el règim anterior de modificació estatutària, que atribuïa a l'Assemblea General l'aprovació i modificació dels Estatuts i exigia majoria qualificada i convocatòria específica, incorporant un procediment previ de participació, debat i esmenes, compatible tant amb canals electrònics com presencials o en paper, i garantint almenys una via no digital amb suport bàsic.",
  101 => "regula les esmenes com a instrument obert de participació de les Persones Associades, sense suport mínim previ, preveient publicitat interna, suports registrats, actuacions personals, possibilitat d'assistència tècnica i traçabilitat de les esmenes agrupades o refoses.",
  102 => "ordena la proposta definitiva i l'aprovació del text, documentant esmenes incorporades, agrupades, refoses i no incorporades, fixant el suport del 10 per cent de les Persones Associades amb dret de vot al final del període de participació per a votació separada necessària, exigint informe breu de retorn, ordre de votacions incompatibles i defensa breu de les esmenes sotmeses a votació separada.",
  103 => "trasllada i actualitza les causes de dissolució al títol final, incorpora expressament la reducció a menys de tres Persones Associades, les causes previstes en els Estatuts, la referència al Codi Civil i manté la dissolució per acord de l'Assemblea General amb majoria absoluta.",
  104 => "actualitza la liquidació, corregeix errors de redacció, clarifica la personalitat jurídica durant la liquidació, preveu que l'autoritat judicial competent puga acordar una liquidació diferent quan corresponga i concreta el destí del romanent amb prioritat per a una altra societat musical d'Albal o, si no és possible, per a entitats sense ànim de lucre o públiques vinculades al municipi, amb afectació a finalitats musicals, educatives o culturals a Albal i prohibició de repartiment entre Persones Associades o entitats lucratives."
}.freeze

PREVIOUS_NUMBER_BY_CURRENT = {}.tap do |mapping|
  (1..7).each { |number| mapping[number] = number }
  mapping[8] = 67
  mapping[9] = 68
  mapping[10] = 8
  mapping[11] = 8
  (12..40).each { |number| mapping[number] = number - 3 }
  mapping[41] = nil
  (42..46).each { |number| mapping[number] = number - 4 }
  mapping[47] = nil
  mapping[48] = nil
  (49..54).each { |number| mapping[number] = number - 4 }
  (55..67).each { |number| mapping[number] = number - 2 }
  mapping[68] = 51
  mapping[69] = 52
  mapping[70] = 68
  mapping[71] = 69
  mapping[72] = 70
  (73..106).each { |number| mapping[number] = number - 2 }
end.freeze

DRAFT_ESCOLA_NOTE = {
  "kind" => "modification",
  "summary" => "Justificació: unifica la denominació \"Escola\" en aquest article.",
  "old_text" => "Escola de Música",
  "draft_text" => "Escola",
  "old_article_refs" => []
}.freeze

DRAFT_ESCOLA_NOTE_TITLES = [
  "Article 32. Del règim orgànic i funcional de la Junta Directiva",
  "Article 33. De la Presidència",
  "Article 61. Disposicions generals",
  "Article 62. De l’Equip Directiu de l’Escola",
  "Article 63. De la planificació educativa de l’Escola",
  "Article 64. Del règim orgànic, funcional i disciplinari de l’Escola",
  "Article 65. De la incorporació a la Banda Simfònica"
].freeze

DELETION_NOTES = {
  31 => [
    {
      "old_refs" => [36],
      "summary" => "Justificació: se suprimeix la figura específica de l'Ajustador perquè les seues funcions es redistribueixen dins d'una organització artística i directiva més clara.",
      "old_text" => <<~TEXT.strip
        Artículo 36.- El Ajustador tiene la delegación permanente del Presidente, para contratar en nombre de la Sociedad los actos en que la Banda deba participar, firmará los compromisos, extenderá y cobrará los recibos en pago de los servicios contratados, entregando la parte que se destine al fondo social al Tesorero, y el resto a cada uno de los músicos que hayan participado en el acto retribuido.

        El cargo de Ajustador recaerá en un músico, y podrá ser prorrogado indefinidamente.
      TEXT
    }
  ],
  12 => [
    {
      "old_refs" => [11],
      "summary" => "Justificació: se suprimeix la categoria separada de Socis Protectors perquè la col·laboració econòmica o institucional passa a regular-se amb fórmules més flexibles de conveni de col·laboració, protecció, patrocini o mecenatge amb persones físiques o jurídiques que vulguen col·laborar de manera especial amb la Societat.",
      "old_text" => <<~TEXT.strip
        Serán Socios Protectores los que, con tal carácter lo soliciten de la Asociación contribuyendo al
        sostenimiento material de la misma, sin tomar parte en la vida activa de la Entidad.
        Los Socios Honorarios y Protectores no podrán ser electores ni elegibles, y carecerán de voto
        en las Asambleas Generales de la Asociación.
      TEXT
    }
  ],
}.freeze

MANUAL_NOTES = {
  "Article 1. De la Denominació" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: modifica la denominació estatutària única de l'entitat. No es tracta només d'una adaptació lingüística del text, sinó que amb aquests Estatuts la denominació oficial passa a ser en valencià, Societat Joventut Musical d'Albal, que és la forma utilitzada habitualment per la Societat.",
      "old_text" => "Artículo 1. De la Denominación.- Se constituye la Asociación denominada SOCIEDAD JUVENTUD MUSICAL DE ALBAL.",
      "draft_text" => "Es constitueix l’Associació denominada Societat Joventut Musical d'Albal, d’ara en avant referida en aquestos Estatuts com «la Societat».",
      "old_article_refs" => [1]
    }
  ],
  "Article 3. De l’activitat i dels fins de la Societat" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: reubica en l'article dedicat a l'activitat i els fins de la Societat la declaració que ja figurava en l'article 2 anterior sobre la naturalesa cultural i l'absència d'ànim de lucre. Per tant, no és una previsió nova, sinó una reorganització sistemàtica del mateix contingut en el lloc més adequat.",
      "old_text" => "Artículo 2. Personalidad Jurídica.- La Asociación tiene personalidad jurídica propia y capacidad plena de obrar para administrar y disponer de sus bienes y cumplir los fines que se propone. Esta Asociación tiene naturaleza cultural y no persigue ninguna finalidad de carácter lucrativo, pues es una entidad sin ánimo de lucro.",
      "draft_text" => "La Societat és una entitat sense ànim de lucre de naturalesa cultural.",
      "old_article_refs" => [2]
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: actualitza els apartats principals de l'article 3 per donar prioritat a la promoció i difusió de la música per mitjà de les Agrupacions artístiques, especialment la Banda Simfònica, i de l'Escola; i amplia expressament l'àmbit cultural a les arts escèniques, incloent la possibilitat d'estendre els ensenyaments de l'Escola a disciplines com la dansa i les arts escèniques.",
      "old_text" => <<~TEXT.strip,
        a) Amb caràcter prioritari, la promoció i difusió de l’art musical per mitjà de la Banda Simfònica i de l’Escola de Música. Així mateix, podrà crear orquestres, rondalles, orfeons i demés conjunts musicals i corals, i organitzar concerts, festivals, certàmens i audicions de qualsevol classe.

        b) La promoció i foment de les arts plàstiques i literàries mitjançant la programació d’exposicions, mostres, representacions teatrals, cinematogràfiques, conferències, seminaris i biblioteques, etc.
      TEXT
      "draft_text" => <<~TEXT.strip,
        a) Amb caràcter prioritari, la promoció i difusió de la música per mitjà de les Agrupacions artístiques, especialment de la Banda Simfònica, i de l'Escola. Podrà crear conjunts instrumentals i vocals de qualsevol tipus, i organitzar concerts, festivals, certàmens i audicions de qualsevol classe.

        b) La promoció i foment de les arts escèniques, plàstiques i literàries mitjançant la programació d'exposicions, mostres, representacions teatrals, cinematogràfiques, conferències, seminaris i biblioteques, etc. Podrà ampliar els ensenyaments de l'Escola a altres disciplines artístiques, especialment la dansa i les arts escèniques.
      TEXT
      "old_article_refs" => [3]
    }
  ],
  "Article 5. Del domicili" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: actualitza i normalitza la identificació del domicili social de la Societat, mantenint la possibilitat de trasllat dins del mateix municipi per Acord de l'Assemblea General.",
      "old_text" => <<~TEXT.strip,
        Articulo 5.- Domicilio y ámbito de actuación.- El domicilio social se fija en el Municipio de .ALBAL... calle o plaza SAN CARLOS -CASA DE LA CULTURA... S/N..... , Código Postal 46470 pero podrá trasladarse a otro lugar, dentro de este Municipio, por acuerdo de la Asamblea General.
      TEXT
      "draft_text" => <<~TEXT.strip,
        El domicili social es fixa al municipi d’Albal, al Carrer Sant Carles, 80 (Casa de la Cultura), amb Codi Postal 46470. Podrà traslladar-se a un altre lloc, dins d’aquest municipi, per Acord de l’Assemblea General.
      TEXT
      "old_article_refs" => [5]
    }
  ],
  "Article 6. Àmbit d’actuació" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: manté el mateix àmbit territorial d'actuació dels Estatuts vigents i en normalitza la redacció en valencià, sense alterar-ne l'abast.",
      "old_text" => <<~TEXT.strip,
        Articulo 6.- La Asociación realizará principalmente sus actividades en el ámbito territorial del Municipio de su domicilio social, sin perjuicio de que algunos actos o determinadas actividades puedan extenderse y realizarse en otros lugares de la Comunidad Valenciana e incluso en otros territorios de España o del extranjero.
      TEXT
      "draft_text" => "La Societat realitzarà principalment les seues activitats en l’àmbit territorial del Municipi del seu domicili social, sense perjuí que alguns actes o determinades activitats puguen estendre’s i dur-se a terme en altres llocs de la Comunitat Valenciana i inclús en altres territoris d’Espanya o de l’estranger.",
      "old_article_refs" => [6]
    }
  ],
  "Article 7. De la durada" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: reubica en el nou Article 7 la previsió de durada indefinida que abans figurava en l'Article 61. La resta del règim de dissolució d'aquell article antic se separa i es reordena en el títol final perquè siga més fàcil de localitzar.",
      "old_text" => <<~TEXT.strip,
        Artículo 61.- La Asociación tendrá una duración indefinida.

        Esta Asociación podrá disolverse por las siguientes causas:

        a) Por acuerdo de los socios, adoptado en Asamblea General convocada expresamente para este fin y con el voto favorable de la mitad de los socios asistentes.

        b) Por sentencia judicial firme.

        artículo 39 del Código Civil y demás legislación aplicable.
      TEXT
      "draft_text" => "La Societat es constitueix per temps indefinit. Únicament podrà dissoldre’s per les causes previstes en aquestos Estatuts i en la llei.",
      "old_article_refs" => [61]
    }
  ],
  "Article 8. De la normativa aplicable" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: situa la normativa supletòria aplicable i la relació amb la Federació de Societats Musicals de la Comunitat Valenciana en un article propi, substituint la supletorietat automàtica dels estatuts federatius per una aplicació per raó de pertinença que no contradiga aquests Estatuts ni la normativa vigent aplicable.",
      "old_text" => <<~TEXT.strip,
        Artículo 58.- Todos los socios están obligados a cumplir escrupulosamente las normas contenidas en los presentes Estatutos, los acuerdos de la Asamblea General y las resoluciones dictadas por la Junta Directiva, en el ámbito de sus respectivas competencias. La interpretación auténtica de las presentes normas corresponderá a la Junta Directiva, cuyas resoluciones serán válidas hasta que la Asamblea General resuelva el correspondiente recurso de apelación si se interpusiera.
      TEXT
      "draft_text" => <<~TEXT.strip,
        Per a tot allò que no estiga expressament previst en aquests Estatuts s’aplicarà la normativa d’associacions vigent i, subsidiàriament, el Dret comú.

        La normativa de la Federació de Societats Musicals de la Comunitat Valenciana serà aplicable per raó de pertinença en els termes que corresponga, sempre que no contradiga aquests Estatuts ni la normativa vigent aplicable.
      TEXT
      "old_article_refs" => [58]
    }
  ],
  "Article 9. De la interpretació dels Estatuts" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: substitueix la interpretació autèntica de la Junta Directiva per una interpretació operativa i provisional, sense perjudici de l'Assemblea General, de la revisió interna i de les impugnacions que corresponguen.",
      "old_text" => <<~TEXT.strip,
        Artículo 58.- Todos los socios están obligados a cumplir escrupulosamente las normas contenidas en los presentes Estatutos, los acuerdos de la Asamblea General y las resoluciones dictadas por la Junta Directiva, en el ámbito de sus respectivas competencias. La interpretación auténtica de las presentes normas corresponderá a la Junta Directiva, cuyas resoluciones serán válidas hasta que la Asamblea General resuelva el correspondiente recurso de apelación si se interpusiera.
      TEXT
      "draft_text" => "La interpretació operativa i provisional de les normes estatutàries correspondrà a la Junta Directiva, que haurà d’aplicar criteris de bona fe, coherència interna dels Estatuts, finalitat de la norma i respecte a la normativa vigent. Les resolucions i decisions que en aquest sentit prenga seran vàlides mentre no siguen modificades per l’Assemblea General, revisades internament o resoltes les impugnacions que corresponguen.",
      "old_article_refs" => [58]
    }
  ],
  "Article 8. Disposicions generals" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix la denominació \"Escola de Música\" per \"Escola\", simplifica \"les Joventuts de la Societat\" a \"les Joventuts\" i evita que el pas a Persona Associada siga automàtic en assolir la majoria d'edat.",
      "old_text" => <<~TEXT.strip,
        2. Aquelles persones que, no havent assolit la majoria d'edat ni l'emancipació, s'integren en alguna de les Agrupacions Artístiques o formen part de l'Escola de Música de la Societat, conformaran les Joventuts de la Societat.

        Per a la seua inclusió a les Joventuts de la Societat es requerirà l'autorització o consentiment de la persona o les persones que tinguen la pàtria potestat o tutela o que suplisquen la seua capacitat, i que aquesta o alguna d'aquestes estiga inscrita com a Persona Associada a la Societat.

        3. Les persones que conformen les Joventuts de la Societat no tindran dret a vot ni podran accedir a càrrecs directius fins que assolisquen la majoria d'edat i tinguen la plena capacitat d'obrar, moment en el qual passaran a ser Persones Associades.
      TEXT
      "draft_text" => <<~TEXT.strip,
        2. Aquelles persones que, no havent assolit la majoria d'edat ni l'emancipació, s'integren en alguna de les Agrupacions Artístiques o formen part de l'Escola de la Societat, conformaran les Joventuts.

        Per a la seua inclusió a les Joventuts es requerirà l'autorització o consentiment de la persona o les persones que tinguen la pàtria potestat o tutela o que suplisquen la seua capacitat, i que aquesta o alguna d'aquestes estiga inscrita com a Persona Associada a la Societat.

        3. Les persones que conformen les Joventuts no tindran dret a vot ni podran accedir a càrrecs directius. En assolir la majoria d'edat i tindre plena capacitat d'obrar, podran sol·licitar la seua incorporació com a Persones Associades. La continuïtat com a persona integrant activa major d'edat d'una Agrupació Artística Titular requerirà tindre la condició de Persona Associada, d'acord amb aquests Estatuts.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 11. Del Llibre Registre" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: desenvolupa el Llibre Registre, separa el Registre Actiu i el Registre Històric, preveu una secció pròpia per a les Joventuts, conserva el número permanent de les Persones Associades i limita les dades conservades en el registre històric d'acord amb la normativa de protecció de dades.",
      "old_text" => <<~TEXT.strip,
        Articulo 8.- Los socios podrán ser: Numerarios, Juveniles, Honorarios, y Protectores.

        Articulo 9.- Serán Socios Numerarios o de pleno derecho, las personas fisicas mayores de edad, que no estén sujetas a ninguna condición legal para el ejercicio de sus derechos, que tengan interés en el desarrollo de los fines de la Asociación, amantes de la música y de la convivencia social, y que se inscriban como tales y satisfagan las correspondientes cuotas sociales. Las personas jurídicas serán socios numerarios previo acuerdo expreso de su órgano competente. Los socios numerarios se relacionarán en un Libro Registro de Socios, por riguroso orden de antiguedad.

        Artículo 10.- Serán Socios Juveniles, los que no alcanzando la mayoría de edad, ni la emancipación, se integren en la sección juvenil correspondiente. Se requerirá autorización o consentimiento del padre o persona que tenga la patria potestad o tutela, o que supla su capacidad. Los Socios Juveniles no tendrán voto ni podrán acceder a cargos directivos hasta que alcancen la mayoría de edad y tengan la plena capacidad de obrar.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. Les Persones Associades i les Joventuts es relacionaran en un Llibre Registre, que podrà consistir en una base de dades informatitzada, sempre que permeta obtindre en qualsevol moment una relació nominal actualitzada.

        Les Joventuts constaran en una secció o apartat propi del Llibre Registre, sense assignació del número permanent reservat a les Persones Associades, llevat que reglamentàriament es dispose altra cosa.

        El Llibre Registre estarà conformat per dues seccions: el Registre Actiu i el Registre Històric. En el Registre Actiu constaran les Persones Associades en situació d’alta, a cadascuna de les quals se li assignarà un número seqüencial, permanent i intransmissible.

        Quan una Persona Associada cause baixa, passarà al Registre Històric, conservant en tot cas el número que tenia assignat. Aquest número no podrà ser reutilitzat ni assignat a cap altra Persona Associada. Les noves altes rebran el número correlatiu següent a l’últim número assignat, amb independència que les persones titulars dels números anteriors continuen en el Registre Actiu o hagen passat al Registre Històric.

        En el Registre Històric únicament es conservaran les dades mínimes necessàries per a identificar la persona i acreditar la seua relació històrica amb la Societat, sense perjudici dels drets que li corresponguen en matèria de protecció de dades personals, inclòs, si escau, el dret de supressió d’acord amb la normativa vigent aplicable.
      TEXT
      "old_article_refs" => [8, 9, 10]
    }
  ],
  "Article 9. De les demés maneres de participació i col·laboració amb la Societat" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: precisa que la Menció d'Honor és atorgada per acord de l'Assemblea General.",
      "old_text" => "Menció d'Honor, atorgada per l'Assemblea General a proposta de la Junta Directiva.",
      "draft_text" => "Menció d'Honor, atorgada per acord de l'Assemblea General a proposta de la Junta Directiva.",
      "old_article_refs" => []
    }
  ],
  "Article 29. De l’elecció de la Junta Directiva" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el model d'elecció individual de la Presidència, amb designació posterior de la resta de càrrecs, per l'elecció d'una candidatura completa de Junta Directiva en llista tancada. Així les Persones Associades voten un equip sencer i saben abans de votar quines persones l'integren i quin càrrec assumirà cadascuna.",
      "old_text" => <<~TEXT.strip,
        Les candidatures es presentaran individualment per al càrrec de la Presidència de la Junta Directiva. En aquest escrit, figurarà la persona que es presente a la Presidència i el llistat de persones que proposarà per a formar part de la Junta Directiva amb els respectius càrrecs als que optaran.

        La Presidència de la Junta Directiva electa designarà en la mateixa sessió de l'Assemblea General a la resta de components de la nova Junta Directiva.
      TEXT
      "draft_text" => <<~TEXT.strip,
        Les candidatures es presentaran com a llistes tancades a la Junta Directiva.

        En aquest escrit haurà de figurar la relació completa de persones que integren la candidatura i el càrrec que desenvoluparà cadascuna dins de la Junta Directiva.

        En cap cas es tractarà d'una llista oberta ni d'una elecció separada per càrrecs, de manera que el vot recaurà sobre la candidatura completa a la Junta Directiva.
      TEXT
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix \"majoria absoluta\" per \"majoria qualificada\" i precisa que aquesta es calcula sobre les Persones Associades presents i representades vàlidament amb dret de vot.",
      "old_text" => "e) Serà escollida la candidatura que aconseguisca la majoria absoluta dels vots de les Persones Associades presents o representades.",
      "draft_text" => "e) Serà escollida la candidatura que aconseguisca la majoria qualificada dels vots de les Persones Associades presents o representades.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: ajusta el calendari electoral perquè les candidatures es presenten en 7 dies naturals, la Junta Directiva les faça públiques l'endemà pels canals habituals i hi haja almenys 7 dies naturals entre la publicació i la votació perquè el cens electoral puga conèixer-les i decidir el seu vot.",
      "old_text" => "Les candidatures es presentaran com a llistes tancades a la Junta Directiva en un termini de 12 dies després de la convocatòria de l'Assemblea en què s'hi vaja a celebrar l'elecció.",
      "draft_text" => <<~TEXT.strip,
        Les candidatures es presentaran en el termini de 7 dies naturals comptats des de l'endemà de la convocatòria.

        El dia natural següent a la finalització del termini de presentació, la Junta Directiva farà publicitat de les candidatures presentades pels canals habituals.

        Entre la publicació de les candidatures i la sessió de l'Assemblea en què s'haja de votar hauran de transcórrer, almenys, 7 dies naturals.
      TEXT
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: elimina la possibilitat d'indicar el sentit del vot en l'escrit de delegació, perquè això desvelaria el vot de la Persona Associada absent quan la votació haja de ser secreta. La delegació només acreditarà la representació, i la persona representant podrà emetre el seu vot i els vots de les persones que representa preservant el caràcter secret.",
      "old_text" => "Les Persones Associades podran assenyalar el sentit del seu vot per la candidatura que estimen en el document d'autorització de la seua representació o en una papereta confeccionada per la persona representada.",
      "draft_text" => <<~TEXT.strip,
        L'autorització de la representació haurà de contindre únicament les dades exigides amb caràcter general per a la delegació de veu i vot, sense indicar el sentit del vot de la persona representada.

        En les votacions secretes, la Persona Associada representant podrà emetre el seu vot i els vots corresponents a les Persones Associades que represente, preservant en tot cas el caràcter secret del vot.
      TEXT
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Justificació: estableix que l'elecció de la Junta Directiva es realitze sempre mitjançant votació secreta, inclús quan només hi haja una candidatura, per preservar la llibertat de vot i evitar pressions personals o socials sense lligar els Estatuts a un suport material concret.",
      "old_text" => "Quan només es presentara una única candidatura, la Junta Directiva podrà ser escollida en votació ordinària per braços alçats, sempre que cap Persona Associada present a la sessió es mostre contrària a aquest procediment de votació, cas en el qual es farà votació secreta per papereta. Quan hi haguera més d’una candidatura, l’elecció es farà sempre en votació secreta per papereta.",
      "draft_text" => "L’elecció de la Junta Directiva es realitzarà sempre mitjançant votació secreta, inclús quan només s’haja presentat una única candidatura.",
      "old_article_refs" => []
    }
  ],
  "Article 30. Durada dels càrrecs assumits a la Junta Directiva" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: adapta la durada, les vacants i la interinitat al sistema de candidatura completa de Junta Directiva en llista tancada. Les vacants ordinàries deixen de dependre de la designació unilateral de la Presidència i passen a cobrir-se per acord de la Junta Directiva amb ratificació posterior de l'Assemblea General.",
      "old_text" => <<~TEXT.strip,
        La durada es computava des de la data de la elecció de la seua Presidència.

        Les vacants distintes a la Presidència es cobrien per designació de la Presidència.

        Quan es produïa vacant en la Presidència, es triava la nova Presidència de la nova Junta Directiva.
      TEXT
      "draft_text" => <<~TEXT.strip,
        La durada es computa des de la data de l'elecció de la Junta Directiva.

        Les vacants distintes a la Presidència es cobriran per acord de la Junta Directiva i hauran de ser ratificades per l'Assemblea General.

        Quan es produïsca vacant en la Presidència, es triarà una nova Junta Directiva mitjançant candidatura de llista tancada.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 17." => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el llindar fix de 12.000 euros per un criteri proporcional vinculat al 10 per cent del pressupost ordinari anual aprovat per l'Assemblea General i precisa que afecta crèdits, préstecs o altres operacions d'endeutament.",
      "old_text" => "h) Aprovar l'assumpció pel patrimoni de la Societat de crèdits superiors a 12.000 €.",
      "draft_text" => "h) Aprovar la sol·licitud o concertació de crèdits, préstecs o altres operacions d'endeutament quan el seu import siga superior al 10 per cent del pressupost ordinari anual aprovat per l'Assemblea General.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: adapta la competència electoral de l'Assemblea General al sistema de candidatura completa, de manera que ja no tria únicament la Presidència sinó la Junta Directiva sencera.",
      "old_text" => "c) Triar i cessar a la Presidència de la Junta Directiva en els termes descrits en estos Estatuts.",
      "draft_text" => "c) Triar i cessar la Junta Directiva en els termes descrits en aquestos Estatuts.",
      "old_article_refs" => []
    }
  ],
  "Article 18." => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el concepte \"Secretariat\" per \"Secretaria\", perquè no s'entenga com un òrgan diferenciat sinó com la funció estatutària no vinculada al gènere de qui l'exerceix.",
      "old_text" => "autorització presentada al Secretariat de l'Assemblea a l'inici de cada sessió",
      "draft_text" => "autorització presentada a la Secretaria de l'Assemblea a l'inici de cada sessió",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix la idea de reunió de l'Assemblea General per la de sessió, reservant el terme reunió per a la Junta Directiva i altres òrgans.",
      "old_text" => <<~TEXT.strip,
        1. L'Assemblea General es reunirà en sessions Ordinàries i Extraordinàries.

        Per a les sessions en que es reunisca l'Assemblea General
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. L'Assemblea General celebrarà sessions ordinàries i extraordinàries.

        Per a les sessions que celebre l'Assemblea General
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 19. De les Assemblees Generals Ordinàries" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: concreta que hi haurà una sessió econòmica al primer trimestre i una sessió social al tercer trimestre, substitueix la idea que l'Assemblea General es reuneix per la formulació que celebra sessions, ajusta els ordres del dia mínims, incorpora com a primer punt l'aprovació de l'acta de la sessió anterior en les dues sessions, situa l'aprovació dels Comptes Anuals abans dels Pressupostos, elimina la modificació de quotes de l'ordre mínim, integra la censura de gestió dins l'aprovació de la Memòria d'activitats i adapta l'elecció ordinària al sistema de Junta Directiva completa.",
      "old_text" => <<~TEXT.strip,
        1. L'Assemblea General es reunirà amb caràcter ordinari dos vegades a l'any. La primera sessió haurà de celebrar-se entre els mesos de gener i febrer, i la segona entre juny i juliol.

        2. L'Ordre del Dia de la primera sessió de cada any de l'Assemblea comprendrà, almenys, els següents punts:
        a) Aprovar els pressupostos ordinaris proposats per la Junta Directiva.
        b) Aprovar els Comptes Anuals de la Societat presentats per la Junta Directiva.
        c) Aprovar o modificar les quotes que hagen de satisfer les Persones Associades, així com les derrames i altres aportacions extraordinàries proposades per la Junta Directiva.
        d) Precs i preguntes.

        3. L'Ordre del Dia de la segona sessió de cada any de l'Assemblea comprendrà, almenys, els següents punts:
        a) Aprovar o censurar la gestió i actuació de la Junta Directiva o dels seus membres
        b) Aprovar la Memòria d'activitats del darrer curs.
        c) Triar i cessar a la Presidència de la Junta Directiva, quan siga procedent de conformitat amb aquestos Estatuts.
        d) Precs i preguntes.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. L'Assemblea General celebrarà sessions ordinàries dos vegades a l'any. La primera sessió, denominada econòmica, haurà de celebrar-se al primer trimestre, i la segona sessió, denominada social, al tercer trimestre.

        2. L'Ordre del Dia de la sessió econòmica de l'Assemblea comprendrà, almenys, els següents punts:
        a) Aprovació de l'acta de la sessió anterior de l'Assemblea General.
        b) Aprovar els Comptes Anuals de la Societat presentats per la Junta Directiva.
        c) Aprovar els pressupostos ordinaris proposats per la Junta Directiva.
        d) Precs i preguntes.

        3. L'Ordre del Dia de la sessió social de l'Assemblea comprendrà, almenys, els següents punts:
        a) Aprovació de l'acta de la sessió anterior de l'Assemblea General.
        b) Aprovar la Memòria d'activitats del darrer curs.
        c) Triar i cessar la Junta Directiva, quan siga procedent de conformitat amb aquestos Estatuts.
        d) Precs i preguntes.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 20. De les Assemblees Generals Extraordinàries" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix la idea que l'Assemblea General es reuneix per la formulació que celebra sessions extraordinàries i precisa que no es pot alterar l'Ordre del Dia expressat en la convocatòria.",
      "old_text" => <<~TEXT.strip,
        1. L'Assemblea General es reunirà amb caràcter extraordinari quan així ho sol·licite la Presidència.

        2. Les Assemblees General Extraordinàries se convocaran dins dels 15 dies següents a la sol·licitud i s'hauran de celebrar necessàriament dins dels 30 dies naturals posteriors a la data de la sol·licitud.

        3. En les Assemblees Generals Extraordinàries no podran ser tractats més assumptes que els expressats en la Convocatòria.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. L'Assemblea General celebrarà sessió extraordinària quan així ho sol·licite la Presidència.

        2. Les sessions extraordinàries de l'Assemblea General es convocaran dins dels 15 dies següents a la sol·licitud i s'hauran de celebrar necessàriament dins dels 30 dies naturals posteriors a la data de la sol·licitud.

        3. En les Assemblees Generals Extraordinàries no es podrà alterar l'Ordre del Dia expressat en la Convocatòria.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 22. De la seua Constitució" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el concepte \"Secretariat\" per \"Secretaria\", perquè no s'entenga com un òrgan diferenciat sinó com la funció estatutària no vinculada al gènere de qui l'exerceix.",
      "old_text" => <<~TEXT.strip,
        1. Dirigiran la sessió la Presidència i el Secretariat de l'Assemblea General, assumint-se dita condició pels qui ho siguen de la Junta Directiva.

        2. El Secretariat redactarà l'Acta de cada reunió.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. Dirigiran la sessió la Presidència i la Secretaria de l'Assemblea General, assumint-se dita condició pels qui ho siguen de la Junta Directiva.

        2. La Secretaria redactarà l'Acta de cada sessió.
      TEXT
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: ajusta el procediment d'aprovació de l'Acta perquè al començament de cada sessió se sotmeta a aprovació la redacció de l'Acta de la sessió anterior, sense afectar l'executivitat dels acords ja adoptats.",
      "old_text" => "Al començament de cada reunió de l'Assemblea es llegirà l'Acta de la sessió anterior a fi de que s'aprove la seua redacció, sense perjuí de l'executivitat dels Acords que en aquella s'hi adoptaren.",
      "draft_text" => "Al començament de cada sessió de l'Assemblea es sotmetrà a aprovació la redacció de l'Acta de la sessió anterior, sense perjuí de l'executivitat dels Acords que en aquella s'hi adopten.",
      "old_article_refs" => []
    }
  ],
  "Article 23. Disposicions generals" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: simplifica la regla de votació de l'Assemblea General i deixa expressament que correspon un vot a cada Persona Associada present o representada.",
      "old_text" => "2. L'Assemblea General adopta els seus acords pel principi majoritari o de democràcia interna, corresponent un vot a cada Persona Associada present o representada.",
      "draft_text" => "2. En l'Assemblea General correspon un vot a cada Persona Associada present o representada.",
      "old_article_refs" => []
    }
  ],
  "Article 24. De la Convocatòria de les Assemblees Generals" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: actualitza el règim de convocatòria de les Assemblees Generals, incorpora canals electrònics, precisa el còmput del termini de quinze dies i manté la publicitat interna i la possibilitat de segona convocatòria.",
      "old_text" => <<~TEXT.strip,
        Artículo 22.- De su Convocatoria.- Las convocatorias de las Asambleas Generales se cursarán por el Presidente, y serán hechas por escrito, expresando lugar, día y hora donde deban celebrarse, así como el orden del día. Se hará público en el Tablón de Anuncios de la Entidad y además deberá distribuirse, en mano o por correo, o por otros medios técnicos e informáticos al domicilio de cada socio que conste en el Libro Registro de la Asociación.

        Deberá mediar al menos un plazo de quince días entre la convocatoria de la Asamblea y su celebración.

        En el propio escrito podrá citarse de segunda convocatoria, debiendo mediar media hora, como mínimo, entre la primera y segunda convocatoria, y en el mismo lugar.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. Les Convocatòries de les Assemblees Generals es cursaran per la Presidència, excepte en els casos en què expressament aquestos Estatuts disposen altra cosa, i seran fetes per escrit, incloent-hi el correu electrònic o altres canals electrònics habilitats per la Societat, expressant-s’hi el lloc, el dia i l’hora en què se celebraran, així com l’Ordre del Dia.

        2. Haurà de mediar, almenys, un termini de quinze dies des del dia següent a la data en què es publicara la convocatòria de l’Assemblea General i fins a la data de la seua celebració, incloent-hi aquesta última en el termini descrit.

        3. Les Convocatòries es faran públiques al Tauler d’Anuncis de la Societat, a més de distribuir-se en mà, per correu postal, per correu electrònic o per altres mitjans tècnics i informàtics a cada Persona Associada que conste al Llibre Registre de la Societat.

        4. En l’escrit de convocatòria podrà citar-se una segona convocatòria, havent de mediar mitja hora com a mínim entre la primera i la segona Convocatòria, i havent de celebrar-se al mateix lloc.
      TEXT
      "old_article_refs" => [22]
    }
  ],
  "Article 24. De l’adopció dels Acords" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: precisa que la majoria simple de l'Assemblea General es calcula sobre les Persones Associades presents i les representades vàlidament.",
      "old_text" => "1. Els Acords de l'Assemblea General s'adoptaran en general per majoria simple de les Persones Associades presents quan els vots afirmatius superen als negatius, excepte en aquells casos en que els presents Estatuts determinen altra cosa.",
      "draft_text" => "1. Els Acords de l'Assemblea General s'adoptaran en general per majoria simple de les Persones Associades presents i representades vàlidament quan els vots afirmatius superen als negatius, excepte en aquells casos en que els presents Estatuts determinen altra cosa.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix \"majoria absoluta\" per \"majoria qualificada\" per unificar la terminologia amb la redacció de la llei d'associacions, i la calcula sobre els vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot.",
      "old_text" => "2. Requeriran de majoria absoluta, que resultarà quan els vots afirmatius superen la mitat dels vots emesos, els següents assumptes:",
      "draft_text" => "2. Requeriran de majoria qualificada, que resultarà quan els vots afirmatius superen la meitat dels vots emesos per les Persones Associades presents o representades vàlidament amb dret de vot, els següents assumptes:",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: limita l'exigència de convocatòria específica als Acords relatius a la modificació de l'articulat dels Estatuts i als esmentats al capítol 4 del títol V.",
      "old_text" => "3. En qualsevol cas, els Acords relatius als punts esmentats a l'apartat anterior requeriran que s'haja convocat específicament amb tal objecte l'Assemblea General corresponent.",
      "draft_text" => "3. En qualsevol cas, els Acords relatius al punt d) de l'apartat anterior i als esmentats al capítol 4 del títol V requeriran que s'haja convocat específicament amb tal objecte l'Assemblea General corresponent.",
      "old_article_refs" => []
    }
  ],
  "Article 31. De la composició de la Junta Directiva" => [
    {
      "kind" => "addition",
      "summary" => "Canvi nou al borrador: incorpora la Vicetresoreria com a càrrec facultatiu de la Junta Directiva, junt amb les Vicepresidències i la Vicesecretaria.",
      "old_text" => "Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, i amb una Vicesecretaria.",
      "draft_text" => "Amb caràcter facultatiu, podran comptar amb una o fins a tres Vicepresidències, amb una Vicesecretaria i amb una Vicetresoreria.",
      "old_article_refs" => []
    }
  ],
  "Article 32. Del règim orgànic i funcional de la Junta Directiva" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix la referència al Balanç i Compte de Resultats per la formulació més completa de Comptes Anuals, i elimina la repetició final de l'Assemblea General.",
      "old_text" => "c) Presentar a l'Assemblea General el Balanç i Compte de Resultats de cada exercici a l'Assemblea General.",
      "draft_text" => "c) Presentar a l'Assemblea General els Comptes Anuals de cada exercici.",
      "old_article_refs" => []
    },
    {
      "kind" => "addition",
      "summary" => "Canvi nou al borrador: trasllada a la Junta Directiva la competència de contractar o acomiadar el personal de l'Escola a proposta de l'Equip Directiu de l'Escola, perquè és una decisió laboral i econòmica que encaixa millor en l'òrgan de govern que en una facultat directa de la Presidència.",
      "old_text" => "",
      "draft_text" => "h) Contractar o acomiadar al personal de l'Escola a proposta de l'Equip Directiu de l'Escola.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Justificació: substitueix la delegació genèrica de facultats de la Junta Directiva per encomanes concretes de gestió, representació, administració, coordinació o suport. La redacció permet encarregar tasques pràctiques a Persones Associades, comissions, Persones Delegades, persones col·laboradores o professionals, però impedeix que l'encomana substituïsca la decisió de la Junta Directiva o permeta exercir competències reservades a l'Assemblea General.",
      "old_text" => "La Junta Directiva podrà delegar o apoderar en favor d’una o diverses Persones Associades part de les seues facultats i funcions, així com revocar-les.",
      "draft_text" => "La Junta Directiva podrà encomanar a Persones Associades, comissions, Persones Delegades, persones col·laboradores o terceres persones, quan resulte necessari, tasques concretes de gestió, representació, administració, coordinació o suport vinculades a les seues funcions.",
      "old_article_refs" => []
    },
    {
      "kind" => "addition",
      "summary" => "Justificació: introdueix una garantia de participació artística abans de nomenar o separar Direccions tècnic-artístiques de les Agrupacions Artístiques Titulars, exigint escoltar la Comissió Mixta d'Agrupacions o les Persones Delegades de l'agrupació afectada quan la naturalesa de la decisió ho permeta, sense convertir la decisió en un procés assembleari rígid ni desconèixer la normativa laboral o la confidencialitat aplicable.",
      "old_text" => "",
      "draft_text" => "En el cas de les Direccions tècnic-artístiques de les Agrupacions Artístiques Titulars, la Junta Directiva haurà d’escoltar prèviament la Comissió Mixta d’Agrupacions o les Persones Delegades de l’Agrupació afectada, sempre que la naturalesa de la decisió ho permeta, sense perjudici de la normativa laboral i de la confidencialitat que corresponga.",
      "old_article_refs" => []
    }
  ],
  "Article 33. De la Presidència" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: suprimeix de les competències directes de la Presidència la contractació o acomiadament del personal de l'Escola, perquè aquesta competència es trasllada a la Junta Directiva en l'article 32.",
      "old_text" => "e) Contractar o acomiadar al personal de l'Escola a proposta de l'Equip Directiu de l'Escola.",
      "draft_text" => "La competència es trasllada a l'article 32 com a funció de la Junta Directiva.",
      "old_article_refs" => []
    }
  ],
  "Article 34. De la Vicepresidència" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el concepte \"Secretariat\" per \"Secretaria\", perquè no s'entenga com un òrgan diferenciat sinó com la funció estatutària no vinculada al gènere de qui l'exerceix.",
      "old_text" => "assumirà les funcions descrites la persona que assumisca el Secretariat",
      "draft_text" => "assumirà les funcions descrites la persona que assumisca la Secretaria",
      "old_article_refs" => []
    }
  ],
  "Article 35. De la Secretaria" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: amplia la funció de la Secretaria perquè autoritze, junt amb la Presidència i quan corresponga, les convocatòries, citacions i comunicacions formals de la Societat.",
      "old_text" => "b) Autoritzar les citacions.",
      "draft_text" => "b) Autoritzar, junt amb la Presidència, les convocatòries, citacions i comunicacions formals de la Societat quan corresponga.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix la referència als títols socials per una formulació més clara sobre certificacions, credencials i documents acreditatius expedits per la Societat.",
      "old_text" => "e) Autoritzar els títols socials.",
      "draft_text" => "e) Autoritzar les certificacions, credencials o documents acreditatius expedits per la Societat.",
      "old_article_refs" => []
    }
  ],
  "Article 36. De la Vicesecretaria" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: corregeix la substitució supletòria de la Vicesecretaria i atribueix la designació alternativa a la Junta Directiva.",
      "old_text" => "En el supòsit de no haver designat cap Vicepresidència, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Presidència de la Junta Directiva.",
      "draft_text" => "En el supòsit de no haver designat cap Vicesecretaria, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Junta Directiva.",
      "old_article_refs" => []
    }
  ],
  VICETRESORERIA_TITLE => [
    {
      "kind" => "addition",
      "summary" => "Canvi nou al borrador: incorpora la Vicetresoreria com a càrrec facultatiu amb funcions de substitució i suport a la Tresoreria, adaptant el mateix esquema previst per a la Vicesecretaria.",
      "old_text" => "",
      "draft_text" => <<~TEXT.strip,
        La persona que, en el seu cas, assumisca la Vicetresoreria substituirà a la Tresoreria per raons justificades de malaltia, absència i/o impossibilitat, quan concórreguen les causes previstes a l'Article 31.3 apartats a) o c), o per delegació expressa de la Tresoreria, sense perjuí d'ulteriors delegacions o apoderaments per part d'altres components de la Junta Directiva.

        En el supòsit de no haver designat cap Vicetresoreria, assumirà les funcions descrites la Vocalia de major edat o altra persona designada per la Junta Directiva.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 40. Dels casos de substitució" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el concepte \"Secretariat\" per \"Secretaria\" i incorpora la Vicetresoreria al règim de substitucions, perquè quede alineat amb la nova composició facultativa de la Junta Directiva.",
      "old_text" => "les Vocalies supliran pel seu ordre, si n'hi haguera, o, en el seu defecte, per ordre d'edat, a la Presidència, al Secretariat i/o a la Tresoreria respectivament.",
      "draft_text" => "Sense perjuí del que es disposa per a la Vicepresidència, la Vicesecretaria i la Vicetresoreria, les Vocalies supliran pel seu ordre, si n'hi haguera, o, en el seu defecte, per ordre d'edat, a la Presidència, a la Secretaria i/o a la Tresoreria respectivament.",
      "old_article_refs" => []
    }
  ],
  "Article 42. De la responsabilitat de la Junta Directiva de la seua gestió front a l’Assemblea General" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: en el vot de censura, substitueix la sol·licitud de convocatòria de reunió extraordinària per convocatòria de sessió extraordinària de l'Assemblea General.",
      "old_text" => "en l'escrit de sol·licitud de convocatòria de reunió extraordinària",
      "draft_text" => "en l'escrit de sol·licitud de convocatòria de sessió extraordinària",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix \"majoria absoluta\" per \"majoria qualificada\" per unificar la terminologia amb la redacció de la llei d'associacions.",
      "old_text" => "El vot de censura s'entendrà aprovat quan vote a favor d'aquest la majoria absoluta de les persones presents amb dret a vot de l'Assemblea General.",
      "draft_text" => "El vot de censura s'entendrà aprovat quan vote a favor d'aquest la majoria qualificada de les persones presents amb dret a vot de l'Assemblea General.",
      "old_article_refs" => []
    },
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: adapta el vot de confiança i el vot de censura al sistema de Junta Directiva escollida per llista tancada. Si cau la confiança, s'ha de triar una nova Junta Directiva completa; si es proposa censura, ha d'anar acompanyada d'una candidatura completa alternativa amb càrrecs assignats.",
      "old_text" => <<~TEXT.strip,
        La confiança quedava revocada en la Presidència de la Junta Directiva i es convocava sessió per a triar la nova Presidència de la Junta Directiva.

        El vot de censura havia d'incloure una nova candidatura a la Presidència i als restants càrrecs de la Junta Directiva.
      TEXT
      "draft_text" => <<~TEXT.strip,
        La confiança queda revocada en la Junta Directiva i es convoca sessió per a triar una nova Junta Directiva.

        El vot de censura haurà d'incloure una candidatura completa de Junta Directiva en llista tancada, amb indicació de les persones que la integren i del càrrec que desenvoluparà cadascuna.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 47. Del funcionament de les Assemblees de Músics" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el concepte \"Secretariat\" per \"Secretaria\", perquè no s'entenga com un òrgan diferenciat sinó com la funció estatutària no vinculada al gènere de qui l'exerceix.",
      "old_text" => "La Persona Delegada de menys edat d'entre les que ho foren en eixe moment exercirà el Secretariat de l'Assemblea de Músics.",
      "draft_text" => "La Persona Delegada de menys edat d'entre les que ho foren en eixe moment exercirà la Secretaria de l'Assemblea de Músics.",
      "old_article_refs" => []
    }
  ],
  "Article 48. Dels Dictàmens de l’Assemblea de Músics" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix \"majoria absoluta\" per \"majoria qualificada\" per unificar la terminologia amb la redacció de la llei d'associacions.",
      "old_text" => "hauran de ser aprovats per majoria absoluta d'entre les persones assistents a la sessió.",
      "draft_text" => "hauran de ser aprovats per majoria qualificada d'entre les persones assistents a la sessió.",
      "old_article_refs" => []
    }
  ],
  "Article 68. Definició i finalitats de l’Arxiu" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: reformula l'antic arxiu musical com a Arxiu de la Societat i centre de documentació del patrimoni musical, artístic, educatiu, social i institucional. La redacció manté una estructura sostenible com a servei intern, però amplia la protecció patrimonial per incloure fons, col·leccions, donacions, llegats, depòsits i documents amb valor històric o permanent.",
      "old_text" => <<~TEXT.strip,
        El Archivero tendrá a su cargo el Archivo Musical, cuya conservación y fomento procurará por todos los medios. Llevará un índice de las obras musicales, que constituyan el archivo en el que constará, el título, clase, procedencia y fecha de adquisición, especificando en el índice si tienen o no partitura y el número de papeles de que consta.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. L’Arxiu de la Societat és el servei intern destinat a reunir, ordenar, descriure, inventariar, conservar i preservar el patrimoni documental de la Societat, siga quina siga la seua data, forma o suport, i a catalogar-lo quan corresponga.

        2. L’Arxiu actua també com a centre de documentació del patrimoni musical, artístic, educatiu, social i institucional de la Societat, i podrà facilitar-ne la consulta, l’estudi i la difusió quan corresponga.

        3. Formen part de l’Arxiu els fons, col·leccions i documents produïts, rebuts, adquirits, donats, llegats, cedits en depòsit o conservats per la Societat que tinguen valor històric, musical, artístic, educatiu, social, institucional o administratiu permanent.

        4. L’Arxiu tindrà com a finalitats principals preservar la memòria històrica de la Societat, donar suport a la seua activitat ordinària, afavorir la investigació i la difusió cultural, i garantir la transmissió del seu patrimoni documental a les generacions futures.
      TEXT
      "old_article_refs" => [36]
    }
  ],
  "Article 69. De la conservació i gestió de l’Arxiu" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: desenvolupa la gestió de l'Arxiu amb quatre fons o seccions documentals, criteris tècnics bàsics, una coordinació flexible i un règim d'accés compatible amb la protecció de dades, la propietat intel·lectual, la confidencialitat i la conservació dels materials. Això permet treballar el patrimoni de la Societat amb ambició cultural sense imposar una estructura professionalitzada o insostenible.",
      "old_text" => <<~TEXT.strip,
        El Archivero tendrá a su cargo el Archivo Musical, cuya conservación y fomento procurará por todos los medios. Llevará un índice de las obras musicales, que constituyan el archivo en el que constará, el título, clase, procedencia y fecha de adquisición, especificando en el índice si tienen o no partitura y el número de papeles de que consta.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. L’Arxiu s’organitzarà, preferentment, en els següents fons o seccions documentals:

        a) El fons musical, artístic i audiovisual, format per partitures, arranjaments, particel·les, enregistraments sonors i audiovisuals, documentació de repertori, programes de mà, cartells, fotografies, materials de difusió i altres documents vinculats a l’activitat artística de la Societat.

        b) El fons social i institucional, format per actes, estatuts històrics, llibres i registres socials, correspondència institucional, documentació econòmica i administrativa amb valor històric o permanent, premsa, publicacions i altra documentació relativa a la vida associativa de la Societat.

        c) El fons educatiu i pedagògic, format per documentació històrica o permanent vinculada a l’Escola, al seu projecte educatiu, planificació educativa, programacions, activitats formatives, materials pedagògics, memòries i altres documents relacionats amb la formació artística desenvolupada per la Societat.

        d) El fons de memòria social i oral, format per testimonis orals, entrevistes, relats biogràfics, llegats personals, col·leccions familiars i altres materials no estrictament artístics que contribuïsquen a preservar la memòria humana, social i institucional de la Societat.

        2. La Junta Directiva vetlarà per la conservació, ordenació i gestió adequada de l’Arxiu, d’acord amb criteris tècnics, de seguretat, conservació, procedència, integritat dels fons, eficiència, accessibilitat i preservació digital.

        3. La Junta Directiva podrà encomanar la coordinació de l’Arxiu a la Secretaria, a una vocalia, a una comissió o a una persona responsable designada a aquest efecte, i podrà comptar amb la col·laboració de Persones Associades, persones voluntàries, personal contractat, persones en pràctiques o professionals amb formació adequada.

        4. L’accés i consulta dels fons podrà facilitar-se a les Persones Associades i, quan siga procedent, a persones investigadores o entitats externes, amb respecte en tot cas a la normativa de protecció de dades personals, propietat intel·lectual, confidencialitat, conservació dels materials, seguretat dels fons i altres límits legalment aplicables.

        5. La Junta Directiva podrà aprovar un Reglament de l’Arxiu de la Societat, que desenvolupe el règim d’ingrés de materials, descripció, inventari, catalogació, conservació, digitalització, consulta, reproducció, préstec, difusió, eliminació o expurgació quan procedisca, i ús dels fons.
      TEXT
      "old_article_refs" => [36]
    }
  ],
  "Article 65. De les agrupacions i conjunts de l’Escola" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: substitueix la remissió genèrica al procediment que reglamentàriament determine la Junta Directiva per un procediment treballat en la Comissió Mixta d'Agrupacions i aprovat per Resolució de la Junta Directiva a proposta d'aquesta, perquè la incorporació de l'alumnat de l'Escola a les Agrupacions Artístiques Titulars es coordine amb l'espai mixt creat pels Estatuts.",
      "old_text" => "L’alumnat de l’Escola, quan reunisca les condicions d’aptitud suficients d’acord amb el criteri de la Direcció tècnic-artística i del professorat corresponent, i, si escau, seguint el procediment que reglamentàriament determine la Junta Directiva, podrà incorporar-se a les Agrupacions Artístiques Titulars.",
      "draft_text" => "L’alumnat de l’Escola, quan reunisca les condicions d’aptitud suficients d’acord amb el criteri de la Direcció tècnic-artística i del professorat corresponent, podrà incorporar-se a les Agrupacions Artístiques Titulars d’acord amb el procediment que, si escau, siga treballat en la Comissió Mixta d’Agrupacions i aprovat per Resolució de la Junta Directiva a proposta d’aquesta.",
      "old_article_refs" => []
    }
  ],
  "Article 78. De la responsabilitat disciplinària a la Societat" => [
    {
      "kind" => "addition",
      "summary" => "Justificació: aclareix que el personal contractat per la Societat es regeix pel règim laboral aplicable, inclosos l'Estatut dels Treballadors, els convenis col·lectius i la normativa laboral, i que el règim disciplinari estatutari no substitueix el règim disciplinari laboral.",
      "old_text" => "",
      "draft_text" => "El personal contractat per la Societat es regirà pel règim laboral aplicable, inclosos l’Estatut dels Treballadors, els convenis col·lectius i la resta de normativa laboral. Les previsions d’aquest títol no substituiran el règim disciplinari laboral, sense perjudici que una persona contractada que també siga Persona Associada puga quedar subjecta al règim disciplinari estatutari pels fets comesos en aquesta condició i en l’àmbit associatiu.",
      "old_article_refs" => []
    }
  ],
  "Article 84. De les faltes greus" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: reordena com a faltes greus conductes ja previstes en els Estatuts vigents sobre inassistència o puntualitat als assajos i actes, i sobre ús no autoritzat d'instruments o béns de la Societat, integrant-les en el nou règim disciplinari graduat.",
      "old_text" => <<~TEXT.strip,
        Artículo 48.- Las faltas de asistencia o puntualidad a los ensayos y a los actos de la Banda, sin previa justificación, serán sancionados por ésta que podrá a juicio de la Junta Directiva, acordar amonestaciones, imponer multas e incluso decidir su expulsión de la Banda.

        Artículo 49.- El uniforme y el instrumento que sean propiedad de la Asociación musical, se entregará al músico en calidad de depósito, y estarán siempre a disposición de la Junta Directiva, que podrá retirarlos cuando así lo acordare, en cuyo caso el músico que los tenga en depósito los entregará inmediatamente. Si así no lo hiciere incurrirá en las responsabilidades civiles o penales pertinentes.

        Artículo 50.- Los músicos no podrán formar parte de otros conjuntos, bandas u orquestas, sin haber obtenido previamente la autorización de la Junta Directiva. Tampoco podrán utilizar para otros fines el instrumento propiedad de la Asociación si no es con carácter eventual y con autorización de la Junta Directiva.
      TEXT
      "draft_text" => <<~TEXT.strip,
        h) La inassistència, impuntualitat o abandonament injustificat d’actuacions, concerts, actes, desplaçaments, serveis, activitats o compromisos per als quals la Persona Associada haja confirmat o assumit la participació, quan cause un perjudici rellevant a l’Agrupació, a l’Escola, a la Societat o a terceres persones.

        i) L’ús no autoritzat o contrari a les condicions de cessió, la mala custòdia, l’alteració, la cessió a terceres persones, la retenció injustificada o la no devolució d’instruments, material, uniformes, documents, claus, credencials, instal·lacions o altres béns de la Societat, quan no constituïsca falta molt greu.
      TEXT
      "old_article_refs" => [48, 49, 50]
    }
  ],
  "Article 66. Del règim orgànic, funcional i disciplinari de l’Escola" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: actualitza el règim orgànic, funcional i disciplinari de l’Escola, precisa que les normes afecten l’alumnat i manté que siguen proposades per la Direcció de l’Escola i aprovades per la Junta Directiva mitjançant Resolució.",
      "old_text" => "Artículo 43.- La Escuela de Música se regirá por unas normas de organización, funcionamiento y disciplina que propuestas por la Dirección de la Escuela, serán aprobadas por la Junta Directiva.",
      "draft_text" => "L’Escola es regirà per unes normes d’organització, funcionament i disciplina de l’alumnat que, proposades per la Direcció de l’Escola, seran aprovades per la Junta Directiva mitjançant Resolució.",
      "old_article_refs" => [43]
    }
  ],
  "Article 89. Del règim disciplinari de les persones que componen la Junta Directiva" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: reformula el règim disciplinari de les persones que componen la Junta Directiva perquè l'obertura i la resolució corresponguen a l'Assemblea General, s'aplique expressament el règim d'abstenció de l'article 75, la instrucció quede separada mitjançant Comissió Instructora o persona instructora externa, i l'obertura de l'expedient no comporte cessament automàtic sinó, si escau, suspensió cautelar motivada.",
      "old_text" => <<~TEXT.strip,
        Només podrà obrir-se expedient disciplinari front a les persones que composen la Junta Directiva quan així ho acorde l'Assemblea General per majoria absoluta d'entre les persones assistents a la sessió.

        Quan es fera front a les persones que ocupen els càrrecs distints a la Presidència i la Secretaria, l'apertura d'expedient disciplinari comportarà el seu cessament per part de la Presidència de la Junta Directiva i el seguiment del procediment ordinari establert reglamentàriament.

        Quan es fera front a les persones que ocupen els càrrecs de la Presidència o la Secretaria, l'expedient serà instruït per una Comissió Instructora designada per majoria absoluta en la sessió de l'Assemblea General. Correspondrà la resolució de l'expedient a l'Assemblea General.
      TEXT
      "draft_text" => <<~TEXT.strip,
        L'obertura d'un expedient disciplinari contra una persona que compose la Junta Directiva haurà de ser acordada per l'Assemblea General per majoria qualificada.

        En aquests supòsits s'aplicarà el règim d'abstenció previst en l'article 75 d'aquestos Estatuts, especialment respecte de la deliberació i votació dels Acords d'obertura, suspensió cautelar i resolució de l'expedient.

        La instrucció correspondrà a una Comissió Instructora formada per tres Persones Associades o, si no fora possible constituir-la, a una persona instructora externa i independent.

        L'obertura de l'expedient no comportarà per si mateixa el cessament en el càrrec, sense perjudici de la possible suspensió cautelar motivada. La resolució correspondrà a l'Assemblea General.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 103. De les causes de dissolució" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix \"majoria absoluta\" per \"majoria qualificada\" en l'acord de dissolució per unificar la terminologia amb la redacció de la llei d'associacions.",
      "old_text" => "a) Per Acord de l'Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria absoluta de les Persones Associades assistents amb dret a vot.",
      "draft_text" => "a) Per Acord de l'Assemblea General, convocada expressament per a aquesta finalitat i amb el vot favorable de la majoria qualificada de les Persones Associades assistents amb dret a vot.",
      "old_article_refs" => []
    }
  ],
  "Article 37. De la Tresoreria" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: actualitza les funcions de Tresoreria, les vincula a pressupostos, comptabilitat, inventari i control econòmic, i precisa que la Tresoreria prepara els Comptes Anuals perquè la Junta Directiva els presente a l'Assemblea General per a la seua aprovació.",
      "old_text" => <<~TEXT.strip,
        Artículo 34.- El Tesorero llevará la gestión económico-financiera de la Entidad, y en especial, su contabilidad, tanto de ingresos como de gastos. Confeccionar, junto con el Secretario, el proyecto de Presupuesto anual, y presentar las Cuentas Generales y Balance de cada anualidad, para ser sometida a la Asamblea General previa aprobación de la Junta Directiva. Le corresponde así mismo custodiar los fondos de la Asociación, el control de los ingresos y los gastos, autorizando los correspondientes libramientos y llevar los libros de Caja, el control de saldos bancarios, de préstamos y su amortización, cuotas sociales, etc., y en general, todo lo referente a la llevanza, fiscalización y control de la gestión económica de la Sociedad y la rendición de cuentas correspondientes.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. La persona que assumisca la Tresoreria estarà al capdavant de la gestió econòmic-financera de la Societat. En general, li correspon tot allò referent a la gestió, fiscalització i control econòmic de la Societat i la rendició dels comptes corresponents.

        2. En qualsevol cas i en particular, sense perjuí d’ulteriors delegacions o apoderaments en altres components de la Junta Directiva, li correspon:

        a) Gestionar la comptabilitat de la Societat; confeccionar tècnicament el projecte de Pressupost anual d’acord amb l’article 97; sol·licitar els antecedents necessaris de les distintes seccions del Pressupost; i preparar els Comptes Anuals perquè la Junta Directiva els presente a l’Assemblea General per a la seua aprovació.

        b) Custodiar els recursos econòmics de la Societat.

        c) Efectuar el control intern dels ingressos i despeses de la Societat; en els termes previstos per aquestos Estatuts, autoritzar els corresponents lliuraments, dur els Llibres de Caixa i controlar els saldos bancaris, les quotes socials, derrames i altres aportacions extraordinàries i, si escau, els préstecs i la seua amortització.

        d) Controlar l’Inventari de béns de la Societat.

        e) Totes aquelles funcions i competències que li corresponen d’acord amb aquestos Estatuts.
      TEXT
      "old_article_refs" => [34]
    }
  ],
  "Article 68. De les obligacions comptables i documentals" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: reubica en el nou Article 68 el contingut de l'antic Article 7 sobre obligacions documentals i comptables, l'actualitza a la normativa vigent i precisa que el Llibre d'Actes recull sessions o reunions segons l'òrgan de què es tracte.",
      "old_text" => <<~TEXT.strip,
        Articulo 7.- De las obligaciones documentales y contables.- La Asociación deberá disponer necesariamente de los siguientes documentos:

        a) Relación actualizada de los asociados; b) Contabilidad, que permita obtener la imagen de su patrimonio, del resultado y de su situación financiera, así como las actividades realizadas; c) Inventario de sus bienes, d) Libro de Actas de las reuniones de sus órganos de gobierno y representación; e) Presupuesto y liquidación anual.
      TEXT
      "draft_text" => <<~TEXT.strip,
        La Societat haurà de disposar necessàriament dels següents documents:

        a) Relació actualitzada de les Persones Associades i de les Joventuts al Llibre Registre.

        b) Comptabilitat, d’acord amb els principis comptables aplicables i la normativa vigent, que permetrà obtindre la imatge fidel del seu patrimoni, del resultat i de la seua situació financera, així com el seguiment cronològic de les operacions realitzades.

        c) Inventari dels seus béns.

        d) Llibre d’Actes de les sessions o reunions dels seus òrgans de govern i representació.

        e) Pressupostos i liquidacions anuals.
      TEXT
      "old_article_refs" => [7]
    }
  ],
  "Article 76. De la revisió interna de les Resolucions de la Junta Directiva" => [
    {
      "kind" => "modification",
      "summary" => "Canvi nou al borrador: substitueix el recurs d'alçada davant l'Assemblea General per una revisió interna davant la mateixa Junta Directiva, que haurà de dictar una nova Resolució motivada.",
      "old_text" => "Contra les Resolucions de la Junta Directiva cap la interposició de l'oportú recurs d'alçada que arribe a l'Assemblea General en un termini de 30 dies des de la notificació de la Resolució o Resolucions de que es tracte.",
      "draft_text" => <<~TEXT.strip,
        Les Persones Associades podran sol·licitar la revisió interna de les Resolucions de la Junta Directiva davant la mateixa Junta Directiva per correu electrònic, formulari electrònic o altres canals habilitats per la Societat, en el termini de 30 dies des de la notificació.

        La Junta Directiva haurà de revisar la Resolució impugnada i dictar una nova Resolució motivada, sense perjudici de la possibilitat de promoure una Assemblea General Extraordinària en els termes estatutaris o d'exercir directament les accions d'impugnació davant l'ordre jurisdiccional civil.
      TEXT
      "old_article_refs" => []
    }
  ],
  "Article 86. De les sancions per faltes molt greus" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: substitueix la previsió genèrica de baixa per sanció disciplinària i expulsió per un règim graduat de sancions per faltes molt greus, amb expulsió, inhabilitació temporal, suspensió temporal de drets i ratificació assembleària de l'expulsió.",
      "old_text" => <<~TEXT.strip,
        Articulo 14.- Causas de baja y pérdida de la condición de socio.- Son causa de baja de la Asociación:

        5ª.- Por sanción disciplinaria, previo expediente regulado bajo los principios de presunción de inocencia, inmediación, audiencia y contradicción.

        El acuerdo de expulsión o separación será adoptado por la Junta Directiva, en resolución motivada, que será notificada por escrito al sancionado, previo expediente disciplinario y audiencia del interesado.
      TEXT
      "draft_text" => <<~TEXT.strip,
        Per raó de les faltes molt greus comeses es podran imposar les següents sancions:

        a) Expulsió de la Societat i pèrdua de la condició de Persona Associada, amb impossibilitat de readmissió durant un període de 4 a 8 anys.

        b) Inhabilitació per a ocupar càrrecs socials durant un període de 4 a 8 anys.

        c) Suspensió dels drets corresponents a les Persones Associades durant un període d’1 a 2 anys.

        L’expulsió de la Societat requerirà, en tot cas, ratificació de l’Assemblea General.
      TEXT
      "old_article_refs" => [14]
    }
  ],
  "Article 102. Del procediment de modificació dels Estatuts" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: desenvolupa el règim anterior de modificació estatutària, que atribuïa a l'Assemblea General l'aprovació i modificació dels Estatuts i exigia majoria qualificada i convocatòria específica, incorporant un procediment previ de participació, debat i esmenes, compatible tant amb canals electrònics com presencials o en paper, i garantint almenys una via no digital amb suport bàsic.",
      "old_text" => <<~TEXT.strip,
        Articulo 20.- De las competencias de la Asamblea General.- Son funciones y competencias de la Asamblea General, las siguientes:

        a) Aprobar y modificar los Estatutos.

        Articulo 24.- De los acuerdos y votaciones.- Los acuerdos de las Asambleas Generales se adoptaran por mayoría simple de los socios presentes, cuando los votos afirmativos superen a los negativos. No obstante, requerirán mayoria cualificada de las personas presentes, que resultará cuando los votos afirmativos superen la mitad de los votos emitidos, para aquellos asuntos en que los acuerdos se refieran a disposición o enajenación de bienes inmuebles, solicitud de declaración de utilidad pública a favor de la Asociación, remuneración de los miembros del órgano de representación y modificación de los Estatutos, siempre que se haya convocado especificamente con tal objeto la Asamblea General correspondiente.
      TEXT
      "draft_text" => <<~TEXT.strip,
        1. La modificació dels Estatuts haurà de ser aprovada per l’Assemblea General convocada específicament amb aquesta finalitat, d’acord amb aquestos Estatuts i amb la normativa vigent aplicable.

        2. La proposta de modificació podrà ser presentada per Resolució de la Junta Directiva o per iniciativa conjunta d’un 10 per cent de les Persones Associades.

        3. Quan la proposta haja sigut presentada per iniciativa conjunta de Persones Associades, les persones promotores tindran dret a designar una persona representant per a defensar-la davant l’Assemblea General i en el procés previ de participació. La Junta Directiva haurà d’ordenar la tramitació del procés, sense perjudici que puga advertir motivadament les deficiències legals, estatutàries o tècniques que aprecie.

        4. La proposta inicial haurà d’anar acompanyada d’un calendari del procés, que indicarà, almenys, el termini de participació, els canals habilitats, la forma de publicitat interna de les esmenes, el moment previst per a la publicació de la proposta definitiva i la data o període previst per a la celebració de l’Assemblea General.

        5. Abans de la celebració de l’Assemblea General s’obrirà un període previ de participació, debat i presentació d’esmenes. Aquest període tindrà una durada mínima de 15 dies naturals, sense perjudici que la Junta Directiva puga establir un termini superior atenent la importància, extensió o complexitat de la modificació proposada.

        6. El procés podrà desenvolupar-se mitjançant plataforma electrònica de participació, formularis electrònics, correu electrònic, presentació presencial, documentació en paper o altres canals habilitats per la Societat, garantint en tot cas la identificació de les Persones Associades participants, la constància de les esmenes presentades i la publicitat interna suficient del procés.

        7. Quan s’utilitzen canals electrònics de participació, la Societat haurà d’habilitar almenys una via no digital i suport bàsic perquè les Persones Associades que tinguen dificultats tecnològiques puguen conéixer la proposta i participar en el procés.
      TEXT
      "old_article_refs" => [20, 24]
    }
  ],
  "DISPOSICIÓ FINAL" => [
    {
      "kind" => "modification",
      "summary" => "Justificació: manté la regla d'entrada en vigor dels Estatuts, però precisa que l'eficàcia davant de terceres persones queda vinculada a la inscripció registral quan aquesta siga preceptiva.",
      "old_text" => <<~TEXT.strip,
        DISPOSICION FINAL
        Los presentes Estatutos entrarán en vigor desde la fecha de su aprobación y surtirán efecto frente a terceros desde su inscripción en el Registro de Asociaciones de la Comunidad Valenciana.
      TEXT
      "draft_text" => "Aquests Estatuts entraran en vigor des de la data de la seua aprovació per l’Assemblea General i tindran efectes davant de terceres persones des de la seua inscripció en el Registre d’Associacions de la Comunitat Valenciana quan aquesta siga preceptiva.",
      "old_article_refs" => []
    }
  ]
}.freeze

MANUAL_NOTE_REPLACEMENT_TITLES = [
  "Article 5. Del domicili",
  "Article 7. De la durada",
  "Article 8. De la normativa aplicable",
  "Article 9. De la interpretació dels Estatuts",
  "Article 11. Del Llibre Registre",
  "Article 24. De la Convocatòria de les Assemblees Generals",
  "Article 37. De la Tresoreria",
  "Article 66. Del règim orgànic, funcional i disciplinari de l’Escola",
  "Article 68. Definició i finalitats de l’Arxiu",
  "Article 69. De la conservació i gestió de l’Arxiu",
  "Article 68. De les obligacions comptables i documentals",
  "Article 86. De les sancions per faltes molt greus",
  "Article 102. Del procediment de modificació dels Estatuts",
  "DISPOSICIÓ FINAL"
].freeze

CURRENT_MANUAL_NOTE_TITLES = [
  "Article 7. De la durada",
  "Article 8. De la normativa aplicable",
  "Article 9. De la interpretació dels Estatuts",
  "Article 11. Del Llibre Registre",
  "Article 24. De la Convocatòria de les Assemblees Generals",
  "Article 66. Del règim orgànic, funcional i disciplinari de l’Escola",
  "Article 68. Definició i finalitats de l’Arxiu",
  "Article 69. De la conservació i gestió de l’Arxiu",
  "Article 84. De les faltes greus",
  "Article 86. De les sancions per faltes molt greus",
  "Article 102. Del procediment de modificació dels Estatuts"
].freeze

INTERNAL_DRAFT_NOTE_OLD_TEXTS = {
  "Article 29. De l’elecció de la Junta Directiva" => [
    "Quan només es presentara una única candidatura, la Junta Directiva podrà ser escollida en votació ordinària per braços alçats, sempre que cap Persona Associada present a la sessió es mostre contrària a aquest procediment de votació, cas en el qual es farà votació secreta per papereta. Quan hi haguera més d’una candidatura, l’elecció es farà sempre en votació secreta per papereta."
  ],
  "Article 32. Del règim orgànic i funcional de la Junta Directiva" => [
    "La Junta Directiva podrà delegar o apoderar en favor d’una o diverses Persones Associades part de les seues facultats i funcions, així com revocar-les."
  ],
  "Article 65. De les agrupacions i conjunts de l’Escola" => [
    "L’alumnat de l’Escola, quan reunisca les condicions d’aptitud suficients d’acord amb el criteri de la Direcció tècnic-artística i del professorat corresponent, i, si escau, seguint el procediment que reglamentàriament determine la Junta Directiva, podrà incorporar-se a les Agrupacions Artístiques Titulars."
  ]
}.freeze

NOTE_DRAFT_TEXT_REPLACEMENTS = {
  "Es constitueix l’Associació denominada Societat Joventut Musical d'Albal, d’ara en avant referida en aquestos Estatuts com «la Societat»." =>
    "Es constitueix l’Associació denominada Societat Joventut Musical d'Albal, d’ara en avant referida en aquestos Estatuts com “la Societat”, que es regirà pels presents Estatuts adaptats al que disposa la Llei Orgànica 1/2002, de 22 de març, reguladora del Dret d’Associació, acollida a la mencionada Llei i altra legislació aplicable, i a l’empara del que disposa l’article 22 de la Constitució Espanyola.",
  "altres components de la Junta Directiva" => "altres persones membres de la Junta Directiva",
  "L’accés i consulta dels fons" => "L’accés als fons i la seua consulta",
  "eliminació o expurgació quan procedisca, i ús dels fons." =>
    "eliminació o expurgació i ús dels fons. L’eliminació o expurgació de documentació haurà d’ajustar-se a criteris tècnics, terminis de conservació, valor històric o permanent, protecció de dades personals, propietat intel·lectual i la resta de límits legals aplicables.",
  "L’ús no autoritzat, la mala custòdia" => "L’ús no autoritzat o contrari a les condicions de cessió, la mala custòdia",
  "La presentació d’esmenes no requerirà suport mínim previ. No obstant això, perquè una esmena no incorporada al text proposat haja de ser sotmesa necessàriament a votació separada en l’Assemblea General, haurà d’obtindre el suport mínim previst en aquestos Estatuts." =>
    "La presentació d’esmenes no requerirà suport mínim previ. No obstant això, perquè una esmena no incorporada al text proposat haja de ser sotmesa necessàriament a votació separada en l’Assemblea General, haurà d’obtindre el suport registrat d’almenys el 10 per cent de les Persones Associades amb dret de vot, d’acord amb l’article 104.3 d’aquests Estatuts.",
  "El romanent net que resulte de la liquidació, si n’hi haguera, es destinarà a una entitat sense ànim de lucre o entitat pública que perseguisca finalitats culturals, musicals, educatives, socials o d’interés general anàlogues a les de la Societat, preferentment vinculada al municipi d’Albal o a la Comunitat Valenciana, d’acord amb el que determine l’Assemblea General i amb respecte a la normativa vigent aplicable." =>
    <<~TEXT.strip,
      El romanent net que resulte de la liquidació, si n’hi haguera, es destinarà, d’acord amb el que determine l’Assemblea General i amb respecte a la normativa vigent aplicable, prioritàriament a una altra societat musical del municipi d’Albal que perseguisca finalitats anàlogues a les de la Societat. Si no existira cap entitat d’aquestes característiques o cap d’elles poguera acceptar adequadament el romanent, es destinarà a una associació cultural, fundació, entitat pública o altra entitat sense ànim de lucre, en tots els casos vinculada al municipi d’Albal, que perseguisca finalitats musicals, culturals, educatives, socials o d’interés general anàlogues a les de la Societat.

      L’entitat destinatària haurà d’acceptar expressament que el romanent quede afectat, en la mesura que siga possible, a la conservació, promoció, ensenyament o pràctica de la música al municipi d’Albal. Quan el romanent incloga instruments, arxius, material musical o altres béns vinculats directament a l’activitat musical de la Societat, l’Acord de destinació procurarà que aquests béns romanguen al municipi d’Albal i continuen destinats a finalitats musicals, educatives o culturals.

      Quan el romanent no haja sigut destinat a una societat musical del municipi d’Albal i posteriorment es constituïra una nova societat musical al municipi amb finalitats anàlogues a les de la Societat, es promourà, sempre que siga legalment possible i d’acord amb les condicions acceptades per l’entitat destinatària, la cessió, transmissió o posada a disposició dels instruments, arxius, material musical o altres béns vinculats directament a l’activitat musical de la Societat a favor d’aquesta nova entitat.
    TEXT
  "la persona instructora o Comissió Instructora" => "la persona instructora o la Comissió Instructora",
  "Les Convocatòries de les Assemblees Generals se cursaran" => "Les Convocatòries de les Assemblees Generals es cursaran",
  "Les decisions i actes de l’Assemblea se materialitzaran" => "Les decisions i actes de l’Assemblea es materialitzaran",
  "que se delegue de manera expressa a la Junta Directiva" => "que es delegue de manera expressa a la Junta Directiva"
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
    article_text = normalize_ocr(source[start_index...end_index])
    article_text = article_text.sub(/\s*DISPOSICION FINAL.*\z/m, "") if number == 62
    articles[number] = article_text.strip
  end

  articles
end

def normalized_note(note)
  note.merge(
    "summary" => note.fetch("summary").sub(/\ACanvi nou al borrador:\s*/, "Justificació: ")
  )
end

def article_number(title)
  title.to_s[/\AArticle\s+(\d+)\./, 1]&.to_i
end

def previous_number_for_notes(number)
  return nil if number.blank?

  PREVIOUS_NUMBER_BY_CURRENT.fetch(number, nil)
end

def renumber_manual_title(title)
  return title.to_s if CURRENT_MANUAL_NOTE_TITLES.include?(title.to_s)

  title.to_s.sub(/\AArticle\s+(\d+)\./) do |match|
    number = Regexp.last_match(1).to_i
    next match if title == "Article 11. Del Llibre Registre"

    target = if number <= 7
               number
             elsif number == 67
               8
             elsif number == 68
               9
             elsif number == 8
               10
             elsif number.between?(9, 66)
               number + 3
             else
               number + 1
             end
    match.sub(number.to_s, target.to_s)
  end
end

def renumber_note_references(text)
  text.to_s
    .gsub("article 75", "article 76")
    .gsub("article 82", "article 83")
    .gsub("article 97", "article 99")
    .gsub("article 98", "article 99")
    .gsub("article 103", "article 105")
    .gsub("article 104", "article 105")
    .gsub("Article 65", "Article 66")
    .gsub("Article 68", "Article 69")
    .gsub("Article 76", "Article 77")
    .gsub("Article 78", "Article 79")
    .gsub("Article 89", "Article 90")
    .gsub("Article 103", "Article 104")
end

def highlighted_text(body)
  body.to_s.scan(%r{<span class="sjma-change-marker">(.*?)</span>}m).flatten.join("\n\n").strip
end

def justification_for(number, title, kind)
  previous_number = previous_number_for_notes(number)
  base = (previous_number && ARTICLE_JUSTIFICATIONS[previous_number]) || generic_justification_for(title, kind)

  renumber_note_references("Justificació: #{base}".gsub(/\s+/, " ").strip)
end

def normalized_manual_note(note)
  draft_text = renumber_note_references(normalized_note(note).fetch("draft_text", ""))
  NOTE_DRAFT_TEXT_REPLACEMENTS.each do |old_text, new_text|
    draft_text = draft_text.gsub(old_text, new_text)
  end

  normalized_note(note).merge(
    "summary" => renumber_note_references(normalized_note(note).fetch("summary")),
    "draft_text" => draft_text
  )
end

def generic_justification_for(title, kind)
  normalized = I18n.transliterate(title.to_s).downcase

  return "permet adaptar el redactat al valencià, al llenguatge inclusiu i a una estructura estatutària més ordenada." if normalized.match?(/\Aarticle\s+(1|2|3|4|6)\b/)
  return "ordena millor la regulació de drets, deures i participació de les persones associades." if normalized.match?(/persona associada|persones associades|drets|deures|baixa|ingres/)
  return "ordena millor les competències, convocatòries i acords de l'Assemblea General." if normalized.match?(/assemble|convocatoria|acord|constitucio/)
  return "adapta el funcionament de la Junta Directiva a una estructura més clara, flexible i responsable." if normalized.match?(/junta directiva|presidencia|vicepresidencia|secretaria|tresoreria|vocalies|interinitat|resolucions/)
  return "crea un canal específic per a la participació artística i la coordinació de les agrupacions musicals." if normalized.match?(/musics|delegades|dictamens|agrupacions|direccions tecnic/)
  return "ordena millor l'Escola, la Banda Simfònica i les seues relacions amb els òrgans socials." if normalized.match?(/escola|banda simfonica|pla d'estudis/)
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

Decidim::Proposals::Proposal.where(component: component, participatory_text_level: "article").order(:position).each do |proposal|
  title = proposal.title.fetch("ca")

  number = article_number(title)
  changed_text = highlighted_text(proposal.body.fetch("ca", ""))
  previous_number = previous_number_for_notes(number)
  mapped_old_refs = previous_number ? OLD_ARTICLE_MAP.fetch(previous_number, []) : []
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

MANUAL_NOTE_REPLACEMENT_FINAL_TITLES = MANUAL_NOTE_REPLACEMENT_TITLES.map { |title| renumber_manual_title(title) }.freeze

MANUAL_NOTES.each do |title, article_notes|
  final_title = renumber_manual_title(title)
  final_notes = article_notes.reject do |note|
    note.fetch("summary").start_with?("Canvi nou al borrador:") ||
      INTERNAL_DRAFT_NOTE_OLD_TEXTS.fetch(title, []).include?(note["old_text"])
  end
  next if final_notes.empty?

  normalized_notes = final_notes.map { |note| normalized_manual_note(note) }

  if MANUAL_NOTE_REPLACEMENT_FINAL_TITLES.include?(final_title)
    notes[final_title] = normalized_notes
  else
    notes[final_title] ||= []
    notes[final_title].concat(normalized_notes)
  end
end

valid_article_titles = Decidim::Proposals::Proposal
  .where(component: component, participatory_text_level: "article")
  .pluck(:title)
  .filter_map { |title_hash| title_hash["ca"] || title_hash[:ca] }
  .to_set

notes.select! do |title, _article_notes|
  !title.start_with?("Article ") || valid_article_titles.include?(title)
end

notes = notes.sort_by { |title, _article_notes| article_number(title) || 10_000 }.to_h

OUTPUT_PATH.write(
  {
    "articles" => notes
  }.to_yaml(line_width: 120)
)

puts "Wrote #{notes.size} article note groups to #{OUTPUT_PATH}"
