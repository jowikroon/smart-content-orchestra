---
title: "SecondBrainVault als brein over tijd, Gemini/Drive-instroom, Notion als projecthub (voorstel)"
type: topic
scope: [CCP, HVL, MPG]
status: active
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [secondbrain-next-step, hansos-next-step-2026-10]
tags: [hansos, vault, obsidian, notion, drive, gemini, plan]
sources: ["[[2026-10-14-ch00-baseline]]"]
hansos.id: plan-2026-10-14-secondbrain-next-step
record_kind: decision
skill_ids: [hansos-vault:vault-ingest, hansos-vault:vault-lint, hansos-vault:vault-probe]
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

# Plan: SecondBrainVault als brein over tijd, Gemini/Drive-instroom, Notion als projecthub

Vault wordt brein over tijd
Domein-doel: SecondBrainVault blijft de enige canonieke kennisbron (lokaal, raw/ naar wiki/), Obsidian laat de groei over tijd zien, Gemini- en Drive-research stroomt via de bestaande bridge-inbox binnen, Notion draagt projectoverzicht en bijlagen en linkt terug naar de wiki.
Wat we nu bouwen: 1 bewezen intake-lus (Gemini Doc in Drive naar Markdown naar `_connector/bridge/inbox/drive/` naar raw/ naar wiki/) met een Bases-tijdlijn en Graph Animate, plus een nieuwe Notion HansOS Hub met 3 databases, in 14 dagen.
**Eerst de poorten (canoniek pad, secrets uit Drive, labelcontract v0.2), dan de lus handmatig met max 5 bronnen per sessie; geen nieuwe schrijver, geen Supabase-RAG en geen Notion-write voordat Hans JA zegt op de exacte versie.**
Volgende stap: Hans beantwoordt 1 richtingsvraag (Notion naast of in plaats van Linear); Claude levert daarna binnen 72 uur de bridge-drops, de Notion Hub als private draft en de Drive-inboxmap.

---

## 1. Context en bewijs (stand 2026-10-14, geverifieerd)

**Brand Design Book 13 okt** (32 p., volledig gelezen). HansOS = Brief > Retrieve > Build > Review > Release > Observe > Curate > Vault. SecondBrainVault = geheugen: bron, beslissing, verificatie, hergebruik, versie. Labelsysteem v0.1-draft (hansos.id, record_kind, skill_ids, case_ids, contract_version) is nog geen leersysteem: 339 md, 202 met 9 sleutels, 137 incompleet. Review-protocol: Klopt het? Werkt het? Voelt het juist? Publicatie vraagt een interactieve versie met 3 workflowdemo's.

**Actuele vault** = private repo `jowikroon/hansos-vault-backup`, HEAD "Auto-backup 2026-10-13 06:15", in deze sessie read-only gecloned naar `/home/user/hansos-vault-backup`. Feiten:
- wiki/ 345 bestanden: topics 95, sources 238, people 9, domains 3. raw/ leeg, raw/_archive 89. Bridge-inbox cowork 0 pending, 50 processed.
- Command-Board 12 okt: AMBER, 42/380 broken wikilinks (case-insensitief), 36 scheduled tasks waarvan 9 enabled. Light lint 12 okt gedaan.
- Dagelijkse Cowork-routine **"Vault bridge drain + ingest"** (22:48, vault gemount, Google_Drive-connector aangesloten, laatste run 13 okt OK) draineert elke map onder `_connector/bridge/inbox/<bron>/` naar raw/ en ingest volgens claude.md Mode A. Een nieuwe map `inbox/drive/` wordt dus automatisch meegenomen.
- Backup: `Backup-Vault-to-GitHub.ps1` (herschreven 28 aug) pusht dagelijks; HAN-168 (5 sep) verving de verlopen PAT. Linear-issue HAN-132 "vault-resilience laag 1" is daarmee feitelijk gedaan, status staat nog op Todo.
- Sync: Syncthing PC naar Pi 5 (Pi receive-only, `Koppel-Vault-aan-Pi5.ps1`), VPS2 code-server mirror (13 okt), GitHub-backup. `_prive/` overal uitgesloten (.stignore, .gitignore). De Pi-roots uit het Brand Book zijn dus mirrors, geen tweede waarheid.
- Obsidian: kale install, 0 community-plugins; graph.json kleurt op pad en tags; Second-Brain-Kaart.canvas is een statische kaart; [[Obsidian-As-Reader]] (24 mei) legt vast: Obsidian leest, de Wiki Agent schrijft. Het brein over tijd bestaat nog niet.
- Labelcontract: vault-labelcontract-v0.1.md, pilotcases-v0.1 en vault-labelsysteem-voorstel.md staan niet in de backup van 13 okt 06:15 en niet in Drive. `hansos.id` komt nergens voor. Locatie [unverified], vermoedelijk lokaal buiten de vault.
- Connectors: `_connector/fanout/endpoints.yml` 15 endpoints (supabase-bucket, wiki-app-vercel, openclaw-cache, gemini-gem-payload tier 2, chatgpt/claudeai-projects tier 3, github-push, ...). Geen Notion-, Drive- of Gemini-intake. Harvesters: chatgpt-export, codex-runs, cowork-sessions, gmail-labeled, supabase-logs, vps-logs. `_connector/mcp/registry.json` (9 okt, 51 entries) kent Notion en google-drive als cowork-connector. NotebookLM-harvest skill bestaat (1 notebook geharvest 23 sep).
- Classifier (`_skill/classifier/classify-rules.yml`): raw/ en lint-rapporten confidential; wiki/sources, wiki/people, log.md, COWORK_MASTER.md internal; topics en domains public tenzij frontmatter anders zegt. Dit bepaalt wat naar Notion mag.
- Open punten die dit raken: ZELFAUDIT-VERBETERPLAN 8 okt (logging split-brain vault log.md vs `C:\AI\claude_cowork\memory\run-log.md`, 2 COWORK_MASTER.md, global instructions in Settings verouderd), [[HANSOS-Registry]] (canoniek register 9 okt), HAN-186 (13 okt, High: scheduled task zonder vault-mount), [[Hermes-Gate-Mandaat-Poort]] (gebouwd, geen cliënt).

**Drive.** Gemini Deep Research landt de facto in map "AI-en-automatisering" (`1NnrCPF01VHGZE3im_AeHPf65-712kbry`, 40+ docs mrt t/m okt 2026, duplicaten 2 tot 4x) en verspreid in scope-mappen. Map `18_dsSw...` heet "ROMMEL-ongetiteld", geen intake. Hans herstructureerde Drive op 13/14 okt (PRIVE, MPG, HVL, AI-en-automatisering, ARCHIEF, CCP-taxonomie) en hernoemde ca. 15 bestanden naar `YYYY-MM-DD_scope_slug`; de Gemini-docs zelf dragen nog default-titels. 14 research-documenten volledig gelezen (11 Gemini Deep Research, 1 Gemini-PDF, 1 Gemini-export, 1 ChatGPT Deep Research). Geen enkel document noemt Notion of een brein over tijd. Direct relevant: "Zelfgehoste n8n Vault Integratie" (10 okt: credential overwrites, Obsidian Local REST API, MCP-bridge, SSRF), "Kostenbesparing AI en Infrastructuur" (10 okt: vault = Tier A, Supabase pgvector als Tier 2, abonnementen opzeggen, VPS consolideren), "Samenvatting hansOS & AI Architectuur.pdf" (9 okt: SecondBrainVault als command center met 3D-pijplijnen), "Dashboard Sync" (22 sep: Dublin Core metadata, deterministische git-sync). De OS Stack-studie (25 mei) adviseert wikilinks om te zetten naar md-links; dat botst met de Obsidian-graph en wordt niet overgenomen.

**Drive-risico.** De vault-snapshot in Drive (`1sy_...`, momentopname 16 aug, "My Computer" desktop-sync) bevat een `_skill`-map en `ENV-INVULLEN-2026-07-11.env` (113 bytes, niet geopend). Soort: adapter-.env. Plus map PRIVE/credentials-NAZIEN. Niets van dit mag ooit naar Notion of een mirror.

**Notion** ("Hans van Leeuwen's Notion", teamspaces E-commerce en Personal projects). Slaapt sinds 2023 (2 identieke stempels 2024-03-20, vermoedelijk systeem-touch [inference]) op 1 pagina na: "CCP Channable Images & Testomgeving Ticket #21966376 (Atvise)", 10 aug 2026, met 4 open actiepunten. Zoeken op HansOS, SecondBrainVault, vault, Obsidian, connectcarparts, marketplacegrowth, hansvanleeuwen, Gemini, Claude: 0 treffers. Projects/Tasks-templates uit 2023 zijn leeg, locked of vervuild (Alpine-productnamen). Capaciteit: create_pages, create_database (FILES, RELATION, ROLLUP, STATUS), create_view, create_file_upload (1 bestand tot 20 MiB), create_attachment (publieke URL), get_file_download_urls (URL verloopt na 1 uur). Plan onder Business: keyword-search, SQL-quota, geen AI-search. Notion MCP vroeg re-auth in non-interactieve runs (COWORK_MASTER S43/S44): schrijven alleen in interactieve sessies. Notion Memory leeg.

**Linear** (team HAN) is live en is per Brand Book de execution source of truth: 60+ issues, laatste update 13 okt. Relevant: HAN-132 vault-resilience, HAN-186 vault-mount, HAN-147 documentatiedrift, HAN-157 blocker-ledger, project P-HAN-3 "Samantha & Cowork agents".

**Deze sessie** (Claude-cloud) heeft lees/schrijf op Drive, Notion, Linear, de repo `jowikroon/smart-content-orchestra` (branch `claude/loving-goodall-ze3mps`) en leestoegang op de vault-backup. Geen toegang tot de lokale vault, de Pi of de PC. Alles wat in de vault moet landen gaat als bridge-drop via een Drive-map die de dagelijkse routine ophaalt, of die Hans kopieert.

## 2. Doelbeeld

- **Vault** = enige kennisbron. raw/ immutable inbox, wiki/ gecureerd, log.md tijdas, git versie. Wikilinks blijven; conversie naar md-links alleen bij export.
- **Obsidian** = lees- en reviewkanaal. Bases-tijdlijn op frontmatter `created` als record (deterministisch, Tier 1), Graph view "Animate" als beleving en demo (kernfunctie, ordent op aanmaaktijd van het bestand, niet op frontmatter), Canvas als kaart.
- **Gemini en ChatGPT** = onderzoeksproducenten. Output via Drive naar `bridge/inbox/drive/`, classifier, raw/, wiki/sources. Label "indicatief" tot Hans de source-pagina beoordeelt.
- **Drive** = landingszone en bijlagenopslag per scope met naamcontract `YYYY-MM-DD_scope_slug`. Nooit raw/ zelf (Google Docs zijn pointers in Drive for desktop).
- **Notion** = projecthub: status, eigenaar, datums, taken, bijlagen, link naar de wiki-pagina via hansos.id en vault_path. De vault houdt het waarom en de les. Linear = executie (issues), Monday = strategische spiegel (ongewijzigd, geen koppeling in deze stap). Deze Notion-rol staat in geen bron en is het voorstel van dit plan.
- **n8n** = pas na hardening en een GO. **Claude-cloud** = schrijver van bridge-drops, Notion en Drive-manifesten. **Claude-lokaal** (Cowork met gemounte vault) = ingest, lint, probe. **Hans** = beoordeelt elke exacte versie.

## 3. Architectuurbesluiten (vast te leggen in HANSOS.md via bridge-drop)

1. **Canoniek.** Lokale vault op de PC is waarheid. Backup-repo = dagelijkse versie (tijdas voor git). Pi en VPS2 = mirrors zonder gezag. Drive-snapshot `1sy_` wordt uit de desktop-sync gehaald of minimaal zonder `_skill/` en `*.env`; stale kopie `1S9koE` naar ARCHIEF. Tier 3, Hans.
2. **Labelcontract v0.2.** Bestaande 9 sleutels plus de bestaande source-velden (ingested_from, ingested_on, source_kind, source_url) blijven verplicht. Nieuw: hansos.id, record_kind (incl. waarde `review`, zodat oordelen zelf nodes worden), skill_ids, case_ids, contract_version (Brand Book v0.1-draft) en drive_id, notion_id, ai_generator [inference]. Geldt direct voor elke nieuwe pagina; de 137 bestaande via een manifest dat Hans valideert. Geen Dublin Core als derde vocabulaire; alleen een mapping-tabel in schema.md.
3. **Classifier-gate inbound en outbound.** Notion komt in endpoints.yml als `notion-hub` (tier 2, internal): titel, status, eigenaar, datums, bijlagen, vault-link. Nooit wiki-tekst, nooit confidential, nooit raw/, `_skill/`, `_connector/`, `_cowork/`. Drive-intake is inbound en hoort in harvest/state, niet in fanout. Secrets-denylist op padsoorten vóór elke sync. Secretsregel: nooit in vault-notes, Notion-rijen, workflow-JSON of Drive-docs; alleen everything.env. Het n8n-advies (N8N_ENCRYPTION_KEY in de vault) wordt niet gevolgd.
4. **Intake-route.** Primair: de bestaande routine "Vault bridge drain + ingest" krijgt een stap 0: lees nieuwe Google Docs uit 1 intakemap (cursor in `_connector/state/drive.json`, harvest_id = drive_id + modifiedTime), schrijf ze als .md met frontmatter naar `_connector/bridge/inbox/drive/`, daarna de bestaande drain. Tier 2, hergebruikt bestaande mount en connector, geen nieuwe secrets. Promptwijziging alleen na JA van Hans. Fallback: rclone copy met `--drive-export-formats md` op de PC. Tot die tijd Tier 3: Hans downloadt Markdown uit Docs.
5. **Brein over tijd.** Frontmatter `created` + Bases = record; Graph Animate = demo; log.md = tijdas; git = versie. Wekelijkse Observe-meting op het Command-Board: nieuwe nodes, nieuwe edges, mediaan dagen raw naar wiki, broken links, backlog, Notion-rijen stale >14 dagen. Nulmeting = Command-Board 12 okt (345 wiki, 42 broken, backlog 0). Geen Juggl (stale 2023), geen Graph Analysis (uit store 21 mei 2026); Clew hooguit experiment.
6. **Schrijfpaden.** Alles buiten wiki/, _meta/, index.md en log.md (endpoints.yml, schema.md, HANSOS.md, HOME.md, canvas, routine-prompt) gebeurt alleen op expliciete opdracht van Hans, met restore point (git commit) vooraf.

## 4. Fasen

Tier 1 = lokaal en deterministisch, Tier 2 = vendor-API of automatisering, Tier 3 = Hans, nooit geautomatiseerd. Hans-uren zijn schattingen.

### Fase 0: Poorten (dag 1 t/m 3, Hans ca. 2 uur)

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| CH-00 baseline-notitie: tellingen uit backup HEAD 13 okt, delta met Brand Book 10 okt (339 vs 345), lijst open items | Claude-cloud | backup-clone, bridge-drop | 1 | Notitie in inbox; Claude-lokaal bevestigt lokaal = HEAD |
| Drive-exposure: Hans haalt snapshot `1sy_` uit desktop-sync of sluit `_skill/` en `*.env` uit; `1S9koE` naar ARCHIEF; credentials-NAZIEN buiten gesyncte paden | Hans | Drive UI | 3 | Drive-zoekopdracht op `.env` in vaultpaden geeft 0 |
| Secrets-denylist (padsoorten) en writers-register (Cowork probe, bridge-drain, Samantha, Claude-code, drive-intake, notion-hub) | Claude-cloud | bridge-drop `_meta/denylist.md`, `_meta/writers.md` | 1 | Classifier-proefrun op 9 kandidaten: 0 treffers |
| Labelcontract v0.2 draft + v0.1 uit de Brand Book-tekst als raw/-bron (de bestanden ontbreken) | Claude-cloud | bridge-drop | 3 | Hans: Klopt, Werkt, Voelt |
| Definieer klaar: input, context, grenzen, output, 4 acceptatiechecks | Claude-cloud, Hans akkoord | bridge-drop | 3 | JA op: 9 bronnen in wiki/sources, Bases en Animate werkend, Hub met 3 projecten, log.md per stap |
| Besluitregels HANSOS.md (canoniek, mirrors, Linear/Monday/Notion-rol, wikilinks, secrets) | Claude-cloud levert, Hans past toe | bridge-drop | 3 | 1 zin per tool in HANSOS.md |

### Fase 1: Gemini en Drive naar raw/ (dag 2 t/m 7, Hans ca. 3 uur)

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| Dedupe- en rename-manifest AI-en-automatisering (id, titel, created, keep/archive, nieuwe naam) | Claude-cloud maakt, Hans voert uit | Drive search, Drive UI | 3 | 1 exemplaar per titel; namen matchen `^\d{4}-\d{2}-\d{2}_(hvl|ccp|mpg|ai)_[a-z0-9-]+$` |
| Intakemap `AI-en-automatisering/_vault-inbox` aanmaken; 1 echte Deep Research-export doen en zien waar hij landt | Claude-cloud (map), Hans (export) | Drive, gemini.google.com | 3 | Map-id in bridge-drop; export zichtbaar |
| Pilot handmatig: "Zelfgehoste n8n Vault Integratie" als `2026-10-10_ai_zelfgehoste-n8n-vault-integratie.md` met v0.2-frontmatter naar `bridge/inbox/drive/` | Claude-cloud levert .md in `_vault-inbox`, Hans kopieert | Drive export md | 3 | Frontmatter compleet; Gemini-boilerplate blijft in raw/ |
| Drain + ingest: source-pagina, links naar [[n8n-Automation-Estate]], [[Obsidian-As-Reader]], [[Second-Brain-Architecture]]; log-regel in bestaand formaat `- YYYY-MM-DD INGEST ...` | Claude-lokaal (routine of interactief) | vault-bridge, vault-ingest | 1 | wiki/sources met v0.2 keys; >=2 topics gelinkt; lint-regel: elke pagina die het topic citeert is bijgewerkt of expliciet als niet-geraakt gelogd |
| Rest in 2 sessies (cap 5): Kostenbesparing, Prompt Optimalisatie, Samenvatting hansOS PDF, OS Stack Research, Dashboard Sync, Samantha-PDF (source chatgpt), Channable herstelplan 12 okt | Claude-cloud levert .md, Claude-lokaal ingest | vault-ingest | 1 | 9 source-pagina's; backlog <= 0 |
| Automatiseren: routine-prompt uitbreiden met stap 0 (Drive-intake, cursor, harvest_id, max 5 per run, dry-run eerst) | Claude-cloud via update_trigger, alleen na JA | Cowork routine | 2 | Nieuw Doc binnen 24 uur als .md in inbox; na drain geen herkopie |

### Fase 2: Brein over tijd zichtbaar (dag 3 t/m 9, Hans ca. 2 uur)

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| Header-gap manifest: CSV van wiki-bestanden zonder `created` of v0.2-sleutels, waarde afgeleid uit eerste log.md-vermelding of ingested_on (nooit ctime na kopie) | Claude-cloud uit backup | script, CSV | 1 | 0 wiki-bestanden zonder `created`; Hans valideert vóór batch-write |
| Batch-write na restore point; lint rapporteert | Claude-lokaal | script, vault-lint | 1 | lint-rapport met oktoberdatum; elke aanvulling gelogd als correctie |
| `_meta/brein-over-tijd.base`: Table (created desc), Cards (30 dagen), Kanban op status | Claude-cloud levert, Claude-lokaal plaatst | Obsidian Bases 1.14 | 1 | 3 views renderen; bestanden zonder created onderaan zichtbaar |
| Hub-pagina `wiki/topics/HansOS-Next-Step-2026-10` linkt 9 bronnen, 3 domeinen en de Notion-hub | Claude-lokaal | vault-ingest | 1 | >=10 edges; 0 nieuwe broken links |
| Graph view: groepen per scope in Brand Book-kleuren (Forest, Process, Review, Vault Gold); Animate opnemen als demo 1 van 3 | Hans | Obsidian | 3 | graph.json aangepast; gedateerde opname in `_cowork/artefacts` met Bron, Beslissing, Verificatie |
| HOME.md en canvas bijwerken (expliciete opdracht): stale claims weg, base-card embed | Hans geeft opdracht, Claude-lokaal | Canvas, HOME.md | 3 | Geen tegenspraak met HANSOS.md |

### Fase 3: Notion HansOS Hub (dag 7 t/m 12, Hans ca. 2 uur)

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| Schema als DDL-tekst ter review: Projecten (naam, scope CCP/HVL/MPG/HansOS, fase, status, eigenaar, datums, hansos_id, vault_path, drive_url, linear_url, classificatie), Taken (two-way relatie, due, status), Bronnen & Bijlagen (FILES, source_url, source_kind, ai_generator, hansos_id, in_vault, last_synced) | Claude-cloud, Hans akkoord | bridge-drop | 2 | Hans: Werkt het? |
| Bouw als private draft, dan verplaatsen naar teamspace E-commerce | Claude-cloud | create_database, create_view | 2 | 3 databases met exacte namen; projectlayout toont Taken en bijlagen |
| Plantest: 1 niet-confidential bestand (Brand Book PDF, 3 MB) uploaden; daarna 1 bestand van 6 MB | Claude-cloud | create_file_upload | 2 | Slaagt 6 MB = betaald (5 GiB), faalt = free (5 MiB); resultaat in log-regel |
| Seed: project 1 Atvise-ticket (4 vinkjes worden Taken), project 2 Channable herstelplan 12 okt (CH-00..CH-15 met Drive-links), project 3 deze stap (fasen als Taken, links naar HAN-132/HAN-186) | Claude-cloud | create_pages, move_pages | 2 | 3 projecten, >=9 taken, hansos_id naar bestaande wiki-pagina |
| Bijlagen: 9 bronrijen = de geïngeste bronnen, upload binnen planlimiet anders Drive-URL; classifier-check vóór upload | Claude-cloud | create_file_upload, create_attachment | 2 | 9 rijen met bestaand vault_path; 0 confidential |
| `notion-hub` in endpoints.yml (tier 2, internal); fanout dry-run op 10 pagina's | Claude-lokaal | endpoints.yml | 1 | Confidential afwezig in payload; index.md-telling = endpoints.yml |
| Lus, interactief: einde sessie 1 voortgangsregel per project; vrijdag Notion naar bridge-drop (rijen zonder in_vault als .md; binaire bijlagen via get_file_download_urls + curl binnen 1 uur) | Claude-cloud | update_page, fetch | 2 | last_synced op elke rij; geen rij >14 dagen open |

### Fase 4: Review, release, les (dag 12 t/m 14, daarna wekelijks, Hans ca. 1,5 uur)

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| Review per onderdeel: Klopt, Werkt, Voelt; uitkomst als `record_kind: review` met hansos.id; afgewezen onderdeel gaat terug naar Build met restore point en nieuwe versie-hash | Hans | hansos-safe-change checklist | 3 | Reviewrecord met criteria, eigenaar, uitkomst, versie-hash |
| Les `wiki/topics/Les-Vault-Intake-MVP-2026-10` (Bron, Beslissing, Verificatie, Hergebruik, Versie) + pilotcase 05; pilotcases 01-04 als case-pagina's met keten Skill > Case > Beslissing > Versie+review > Uitkomst > Les | Claude-lokaal | vault-ingest | 1 | 5 case-pagina's halen lint; zichtbaar in de base |
| 3 demo-opnames voor de Brand Book-publicatie: intake-lus, Animate, Notion-lus | Hans + Claude-cloud | screen recording, `_cowork/artefacts` | 3 | 3 gedateerde opnames met Bron, Beslissing, Verificatie |
| Observe wekelijks: probe, lint, 6 metingen op Command-Board | Claude-lokaal | vault-probe, vault-lint | 1 | Maandag `_meta/lint-*.md`; Command-Board toont de 6 getallen t.o.v. nulmeting 12 okt |
| GO/NO-GO: n8n-route, Supabase pgvector, Notion-upgrade, Clew, Gemini-abonnement (Kostenbesparing adviseert opzeggen, intake hangt eraan) | Hans | Command-Board | 3 | JA/NEE/LATER met datum in log.md |

### Fase 5 (alleen na GO): n8n en automatisering

| Stap | Eigenaar | Tool | Tier | Verify |
|---|---|---|---|---|
| n8n hardening volgens "Zelfgehoste n8n Vault Integratie": Postgres, encryption key in host-env, SSRF-allowlist, geen poort 5678, pruning | Hans + Claude-lokaal | docker-compose, n8n env | 2 | n8n /healthz groen; 0 publieke poort 5678 |
| Drive Trigger als notifier naast de routine; credential overwrites uit read-only JSON op de host (CE-beschikbaarheid [inference]) | Claude-lokaal | n8n | 2 | 1 testdoc triggert binnen 2 min |
| Notion-node Update Markdown voor statusregels; sync-contract uit "Dashboard Sync" (porcelain, ff-only, atomair, nooit force-push) | Claude-lokaal | n8n Notion node | 2 | Dry-run zonder writes eerst |
| Dead man's switch (healthchecks.io) op routine en n8n-flow; Local REST API alleen read voor externe agents, PATCH alleen wiki/ en _meta/ | Hans | healthchecks, Local REST API | 2 | Alarm bij 1 gemiste run |

Supabase pgvector, 3D-dashboard, OpenClaw-consolidatie en abonnementsbesluit blijven backlog met hansos.id.

## 5. Wat Claude direct na goedkeuring doet (72 uur)

Dag 1: CH-00 baseline uit backup HEAD; dedupe- en rename-manifest (CSV); secrets-denylist en writers-register; Drive-map `_vault-inbox` aanmaken; voorstel-doc committen in de repo (`docs/hansos/2026-10-14-secondbrain-next-step.md`) en als draft PR pushen.
Dag 2: labelcontract v0.2 plus v0.1 uit Brand Book als raw-bron; definieer-klaar pagina; 9 Gemini/ChatGPT-docs als .md met frontmatter in `_vault-inbox`; HANSOS.md-besluitregels.
Dag 3: 2 .base-definities en hub-pagina als tekst; Notion Hub als private draft met 3 databases en 3 seed-projecten; plantest met Brand Book PDF; voorstel voor de routine-prompt stap 0 (niet toegepast tot JA); Linear: comment op HAN-132 (laag 1 gedaan, bewijs) en 1 nieuw issue voor deze stap met link naar de Notion-hub.
Alles landt als bridge-drop in `_vault-inbox` (Drive) en in de repo; niets wordt direct in wiki/, in 2023-databases of in de routine geschreven.

## 6. Risico's en gates

- Secrets in Drive-snapshot: gate = Fase 0 exposure-fix vóór elke sync of upload.
- Confidential naar Notion: gate = classifier dry-run, alleen titel, status, link, bijlagen uit public/internal.
- Notion OAuth valt uit in cron: gate = Notion-writes alleen interactief tot n8n gehard is.
- Animate ordent op bestandstijd: gate = `created` in frontmatter + Bases als record; demo op de PC, niet op een kopie.
- Dubbele ingest: gate = copy + cursor + harvest_id; cap 5 per sessie; backlog <= nulmeting.
- Tweede schrijver: gate = writers-register vóór nieuwe runtime; Samantha-pad apart.
- Agent-runaway (claude-mem 345M tokens/dag in Dashboard Sync-doc): gate = geen observer-sessies op vaultpaden; tokenbudget per run in log.md.
- Labelcontract-bestanden ontbreken: gate = v0.1 uit Brand Book als raw-bron; Brand Book-verwijzing volgt.
- Routine-prompt is live-infra: gate = dry-run stap 0 en JA van Hans; update_trigger is omkeerbaar (vorige prompt bewaard in bridge-drop).

## 7. Wat we niet doen

Geen nieuwe Supabase pgvector of RAG (bestaande supabase-bucket fanout en vault-sync blijven ongewijzigd; Supabase blijft audit en logs). Geen 3D-command-center. Geen wikilinks omzetten in wiki/. Geen Juggl, Graph Analysis, obsidian-mcp-tools of two-way Notion-sync-plugins. Geen retrofit van 2023-databases. Geen directe writes in wiki/ door Hans, Gemini, routine-stap 0, n8n of Notion. Geen Drive-for-desktop-map als raw/. Geen secrets in vault-notes, Notion, workflow-JSON of Drive-docs. Geen abonnementsopzegging, VPS-consolidatie of OpenClaw-hardening in deze 2 weken; die adviezen gaan als bron de wiki in. Geen permissiewijzigingen in Drive, Notion of Supabase. Geen ingest van ROMMEL-ongetiteld, PRIVE, BKR of songteksten. Geen agent die goedkeuring uitspreekt namens Hans. Monday ongewijzigd.

## 8. Verificatie (einde dag 14)

1. `wiki/sources/` bevat 9 nieuwe pagina's met v0.2-frontmatter; `grep -l 'hansos.id' wiki/ | wc -l` >= 9 in de backup-repo van die dag.
2. Obsidian 1.14 op de PC: `_meta/brein-over-tijd.base` rendert 3 views, gesorteerd op `created`; Graph Animate-opname staat gedateerd in `_cowork/artefacts`.
3. Notion: 3 databases in E-commerce, 3 projecten, >=9 taken, 9 bronrijen met bestaand vault_path, 0 confidential (classifier-log).
4. Routine "Vault bridge drain + ingest": 1 testdoc in `_vault-inbox` staat binnen 24 uur als source-pagina in wiki/ (alleen als stap 0 is goedgekeurd).
5. log.md toont per stap 1 regel in bestaand formaat; Command-Board toont de 6 Observe-getallen t.o.v. 12 okt.
6. Hans heeft 4 reviewrecords (`record_kind: review`) met uitkomst JA, en 1 les-pagina.

## 9. Besluiten

1. **Notion naast Linear** (besloten door Hans, 14 okt): Notion = projectdossier met status, bijlagen en vault-links; Linear blijft het issue- en executiespoor; de Hub krijgt per project een `linear_url` en linkt naar HAN-132/HAN-186. Geen migratie van Linear-issues.
2. Besloten zonder te vragen (omkeerbaar): intake via uitbreiding van de bestaande routine (rclone als fallback, handmatig tot JA); Notion Hub nieuw in teamspace E-commerce, eerst als private draft; secretsregel = everything.env, nooit vault-notes; wikilinks blijven in wiki/.
3. Goedkeuring van dit plan geldt als JA voor: aanmaken van Drive-map `AI-en-automatisering/_vault-inbox` met bridge-drops, de Notion Hub als private draft met 3 seed-projecten en de plantest-upload, 1 Linear-comment op HAN-132 plus 1 nieuw Linear-issue voor deze stap, en commit plus draft PR in `jowikroon/smart-content-orchestra`. Niet inbegrepen: de routine-prompt wijzigen (aparte JA na dry-run), schrijven in wiki/ of HANSOS.md (Claude-lokaal of Hans).

## 10. Bronnen

- Brand Book: HansOS brand identity en design book, boekeditie 13 okt 2026.
- Vault (backup HEAD 13 okt 06:15): HANSOS.md, claude.md, START-HERE.md, index.md, Command-Board.md (12 okt), log.md (t/m 13 okt), COWORK_MASTER.md (S87, 9 okt), _LEES-DIT-NIET-CANONIEK.md, _meta/schema.md, _connector/README.md, fanout/endpoints.yml, mcp/registry.json, _skill/classifier/classify-rules.yml, _skill/SKILL.md, _cowork/ZELFAUDIT-VERBETERPLAN-2026-10-08.md, _dashboard/Schedules.md, wiki/topics: Obsidian-As-Reader, HANSOS-Registry, Hermes-Gate-Mandaat-Poort, Cowork-Automation-System, HansOS-Network-Devices-and-Memory; Second-Brain-Kaart.canvas; .obsidian/graph.json; Backup-Vault-to-GitHub.ps1; Koppel-Vault-aan-Pi5.ps1.
- Cowork routines (list_triggers 14 okt): Vault bridge drain + ingest, HVL Search Command verversen, Agent-reaper weekly, Prospect-radar, Bewijs & positionering.
- Linear: HAN-132, HAN-186, HAN-147, projecten P-HAN-1 t/m 9.
- Gemini (Drive): Zelfgehoste n8n Vault Integratie (10 okt), Kostenbesparing AI en Infrastructuur (10 okt), Prompt Optimalisatie Bestandsbeheer (9 okt), Samenvatting hansOS & AI Architectuur.pdf (9 okt), Dashboard Sync Prompt Optimization (22 sep), Personal Automation OS Stack Research (25 mei), Claude Code Multi-Device Architecture (25 aug), Personal AI Automation Stack (6 aug), Cowork Workspace Optimalisatie (12 mei), Shadow AI Werkplek (28 aug), Stresstest Hybride AI Setup (29 aug), Ontwikkeling Van JARVIS AI Systeem (5 aug, buiten scope), Export van Gemini 13 okt.
- ChatGPT (Drive): Samantha als veilige, persoonlijke en autonome AI.pdf (5 aug), CCP Channable eBay DE herstelplan (12 okt), voice card schrijfstijl (13 okt).
- Notion: workspace-inventaris 14 okt (get-self, tool-access, 11 searches, Projects/Tasks-schema's, Atvise-pagina, Memory).
- Web: Obsidian Help (graph, bases, canvas, cli), changelogs 0.12.13, 1.12, 1.14; Local REST API README; Notion API 2026-03-11 docs en MCP supported tools; n8n credential-overwrites docs; Drive API export formats; rclone drive docs; Karpathy llm-wiki gist (4 apr 2026).
