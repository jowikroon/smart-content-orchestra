---
title: "Besluitregels voor HANSOS.md: 1 zin per tool"
type: meta
scope: [CCP, HVL, MPG]
status: draft
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [besluitregels, hansos-tool-rollen]
tags: [hansos, governance, canoniek, tools]
sources: ["[[2026-10-14-secondbrain-next-step]]"]
hansos.id: decision-2026-10-14-hansos-besluitregels
record_kind: decision
skill_ids: []
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
notion_id: ""
---

# Besluitregels (voorstel voor HANSOS.md, sectie "Tools en rollen")

Toepassen door Hans of Claude-lokaal op expliciete opdracht, met restore point vooraf. Niet door deze sessie.

| Tool | Regel (1 zin) |
|---|---|
| SecondBrainVault (PC) | Enige canonieke kennisbron; raw/ immutable inbox, wiki/ gecureerd, log.md tijdas, git versie. |
| Backup-repo hansos-vault-backup | Dagelijkse versie en tijdas voor git; leest de vault, schrijft nooit terug. |
| Pi 5 en VPS2 | Mirrors zonder gezag; receive-only, nooit bron van waarheid. |
| Drive-snapshot `1sy_` en kopie `1S9koE` | Momentopnamen, geen bron en geen schrijver; snapshot zonder `_skill/` en `*.env`, kopie naar ARCHIEF. |
| Google Drive | Landingszone en bijlagenopslag per scope, naamcontract `YYYY-MM-DD_scope_slug`; intake alleen via `AI-en-automatisering/_vault-inbox`; nooit raw/ zelf. |
| Gemini en ChatGPT | Onderzoeksproducenten; output is indicatief tot Hans de source-pagina beoordeelt; altijd `ai_generator`, `source_url`, `drive_id`. |
| Obsidian | Leest en toont; Bases op `created` is het record, Graph Animate de demo; schrijft niet in wiki/. |
| Wiki Agent (Claude-lokaal, Cowork met mount) | Enige schrijver van wiki/ via Mode A (ingest) en Mode B (lint na bevestiging). |
| Claude-cloud | Schrijver van bridge-drops, Drive-manifesten en Notion; nooit direct in de vault. |
| Routine "Vault bridge drain + ingest" | Enige automatische intake-lus; stap 0 (Drive) alleen na dry-run en JA. |
| Notion HansOS Hub | Projectdossier: status, eigenaar, datums, taken, bijlagen en link naar de wiki via hansos_id; nooit wiki-tekst of confidential. |
| Linear (team HAN) | Issue- en executiespoor; elk Notion-project draagt een linear_url, geen migratie. |
| Monday | Strategische spiegel, ongewijzigd, geen koppeling in deze stap. |
| Supabase | Audit, logs en bestaande bucket-fanout; geen pgvector of RAG. |
| n8n | Pas na hardening en GO; nooit schrijver van wiki/. |
| Samantha (Pi) | Leest de mirror, schrijft alleen in eigen state; geen vault-schrijfrecht. |
| Wikilinks | Blijven in wiki/; conversie naar md-links alleen bij export. |
| Secrets | Alleen in everything.env; nooit in vault-notes, Notion-rijen, workflow-JSON of Drive-docs. |
| Classifier | Autoritair voor elke externe push, upload en sync; denylist op padsoorten gaat voor. |
| Hans | Beoordeelt elke exacte versie met Klopt het, Werkt het, Voelt het juist; een agent spreekt nooit goedkeuring uit. |
