---
title: "Voorstel stap 0 (Drive-intake) voor routine 'Vault bridge drain + ingest', niet toegepast"
type: meta
scope: [CCP, HVL, MPG]
status: draft
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [routine-stap0, drive-intake-voorstel]
tags: [cowork, routine, drive, intake, bridge]
sources: ["[[2026-10-14-secondbrain-next-step]]", "[[2026-10-14-meta-denylist]]", "[[2026-10-14-labelcontract-v0.2-draft]]"]
hansos.id: meta-2026-10-14-routine-stap0
record_kind: meta
skill_ids: []
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

# Stap 0: Drive-intake voor de dagelijkse routine

Routine: "Vault bridge drain + ingest", trigger-id `trig_01YAu3Tb2SKwuVn5aiDdvR8Z`, dagelijks 22:48 Europe/Amsterdam, vault gemount, Google_Drive-connector aangesloten, laatste run 13 okt OK. Status van dit voorstel: NIET toegepast. Toepassing alleen na 2 dry-runs en JA van Hans, via update_trigger (omkeerbaar; de huidige prompt staat onderaan).

## Waarom hier
Hergebruikt de bestaande mount, connector en drain-lus. Geen nieuwe schrijver, geen nieuwe secrets. Stap 0 schrijft alleen in `_connector/bridge/inbox/drive/` en `_connector/state/drive.json`; stap 1 en 2 blijven ongewijzigd en nemen de map `drive/` automatisch mee.

## Tekst om vóór "STAP 1 - Drain" in te voegen

STAP 0 - Drive-intake (max 5 bestanden per run)
Gebruik de Google_Drive-connector. Intakemap: AI-en-automatisering/_vault-inbox (map-id 1J3qP69iLzCVc3bmK1FRU-pSNuYgjm4Ck). Cursor: _connector/state/drive.json met de vorm {"last_modified": "<RFC3339>", "seen": {"<drive_id>": "<modifiedTime>"}}. Ontbreekt het bestand: maak het aan met last_modified = 2026-10-14T00:00:00Z en seen leeg.
a. Zoek in de intakemap naar bestanden met modifiedTime groter dan last_modified (search_files met parentId = '<map-id>' and modifiedTime > '<last_modified>'). Oudste eerst, maximaal 5. Alleen Google Docs, .md, .txt en .pdf; mappen en andere types melden en overslaan.
b. harvest_id = <drive_id>_<modifiedTime>. Staat drive_id in seen met dezelfde modifiedTime: overslaan.
c. Denylist vóór lezen: naam matcht op .env, .key, .pem, .rdp, .pfx, credentials, PRIVE, everything, ENV-INVULLEN: niet lezen, niet kopiëren, melden als GEBLOKKEERD. Na lezen: inhoud matcht op de patronen in _meta/denylist.md (api key, secret, token, Bearer, sk-, ghp_, eyJ..., wachtwoord): idem GEBLOKKEERD.
d. Lees de inhoud (read_file_content; Google Doc als tekst). Schrijf _connector/bridge/inbox/drive/<YYYY-MM-DD>_<scope>_<slug>.md. Datum = createdTime van het Drive-bestand, of de datum uit de bestandsnaam als die het patroon YYYY-MM-DD_ volgt. Scope = ccp, hvl, mpg of ai (bepaal uit map en inhoud; twijfel = ai). Slug = kebab-case uit de titel, max 60 tekens.
   Frontmatter volgens _meta/labelcontract-v0.2.md: title, type: source, scope: [CCP|HVL|MPG|HansOS], status: draft, created, last_reviewed (vandaag), aliases: [], tags (3 tot 6), sources: [], source: drive-bridge, source_kind (article voor Docs en .md, pdf voor .pdf), source_url (webViewLink), drive_id, ai_generator (gemini als titel of inhoud Gemini of Deep Research noemt, chatgpt als ChatGPT, anders human), ingested_from: _connector/bridge/inbox/drive/<bestand>, ingested_on: "", hansos.id: src-<created>-<slug>, record_kind: source, skill_ids: [], case_ids: [], contract_version: 0.2-draft, classification: internal, notion_id: "".
   Body: "## Herkomst" (Drive-map, datum, generator, status indicatief tot review) en "## Inhoud" (letterlijke tekst, niets samenvatten of weglaten).
   Bestaat dezelfde bestandsnaam al in inbox/drive/, inbox/drive/_processed/, raw/ of raw/_archive/: overslaan en melden.
e. Werk drive.json bij: seen[drive_id] = modifiedTime, last_modified = hoogste verwerkte modifiedTime. Voeg aan log.md 1 regel toe: "- YYYY-MM-DD DRIVE-INTAKE <n> bestanden -> _connector/bridge/inbox/drive/ (overgeslagen: <k>, geblokkeerd: <m>)".
f. Wijzig, verplaats of verwijder nooit iets in Drive.
Daarna STAP 1 zoals hieronder.

## Dry-run (eerste 2 runs, verplicht)
Zelfde stap 0, maar: schrijf naar _connector/bridge/inbox/drive/_dryrun/ in plaats van inbox/drive/, werk drive.json niet bij, en zet in het eindantwoord per bestand: naam, gekozen datum, scope, slug, ai_generator, classificatie en of de denylist iets blokkeerde. Stap 1 slaat de map _dryrun over (regel toevoegen aan stap 1: "sla _processed en _dryrun over").

## Verify
- Dry-run 1: de 9 bestanden in _vault-inbox verschijnen in _dryrun met complete frontmatter; 0 GEBLOKKEERD.
- Dry-run 2 (volgende dag, niets nieuw): 0 bestanden, cursor ongewijzigd.
- Live run 1: 5 bestanden in inbox/drive/, dezelfde nacht gedraind en geïngest; log.md toont DRIVE-INTAKE en INGEST regels.
- Live run 2: resterende 4; daarna geen herkopie (seen werkt).
- Rollback: update_trigger met de prompt hieronder.

## Huidige prompt (13 okt 2026, bewaard voor rollback, letterlijk)

Je bent de dagelijkse bridge-harvester en Wiki Agent voor Hans van Leeuwen's SecondBrainVault (C:\Users\Malle Flappie\Documents\SecondBrainVault). Taal: Nederlands, vakjargon Engels. Werk volledig autonoom, stel geen vragen. Gebruik device_bash op de gekoppelde computer (vault gemount onder $HOME/mnt/SecondBrainVault). Gebruik nooit Desktop Commander en nooit Kernel.

HARDE REGELS
- Verstuur niets naar niemand (geen mail, Slack, berichten). Alleen bestanden in de vault.
- Verwijder niets. Alleen kopieren en verplaatsen (mv -n).
- Verzin geen feiten. Wat niet in de bron staat: [unverified].
- Geen em-dashes in tekst die je schrijft.
- log.md en COWORK_MASTER.md zijn append-only.

STAP 1 - Drain (vervangt bridge-inbox.ps1, dat niet meer draait)
Voor elke map onder _connector/bridge/inbox/<bron>/ (sla _processed over), voor elk .md-bestand:
a. Kopieer naar raw/<zelfde bestandsnaam>. Zorg dat de frontmatter een regel "source: <bron>-bridge" heeft (voeg frontmatter toe als die ontbreekt). Bestaat raw/<naam> of raw/_archive/<naam> al: overslaan en melden.
b. Verplaats het origineel naar _connector/bridge/inbox/<bron>/_processed/ (map aanmaken als die ontbreekt).
Maximaal 15 bestanden per run, oudste eerst; de rest volgt morgen.

STAP 2 - Ingest (volgens claude.md in de vault-root, Mode A, en _meta/schema.md)
Lees eerst claude.md, _meta/schema.md en index.md. Voor elk nieuw raw-bestand (cross-check log.md):
- Lees volledig, bepaal scope (CCP / HVL / MPG / multi). Persoonlijk muziekwerk (jowikroon, NEON) volgt het bestaande precedent: [[Jowikroon-Music]], [[NEON-Beats-Album]], [[Suno-Audio-Mastering-Keten]].
- Maak wiki/sources/YYYY-MM-DD-<slug>.md met volledige frontmatter (type: source, ingested_from, ingested_on, key_topics) en de body-secties Summary, Key Points, Connections, Open Questions, Sources.
- Breid bestaande topic-pagina's uit (nieuwe sectie met datum) of maak een nieuwe topic als het een nieuw idee is (een idee per bestand). Voeg de bron toe aan de sources-frontmatter van elke geraakte topic en zet last_reviewed op vandaag.
- Werk de relevante domeinpagina bij (wiki/domains/CCP.md, HVL.md of MPG.md) met een regel.
- Controleer dat elke [[wikilink]] die je schrijft naar een bestaand bestand wijst.
- Verplaats het raw-bestand na verwerking naar raw/_archive/.

STAP 3 - Afronden
- Werk index.md bij: regel bovenaan "Sources (recent)" per nieuwe bron, nieuwe topics in de juiste sectie, regel bovenaan "Stats".
- Voeg aan log.md een regel toe per ingest: "- YYYY-MM-DD INGEST raw/<bestand> -> [[...]] (scope: ...)" plus een samenvattende regel met aantallen en hoeveel drops nog in de inbox staan.
- Als C:\AI\claude_cowork\REGISTRY.md bestaat: verander niets aan dat bestand.

Eindantwoord: aantal gedraind, aantal geingest, nieuwe en uitgebreide topics, resterende drops, en exact wat faalde als iets faalde.

## Let op voor de hub-pagina
Stap 2 maakt source-pagina's als wiki/sources/YYYY-MM-DD-<slug>.md. De wikilinks in [[2026-10-14-hub-HansOS-Next-Step-2026-10]] moeten daar bij ingest op worden afgestemd.
