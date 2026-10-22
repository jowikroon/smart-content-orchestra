---
title: "Notion HansOS Hub: schema (DDL-tekst) en sync-contract"
type: meta
scope: [CCP, HVL, MPG]
status: draft
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [notion-hub-schema, notion-ddl]
tags: [notion, hansos, projecten, bijlagen, schema]
sources: ["[[2026-10-14-secondbrain-next-step]]"]
hansos.id: meta-2026-10-14-notion-hub-ddl
record_kind: meta
skill_ids: []
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: "3f9bafab-a501-8154-b20d-ff43e742fc47"
---

# Notion HansOS Hub

Pagina: HansOS Hub (private draft, 14 okt 2026), later verplaatsen naar teamspace E-commerce (`fe6b5c9d-bc7a-4a98-aa14-02f52a1d02a4`). Rol: projectdossier naast Linear. Nooit wiki-tekst, nooit confidential.

## Database 1: Projecten
| Property | Type | Opties / regel |
|---|---|---|
| Naam | title | |
| Scope | select | CCP, HVL, MPG, HansOS |
| Fase | select | Brief, Retrieve, Build, Review, Release, Observe, Curate, Vault |
| Status | status | Todo (To-do), Bezig (In progress), Review, Klaar (Complete) |
| Eigenaar | people | |
| Start | date | |
| Deadline | date | |
| hansos_id | rich_text | `<prefix>-<yyyy-mm-dd>-<slug>` |
| vault_path | rich_text | pad in de vault, bijv. `wiki/topics/HansOS-Next-Step-2026-10.md` |
| drive_url | url | map of document |
| linear_url | url | HAN-issue of project |
| Classificatie | select | public, internal |
| Taken | relation (two-way) | naar Taken |
| Bijlagen | relation (two-way) | naar Bronnen & Bijlagen |
| Open taken | rollup | count van Taken waar Status != Klaar |

## Database 2: Taken
| Property | Type | Opties / regel |
|---|---|---|
| Taak | title | |
| Project | relation (two-way) | naar Projecten |
| Status | status | Todo, Bezig, Klaar |
| Due | date | |
| Eigenaar | people | |
| Tier | select | 1 deterministisch, 2 vendor, 3 Hans |
| hansos_id | rich_text | |
| linear_url | url | |

## Database 3: Bronnen & Bijlagen
| Property | Type | Opties / regel |
|---|---|---|
| Naam | title | `YYYY-MM-DD_scope_slug` |
| Bestand | files | upload binnen planlimiet; anders Drive-URL |
| source_url | url | |
| source_kind | select | article, pdf, chat, transcript, dataset, email, code, image |
| ai_generator | select | gemini, chatgpt, claude, notebooklm, human |
| hansos_id | rich_text | |
| vault_path | rich_text | `wiki/sources/...` zodra geïngest |
| in_vault | checkbox | true zodra de source-pagina bestaat |
| Classificatie | select | public, internal |
| last_synced | date | |
| Project | relation (two-way) | naar Projecten |

## Views
- Projecten: Board op Status; Table op Deadline; per Scope gefilterd.
- Taken: Table gegroepeerd op Project; Kalender op Due.
- Bronnen: Table op last_synced; Gallery met bestandspreview.

## Sync-contract (Tier 2, interactief)
1. Classifier-check vóór elke upload: alleen public of internal.
2. Einde sessie: 1 voortgangsregel per geraakt project (update_page).
3. Vrijdag: rijen zonder `in_vault` als .md naar `_connector/bridge/inbox/notion/`; binaire bijlagen via get_file_download_urls + download binnen 1 uur.
4. `last_synced` op elke geraakte rij. Rij >14 dagen zonder update = Observe-signaal.
5. Geen Notion-writes uit cron (OAuth faalt daar); pas na n8n-hardening en GO.
6. endpoints.yml krijgt `notion-hub` (tier 2, internal) zodra Claude-lokaal dat op opdracht toevoegt; fanout dry-run op 10 pagina's eerst.
