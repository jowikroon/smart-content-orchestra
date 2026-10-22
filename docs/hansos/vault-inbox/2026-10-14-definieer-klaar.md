---
title: "Definieer klaar: HansOS next step oktober 2026"
type: meta
scope: [CCP, HVL, MPG]
status: draft
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [definieer-klaar, klaar-criteria-next-step]
tags: [hansos, brief, acceptatie, vault]
sources: ["[[2026-10-14-secondbrain-next-step]]", "[[2026-10-14-ch00-baseline]]"]
hansos.id: decision-2026-10-14-definieer-klaar
record_kind: decision
skill_ids: [hansos-vault:vault-ingest, hansos-vault:vault-lint, hansos-vault:vault-probe]
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

# Definieer klaar

Brand Book p. 5: bepaal eerst wat een bruikbaar resultaat is. Goedkeuring geldt voor de beoordeelde versie en scope. Release en een geverifieerd resultaat blijven afzonderlijke stappen.

## Input
- Brand Book 13 okt (loop, labelcontract v0.1, reviewprotocol).
- Backup-repo HEAD 13 okt 06:15 (CH-00 baseline: 345 wiki, 138 incompleet, 42 broken links, backlog 0).
- 14 research-docs uit Drive (Gemini, ChatGPT), 9 geselecteerd voor intake.
- Routine "Vault bridge drain + ingest" (dagelijks 22:48, vault gemount, Drive-connector).
- Besluit Hans 14 okt: Notion naast Linear.

## Context
Vault is de enige kennisbron. Obsidian leest. Linear is executie. Notion wordt projectdossier met bijlagen. Claude-cloud schrijft nooit direct in de vault; Claude-lokaal ingest, lint en probe; Hans beoordeelt elke exacte versie.

## Grenzen
- Geen schrijven in wiki/ buiten Mode A (ingest) en Mode B (lint na bevestiging).
- Geen nieuwe schrijver zonder regel in writers-register.
- Geen confidential buiten de vault; classifier autoritair.
- Geen routine-promptwijziging zonder dry-run en JA.
- Max 5 bronnen per ingest-sessie; backlog nooit boven nulmeting.
- Geen Supabase-RAG, geen Juggl, geen two-way Notion-sync, geen wikilink-conversie in wiki/.

## Output (einde dag 14)
1. 9 source-pagina's in `wiki/sources/` met v0.2-frontmatter.
2. `_meta/brein-over-tijd.base` rendert 3 views op `created`; Graph Animate-opname gedateerd in `_cowork/artefacts`.
3. Notion HansOS Hub in teamspace E-commerce: 3 databases, 3 projecten, >= 9 taken, 9 bronrijen met bestaand vault_path, 0 confidential.
4. log.md: 1 regel per stap in bestaand formaat; Command-Board toont 6 Observe-getallen t.o.v. 12 okt.

## Acceptatiechecks (alle 4 JA, anders terug naar Build)
| # | Check | Meetbaar | Wie |
|---|---|---|---|
| 1 | Bronnen in de vault | `grep -l 'hansos.id' wiki/sources | wc -l` >= 9 in de backup van die dag | Claude-lokaal meet, Hans ziet |
| 2 | Brein over tijd werkt | Bases toont 3 views, nieuwste bovenaan; Animate speelt 24 mei t/m vandaag | Hans op de PC |
| 3 | Hub met 3 projecten | 3 projectpagina's met status, linear_url en bijlagen; rijen linken naar bestaande wiki-paden | Hans in Notion |
| 4 | Spoor in log.md | elke stap 1 regel `- YYYY-MM-DD <TAG> ...`; 0 directe wiki-writes buiten Mode A/B | lint |

## Review (Hans, per onderdeel)
Klopt het? Werkt het? Voelt het juist? Uitkomst als `record_kind: review` met hansos.id, criteria, eigenaar, uitkomst en versie-hash. Afgewezen onderdeel gaat terug naar Build met restore point en nieuwe versie-hash.
