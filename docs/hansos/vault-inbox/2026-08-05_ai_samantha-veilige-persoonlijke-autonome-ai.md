---
title: "Samantha als veilige, persoonlijke en autonome AI"
type: source
scope: [HVL, CCP, MPG]
status: active
created: 2026-08-05
last_reviewed: 2026-10-14
aliases: []
tags: [samantha, security, least-privilege, obsidian, roadmap]
sources: []
source: drive-bridge
source_kind: pdf
source_url: "https://drive.google.com/file/d/1eBAbZ5vMijGeKiN5SMmnnSJO9cFWHTnn/view"
drive_id: "1eBAbZ5vMijGeKiN5SMmnnSJO9cFWHTnn"
ai_generator: chatgpt
ingested_from: _connector/bridge/inbox/drive/2026-08-05_ai_samantha-veilige-persoonlijke-autonome-ai.md
ingested_on: ""
hansos.id: src-2026-08-05-samantha-veilige-persoonlijke-autonome-ai
record_kind: source
skill_ids: []
case_ids: []
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

## Herkomst
- Bron: ChatGPT export in Google Drive, map AI-en-automatisering (of scope-map), aangemaakt 2026-08-05.
- Status: raw bronmateriaal, nog niet beoordeeld. Claims zijn indicatief tot Hans de source-pagina heeft beoordeeld (Klopt het? Werkt het? Voelt het juist?).
- Bridge-drop gemaakt door Claude-cloud op 2026-10-14 als onderdeel van de HansOS next-step (zie wiki/topics/HansOS-Next-Step-2026-10 zodra geïngest).

## Inhoud

# Samantha als veilige, persoonlijke en autonome AI

## Executive summary

Het nieuwe Samantha JARVIS-voorstel bevat niet aantoonbaar alle functies van de eerdere versie. Het document breidt Samantha inhoudelijk uit met een rijkere persoonlijkheid, proactieve monitoring, hybride geheugen, spraak, beeldherkenning en uitvoerende bevoegdheden. Tegelijkertijd verdwijnen of vervagen eerder genoemde onderdelen, waaronder Obsidian-mobile-integratie, bronprovenance, append-only logging, specifieke eBay-kennisprocessen en de precieze toegangsrechten. Bovendien beschrijft het voorstel vooral een doelbeeld; het bewijst niet dat de genoemde functies technisch zijn gebouwd, getest of operationeel zijn. fileciteturn2file0

De grootste tekortkoming is niet een ontbrekende AI-functie, maar een ontbrekende controlelaag tussen denken en doen. De formulering dat Samantha “volledige toegang” of “de sleutels tot de gehele infrastructuur” heeft, is onverenigbaar met een veilig agentmodel. Prompt injection, foutieve interpretatie of een besmet document kan bij zulke rechten leiden tot datalekken, destructieve acties of ongewenste publicaties. OWASP noemt prompt injection, gevoelige-informatielekkage, onveilige outputverwerking, zwakke vectorstores en excessive agency expliciet als kernrisico’s voor generatieve AI-systemen. [1]

De aanbevolen ontwikkelrichting is daarom:

| Besluit | Prioriteit | Kernadvies |
| --- | --- | --- |
| Geen onbeperkte systeemtoegang | High | Vervang “full access” door tijdelijke, taakgebonden capabilities en least privilege |
| Scheid plannen van uitvoeren | High | Laat Samantha voorstellen maken; een deterministische policy- en execution gateway beslist wat werkelijk mag |
| Bouw geheugen met vergeetbaarheid | High | Geen “zero amnesia”, maar geheugen met doelbinding, herkomst, bewaartermijnen, correctie en verwijdering |
| Begin met enkele veilige workflows | High | Start read-only en met omkeerbare e-commerce- automatiseringen |
| Voeg auditability en observability toe | High | Traceer iedere prompt, bron, beslissing, toolcall, goedkeuring en wijziging |
| Stel voice en ambient sensing uit | Medium | Eerst identiteit, autorisatie, geheugenkwaliteit en workflowbetrouwbaarheid stabiliseren |
| Fine-tuning pas later | Low voor MVP | Gebruik aanvankelijk RAG, expliciete voorkeuren en gestructureerd user modelling |

Onder de expliciete aannames in dit rapport kan een productiegeschikte MVP in circa acht tot tien weken worden gerealiseerd. Een bredere versie met veilige autonomie, geheugenbeheer, observability en voice/vision vraagt circa zestien tot twintig weken. De indicatieve eenmalige ontwikkelraming bedraagt €110.000–€250.000, exclusief btw, bestaande licenties en interne tijd. Een lean één- gebruikerstraject kan goedkoper worden uitgevoerd, maar werkelijke kosten zijn onbekend zolang codebase, kwaliteitsniveau, API-contracten, beveiligingsstatus en beschikbaar team niet zijn geïnspecteerd.

## Onderzoeksbasis en aannames

De vergelijking is gebaseerd op het aangeleverde bestand. Dat bestand bevat drie verschillende soorten uitspraken:

1. onderdelen die als gerealiseerd worden gepresenteerd, zoals een Samantha-identiteitskaart, Telegram-koppeling, Supabase-geheugen, Vault-toegang, SMB-mount, Obsidian-integratie en samenwerking met n8n/OpenClaw;
2. een maturiteitsanalyse waarin Samantha juist als grotendeels reactief wordt omschreven, met zeven dagen context en handmatige geheugenopslag;
3. een nieuw JARVIS-blueprint waarin toekomstige functionaliteit wordt voorgesteld, waaronder een heartbeat, automatische geheugenextractie, voice, vision en autonome herstelacties. fileciteturn2file0

Die drie lagen zijn niet overal consistent. Zo wordt eerst “volledige toegang tot het gehele HansOS Ecosystem” genoemd, terwijl de maturiteitsmatrix later spreekt over “leestoegang Vault & rapporten”. Ook worden voice-responstijden van 1,5 seconde als toekomstbeeld genoemd, zonder performance- architectuur, meetresultaten of testdefinitie. Daarom gebruikt dit rapport de volgende statussen:

| Status | Betekenis |
| --- | --- |
| Gedocumenteerd | In het bestand als bestaand beschreven, maar technisch niet onafhankelijk geverifieerd |
| Voorgesteld | Genoemd als toekomstig ontwerp of roadmaponderdeel |
| Gedeeltelijk | Conceptueel aanwezig, maar zonder voldoende technische of operationele specificatie |
| Onbekend | Geen controleerbare informatie beschikbaar |
| Niet opgenomen | Niet teruggevonden in het nieuwe voorstel |

### Expliciete aannames

| Onderwerp | Status of aanname |
| --- | --- |
| Huidige broncode en repositories | Onbekend |
| Programmeertalen en applicatieframework | Onbekend |
| Exacte LLM-provider en modellen | Onbekend |
| Deploymentmodel van Supabase en n8n | Onbekend: managed, self-hosted of hybride |
| OpenClaw/Barbapapa-architectuur | Onbekend |
| Aantal Samantha-gebruikers | Aangenomen: aanvankelijk één primaire gebruiker |
| Gebruik | Aangenomen: privé én zakelijk, waaronder e-commerce-operaties |
| Dagelijks aantal gesprekken/toolcalls | Onbekend |
| Budget | Onbekend |
| Bestaande testdekking | Onbekend |
| Beschikbare ontwikkelaars | Onbekend |
| Huidige identity provider en MFA | Onbekend |
| Encryptie van SMB/Vault/device-opslag | Onbekend |
| Verwerkersovereenkomsten met AI- en voiceproviders | Onbekend |
| Back-up-, restore- en disaster-recoverytests | Onbekend |
| Formele risicoanalyse of DPIA | Onbekend |
| Betrokken persoonsgegevens van klanten, medewerkers of leveranciers | Waarschijnlijk, gezien e-commerce- integraties; exacte categorieën onbekend |

Omdat Samantha ook aan e-commerceprocessen wordt gekoppeld, kan zij niet zonder meer als uitsluitend particuliere AI worden behandeld. De uitzondering voor persoonlijke, niet-professionele inzet is daardoor waarschijnlijk niet op het gehele systeem toepasbaar. Sinds 2 augustus 2026 gelden bovendien verschillende transparantieverplichtingen van de Europese AI-verordening, waaronder het informeren van natuurlijke personen dat zij met een AI-systeem interacteren. [2]

## Huidige functionaliteit en vergelijkingsanalyse

### Bekende huidige functionaliteit

Onderstaande inventaris is uitsluitend gebaseerd op wat in het aangeleverde materiaal wordt gesteld. “Gedocumenteerd” betekent niet dat configuraties, code of operationele werking zijn gecontroleerd. fileciteturn2file0

| Functiedomein | Bekende feature | Huidige status | Bewijsniveau | Aanbeveling | Priorite |
| --- | --- | --- | --- | --- | --- |
| Identiteit | Samantha- identiteits- en systeemkaart | Gedocumenteerd | Documentair | Versiebeheer en tests voor persona/system prompts | Hig |
| Rol | AI-partner, geheugencoach en Vault-bibliothecaris | Gedocumenteerd | Documentair | Scheid persona van security policy | Hig |
| Interface | Tekstinteractie via Telegram/webhook | Gedocumenteerd | Documentair | Voeg sterke accountbinding, webhookvalidatie en sessiebeheer toe | Hig |
| Langetermijngeheugen | Supabase-tabel `samantha_memory` | Gedocumenteerd | Documentair | Maak schema, herkomst, TTL, toestemming en verwijdering expliciet | Hig |
| Kortetermijncontext | Zeven dagen context | Gedocumenteerd | Documentair | Vervang vaste periode door taak- en gevoeligheidsafhankelijke retentie | Hig |
| Kennisbank | Second Brain Vault met raw/ , wiki/ en outputs/ | Gedocumenteerd | Documentair | Classificeer data en voeg document-level autorisatie toe | Hig |
| Semantische kennis | AnythingLLM/ vectorstore | Voorgesteld of gedeeltelijk | Laag | Gebruik permission- aware RAG en bronverwijzingen | Hig |
| Netwerktoegang | SMB-mount S:\ | Gedocumenteerd | Documentair | Maak standaard read- only; geen service- account met brede schrijfrechten | Hig |
| Workflow-orchestratie | n8n | Gedocumenteerd als ecosysteemcomponent | Documentair | Gebruik afzonderlijke development- en production-instances | Hig |
| Execution engine | OpenClaw/ Barbapapa | Gedocumenteerd als ecosysteemcomponent | Documentair | Plaats execution gateway en sandbox ervoor | Hig |
| Domeinkennis | eBay DE, listings, fitment, Channable/ Magento-context | Gedocumenteerd | Documentair | Maak domeinconnectors read-only in eerste MVP | Hig |
| Vault-visualisatie | Obsidian Graph en Canvas | Gedocumenteerd | Documentair | Behouden als menselijk inzichts- en reviewkanaal | Mediu |
| Mobiele toegang | Obsidian mobile via Sync/Remotely Save/ Git | Gedocumenteerd als mogelijkheid | Laag | Kies één beheerde synchronisatiemethode | Mediu |
| Provenance | Source notes en ingestmetadata | Gedocumenteerd | Documentair | Maak provenance verplicht voor alle herinneringen en antwoorden | Hig |
| Logging | Append-only Vault Operations Log | Gedocumenteerd voor ingest | Documentair | Uitbreiden naar iedere agentactie en toolcall | Hig |
| Persona | Neutraal/librarian- profiel | Gedocumenteerd | Documentair | Migreren naar persona 2.0 zonder antropomorfe misleiding | Mediu |
| Proactieve monitoring | Onbekend of niet gerealiseerd | Onbekend | Geen | Heartbeat pas na veilige event- en policylaag | Mediu |
| Voice | Onbekend of niet gerealiseerd | Onbekend | Geen | Niet in MVP tenzij aantoonbare noodzaak | Lo |
| Vision | Onbekend of niet gerealiseerd | Onbekend | Geen | Eerst screenshotanalyse zonder automatische uitvoering | Mediu |
| MFA/RBAC | Onbekend | Onbekend | Geen | Verplicht voor production access | Hig |
| Back-up/restore | Onbekend | Onbekend | Geen | Hersteltests en gescheiden back-ups invoeren | Hig |
| Kill switch | Onbekend | Onbekend | Geen | Globale en per-tool noodstop bouwen | Hig |

### Vergelijking vorige versie en nieuw voorstel

De belangrijkste conclusie uit de vergelijking is dat het nieuwe voorstel functioneel ambitieuzer maar operationeel minder compleet is. Het bewaart delen van de vorige architectuur impliciet, maar specificeert niet dat alle bestaande functies behouden, gemigreerd en getest worden. fileciteturn2file0

| Feature | Status oude versie | Status nieuw voorstel | Beoordeling | Impact wanneer ontbrekend of onduidelijk |
| --- | --- | --- | --- | --- |
| Samantha-identiteit | Gedocumenteerd | Uitgebreid naar persona 2.0 | Behouden en uitgebreid | Laag |
| Telegram-tekstchat | Gedocumenteerd | Impliciet behouden | Geen expliciete regressietest | Hoog: primaire bediening kan instabiel worden |
| Supabase-geheugen | Handmatig, beperkt | Automatische hybride memory voorgesteld | Verbetering, niet aangetoond geïmplementeerd | Hoog |
| Zevendaagse context | Gedocumenteerd | “Zero-amnesia” als doel | Vervangen door onveilig/ onbegrensd concept | Zeer hoog: privacy, vervuiling en kosten |
| Second Brain Vault | Lees-/ koppeltoegang genoemd | Onderdeel van hybrid brain | Conceptueel behouden | Hoog |
| SMB-mount | Gedocumenteerd | Niet gespecificeerd | Mogelijk vergeten | Hoog: connector kan breken of te breed blijven |
| Obsidian Graph | Gedocumenteerd | Niet opgenomen | Ontbreekt in roadmap | Medium: minder menselijk overzicht |
| Obsidian Canvas | Gedocumenteerd | Niet opgenomen | Ontbreekt | Medium |
| Mobiele Vault- toegang | Gedocumenteerd | Niet opgenomen | Ontbreekt | Medium |
| Source provenance | Gedocumenteerd bij ingest | Niet als architectuureis opgenomen | Ernstige omissie | Hoog: niet uitlegbaar welke bron gebruikt is |
| Append-only operations log | Gedocumenteerd bij ingest | Niet uitgewerkt voor agentacties | Ernstige omissie | Zeer hoog: geen forensische reconstructie |
| eBay-rapporting en listinganalyse | Gedocumenteerd | Alleen monitoringvoorbeelden | Gedeeltelijk behouden | Hoog: analysefunctie kan verschralen |
| K-Type/TecDoc- context | Gedocumenteerd | Niet expliciet opgenomen | Mogelijke regressie | Hoog voor marketplacekwaliteit |
| Persoonlijke stijl | Beperkt/neutraal | Warm, gevat, beschermend | Duidelijke uitbreiding | Medium |
| Proactieve heartbeat | Niet aanwezig | Iedere vijftien minuten voorgesteld | Nieuwe functie | Hoog potentieel, hoog risico |
| Agenda- en welzijnsmonitoring | Niet aangetoond | Voorgesteld | Nieuwe, privacygevoelige functie | Hoog |
| Automatische n8n- retries | Niet aangetoond | Voorgesteld | Nieuwe functie | Medium, mits idempotent |
| Cache legen | Niet aangetoond | Autonoom voorgesteld | Onvoldoende risicoclassificatie | Hoog |
| Directe OpenClaw/ MCP-sturing | Niet aangetoond | Doelarchitectuur | Nieuwe bevoegdheid | Zeer hoog |
| Telegram- goedkeuring | Niet aangetoond | Eén-klikbevestiging voorgesteld | Positief maar onvoldoende | Hoog |
| Voice | Niet aanwezig | Voorgesteld | Nieuwe functie | Medium |
| Vision | Niet aanwezig | Voorgesteld | Nieuwe functie | Medium |
| Encryptie | Onbekend | Niet uitgewerkt | Ontbreekt | Zeer hoog |
| Authenticatie en autorisatie | Onbekend | Niet uitgewerkt | Ontbreekt | Zeer hoog |
| Rollen en least privilege | Onbekend | “Volledige toegang” suggereert te brede rechten | Negatieve regressie | Kritiek |
| Prompt- injectionbescherming | Onbekend | Niet uitgewerkt | Ontbreekt | Kritiek |
| Memory poisoning | Onbekend | Niet uitgewerkt | Ontbreekt | Kritiek |
| Rollback en undo | Alleen elders nood-rollback genoemd | Niet als agentstandaard | Ontbreekt | Kritiek bij writes/ deletes |
| Betrouwbaarheid/ SLO’s | Onbekend | Geen meetbare targets | Ontbreekt | Hoog |
| Failover | Onbekend | Niet opgenomen | Ontbreekt | Hoog |
| Kosten- en tokenlimieten | Tokenverbruik wordt gemonitord | Geen harde budgetcontrols voorgesteld | Gedeeltelijk | Hoog |
| AVG-processen | Onbekend | Niet opgenomen | Ontbreekt | Kritiek |
| AI Act-transparantie | Niet opgenomen | Niet opgenomen | Ontbreekt | Hoog bij externe interactie |

### Eindoordeel over functionele dekking

Het nieuwe voorstel bevat vijf sterke nieuwe pijlers, maar mist de definitie van een compatibiliteitscontract. Voor iedere oude functie zou minimaal moeten worden vastgelegd:

| Vereiste | Concrete invulling |
| --- | --- |
| Feature-ID | Uniek nummer en eigenaar |
| Oude implementatie | Connector, tabel, workflow, prompt of Vault-pad |
| Nieuwe implementatie | Vervangend component |
| Data-migratie | Welke data, mapping, validatie en rollback |
| Acceptatiecriterium | Objectief testbare uitkomst |
| Regressietest | Automatische test of menselijke checklist |
| Securityclassificatie | Read, draft, write, publish, delete of financieel |
| Observability | Log, metric en trace-ID |
| Rollback | Herstelprocedure en maximale hersteltijd |

Aanbeveling: maak vóór verdere ontwikkeling een machineleesbare feature registry, bijvoorbeeld in YAML of Postgres, waarin alle bestaande en nieuwe capabilities, rechten, afhankelijkheden en tests zijn opgenomen. Prioriteit High, complexiteit Medium, benodigde inzet ongeveer één product/AI-architect en één backend engineer gedurende één tot twee weken.

## Doelarchitectuur voor automatisering en personalisatie

### Ontwerpprincipes

Samantha moet niet als één almachtige chatbot worden gebouwd, maar als een verzameling begrensde lagen:

- het LLM interpreteert, redeneert en stelt een plan op;
- een policy engine controleert of dat plan toegestaan is;
- een execution gateway vertaalt goedgekeurde acties naar strikt getypeerde commando’s;
- connectors krijgen alleen de minimale rechten die zij nodig hebben;
- kritieke acties worden vooraf goedgekeurd;
- iedere actie krijgt een trace-ID, idempotency key, auditrecord en waar mogelijk een undo-pad.

Het ReAct-onderzoek laat zien dat het combineren van redeneren en externe acties bruikbaar kan zijn voor agenttaken, maar de productiearchitectuur moet de gegenereerde acties als onbetrouwbare voorstellen behandelen, niet als rechtstreeks uitvoerbare instructies. [3]

### Aanbevolen dataflow en veiligheidscontrole

*(Figuur in de bron; onderstaande labels zijn de tekstelementen uit het diagram, in de volgorde van de PDF-extractie.)*

- Hans of geautoriseerde gebruiker
- Telegram, web of voice
- Identity gateway MFA, sessiecontrole, device binding
- Samantha orchestrator
- Context builder
- Expliciet gebruikersprofiel
- Memory broker
- Omkeerbare write
- Kritiek, financieel, delete of publish
- Permission-aware Vault retrieval
- LLM planner
- Input- en prompt-injectioncontrole
- Getypeerd actieplan geen vrije shellcommando's
- Policy engine risico, scope, budget, dataklasse
- Weigeren en uitleggen
- Execution gateway
- Retentie, correctie, export en verwijderen
- Verboden
- Alleen lezen
- Preview en bevestiging
- Step-up auth en expliciete goedkeuring
- Sandbox en egress allow-list
- n8n workflows
- Getypeerde API-connectors
- Security monitoring en incident response
- RPA alleen voor systemen zonder API
- eBay, Magento, Channable, agenda, infra
- Resultaatverificatie
- Append-only audit log
- Metrics, logs en traces
- Rollback of compensating action

### Automatiseringsmogelijkheden

n8n is geschikt als integratie- en automatiseringslaag voor triggers, webhooks, schedules en API-calls, maar de officiële documentatie laat ook zien dat workflows toegang kunnen hebben tot credentials, filesystemen en risicovolle nodes. n8n biedt security audits, execution history, retries en Git-gebaseerde omgevingen; die functies moeten onderdeel van de productiebaseline worden. [4]

Voor processen die niet verloren mogen gaan door een crash of netwerkstoring kan een durable workflow-engine zoals Temporal worden toegevoegd. Temporal is ontworpen om workflows na storingen te hervatten vanaf de vastgelegde staat. [5]

| Workflow | Trigger | Automatiseringsniveau | Goedkeuring | Kerncontrole | Prioriteit |
| --- | --- | --- | --- | --- | --- |
| Dagelijkse operationele briefing | Schedule, bijvoorbeeld 07:30 | Volledig automatisch | Niet nodig | Alleen lezen; bronlinks | High |
| Vastgelopen orders detecteren | Webhook plus periodieke controle | Automatisch detecteren | Niet voor melding | Dedupe, order-ID, severity | High |
| Order opnieuw aanbieden | Gedetecteerde fout | Draft of voorbereid | Verplicht in MVP | Idempotency key en statuscheck | High |
| Listingkwaliteitsanalyse | Nieuwe/gewijzigde listing | Automatische analyse | Niet nodig | Geen publicatierechten | High |
| Titel- of beschrijvingsvoorstel | Analyse-uitkomst | Automatisch concept | Goedkeuring vóór publicatie | Diff-view en marketplacevalidatie | High |
| Listing publiceren | Goedgekeurd concept | Uitvoering na bevestiging | Verplicht | Rate limit, snapshot, rollback | High |
| Prijswijziging | Marge- of concurrentietrigger | Alleen aanbeveling in MVP | Verplicht | Min/max-prijs en margegrens | High |
| Voorraadcorrectie | Voorraadverschil | Voorstel | Verplicht | Bronreconciliatie | High |
| Server- en tunnelmonitoring | Event plus schedule | Automatische detectie | Niet nodig | Read-only monitoringaccount | High |
| Service restart | Healthcheck faalt | Beperkte automatische actie | Alleen voor allow-listed services | Maximaal aantal retries | Medium |
| Cache legen | Specifieke foutconditie | Gedeeltelijk automatisch | Eerst verplicht | Scopebeperking en impactcheck | Medium |
| Agenda-assistent | Agenda-event of verzoek | Concepten en reminders | Bevestiging voor uitnodigingen | Alleen eigen agenda | Medium |
| E-mailconcepten | Inkomend bericht | Draft | Bevestiging voor verzenden | Geen autonoom send/delete | Medium |
| Vault-ingest | Nieuw bestand | Automatische classificatie en conceptmetadata | Review bij gevoelige data | Malware scan, provenance, quarantainelaag | High |
| Persoonlijke dagreview | Dagelijks | Automatisch overzicht | Niet nodig | Privé-kanaal, beperkte retentie | Medium |
| Financiële betaling | Verzoek of factuur | Alleen analyseren | Altijd extern bevestigen | Nooit autonome betaling | High |
| Verwijderen van bestanden/data | Verzoek | Soft-deletevoorstel | Step-up auth | Quarantaine en hersteltermijn | High |

RPA-beleid: kies API’s en webhooks als standaard. Gebruik browser- of desktop-RPA alleen wanneer een systeem geen stabiele API heeft. RPA moet in een geïsoleerde worker draaien, met een beperkt account, screenshots voor bewijs, selectors met validatie en een harde stop wanneer de interface onverwacht verandert.

### Personalisatie en adaptiviteit

De beste personalisatie ontstaat niet uit een steeds langere system prompt of onbeperkte chatgeschiedenis. Een robuust model bevat verschillende geheugentypen:

| Geheugenlaag | Inhoud | Schrijfmethode | Retentie | Gebruikerscontrole |
| --- | --- | --- | --- | --- |
| Sessiecontext | Actuele taak, recente berichten, tijdelijk plan | Automatisch | Minuten tot uren | Sessie wissen |
| Werkgeheugen | Openstaande stappen en relevante documenten | Automatisch | Tot taak afgerond | Taak sluiten |
| Expliciet profiel | Taal, stijl, doelen, werktijden, tolerantie voor meldingen | Alleen expliciet of bevestigd | Tot gewijzigd | Bekijken en aanpassen |
| Voorkeurengeheugen | Terugkerende keuzes en feedback | Kandidaten laten bevestigen | Periodieke herbevestiging | Accepteren, corrigeren, verwijderen |
| Episodisch geheugen | Belangrijke gebeurtenissen of besluiten | Samenvatting met bronverwijzing | Instelbare TTL | Volledige CRUD |
| Kennisgeheugen | Vault- documenten enoperationele feiten | Gecontroleerde ingest | Volgens bronsysteem | Bron beheren |
| Auditgeheugen | Wie deed wat, wanneer en waarom | Automatisch, append-only | Juridisch/ operationeel bepaald | Beperkte inzage; geen normale bewerking |

Hiërarchisch geheugen is technisch plausibel: MemGPT beschrijft een ontwerp met verschillende geheugenlagen voor context buiten het directe modelvenster. RAG combineert modelkennis met een externe, updatebare kennisbron en biedt daarmee betere mogelijkheden voor provenance dan uitsluitend parametrisch geheugen. [6]

Aanbevolen personalisatiestrategie:

| Techniek | Advies | Prioriteit | Complexiteit | Reden |
| --- | --- | --- | --- | --- |
| Expliciete voorkeuren | Direct bouwen | High | Low | Controleerbaar en corrigeerbaar |
| RAG over Vault | Direct bouwen | High | Medium | Actuele kennis zonder modeltraining |
| Structured user model | Direct bouwen | High | Medium | Vermijdt ondoorzichtige profielinferenties |
| Feedbackknoppen | Direct bouwen | High | Low | Meetbare correcties |
| Episodische samenvattingen | Gefaseerd bouwen | Medium | Medium | Nuttig, maar gevoelig voor verkeerde conclusies |
| Knowledge graph | Later toevoegen | Medium | High | Waardevol voor relaties en historie |
| Fine-tuning voor stijl | Pas na stabiele dataset | Low | High | Moeilijker te wissen en te verklaren |
| Fine-tuning op privédata | Niet voor MVP | Low | Zeer hoog | Extra privacy-, governance- en lifecycle- risico |
| Automatisch emotioneel profiel | Niet aanbevolen | Low | High | Hoog risico op onjuiste of invasieve inferenties |

Supabase kan dit ondersteunen met Postgres, Auth, Row Level Security, vectorsearch en permission- aware RAG. De officiële documentatie benadrukt dat RLS op blootgestelde tabellen ingeschakeld moet zijn en dat privileged service keys niet aan clients mogen worden blootgesteld. Supabase documenteert daarnaast dat vectorretrieval met RLS kan worden gecombineerd, zodat alleen toegestane documenten in de RAG-context terechtkomen. [7]

## Veiligheid, privacy en compliance

### Hoofdbevinding

De huidige formulering “volledige toegang” moet worden vervangen door volledige zichtbaarheid voor de gebruiker, maar minimale rechten voor de AI. Samantha mag weten welke capabilities beschikbaar zijn, zonder permanent over de credentials te beschikken waarmee zij die capabilities zelfstandig kan uitvoeren.

OWASP waarschuwt dat excessive agency ontstaat wanneer een LLM te veel functionaliteit, rechten of autonomie krijgt. Prompt injection kan bovendien rechtstreeks via een gebruiker binnenkomen, maar ook indirect via documenten, webpagina’s, e-mails, listings of toolmetadata die door het model worden gelezen. [8]

### Rechtenmodel

| Risiconiveau | Voorbeelden | Standaardrecht | Bevestiging | Rollback |
| --- | --- | --- | --- | --- |
| Niveau nul: conversatie | Uitleg, samenvatten, brainstorm | Toestaan | Geen | Niet van toepassing |
| Niveau één: read-only | Orders lezen, dashboards opvragen, Vault binnen scope doorzoeken | Toestaan | Geen of sessiebevestiging | Niet van toepassing |
| Niveau twee: draft | E-mailconcept, listingtekst, workflowvoorstel | Toestaan | Voor publicatie | Concept verwijderen |
| Niveau drie: omkeerbare write | Label aanpassen, retry starten, agenda-item maken | Beperkt | Expliciet in MVP | Verplichte compensating action |
| Niveau vier: externe impact | E-mail versturen, listing publiceren, prijs wijzigen | Standaard geblokkeerd | Step-up auth | Snapshot en undo waar mogelijk |
| Niveau vijf: destructief/ financieel | Delete, betaling, credentialwijziging, server wipe | Niet autonoom | Buiten Samantha of dual control | Verplichte recoveryprocedure |

### Threat model

| Dreiging | Aanvalsroute | Potentiële impact | Verplichte maatregel | Prioriteit | Complexiteit |
| --- | --- | --- | --- | --- | --- |
| Directe prompt injection | Telegram- of webbericht | Policy bypass | Input als onbetrouwbaar behandelen; policy buiten LLM | High | Medium |
| Indirecte prompt injection | E-mail, Vault- document, website, listing | Diefstal of ongewenste toolcall | Retrieved content nooit als systeeminstructie uitvoeren | High | High |
| Excessive agency | Te brede API- of shellrechten | Grote blast radius | Capability allow- list en least privilege | High | High |
| Credential leakage | Prompt, log, browser of database | Accountovername | Secret manager, redactie, key rotation | High | Medium |
| Memory poisoning | Fout of kwaadaardig feit wordt permanent opgeslagen | Langdurig verkeerd gedrag | Quarantaine, brongewicht, bevestiging, versiehistorie | High | High |
| Data-exfiltratie | LLM-output, externe URL, webhook | AVG-incident en IP-verlies | Egress allow-list, DLP en dataclassificatie | High | High |
| Onveilige outputverwerking | Modeltekst wordt SQL/shell/HTML | Code execution of injectie | Getypeerde schema’s; nooit vrije output uitvoeren | High | Medium |
| Replay of dubbele uitvoering | Retry/webhook wordt herhaald | Dubbele order- of prijsactie | Idempotency keys en state checks | High | Medium |
| Hallucinatie | Onjuiste feiten of actieparameters | Verkeerde beslissing | Bronvermelding, verificatiestap, confidence gates | High | Medium |
| Supply- chainrisico | Community node, model, MCP-tool | Backdoor of kwetsbaarheid | Gepinde versies, SBOM, review en patch-SLA | High | High |
| Gestolen Telegram-account | Sessiekaping | Volledige assistenttoegang | MFA, device binding, step-up auth | High | Medium |
| Voice spoofing | Opgenomen of synthetische stem | Ongeautoriseerde opdrachten | Stem nooit als enige authenticatiefactor | High | Medium |
| Runaway workflow | Loop of ongecontroleerde retries | Kosten en downtime | Budgetlimieten, timeouts, circuit breakers | High | Medium |
| Onherstelbare delete | Verkeerde interpretatie | Dataverlies | Soft-delete, quarantaine, delayed execution | High | Medium |

### Data governance en AVG

Het doel “zero amnesia” moet worden verlaten. Onder de AVG moeten organisaties privacy by design en default toepassen en standaard niet meer persoonsgegevens verwerken dan nodig voor het specifieke doel. Daar horen beperkingen op hoeveelheid, toegankelijkheid en bewaartermijn bij. Betrokkenen hebben onder meer rechten op inzage, rectificatie, verwijdering, beperking en dataportabiliteit. [9]

Een beter concept is selective, accountable memory:

| Governancecontrole | Vereiste implementatie |
| --- | --- |
| Doelbinding | Iedere memory record krijgt een purpose |
| Rechtsgrond | Per gegevenscategorie vastleggen |
| Herkomst | `source_id` , tijdstip, gebruiker en extractiemethode |
| Gevoeligheid | Public, internal, confidential, personal, special category |
| Betrouwbaarheid | Confidence en verificatiestatus |
| Bewaartermijn | `expires_at` of expliciete uitzondering |
| Toestemming | Vastleggen wanneer informatie vrijwillig wordt onthouden |
| Correctie | Nieuwe versie plus verwijzing naar vervangen record |
| Verwijdering | Hard delete waar vereist; verwijderen uit vectorindex en caches |
| Export | Machineleesbare export van profiel en herinneringen |
| Traininggebruik | Standaard uit; afzonderlijke expliciete keuze |
| Derden | Register van providers, regio’s en subverwerkers |
| Incidentrespons | Detectie, beoordeling en meldprocedure |

Een DPIA is waarschijnlijk verstandig voordat Samantha breed toegang krijgt tot persoonlijke agenda’s, communicatie, e-commerceklantdata, gedragsprofielen of continue monitoring. De EDPB noemt een DPIA als relevant wanneer verwerking waarschijnlijk een hoog risico oplevert en verlangt dat organisaties hun naleving kunnen aantonen. [10]

Wanneer Samantha beslissingen over andere personen zou nemen die juridische of vergelijkbaar significante gevolgen hebben, worden de regels rond geautomatiseerde besluitvorming en profilering relevant. Volledig geautomatiseerde besluitvorming met zulke gevolgen is onder de AVG beperkt en vraagt onder meer daadwerkelijke menselijke interventie en passende waarborgen. [11]

### Encryptie, authenticatie en secrets

| Onderdeel | Minimumvereiste | Aanbevolen technologie |
| --- | --- | --- |
| Data in transit | TLS voor alle verbindingen | TLS 1.2 of hoger |
| Database at rest | Provider- of disk-encryptie | Supabase/Postgres-encryptie |
| Gevoelige velden | Applicatie- of kolomniveau-encryptie waar nodig | Envelope encryption |
| Secrets | Niet in prompts, workflows of Vault- notes | Supabase Vault of externe secret manager |
| Gebruikersauth | MFA en korte sessies | Supabase Auth of centrale IdP |
| Serviceauth | Individuele service identities | Kortlevende tokens |
| Autorisatie | RLS plus capability policies | Postgres RLS |
| Webhooks | Signature, timestamp en replaypreventie | HMAC plus nonce |
| Device access | Device identity en remote revoke | MDM/VPN waar passend |
| Logs | Gevoelige velden redacten | Structured logging met DLP-filter |

Supabase Vault slaat secrets met authenticated encryption op, maar secrets moeten nog steeds alleen aan minimale, server-side uitvoeringspaden beschikbaar worden gemaakt. De Supabase-documentatie waarschuwt tevens dat service- of bypassrechten RLS kunnen omzeilen en daarom niet in clients of onbeheerde workflows thuishoren. [12]

### AI-governance

Gebruik NIST AI RMF als operationeel raamwerk met vier permanente functies: govern, map, measure en manage. Het NIST Generative AI Profile voegt specifieke aandacht toe voor generatieve-AI-risico’s, evaluatie, incidenten en lifecycle governance. [13]

De Europese AI-verordening is sinds 2 augustus 2026 grotendeels toepasbaar, met afwijkende termijnen voor bepaalde hoogrisicosystemen. Voor een normale persoonlijke/e-commerce-assistent is de hoogrisicoclassificatie niet automatisch van toepassing, maar de classificatie moet opnieuw worden beoordeeld zodra Samantha wordt gebruikt voor bijvoorbeeld arbeidsbesluiten, kredietwaardigheid, biometrie of andere gevoelige toepassingsgebieden. Interactieve AI-systemen moeten mensen in toepasselijke situaties informeren dat zij met AI interacteren. [14]

## Betrouwbaarheid, performance en gebruikersacceptatie

### Reliability-architectuur

De huidige blueprint noemt geen SLO’s, failover, recovery, observability of formele verificatie. Dat is onvoldoende voor een assistent die orders, listings, infrastructuur of agenda’s kan beïnvloeden.

| Betrouwbaarheidscontrole | MVP | Volwassen stadium |
| --- | --- | --- |
| Beschikbaarheid chatinterface | 99,5% per maand | 99,9% |
| Succesratio read-only workflows | ≥99,0% | ≥99,8% |
| Succesratio goedgekeurde writes | ≥98,0% | ≥99,5% |
| Onbedoelde dubbele acties | <0,5% | <0,1% |
| Herstelbare acties | ≥90% | ≥99% |
| RPO database | Maximaal 24 uur | Maximaal 5 minuten |
| RTO | Maximaal 4 uur | Maximaal 30 minuten |
| Detectie kritieke workflowfout | Binnen 15 minuten | Binnen 5 minuten |
| Auditdekking | ≥95% acties | 100% acties |
| Security-patchtermijn kritiek | 72 uur | 24 uur |
| Runaway-costdetectie | Dagelijks | Binnen 5 minuten |

Dit zijn aanbevolen doelwaarden, geen gemeten huidige prestaties.

### Latencydoelen

De eerder genoemde voice-response binnen 1,5 seconde is pas realistisch wanneer streaming speech- to-text, snelle intentdetectie, parallelle retrieval, streaming modeloutput en text-to-speech worden gecombineerd. Voor een eerste productieversie zijn de volgende targets realistischer:

| Interactie | MVP-doel | Later doel |
| --- | --- | --- |
| Eenvoudige tekstvraag, first token p50 | <2 seconden | <1 seconde |
| Eenvoudige tekstvraag, first token p95 | <5 seconden | <3 seconden |
| RAG-antwoord volledig p95 | <10 seconden | <6 seconden |
| Read-only toolactie p95 | <8 seconden | <5 seconden |
| Complexe multi-tool-taak | Voortgang zichtbaar binnen 3 seconden | Idem |
| Voice first audio p50 | <3 seconden | <1,5 seconde |
| Proactieve incidentmelding | <5 minuten na event | <1 minuut |

De UX moet onderscheid maken tussen “Samantha denkt”, “Samantha wacht op een externe API”, “actie vereist goedkeuring” en “actie uitgevoerd”. Een generieke typing-indicator is onvoldoende voor langlopende workflows.

### Observability

OpenTelemetry biedt een vendor-neutrale manier om traces, metrics en logs met gedeelde context te verzamelen. Daarmee kan één Samantha-verzoek worden gevolgd van Telegram via retrieval en modelcall tot n8n-workflow en externe API. [15]

Iedere run moet minimaal bevatten:

| Veld | Doel |
| --- | --- |
| `trace_id` | End-to-end reconstructie |
| `user_id` en `session_id` | Geautoriseerde herkomst |
| `request_class` | Chat, read, draft, write, publish, delete |
| `model_provider` en `model_version` | Reproduceerbaarheid |
| `prompt_version` | Regressieanalyse |
| `retrieved_source_ids` | Provenance |
| `policy_decision` | Waarom toegestaan of geweigerd |
| `tool_name` en `tool_version` | Tooltracking |
| `approval_id` | Bewijs van menselijke toestemming |
| `idempotency_key` | Dubbele uitvoering voorkomen |
| `latency_breakdown` | Bottleneckanalyse |
| `token_usage` en kosten | Budgetbewaking |
| `result_verification` | Uitkomstcontrole |
| `rollback_reference` | Herstel |
| `redaction_status` | Voorkomen van gevoelige logging |

### Failover en degradatie

Samantha moet veilig kunnen degraderen:

| Storing | Gewenst gedrag |
| --- | --- |
| Primair LLM niet beschikbaar | Overschakelen naar goedgekeurd fallbackmodel of read-only modus |
| Vectorstore niet beschikbaar | Geen ongefundeerde geheugenclaims; antwoorden zonder persoonlijke retrieval |
| n8n niet beschikbaar | Taken in durable queue; geen stille verdwijning |
| Externe API timeout | Exponentiële back-off binnen harde retrylimiet |
| Policy engine niet beschikbaar | Fail closed: geen writes uitvoeren |
| Auditlog niet beschikbaar | Kritieke acties blokkeren |
| Goedkeuringskanaal niet beschikbaar | Kritieke taak pauzeren |
| Supabase unavailable | Geen memory writes; tijdelijk encrypted buffer met korte TTL |
| Onzeker resultaat | Escaleren naar gebruiker in plaats van gokken |

### UX, explainability en controle

De beste persoonlijke AI is niet degene die altijd autonoom handelt, maar degene die de juiste mate van initiatief kiest en de gebruiker controle geeft.

| UX-component | Functie | Prioriteit | Complexiteit |
| --- | --- | --- | --- |
| Actiepreview | Laat precies zien wat gewijzigd wordt | High | Medium |
| Diff-view | Voor/na bij listings, e-mail en configuratie | High | Medium |
| “Waarom?”-knop | Bronnen, regels en aannames tonen | High | Medium |
| Memory dashboard | Bekijken, corrigeren, vastzetten en verwijderen | High | Medium |
| Autonomie- instellingen | Per tool bepalen: read, draft, confirm, auto | High | Medium |
| Notification budget | Maximum aantal proactieve meldingen | High | Low |
| Stilteperiodes | Geen niet-kritieke meldingen tijdens rust | Medium | Low |
| Undo centre | Recente acties terugdraaien | High | High |
| Activity feed | Volledige, begrijpelijke historie | High | Medium |
| Vertrouwensindicator | Feit, inferentie, voorstel of onbekend | High | Low |
| Bronverwijzingen | Document en datum tonen | High | Medium |
| Emergency stop | Alle uitvoering direct uitschakelen | High | Medium |
| Persona sliders | Zakelijk, warm, kort, kritisch | Medium | Low |
| Onboarding | Toestemmingen per domein uitleggen | High | Medium |

“Persoonlijkheid” mag niet betekenen dat Samantha onzekerheid verbergt of psychologische autoriteit simuleert. Ze moet duidelijk blijven aangeven dat zij een AI-systeem is, welke bronnen zij heeft gebruikt en waar menselijke verificatie nodig is. De AI Act-transparantievereisten voor interactieve AI ondersteunen deze ontwerpkeuze. [16]

## Roadmap, resources, kosten en KPI’s

### Aanbevolen roadmap

De voorgestelde volgorde wijkt bewust af van het oorspronkelijke JARVIS-blueprint. Voice en ambient sensing komen niet vóór de security-, memory- en executionfundering.

**Roadmap voor een veilige en persoonlijke Samantha**

*(Figuur in de bron: tijdlijn met fasen per datum; hieronder als lijst.)*

- 2026-08-10 — Discovery en governance
  - Feature registry en architectuurinventaris
  - Data mapping, DPIA-screening en threat model
  - Bevriezen van onbeperkte toegangsrechten
- 2026-08-24 — Secure core
  - Identity, MFA en capability model
  - Policy engine en execution gateway
  - Auditlog, kill switch en secret management
- 2026-09-21 — Veilige MVP-automatisering
  - Dagbriefing en read-only e-commerce monitoring
  - Orderfoutdetectie en listingconcepten
  - Goedkeuringsflow, idempotency en rollback
- 2026-10-19 — Persoonlijk geheugen
  - Structured user profile
  - Permission-aware Vault RAG
  - Memory dashboard, TTL en correctie/verwijdering
- 2026-11-16 — Reliability en acceptatie
  - OpenTelemetry en SLO dashboards
  - Failover, restoretests en red-teamtests
  - Pilotgebruik en UX-optimalisatie
- 2026-12-07 — Voice en vision pilot
  - Telegram voice notes
  - Screenshotanalyse
  - Geen autonome acties op basis van voice of vision
- 2027-01-04 — Beperkte proactieve autonomie
  - Event-driven Samantha Pulse
  - Alleen allow-listed omkeerbare acties
  - Maandelijkse governance review

### Fasen, deliverables en gates

| Fase | Duur | Belangrijkste deliverables | Exit gate | Prioriteit |
| --- | --- | --- | --- | --- |
| Discovery en baseline | 2 weken | Feature registry, systeemkaart, datastromen, risicoanalyse | Alle bestaande functies en credentials geïnventariseerd | High |
| Secure core | 4–5 weken | Auth, policy engine, execution gateway, audit, kill switch | Geen directe LLM- toegang tot privileged credentials | High |
| MVP- automatisering | 4 weken | Drie tot vijf workflows, approvals, idempotency | ≥98% succesvolle testuitvoering; nul ongeautoriseerde writes | High |
| Memory en personalisatie | 3–4 weken | User profile, RAG, memory lifecycle, dashboard | Geheugen kan worden bekeken, gecorrigeerd en verwijderd | High |
| Reliability en UX | 3–4 weken | SLO’s, traces, recovery, activity feed, undo | Restore- en incidenttests geslaagd | High |
| Voice en vision | 3 weken | Voice notes en veilige image analysis | Geen voice-only authenticatie; toolactions blijven gated | Medium |
| Proactieve autonomie | Doorlopend | Event-driven monitoring en beperkte auto- remediation | Per capability expliciet risicogoedgekeurd | Medium |

### Benodigde rollen

| Rol | Gemiddelde inzet | Verantwoordelijkheid |
| --- | --- | --- |
| Product owner/ domeineigenaar | 0,2–0,4 FTE | Prioriteiten, e-commerceprocessen, acceptatie |
| AI/agent architect | 0,6–1,0 FTE | Orchestratie, prompting, retrieval, evaluaties |
| Backend engineer | 1,0 FTE | API’s, policy gateway, memory service |
| Automation engineer | 0,5–1,0 FTE | n8n, connectors, triggers, retries |
| DevOps/SRE | 0,3–0,5 FTE | Deployment, observability, back-up, failover |
| Security engineer | 0,2–0,5 FTE | Threat model, IAM, sandboxing, pentest |
| Privacy/legal specialist | 0,1–0,2 FTE | AVG, DPIA, contracten, AI Act |
| UX/conversation designer | 0,2–0,4 FTE | Persona, onboarding, approvals, explainability |
| QA/automation tester | 0,3–0,6 FTE | Regressie-, workflow- en adversarial tests |

Een persoon kan meerdere rollen combineren, maar security review en productacceptatie mogen niet uitsluitend door dezelfde engineer worden uitgevoerd die de betreffende capability heeft gebouwd.

### Indicatieve kostenraming

De onderstaande bedragen zijn een engineeringraming, geen offerte. Ze gaan uit van een blended extern tarief van ongeveer €900–€1.300 per werkdag, een bestaande basisinfrastructuur en één primaire gebruiker. Werkelijke tarieven, contracten en bestaande herbruikbare code zijn onbekend.

| Fase | Teamomvang equivalent | Indicatieve kosten |
| --- | --- | --- |
| Discovery, inventarisatie en risicoanalyse | 20–30 teamdagen | €18.000–€39.000 |
| Secure core | 45–65 teamdagen | €40.000–€85.000 |
| MVP-workflows | 35–55 teamdagen | €32.000–€72.000 |
| Memory en personalisatie | 30–50 teamdagen | €27.000–€65.000 |
| Reliability, UX en hardening | 25–45 teamdagen | €23.000–€59.000 |
| Voice/vision pilot | 15–30 teamdagen | €14.000–€39.000 |
| Totaal met overlap en hergebruik | — | €110.000–€250.000 |

Een lean traject dat bestaande n8n-, Supabase- en Telegram-componenten intensief hergebruikt, voice uitstelt en slechts drie workflows productierijp maakt, kan mogelijk binnen €45.000–€100.000 blijven. Dat scenario heeft minder redundancy, minder uitgebreide UX en een kleinere integratiescope.

| Operationele kosten | Raming |
| --- | --- |
| LLM/API-verbruik | Onbekend zonder volume, modelkeuze en contextgrootte |
| Voice/STT/TTS | Onbekend zonder gebruiksminuten en provider |
| Supabase/n8n/hosting | Onbekend door deployment- en planonzekerheid |
| Monitoring en logging | Onbekend door retentie en datavolume |
| Security tooling | Onbekend |
| Onderhoud | Reken indicatief op 0,2–0,5 FTE na productie |
| Periodieke privacy/securityreview | Minimaal per kwartaal en bij grote capabilitywijzigingen |

### Belangrijkste projectrisico’s

| Risico | Kans | Impact | Mitigatie | Eigenaar |
| --- | --- | --- | --- | --- |
| Bestaande functionaliteit blijkt niet reproduceerbaar | Hoog | Hoog | Feature registry en technische discovery vóór nieuwbouw | Product/ architect |
| Te brede credentials zijn al actief | Medium– hoog | Kritiek | Direct roteren en opsplitsen | Security/ DevOps |
| Vault bevat gevoelige of ongeclassificeerde data | Hoog | Hoog | Dataclassificatie en permission-aware ingest | Privacy/data |
| Agent voert verkeerde write uit | Medium | Kritiek | Approval, schema validation, idempotency, rollback | Backend/ security |
| Memory bevat onjuiste conclusies | Hoog | Hoog | Bevestigingsflow, provenance, confidence en versiebeheer | AI/UX |
| Integraties breken bij API-wijzigingen | Medium | Hoog | Contracttests, versiepinning en adapters | Automation |
| Meldingen worden irritant | Hoog | Medium | Notification budget en feedbackgestuurde drempels | UX/product |
| Latency wordt te hoog door RAG en tools | Medium | Medium | Parallelisatie, caching, routing en tracing | AI/SRE |
| Tokenkosten lopen weg | Medium | Hoog | Budgetten, modelrouting en contextcompressie | Product/SRE |
| Persona krijgt te veel vertrouwen | Medium | Hoog | Transparantie, onzekerheidslabels en action previews | UX/ governance |
| Compliance wordt achteraf toegevoegd | Medium | Hoog | DPIA- en governancegate vóór gevoelige integraties | Privacy/ product |

### Meetbare succescriteria

| Dimensie | KPI | MVP-doel | Volwassen doel |
| --- | --- | --- | --- |
| Taakautomatisering | Bespaarde handmatige tijd | ≥5 uur per week | ≥15 uur per week |
| Taakvoltooiing | Succesvolle workflows zonder handmatige reparatie | ≥90% | ≥98% |
| Actieve correctheid | Ongeautoriseerde writes | 0 | 0 |
| Actieve correctheid | Verkeerde writes per 1.000 acties | <5 | <1 |
| Betrouwbaarheid | Workflow success rate | ≥98% | ≥99,5% |
| Betrouwbaarheid | Dubbele acties | <0,5% | <0,1% |
| Herstelbaarheid | Writes met werkende rollback | ≥90% | ≥99% |
| Performance | Tekst first-token p95 | <5 sec | <3 sec |
| Performance | Read-only toolactie p95 | <8 sec | <5 sec |
| Geheugenkwaliteit | Bevestigde correcte herinneringen | ≥90% | ≥97% |
| Geheugenkwaliteit | Memory records met provenance | 100% | 100% |
| Privacy | Records zonder doel/retentieveld | 0 | 0 |
| Privacy | Verwijderverzoeken volledig verwerkt | 100% | 100% |
| Security | Privileged actions zonder step- up approval | 0 | 0 |
| Security | Kritieke open kwetsbaarheden | 0 | 0 |
| Auditability | Toolcalls met volledige trace | ≥95% | 100% |
| UX | Goedkeuringsbeslissing binnen 20 seconden | ≥80% | ≥90% |
| UX | Gebruiker begrijpt voorgestelde actie | ≥90% in tests | ≥95% |
| Acceptatie | Wekelijks actief gebruik | ≥4 dagen per week | ≥6 dagen per week |
| Proactiviteit | Relevante meldingen | ≥70% als nuttig beoordeeld | ≥85% |
| Proactiviteit | Genegeerde of irritante meldingen | <20% | <10% |
| Uitlegbaarheid | Antwoorden met bron bij zakelijke feiten | ≥95% | ≥99% |
| Kosten | Kosten per succesvol geautomatiseerde taak | Baseline vaststellen | Maandelijks dalend |
| Businessimpact | Voorkomen order-/ listingincidenten | Baseline plus trend | Meetbare omzet- of foutreductie |

## Beslissende aanbeveling

Samantha kan uitgroeien tot een uitzonderlijk goede persoonlijke AI, maar niet door haar simpelweg meer persoonlijkheid, meer geheugen en meer systeemrechten te geven. De winnende architectuur combineert:

een stabiele persona, selectief geheugen, actuele kennis, veilige tooltoegang, event-driven automatisering, expliciete gebruikerscontrole, volledige auditability en meetbare betrouwbaarheid.

Het nieuwe voorstel moet daarom niet worden afgewezen, maar worden herbouwd rond drie harde principes:

1. Samantha mag breed kunnen begrijpen, maar smal en gecontroleerd uitvoeren.
2. Alles wat zij onthoudt moet herleidbaar, corrigeerbaar en vergeetbaar zijn.
3. Alles wat zij uitvoert moet toegestaan, observeerbaar, verifieerbaar en waar mogelijk omkeerbaar zijn.

Pas wanneer die fundering aantoonbaar werkt, zijn een proactieve heartbeat, ambient voice, vision en een rijkere JARVIS-achtige persoonlijkheid verantwoorde uitbreidingen.

## Bronnen

- 1 8 LLM06:2025 Excessive Agency - OWASP Gen AI Security Project — https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com
- 2 14 Navigating the AI Act | Shaping Europe’s digital future — https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com
- 3 ReAct: Synergizing Reasoning and Acting in Language Models — https://arxiv.org/abs/2210.03629?utm_source=chatgpt.com
- 4 Security audit | n8n Docs — https://docs.n8n.io/hosting/securing/security-audit/?utm_source=chatgpt.com
- 5 Temporal Docs | Temporal Platform Documentation — https://docs.temporal.io/?utm_source=chatgpt.com
- 6 MemGPT: Towards LLMs as Operating Systems — https://arxiv.org/abs/2310.08560?utm_source=chatgpt.com
- 7 Row Level Security | Supabase Docs — https://supabase.com/docs/guides/database/postgres/row-level-security?utm_source=chatgpt.com
- 9 10 Be compliant | Data protection guide for small business | European Data Protection Board — https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com
- 11 Respect individuals’ rights | Data protection guide for small business | European Data Protection Board — https://www.edpb.europa.eu/sme/be-compliant/respect-individuals-rights_ga?utm_source=chatgpt.com
- 12 Vault | Supabase Docs — https://supabase.com/docs/guides/database/vault?utm_source=chatgpt.com
- 13 Artificial Intelligence Risk Management Framework: Generative Artificial Intelligence Profile | NIST — https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence?utm_source=chatgpt.com
- 15 OpenTelemetry — https://opentelemetry.io/?utm_source=chatgpt.com
- 16 Transparenzpflichten nach Artikel 50 des KI-Gesetzes | Gestaltung der digitalen Zukunft Europas — https://digital-strategy.ec.europa.eu/de/faqs/transparency-obligations-under-article-50-ai-act?utm_source=chatgpt.com

<https://chatgpt.com/?utm_src=deep-research-pdf>
<https://chatgpt.com/?utm_src=deep-research-pdf>
<https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com>
<https://arxiv.org/abs/2210.03629?utm_source=chatgpt.com>
<https://docs.n8n.io/hosting/securing/security-audit/?utm_source=chatgpt.com>
<https://docs.temporal.io/?utm_source=chatgpt.com>
<https://arxiv.org/abs/2310.08560?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/postgres/row-level-security?utm_source=chatgpt.com>
<https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/respect-individuals-rights_ga?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/vault?utm_source=chatgpt.com>
<https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com>
<https://opentelemetry.io/?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/de/faqs/transparency-obligations-under-article-50-ai-act?utm_source=chatgpt.com>
<https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com>
<https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com>
<https://genai.owasp.org/llmrisk/llm062025-excessive-agency/?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/en/faqs/navigating-ai-act?utm_source=chatgpt.com>
<https://arxiv.org/abs/2210.03629?utm_source=chatgpt.com>
<https://arxiv.org/abs/2210.03629?utm_source=chatgpt.com>
<https://docs.n8n.io/hosting/securing/security-audit/?utm_source=chatgpt.com>
<https://docs.n8n.io/hosting/securing/security-audit/?utm_source=chatgpt.com>
<https://docs.temporal.io/?utm_source=chatgpt.com>
<https://docs.temporal.io/?utm_source=chatgpt.com>
<https://arxiv.org/abs/2310.08560?utm_source=chatgpt.com>
<https://arxiv.org/abs/2310.08560?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/postgres/row-level-security?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/postgres/row-level-security?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/be-compliant_en?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/respect-individuals-rights_ga?utm_source=chatgpt.com>
<https://www.edpb.europa.eu/sme/be-compliant/respect-individuals-rights_ga?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/vault?utm_source=chatgpt.com>
<https://supabase.com/docs/guides/database/vault?utm_source=chatgpt.com>
<https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence?utm_source=chatgpt.com>
<https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence?utm_source=chatgpt.com>
<https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence?utm_source=chatgpt.com>
<https://opentelemetry.io/?utm_source=chatgpt.com>
<https://opentelemetry.io/?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/de/faqs/transparency-obligations-under-article-50-ai-act?utm_source=chatgpt.com>
<https://digital-strategy.ec.europa.eu/de/faqs/transparency-obligations-under-article-50-ai-act?utm_source=chatgpt.com>
