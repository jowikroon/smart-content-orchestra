---
title: "Prompt Optimalisatie Bestandsbeheer"
type: source
scope: [HVL, CCP, MPG]
status: active
created: 2026-10-09
last_reviewed: 2026-10-14
aliases: []
tags: [drive, bestandsbeheer, metadata, naamconventie]
sources: []
source: drive-bridge
source_kind: article
source_url: "https://docs.google.com/document/d/1iXwvJBQSHOo40J_jYIGyKfIn-ynTVZ95LBGtoCUcQiY/edit"
drive_id: "1iXwvJBQSHOo40J_jYIGyKfIn-ynTVZ95LBGtoCUcQiY"
ai_generator: gemini
ingested_from: _connector/bridge/inbox/drive/2026-10-09_ai_prompt-optimalisatie-bestandsbeheer.md
ingested_on: ""
hansos.id: src-2026-10-09-prompt-optimalisatie-bestandsbeheer
record_kind: source
skill_ids: []
case_ids: []
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

## Herkomst
- Bron: Gemini Deep Research export in Google Drive, map AI-en-automatisering (of scope-map), aangemaakt 2026-10-09.
- Status: raw bronmateriaal, nog niet beoordeeld. Claims zijn indicatief tot Hans de source-pagina heeft beoordeeld (Klopt het? Werkt het? Voelt het juist?).
- Bridge-drop gemaakt door Claude-cloud op 2026-10-14 als onderdeel van de HansOS next-step (zie wiki/topics/HansOS-Next-Step-2026-10 zodra geïngest).

## Inhoud

# Rapportage: Strategische Optimalisatie van LLM-Prompts voor Geautomatiseerd Bestandsbeheer en Metadata-Extractie

## Introductie en Systeemcontext

De exponentiële accumulatie van ongestructureerde data vormt een van de meest kritieke uitdagingen binnen moderne IT-infrastructuren, in het bijzonder wanneer lokale opslagmedia gelijktijdig worden ingezet voor professionele, educatieve en persoonlijke doeleinden. Uit de verstrekte systeemcontext blijkt dat er recentelijk een acute crisis heeft plaatsgevonden waarbij de fysieke opslagcapaciteit van diverse systemen automatisch werd gemaximaliseerd ("maxing out over time"). Deze opslagcrisis trof onder meer de C:\\ en D:\\ partities, evenals de opslag van een extern Raspberry Pi-systeem. Om verdere systeemstagnatie of catastrofaal dataverlies te voorkomen, zijn er doeltreffende remediërende acties uitgevoerd. Deze acties omvatten de rigoureuze opschoning van zware virtuele omgevingen, waaronder Docker WSL2-containers, AnythingLLM-installaties, Claude VM-bundels en verouderde Syncthing-versies. Tevens is er een succesvolle optimalisatieslag doorgevoerd in Windows Explorer met behulp van vijf autonome software-agenten, en is er via het robuuste commando-regel hulpprogramma Robocopy een veilige, ongewijzigde datakopie naar Google Drive gerealiseerd, waarbij alle foto's en video's veilig zijn gesteld.

Hoewel de onmiddellijke dreiging van hardware-falen door ruimtegebrek is afgewend, resteert er een fundamenteel architecturaal probleem inzake data-ordening en bestandsmigratie. De initiële instructie (prompt) luidt: *"Analyseer alle D:\\ folders en bestanden. Ik wil drive als main verzamelplek voor alle afbeeldingen, zelf of ai gemaakt en gescheiden op werkgever of studie met hoofdcategorie werk (om werk en prive gescheiden te houden hier. Ik wil dat alle bestanden voor van mijn studie (die map is er) correct worden ingedeeld."*

Deze initiële prompt is conceptueel helder, maar functioneert suboptimaal als sturingsmechanisme voor geautomatiseerde workflows die worden aangestuurd door een Large Language Model (LLM) of script-genererende agenten. Een taalmodel vereist uiterst specifieke, technologisch sluitende en grensafbakenende instructies om een complex migratie- en classificatieproces uit te voeren zonder datacorruptie, semantische misclassificatie of netwerkoverbelasting te veroorzaken. Dit uitgebreide rapport biedt een uitputtende analyse van de hiaten in de originele instructie en presenteert een fundamenteel gereviseerde architectuur voor de interactie met AI-agenten. Hierbij wordt diepgaand ingegaan op het gebruik van geavanceerde metadata-forensica (inclusief de nieuwste IPTC 2025.1 standaarden) voor het scheiden van AI-gegenereerde en authentieke afbeeldingen, de toepassing van hiërarchische best practices binnen Google Drive, en de integratie van fail-safe PowerShell- en Robocopy-mechanismen voor de fysieke en non-destructieve dataverplaatsing.

## Architecturale Deconstructie van de Initiële Instructie

De originele prompt is geformuleerd in natuurlijke taal, wat voor menselijke interpretatie afdoende is, maar voor een computationeel neuraal netwerk aanzienlijke ambiguïteit introduceert. Een diepgaande analyse brengt diverse technische, logische en semantische knelpunten aan het licht die, indien ongeadresseerd, kunnen leiden tot inefficiënte verwerking of het genereren van destructieve code.

Het commando om alle D:\\ mappen en bestanden te analyseren, is technologisch gezien onbepaald. Een taalmodel bezit van nature geen directe interface met een lokaal bestandssysteem. De prompt specificeert niet via welke mechanismen, programmeertalen of besturingssysteem-API's (zoals Python met os.walk() of pathlib.Path.rglob(), of PowerShell's Get-ChildItem) deze analyse moet plaatsvinden. Zonder strikte restricties in de prompt kan een agent scripts genereren die recursief in oneindige lussen belanden bij het scannen van diep geneste of verborgen systeemmappen (zoals de System Volume Information map), of vastlopen op bestanden met restrictieve NTFS-toegangsrechten1.

Daarnaast introduceert de wens om de bestanden te scheiden op "werkgever of studie met hoofdcategorie werk" een logische complexiteit die in een platte directory-instructie gemakkelijk verkeerd wordt geïnterpreteerd. De hiërarchie moet expliciet worden gedefinieerd om te voorkomen dat de AI-agent redundante of circulaire mappen aanmaakt. Tevens wordt er gerefereerd aan een bestaande studiemap met de toevoeging dat deze map er reeds is. Omdat de exacte absolutie padverwijzing naar deze specifieke map ontbreekt, wordt het model gedwongen om op basis van heuristiek te raden welke map bedoeld wordt, wat de foutmarge aanzienlijk verhoogt.

Het meest complexe en technologisch uitdagende knelpunt bevindt zich in de eis om alle afbeeldingen in te delen op basis van de oorsprong: "zelf of ai gemaakt". Het maken van een accuraat onderscheid tussen een organisch gefotografeerde afbeelding (afkomstig van een digitale camera of smartphone) en een afbeelding die door een neuraal netwerk (zoals Midjourney, DALL-E 3 of Stable Diffusion) is gegenereerd, is een computationeel zware taak. De originele prompt geeft de script-genererende agent geen enkele instructie over de te hanteren methodologie. Zonder expliciete sturing zal een taalmodel mogelijk voorstellen om een lokaal visueel classificatiemodel in te laden (zoals via MediaPipe of OpenCV) om de beelden op pixelniveau te analyseren3. Dit is buitengewoon rekenintensief, vereist zware GPU-bronnen, en is sterk gevoelig voor valse positieven. De optimale, gestructureerde benadering vereist daarentegen de systematische extractie van ingesloten metadata, zoals IPTC-tags, EXIF-data, en specifieke PNG-chunks5.

Tabel 1 illustreert de noodzakelijke transformatie van de originele, ambigue intenties naar computationeel gedefinieerde, geoptimaliseerde vereisten die als fundament dienen voor de nieuwe prompt-architectuur.

| Origineel Concept | Geïdentificeerd Knelpunt | Geoptimaliseerde Conceptuele Vereiste |
| :-: | :-: | :-: |
| Analyseer alle D:\\ folders | Ambiguïteit in executiemethode; risico op overbelasting van schijf I/O. | Expliciete instructie tot het genereren van een geoptimaliseerd, asynchroon script voor gerichte directory-traversal. |
| Drive als main verzamelplek | Onduidelijkheid over het gebruikte toegangsprotocol (lokale file stream vs. cloud API). | Definiëring van het doelsysteem via lokale pad-referenties naar de gemonteerde Google Drive File Stream. |
| Zelf of ai gemaakt | Volledig ontbreken van detectie-logica en validatieprotocollen. | Verplichte implementatie van metadata-forensica (IPTC, EXIF, C2PA) via bibliotheken zoals Python Pillow en ExifTool5. |
| Werkgever of studie onder werk | Risico op wildgroei aan structuren of inconsistente mapping. | Strikte, vooraf gedefinieerde definitie van de boomstructuur met maximaal drie geneste niveaus10. |
| Die map is er (studie) | Gebrek aan absolutie pad-declaratie. | Instructie om expliciete pad-variabelen bovenaan de script-generatie op te nemen voor handmatige validatie door de eindgebruiker. |

## Geavanceerde Datataxonomie en Google Drive Architectuur

Om de opslagcrisis op de D:\\ schijf niet louter te verplaatsen naar een ongeorganiseerde chaos in de cloud, is de fundamentele inrichting van de doellocatie op Google Drive van doorslaggevend belang. De best practices voor data-ordening dicteren dat een optimale bestandsstructuur hiërarchisch is, primair gestructureerd op basis van actieve levens- of bedrijfsfuncties in plaats van losse bestandstypen, en dat de nesting (de recursieve diepte van de mappen) idealiter beperkt blijft tot twee of drie niveaus10. Dieper geneste mappenstructuren verminderen de navigeerbaarheid drastisch en compliceren geautomatiseerde pad-referenties in synchronisatiescripts.

De geoptimaliseerde prompt moet de agent dwingend instrueren om een rigoureuze taxonomie aan te houden bij het schrijven van de verplaatsingsscripts. Aangezien de gebruiker expliciet de wens uitspreekt om werk en privé gescheiden te houden, en 'Studie' en 'Werkgever' onder de brede paraplu 'Werk' vallen, dient de boomstructuur als een vaste parameter in de logica te worden verankerd. Het script dat de AI genereert moet de bestanden niet slechts sorteren, maar de doellocatie vooraf valideren, ontbrekende mappen aanmaken, en de logica in stand houden.

De aanbevolen hiërarchie voor het Google Drive ecosysteem, welke direct als structurele wetmatigheid in de prompt moet worden ingebed, is ontworpen om robuust en toekomstbestendig te zijn. Binnen de sectie "Werk" worden de gespecificeerde hoofdcategorieën aangebracht, terwijl er een duidelijke scheiding blijft tussen authentieke media en synthetische (AI) content.

Tabel 2 toont het architecturale sjabloon voor de mappenstructuur op Google Drive waarnaar het verplaatsingsscript moet routeren.

| Primaire Categorie (Top-Level) | Secundaire Categorie (Functie) | Tertiaire Categorie (Metadata Validatie) | Doel van de Sub-structuur |
| :-: | :-: | :-: | :-: |
| G:\\Drive\\Privé\\ | N.v.t. (Algemeen privé) | \\Afbeeldingen\_Authentiek\\ | Veilige opslag van organische, persoonlijke foto's. |
| G:\\Drive\\Privé\\ | N.v.t. (Algemeen privé) | \\Afbeeldingen\_AIGegenereerd\\ | Opslag van hobbymatige AI-generaties. |
| G:\\Drive\\Werk\\ | \\Werkgever\\ | \\Afbeeldingen\_Authentiek\\ | Bedrijfsgerelateerde camera- of screenshotbestanden. |
| G:\\Drive\\Werk\\ | \\Werkgever\\ | \\Afbeeldingen\_AIGegenereerd\\ | Synthetische assets voor professioneel gebruik. |
| G:\\Drive\\Werk\\ | \\Studie\\ *(Reeds Bestaand)* | \\Afbeeldingen\_Authentiek\\ | Ingescande documenten, foto's voor studie. |
| G:\\Drive\\Werk\\ | \\Studie\\ *(Reeds Bestaand)* | \\Afbeeldingen\_AIGegenereerd\\ | AI-onderzoek of visuele referentiematerialen. |

Door het gebruik van zeer beschrijvende mapnamen wordt gegarandeerd dat het bestandssysteem de intentie van de gebruiker weerspiegelt10. Het script dat door de LLM wordt gegenereerd, moet gebruikmaken van string-matching, reguliere expressies (Regex), of semantische analyse van de oorspronkelijke paden op de D:\\ schijf om de bestanden naar de juiste hoofdcategorie (bijvoorbeeld Werkgever of Studie) te dirigeren, alvorens de metadata-scheiding toe te passen. Om te voorkomen dat de opslag op lange termijn opnieuw volloopt, vereist het datamanagement tevens strategieën zoals het periodiek archiveren van voltooide projecten en het verstandig toepassen van ster-labels of prioriteitsmarkeringen in de Google Drive web-interface, in plaats van mappen te hernoemen naar urgente statussen10.

## Fundamenten van Metadata-Forensica voor AI-Classificatie

Het meest kritieke en technologisch veeleisende aspect van de prompt-optimalisatie betreft het automatiseren van het onderscheid tussen authentieke foto's en door kunstmatige intelligentie gegenereerde afbeeldingen. Zoals eerder vastgesteld, is een visuele pixelanalyse inefficiënt en onbetrouwbaar op grote schaal3. De geoptimaliseerde prompt moet de coderingsagent voorzien van gedetailleerde protocollen voor cryptografische en declaratieve metadata-extractie, specifiek gericht op de nieuwste industriestandaarden.

Elke professionele of digitaal gegenereerde afbeelding draagt meerdere lagen van onzichtbare metadata met zich mee. Terwijl Exchangeable Image File Format (EXIF) data traditioneel registreert met welke fysieke camera-instellingen (diafragma, sluitertijd, ISO) een foto is genomen, is de metadata rondom de intellectuele oorsprong en rechten het domein van de International Press Telecommunications Council (IPTC)5. De standaardisering van deze data heeft zich in de afgelopen decennia sterk ontwikkeld. Waar oudere dragers zoals het Information Interchange Model (IIM) uit 1990 binaire structuren in APP13-segmenten van JPEG-bestanden gebruikten, maakt de moderne standaard gebruik van de door Adobe geïntroduceerde Extensible Metadata Platform (XMP) architectuur, welke in het APP1-segment als XML wordt opgeslagen15. Moderne classificatie moet beide systemen kunnen lezen.

### De Evolutie van de IPTC DigitalSourceType Eigenschap

De prompt moet de agent instrueren om scripts te genereren die expliciet zoeken naar de DigitalSourceType eigenschap binnen de IPTC/XMP metadata. Tot medio 2022 bevatte de standaard geen eenduidige velden voor AI, maar de snelle opkomst van generatieve netwerken noodzaakte een aanpassing. In de standaardisering wordt een volledig door een algoritme gegenereerde afbeelding geduid met de waarde trainedAlgorithmicMedia of via de officiële URI http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia5. Deze taxonomie werd verder verfijnd door introducties zoals compositeWithTrainedAlgorithmicMedia, wat wordt toegepast wanneer een originele foto door middel van AI inpainting of outpainting is gemodificeerd5.

Bovendien heeft de IPTC in november 2025 de Photo Metadata Standard 2025.1 gepubliceerd, welke specifiek vier nieuwe velden toevoegt om AI-transparantie te borgen. Deze velden, die nu door grote indexers zoals Google Images en platforms zoals Meta en Pinterest worden gerespecteerd en uitgelezen, zijn14:

1. **AI System Used:** De naam of het model van de generatieve engine (bijv. "ChatGPT DALL-E").
2. **AI System Version Used:** De specifieke iteratie van het model.
3. **AI Prompt Information:** De volledige tekst-instructie (prompt) die aan het model is gevoed.
4. **AI Prompt Writer Name:** De naam van de entiteit die de prompt heeft opgesteld (wat conceptueel gescheiden is van de 'Creator' van een authentieke foto).

De gegenereerde code moet gebruikmaken van robuuste parsers. Open-source oplossingen zoals ExifTool (aangeroepen via sub-processen in Python) zijn de industriestandaard voor het extraheren van deze fijnmazige XMP en IIM data8.

### EXIF-handtekeningen, PNG Chunks en Cryptografie

Naast de formele IPTC-standaarden laten vrijwel alle gerenommeerde AI-generatoren hun sporen na in meer conventionele datavelden. De geoptimaliseerde prompt moet de agent wijzen op de noodzaak om het Software of CreatorTool veld in de EXIF-data uit te lezen. Een string die verwijst naar "Midjourney v6.1", "Stable Diffusion XL", of simpelweg het veelgebruikte "PIL/Pillow" in een context waar een camera-identifier verwacht wordt, is een direct classificatiesignaal5.

Een bijzonder complex scenario ontstaat bij bestanden met de .png extensie. In tegenstelling tot JPEG- of TIFF-bestanden, is EXIF-data niet van nature gegarandeerd in de standaard PNG-informatie headers zonder specifieke handelingen6. Lokaal gedraaide modellen, zoals veel varianten van Stable Diffusion, slaan hun uitvoerige generatie-parameters (inclusief Sampler methoden, CFG-schalen en seed-waarden) op in specifieke PNG tekst-chunks, bekend als tEXt of gecomprimeerde zTXt blokken5. De prompt moet expliciet dicteren dat de Python-logica bij het gebruik van de Pillow bibliotheek voor PNG-bestanden de im.load() methode aanroept (essentieel vanaf Pillow 6.0) en de im.info dictionary parst op zoek naar sleutels zoals "parameters" of JSON-geformatteerde "prompts"6.

Tot slot is er de opkomende C2PA (Coalition for Content Provenance and Authenticity) standaard, die cryptografisch ondertekende manifesten aan bestanden hecht5. Elke tampering verbreekt deze signatuur. De geoptimaliseerde detectie-logica moet hiërarchisch zijn, beginnend bij C2PA-validatie (indien de bibliotheek dit toelaat), vervolgens de IPTC 2025.1 en DigitalSourceType velden raadplegen, daarna scannen op EXIF-software handtekeningen, en eindigen met ruwe PNG-chunk extractie5.

Wanneer bestanden via applicaties zoals WhatsApp zijn gedeeld of via schermafbeeldingen zijn opgeslagen, wordt nagenoeg alle metadata agressief gestript7. De geoptimaliseerde prompt moet de agent instrueren dat dergelijke bestanden, bij afwezigheid van zowel camera-data als AI-data, op basis van fail-safe principes als "Authentiek/Onbepaald" moeten worden gecategoriseerd om ongewenste verwijdering of cloud-vervuiling te voorkomen, of naar een aparte "Review"-map moeten worden gerouteerd7.

Tabel 3 concretiseert de hiërarchische filterprioriteiten die in de Python-scripts van de agent moeten worden geïncorporeerd.

| Prioriteit (Volgorde van Executie) | Metadata Vorm en Standaard | Doelveld of Sleutel (Key) | Verwachte Waarde voor Aanduiding AI |
| :-: | :-: | :-: | :-: |
| 1 | C2PA Content Credentials | Cryptografisch Manifest | Aanwezigheid van een cryptografisch gevalideerde signatuur van een AI-entiteit5. |
| 2 | IPTC / XMP (Core / Extension) | DigitalSourceType | trainedAlgorithmicMedia of URI referentie hiervan5. |
| 3 | IPTC 2025.1 (Nieuw) | AISystemUsed / AIPromptInformation | Aanwezigheid van een generatieve engine naam of tekstprompt17. |
| 4 | EXIF (Camera Standaard) | Software of CreatorTool | Strings zoals "DALL-E 3 via ChatGPT" of "Midjourney"5. |
| 5 | PNG Data Chunks | im.info\['parameters'\] of tEXt / zTXt | Complexe string met "Steps: 30, Sampler: DPM++"5. |

## Robuuste Fysieke Migratie via PowerShell en Robocopy

Uit de eerdere conversatie blijkt dat Robocopy reeds met succes is ingezet voor een veilige, ongewijzigde kopie naar de Google Drive-infrastructuur. Echter, omdat de lokale drives (C:, D:) een historiek hebben van vollopen ("maxing out"), is een simpele eenrichtingskopie niet meer afdoende. Het script dat de LLM genereert, moet de intelligentie van Python (voor de metadata analyse en pad-mapping) combineren met de onverslaanbare robuustheid van Robocopy en PowerShell voor de daadwerkelijke, destructieve migratie.

Robocopy (Robust File Copy) is een ingebouwd Windows command-line hulpprogramma ontworpen voor complexe synchronisaties, dat beduidend beter presteert dan reguliere kopieer-opdrachten dankzij zijn vermogen om attributen, NTFS-rechten, en tijdstempels intact te houden, en netwerkstoringen te overleven1. De geoptimaliseerde prompt moet eisen dat de agent de daadwerkelijke verplaatsing via een gegenereerd PowerShell-script uitvoert dat Robocopy-processen aanroept met specifieke parameterisering.

Allereerst moet het script gebruikmaken van de /MOVE parameter (of /MOV indien lege mappen moeten blijven bestaan). Dit garandeert dat bestanden direct van de D:\\ schijf worden verwijderd nadat ze succesvol en gevalideerd op de Google Drive zijn aangekomen, waardoor de opslagcrisis daadwerkelijk wordt verholpen1.

Daarnaast is de /LFSM (Low Free Space Mode) switch van cruciaal belang. Gegeven de context van de dichtgeslibde schijven, instrueert /LFSM het Robocopy-proces om te pauzeren wanneer de vrije ruimte op het doelvolume onder een kritiek percentage zakt, wat voorkomt dat het doelbestandssysteem eveneens vastloopt tijdens massale migraties1. Opmerkelijk is dat /LFSM niet verenigbaar is met multithreading-opties zoals /MT, waardoor het scriptontwerp hierin een bewuste keuze moet maken, aangestuurd door de prompt1.

Tijdens overdrachten naar cloud-gebaseerde virtuele schijven (zoals de gemonteerde Google Drive File Stream) of netwerk-aandelen (NAS), kunnen de verbindingen fluctueren. Het PowerShell-script moet daarom Robocopy voorzien van de /Z (Restartable mode) of /ZB (waarbij het fallbackt naar Backup mode bij toegangsweigeringen) switches. Dit zorgt ervoor dat een onderbroken bestandsoverdracht kan worden hervat vanaf het punt van verbreken, in plaats van opnieuw te moeten beginnen1. Eventuele haperingen worden ondervangen door de retries in te stellen met parameters zoals /R:3 (maximaal 3 pogingen bij falen) en /W:5 (een wachttijd van 5 seconden tussen pogingen)1.

Verder is databehoud essentieel. De eigenschappen van de mediabestanden, in het bijzonder de creatiedatum en wijzigingsdatum, moeten bewaard blijven om de chronologische orde op Google Drive niet te verstoren. De parameter /COPY:DAT instrueert Robocopy om de Data, Attributen en Timestamps te kopiëren, in plaats van de bestanden te voorzien van de actuele systeemdatum tijdens overdracht2. Tevens dient de /XO (Exclude Older) switch te worden geïmplementeerd om te voorkomen dat oudere versies vanaf de lokale schijf onbedoeld nieuwere bestanden in de reeds bestaande 'Studie' doelmap overschrijven1.

Indien de gebruiker voornemens is dit proces te automatiseren via de Windows Task Scheduler, stuit men vaak op de bekende foutmelding 0x00000005 - Access Denied, in het bijzonder wanneer er gepoogd wordt bestanden te verplaatsen naar gemapte netwerkschijven (zoals een G:\\ of M:\\ pad toegewezen door Google Drive File Stream). De prompt moet de agent instrueren om, indien automatisering wordt geschreven, de Task Scheduler niet direct het .bat of .ps1 script te laten aanroepen, maar de PowerShell-executable te starten met de -ExecutionPolicy Bypass -File parameters, en om bij netwerkdoelen idealiter Universal Naming Convention (UNC) paden (\\servername\\path) te gebruiken, aangezien de achtergrond-service van Task Scheduler gemapte drive-letters vaak niet herkent2. Tevens moet het script robuuste logging implementeren, bijvoorbeeld door het gebruik van Start-Transcript in PowerShell of het loggen van Robocopy-output ($lastexitcode) naar een tekstbestand, zodat eventuele falende kopieeracties exact traceerbaar zijn2.

Tabel 4 consolideert de onmisbare Robocopy-parameters die door de agent in de scriptgeneratie moeten worden verwerkt om een veilige operatie te garanderen.

| Robocopy Parameter | Operationele Functie | Noodzaak Binnen de Huidige Context (Drives Maxing Out) |
| :-: | :-: | :-: |
| /MOVE | Verplaatst bestanden en verwijdert de bron na succes25. | Fundamenteel voor het structureel vrijmaken van de D:\\ partitie. |
| /L | Activeert Dry Run modus (List only)1. | Biedt de mogelijkheid om de complexe route-logica zonder schijfmutatie te testen. |
| /LFSM of /MT | Low Free Space Mode of Multi-threading1. | /LFSM voorkomt doel-overbelasting; /MT accelereert verwerking (let op: niet compatibel met elkaar). |
| /ZB | Restartable / Backup mode1. | Omzeilt NTFS permissie-restricties en resumeert netwerkfalen richting cloud-drives. |
| /COPY:DAT | Behoudt metadata, attributen en tijdstempels2. | Garandeert dat de EXIF-creatiedata van authentieke foto's ongeschonden overkomt op Google Drive. |
| /XO | Exclude Older (Slaat oude bestanden over)1. | Beschermt de reeds opgebouwde doelstructuur tegen ongewenste overschrijvingen. |
| /XD | Exclude Directories1. | Essentieel om verborgen systeemmappen (zoals System Volume Information) buiten beschouwing te laten en lussen te voorkomen. |

## De Geoptimaliseerde Master Prompt

Het succes van de automatisering valt of staat met de complexiteit en structurering van de uiteindelijke instructie aan het Large Language Model (bijv. ChatGPT, Claude, of een lokaal systeem zoals AnythingLLM). Geavanceerde prompt engineering dicteert het gebruik van een 'Persona-Context-Taak-Restricties-Output' (PCTRO) format. Door de LLM de rol aan te meten van een Senior Data Architect, conditioneert men het neurale netwerk om robuuste, defensieve code te genereren in plaats van simplistische oplossingen.

De onderstaande geoptimaliseerde prompt is ontworpen om de volledige breedte van de geanalyseerde problematiek te dekken en direct door de eindgebruiker te worden geïnjecteerd in de AI-interface.

**\[START VAN DE GEOPTIMALISEERDE PROMPT\]**

**Rol en Context:**

Je fungeert als een Senior Data Architect en Systems Automation Engineer, met vergaande expertise in Python, geavanceerde PowerShell-scripting, Robocopy data-migratie, en IPTC/EXIF metadata-forensica.

Recentelijk hebben mijn lokale schijven (inclusief de C:, D:\\ en een extern Raspberry Pi-systeem) te kampen gehad met opslagtekorten, waarbij de drives automatisch hun maximale capaciteit bereikten ("maxing out"). Als succesvolle mitigerende maatregel heb ik reeds Docker WSL2-omgevingen, AnythingLLM, Claude VM-bundels en verouderde Syncthing-versies opgeschoond. De Windows Explorer is geoptimaliseerd via 5 agenten, en ik heb recentelijk met succes via Robocopy een non-destructieve, veilige kopie naar Google Drive voltooid, waarbij alle metadata intact is gebleven.

**Het Huidige Doel:**

Ik wil nu de D:\\ schijf fundamenteel reorganiseren en permanent opschonen om verdere capaciteitsproblemen te voorkomen. De Google Drive (toegankelijk via desktop synchronisatie of een lokaal pad) moet de primaire, centrale verzamelplek worden voor *alle* afbeeldingen op mijn systemen.

Deze afbeeldingen moeten asynchroon worden geanalyseerd, gemigreerd en gedeponeerd op basis van de volgende strikte taxonomie:

1. **Primaire Classificatie (Oorsprong)**: Onderscheid maken tussen authentieke, zelfgemaakte foto's en door algoritmen (AI) gegenereerde afbeeldingen.
2. **Secundaire Classificatie (Domein)**: Indeling in "Werk" (als hoofdcategorie) versus "Privé".
3. **Tertiaire Classificatie (Specificatie binnen Werk)**: Verder uitsplitsen in "Werkgever" en "Studie". Belangrijk: Er bestaat reeds een doelmap voor mijn studie; bestanden die hiertoe behoren moeten naadloos in deze bestaande structuur worden geïntegreerd zonder nieuwer materiaal te overschrijven.

**Jouw Taak:**

Ontwerp een geautomatiseerd, fail-safe executieplan en genereer de benodigde productie-klare scripts. Het is vereist dat je een modulaire aanpak hanteert: een Python-script voor de metadata-extractie en pad-berekening (indexering), gevolgd door een robuust PowerShell-script dat Robocopy aanroept voor de daadwerkelijke, destructieve migratie (het leegmaken van de D:\\ schijf).

**Strikte Randvoorwaarden en Systemische Restricties:**

- **Diepgaande Metadata Detectie (Extreem Belangrijk):** Gebruik Python (bijv. de Pillow bibliotheek in combinatie met een wrapper voor exiftool) om ingesloten metadata te parsen en AI-afbeeldingen te identificeren. Het script moet controleren op de IPTC DigitalSourceType (zoek expliciet naar trainedAlgorithmicMedia of compositeWithTrainedAlgorithmicMedia), evenals de nieuwe IPTC 2025.1 velden zoals AISystemUsed en AIPromptInformation. Controleer daarnaast het EXIF Software veld (op generatoren zoals Midjourney, DALL-E, Stable Diffusion). Voor PNG-bestanden dien je im.load() te gebruiken in Pillow en de tEXt of zTXt chunks binnen im.info te scannen op AI-parameters (zoals "Steps:", "Sampler:", etc.). Afbeeldingen zonder metadata of met onbepaalde headers moeten worden beschouwd als "Authentiek/Onbepaald".
- **Fysieke Bestandsverplaatsing:** Gezien de schaarste aan opslagruimte dienen bestanden, nadat een succesvolle en gevalideerde kopie naar Google Drive heeft plaatsgevonden, van de D:\\ schijf te worden verwijderd. Gebruik hiervoor Robocopy's /MOVE functionaliteit of bouw een expliciete Remove-Item validatie-stap in PowerShell in.
- **Dry Run Capaciteit:** Integreer een duidelijke 'Dry Run' modus. Het PowerShell-script moet ondersteuning bieden voor de Robocopy /L (List only) switch, zodat ik de volledige directory-manipulatie en mapping-operaties in een output-logbestand kan simuleren en controleren, vóórdat enige schijfmutatie wordt geautoriseerd.
- **Robocopy Parameterisering:** Zorg voor ongeëvenaarde netwerk-afhandeling naar de cloud. Gebruik parameters zoals /ZB (restartable/backup modus bij permissie-conflicten), /R:3 en /W:5 voor het opvangen van timeouts, en /COPY:DAT om te garanderen dat originele aanmaaktijden (timestamps) van mediabestanden intact blijven. Gebruik /XO om te vermijden dat nieuwere bestanden in de Studie-map worden overschreven, en /XD om mappen zoals System Volume Information uit te sluiten. Overweeg het gebruik van /LFSM (Low Free Space Mode) om Google Drive niet te overbelasten, in plaats van /MT.
- **Variabelen en Pad-declaraties:** Maak bovenaan de scripts gebruik van duidelijk gemarkeerde variabelenblokken voor de bron (bijv. D:), het doel (G:\\Drive...), en de specifieke absolutie paden voor de Studie- en Werkgever-mappen. Zo kan ik de configuratie eenvoudig aanpassen aan de lokale toewijzing van de File Stream.
- **Categorisatie-Logica:** Voorzie de Python-code van een flexibel blok (zoals lijsten of Regex-patronen) waarin ik zelf de trefwoorden of bestandsnaam-conventies (bijv. "Semester\_1", "Project\_Bedrijf\_X") kan definiëren. Het script gebruikt deze logica vervolgens om de string-matching uit te voeren en te bepalen of een afbeelding bij "Studie" of "Werkgever" hoort.
- **Logging:** Het PowerShell-script moet gebruikmaken van Start-Transcript of de uitvoer ($lastexitcode) loggen om de integriteit van de migratie traceerbaar te houden.

**Gewenste Oplevering:**

1. Een overzichtelijk, architecturaal stappenplan van de voorgestelde workflow.
2. Het volledige, becommentarieerde Python-script voor de metadata-extractie en het genereren van een verplaatsings-manifest (bijv. CSV-mapping).
3. Het geavanceerde PowerShell/Robocopy orkestratie-script voor de daadwerkelijke datamigratie op basis van het Python-manifest.
4. Gedetailleerde instructies voor de veilige uitvoering, foutafhandeling (zoals 0x00000005 errors via Task Scheduler), en validatie van het proces.

**\[EINDE VAN DE GEOPTIMALISEERDE PROMPT\]**

## Operationele Implementatie, Risicomitigatie en Validatie

De geoptimaliseerde prompt resulteert in geavanceerde, operationele scripts. De uitvoering van dergelijke scripts, met name in omgevingen die recent een opslagcrisis hebben doorgemaakt, vereist een gestructureerde uitrol om datacorruptie uit te sluiten. Deze implementatie dient in strikt gescheiden, sequentiële fasen plaats te vinden, gecentreerd rondom logging en checksum-validatie.

### Fase 1: Asynchrone Indexering en Log-generatie

Wanneer het gegenereerde Python-script wordt uitgevoerd, traverseert het de lokale bestandssystemen (zoals de gespecificeerde D:\\ partitie). Aangezien schijf-I/O zwaar kan worden belast, is het van belang dat de uitvoering asynchroon of stapsgewijs geschiedt. Tijdens deze fase voert Python louter lees-operaties uit. Voor bestanden met bekende afbeeldings-extensies (bijv. .jpg, .png, .tiff, .webp) past het de gespecificeerde metadata-forensica toe.

Het uiterst complexe PNG-scenario wordt correct afgehandeld omdat de prompt de AI dwingt om niet blind op EXIF te vertrouwen, maar via Pillow expliciet de zTXt of tEXt data-chunks (die typisch gegenereerd worden door systemen als Stable Diffusion) uit de im.info structuur te parsen, pas na het initialiseren van de bitmap via im.load()5. De output van deze iteratie is geen onmiddellijke bestandsverplaatsing, maar de generatie van een datamap-manifest (zoals een CSV of JSON-tabel), waarin elke unieke bestands-hash, de huidige locatie op D:, en de berekende doel-URL op Google Drive wordt vastgelegd. Dit manifest fungeert als de bron van waarheid voor de volgende fasen en stelt de eindgebruiker in staat om via een spreadsheet-applicatie handmatig de classificaties ("Werk", "Studie", "AI-gegenereerd") te valideren voorafgaand aan de executie.

### Fase 2: De Dry-Run en Simulatie

De geautomatiseerde integratie naar de Google Drive wordt voorbereid door het gegenereerde PowerShell-script in de simulatiemodus te draaien. Omdat de prompt de implementatie van de Robocopy /L (List only) switch vereist, zal het script de command-line iteraties doorlopen alsof het de bestanden daadwerkelijk verplaatst, zonder echter enige I/O mutatie op het opslagmedium uit te voeren1. Deze Dry-Run produceert via de Start-Transcript of omgeleide output een logbestand waarin conflicten, zoals geblokkeerde bestanden, ontbrekende bestemmingspaden of foutieve naamgevingen, direct zichtbaar worden2. Dit is een kritieke veiligheidsstap; de destructieve aard van /MOVE vergevingsgezindheid uitsluit, en een foutieve configuratie van het Destination pad zou anders onherstelbare schade aanrichten aan de reeds opgebouwde datastructuren1.

### Fase 3: Fail-safe Fysieke Uitvoering en Afronding

Wanneer de logs van de simulatie foutloos zijn bevonden, kan de restrictie op de Robocopy of Move-Item operaties worden opgeheven. De PowerShell logica roept iteratief of batchgewijs de kopieer- en verwijder-routines aan. Indien er gedurende de kopieeractie een daling optreedt in de beschikbare capaciteit op de doelschijf (Google Drive caching of quota-limieten), zal de geadviseerde /LFSM parameter het proces temporiseren, waardoor systeemcrashes worden voorkomen1.

Zodra het proces ten einde komt, is de originele D:\\ schijf systematisch gestript van alle afbeeldingsbestanden, waarbij de vrijgekomen ruimte direct wordt geregistreerd in het besturingssysteem. Tegelijkertijd bezit de Google Drive nu een georganiseerde, hiërarchische datastructuur, waarin timestamps (/COPY:DAT) en met name de kritieke IPTC/XMP-tags zoals trainedAlgorithmicMedia of AISystemUsed naadloos en onveranderd zijn gemigreerd2. Hierdoor blijven de bestanden voor lange termijn toegankelijk, zoekbaar, en compatibel met enterprise search-tools of toekomstige AI-detectie mechanismen van Google en gerelateerde cloud-dienstverleners.

## Strategische Conclusies

Het optimaliseren van een ogenschijnlijk eenvoudige commando-regel (een verzoek om bestanden op te schonen en te verplaatsen op basis van origine en werksfeer) naar een functioneel, robuust instructiepakket voor taalmodellen, vereist een fundamenteel begrip van zowel de datatechnologische realiteit als de gedragsmechanismen van Large Language Models. De initiële systeemsituatie, gekenmerkt door maximale schijfcapaciteit, noodzaakte een directe en verantwoorde overgang van ad-hoc datamanagement naar een gestandaardiseerde, permanente opslagarchitectuur.

De uitputtende analyse van dit rapport, evenals de daaruit voortvloeiende geoptimaliseerde prompt-architectuur, toont aan dat het succesvol integreren van autonome systemen afhankelijk is van drie hoofdpijlers. Ten eerste de naadloze overdracht van operationele context: het model moest worden begrensd door de kennis dat eerdere acties via Robocopy succesvol waren, en dat ruimtegebrek prioriteit eist via verplaatsingen (/MOVE, /LFSM) in plaats van duplicaties. Ten tweede de dwingende implementatie van geavanceerde metadata-forensica: door expliciet te verwijzen naar de IPTC 2025.1 standaarden, C2PA-manifesten, en Pillow's PNG-chunk-extractie methoden (tEXt/zTXt), elimineert men de foutgevoelige en rekenintensieve benadering van visuele AI-detectie ten faveure van deterministische attributen. Ten derde de integratie van defensieve en robuuste scripts via PowerShell: mechanismen zoals dry-runs (/L), versiebeheer (/XO), en transcriptielogging zorgen ervoor dat het eindresultaat een veilige netwerkoperatie is in plaats van een experimentele manipulatie.

Door de ontwikkelde Master Prompt in zijn totaliteit te hanteren, wordt de LLM niet vrijgelaten om te abstraheren, maar dwingend gestuurd richting de generatie van enterprise-waardige code. Deze verstrekkende methodiek resulteert in een opslagomgeving die vrij is van bestandsruis en capaciteitsproblemen, en bewerkstelligt de realisatie van een ordentelijke, hiërarchische cloud-opslag waarbij menselijk werk, studie en algoritmische media accuraat, efficiënt en veilig van elkaar zijn gescheiden.

#### Geciteerd werk

1. Robocopy Commands: Complete Guide with Examples, <https://petri.com/robocopy-complete-guide/>
2. Automating Production-to-DR File Replication Using PowerShell, <https://medium.com/@pathanfardeen555/automating-production-to-dr-file-replication-using-powershell-robocopy-and-task-scheduler-2d6f914f1dba>
3. Image classification guide for Python | Google AI Edge, <https://developers.google.com/edge/mediapipe/solutions/vision/image_classifier/python>
4. Python Image Editing Techniques and Libraries - Cloudinary, <https://cloudinary.com/guides/image-effects/python-image-editing>
5. How to Detect AI-Generated Images Using Metadata in 2026 | Fastio, <https://fast.io/resources/ai-generated-image-metadata-detection-tools/>
6. Python: Extract Metadata from PNG - Stack Overflow, <https://stackoverflow.com/questions/48631908/python-extract-metadata-from-png>
7. Is it AI? How to Tell Using Metadata - The Photo Investigator, <https://photoinvestigator.co/blog/how-to-tell-if-a-photo-is-ai-generated-metadata/>
8. How to extract image metadata in Python? - GeeksforGeeks, <https://www.geeksforgeeks.org/python/how-to-extract-image-metadata-in-python/>
9. Hack This: Extract Image Metadata Using Python - VICE, <https://www.vice.com/en/article/hack-this-extra-image-metadata-using-python/>
10. Mastering Google Drive: The Ultimate Guide to Organizing Your, <https://jacksdev.com/blog/organising-google-drive/>
11. Google Drive Folder Structure: A Simple System That Actually Works, <https://www.overdrive.tools/blog/google-drive-folder-structure-best-practices>
12. Best-practice folder and sharing structure for Google Drive, <https://drdaveheath.com/blog/best-practice-folder-and-sharing-structure-for-google-drive>
13. These 5 Python steps connect any AI image detection API., <https://aiidentifiers.com/blog/ai-image-detection-api-python-integration-tutorial>
14. IPTC Metadata Fields: Complete Reference Guide - Exif Injector, <https://exifinjector.com/blog/iptc-metadata-fields>
15. IPTC Photo Metadata Standard 2025.1, <http://www.iptc.org/std/photometadata/specification/IPTC-PhotoMetadata>
16. Explaining IPTC metadata - PPC Land, <https://ppc.land/iptc-metadata/>
17. IPTC Photo Metadata Standard, <https://iptc.org/standards/photo-metadata/iptc-standard/>
18. Google extends AI transparency based on IPTC standards, <https://iptc.org/news/google-ai-transparency-based-on-iptc-standards/>
19. IPTC Photo Metadata Standard adds new properties for AI, <https://iptc.org/news/iptc-photo-metadata-standard-2025-1-adds-ai-properties/>
20. AI-generated content - Google Merchant Center Help, <https://support.google.com/merchants/answer/14743464?hl=en-IE>
21. Writing Your First Forensic Tool-2: Extract Image Metadata with, <https://medium.com/@foysol60s/writing-your-first-forensic-tool-2-extract-image-metadata-with-python-image-library-faa70ac3b506>
22. Batch Extract Metadata from PNG files : r/StableDiffusion - Reddit, <https://www.reddit.com/r/StableDiffusion/comments/13ssv4t/batch_extract_metadata_from_png_files/>
23. What is C2PA? A Guide to Content Credentials and ... - Fotoware, <https://www.fotoware.com/blog/what-is-c2pa>
24. How to Sync Files from One Server to Another with Robocopy, <https://www.resilio.com/blog/robocopy-from-one-server-to-another>
25. How to Use Robocopy to Sync Files on a Drive or Directory in, <https://www.howtogeek.com/use-robocopy-to-sync-files-on-a-drive-or-directory-in-windows/>
26. Robocopy command for iterative and nondestructive backup - Reddit, <https://www.reddit.com/r/DataHoarder/comments/13hpvn6/robocopy_command_for_iterative_and_nondestructive/>
27. Sync items using a PowerShell wrapper around robocopy · GitHub, <https://gist.github.com/tylerapplebaum/d8caf3e852aa9280bf931ec8e4a25424>
28. Two-way folder sync with robocopy - Stack Overflow, <https://stackoverflow.com/questions/33022584/two-way-folder-sync-with-robocopy>
29. Robo-Copying files between google file stream and a network drive, <https://superuser.com/questions/1568893/robo-copying-files-between-google-file-stream-and-a-network-drive-with-a-windows>
30. Scheduled Task running Powershell Script that calls Robocopy not, <https://learn.microsoft.com/en-us/answers/questions/258559/scheduled-task-running-powershell-script-that-call>
