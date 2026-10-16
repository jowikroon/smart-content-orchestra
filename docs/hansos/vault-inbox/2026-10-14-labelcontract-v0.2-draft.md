---
title: "Labelcontract v0.2-draft: frontmatter-sleutels voor de SecondBrainVault"
type: meta
scope: [CCP, HVL, MPG]
status: draft
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [labelcontract, labelcontract-v0.2, frontmatter-contract]
tags: [hansos, vault, labels, schema, frontmatter]
sources: ["[[2026-10-13_hvl_vault-labelcontract-v0.1-uit-brand-book]]", "[[2026-10-14-ch00-baseline]]"]
hansos.id: meta-2026-10-14-labelcontract-v0-2
record_kind: meta
skill_ids: [hansos-vault:vault-ingest, hansos-vault:vault-lint]
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

# Labelcontract v0.2-draft

Bestemming: `_meta/labelcontract-v0.2.md` plus 1 mapping-tabel in `_meta/schema.md`. Status: draft tot Hans JA zegt (Klopt het? Werkt het? Voelt het juist?). Geldt daarna direct voor elke nieuwe pagina. De 138 bestaande incomplete bestanden volgen via `2026-10-14-header-gap-manifest.csv`, dat Hans eerst valideert; batch-write door Claude-lokaal na een restore point.

Uitgangspunt uit het Brand Book (p. 8): v0.1-draft voegt `hansos.id`, `record_kind`, `skill_ids`, `case_ids` en `contract_version` toe aan de 9 bestaande sleutels. Keten: Skill > Case > Beslissing > Versie + review > Uitkomst > Les. Regel: bewijs is niet hetzelfde als skillniveau, en skillniveau is niet hetzelfde als publicatieakkoord. v0.2 neemt dit over en voegt alleen de sleutels toe die de Drive-intake en de Notion-hub nodig hebben.

## A. Verplicht voor elke pagina (bestaand, `_meta/schema.md`)
| Sleutel | Type | Formaat | Bron van de waarde |
|---|---|---|---|
| title | string | vrije titel | pagina |
| type | enum | topic, source, person, domain, meta | map in wiki/ |
| scope | list | CCP, HVL, MPG, HansOS | inhoud |
| status | enum | active, draft, archived, stale | curatie |
| created | date | YYYY-MM-DD | datum van de bron of eerste log.md-vermelding; nooit ctime na kopie |
| last_reviewed | date | YYYY-MM-DD | laatste menselijke of lint-review |
| aliases | list | alternatieve namen | pagina |
| tags | list | kebab-case | pagina |
| sources | list | wikilinks naar source-pagina's | ingest |

## B. Verplicht voor `type: source` (bestaand, Mode A)
| Sleutel | Type | Formaat |
|---|---|---|
| ingested_from | path | `_connector/bridge/inbox/<bron>/<bestand>` of `raw/<bestand>` |
| ingested_on | date | YYYY-MM-DD, gezet door de Wiki Agent |
| source_kind | enum | article, pdf, chat, transcript, dataset, email, code, image |
| source_url | url | canonieke vindplaats (Drive, web, mail-id) |

## C. Nieuw in v0.2
| Sleutel | Type | Formaat | Verplicht voor | Wie vult |
|---|---|---|---|---|
| hansos.id | string | `<prefix>-<yyyy-mm-dd>-<slug>`; prefix uit D; uniek in de vault; nooit hergebruikt | alle | Wiki Agent bij ingest, Hans bij review |
| record_kind | enum | source, topic, person, domain, case, skill, review, decision, lesson, meta | alle | Wiki Agent |
| skill_ids | list | `<skillpack>:<skill>`, bijv. `hansos-vault:vault-ingest` | case, review, lesson | Hans of agent op opdracht |
| case_ids | list | `case-<yyyy-mm>-<slug>` | source, review, lesson, decision | agent |
| contract_version | string | `0.2-draft` tot JA, dan `0.2` | alle | agent |
| drive_id | string | Google Drive file-id | source uit Drive | drive-intake |
| notion_id | string | Notion page-id (32 hex) of leeg | pagina's met Hub-rij | notion-hub |
| ai_generator | enum | gemini, chatgpt, claude, notebooklm, human | source | drive-intake |
| classification | enum | public, internal, confidential | optioneel; override op classify-rules.yml | classifier of Hans |

## D. ID-grammatica
Prefixen: `src` (source), `topic`, `person`, `domain`, `case`, `skill`, `review`, `decision`, `les` (lesson), `meta`, `plan`. Slug: ascii, kebab-case, max 60 tekens, afgeleid van de titel. Voorbeeld: `src-2026-10-10-zelfgehoste-n8n-vault-integratie`. De voorbeeld-IDs uit het Brand Book zijn niet importeerklaar (p. 8); deze grammatica vervangt ze.

## E. Regels
1. Een agent vult nooit een review-uitkomst, goedkeuring, skillniveau of publicatieakkoord in. Alleen Hans maakt `record_kind: review` (via bridge-drop `inbox/cowork/`), met criteria, eigenaar, uitkomst en versie-hash.
2. `record_kind: review` is een eigen node, zodat oordelen zichtbaar worden in graph en Bases.
3. `created` komt uit de bron (documentdatum) of de eerste log.md-vermelding. Nooit uit de bestandstijd na kopie of sync.
4. Een source-pagina blijft `status: draft` en krijgt het label indicatief tot Hans de pagina heeft beoordeeld.
5. Gemini- en ChatGPT-output krijgt altijd `ai_generator`, `source_url` en `drive_id`. Zonder deze 3 geen ingest.
6. Geen Dublin Core of derde vocabulaire in de frontmatter. Alleen onderstaande mapping-tabel in `_meta/schema.md`, voor export.
7. Lint controleert A en B hard (fout), C zacht (waarschuwing) tot JA; daarna hard voor nieuwe pagina's.

## F. Mapping voor export (alleen tabel, geen extra sleutels)
| v0.2 | Dublin Core | Notion Hub | Drive |
|---|---|---|---|
| title | dc:title | Naam | name |
| created | dc:date | Aangemaakt | createdTime |
| source_url | dc:source | source_url | webViewLink |
| ai_generator | dc:creator | ai_generator | n.v.t. |
| hansos.id | dc:identifier | hansos_id | appProperties.hansos_id |
| scope | dc:subject | Scope | map |
| classification | dc:rights | Classificatie | n.v.t. |

## G. Acceptatie
- Klopt het: elke sleutel heeft type, formaat en vuller; geen overlap met bestaande sleutels.
- Werkt het: de 9 bronnen in `_vault-inbox` dragen alle sleutels uit A, B en C; lint geeft 0 fouten op A en B.
- Voelt het juist: Hans herkent de keten Skill > Case > Beslissing > Versie + review > Uitkomst > Les in de sleutels, zonder dat een agent oordelen invult.
