---
title: "Writers-register: wie schrijft waar in de vault"
type: meta
scope: [CCP, HVL, MPG]
status: active
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [writers, writers-register, schrijfregister]
tags: [governance, vault, automation]
sources: ["[[2026-10-14-ch00-baseline]]", "[[Cowork-Automation-System]]", "[[HANSOS-Registry]]"]
hansos.id: meta-2026-10-14-writers
record_kind: meta
contract_version: 0.2-draft
classification: internal
---

# Writers-register

Bestemming: `_meta/writers.md`. Regel: elke automatische schrijver heeft 1 namespace en staat hier vóór hij draait. Twee schrijvers op hetzelfde pad = fout (S66, `_meta/health-*`). Bij tegenspraak wint `C:\AI\claude_cowork\REGISTRY.md` ([[HANSOS-Registry]]).

| Schrijver | Runtime | Mag schrijven naar | Cadans | Status 14 okt |
|---|---|---|---|---|
| vault-probe-command-board | Cowork scheduled | `_meta/health-*.md`, `Command-Board.md`, `_dashboard/*.md`, `COWORK_MASTER.md` (append), `log.md` (append), `index.md` | ma/wo/vr 07:45 | actief (Se87 9 okt, late-run 12 okt) |
| Vault bridge drain + ingest | Cowork routine (meta_mcp) | `raw/`, `raw/_archive/`, `wiki/`, `index.md`, `log.md` (append), `_connector/bridge/inbox/*/_processed/` | dagelijks 22:48 | actief (13 okt OK) |
| HVL Search Command verversen | Cowork routine | `log.md` (append) | dagelijks 06:49 | actief; vault-mount ontbreekt (HAN-186) |
| Agent-reaper weekly | Cowork routine | `log.md` (append), `C:\AI\claude_cowork\REGISTRY.md` (wijzigingslog) | zo 08:55 | actief |
| Backup-Vault-to-GitHub.ps1 | Windows Taakplanner | leest vault, schrijft GitHub `hansos-vault-backup` | dagelijks | actief (13 okt 06:15) |
| Syncthing PC naar Pi | PC | Pi-mirror (receive-only), nooit terug | continu | actief [unverified sinds 23 aug] |
| Samantha (Pi) | Pi containers | `~/samantha/vault/` (mirror), `~/samantha/state/`; vault-schrijfrecht: geen | n.v.t. | Task-40 health-writer [unverified of nog actief]; bij conflict pauzeren |
| Claude-cloud (deze sessie) | claude.ai/code | Drive `AI-en-automatisering/_vault-inbox`, repo `smart-content-orchestra/docs/hansos`, Notion HansOS Hub (private draft), Linear | ad hoc | actief; schrijft nooit direct in de vault |
| Claude-code / Codex lokaal | PC | via `_connector/bridge/inbox/claude-code/` en outbox-push-specs | ad hoc | zie [[Cowork-GitHub-Push-Bridge]] |
| drive-intake (voorstel) | Vault bridge drain + ingest, stap 0 | `_connector/bridge/inbox/drive/`, `_connector/state/drive.json` | dagelijks | VOORSTEL, pas na JA + dry-run |
| notion-hub (voorstel) | Claude interactief, later n8n | alleen Notion (outbound); vault-write via bridge-drop `inbox/notion/` | einde sessie, vrijdag | VOORSTEL |

## Regels
1. `wiki/` wordt alleen geschreven door een Wiki Agent in Mode A (ingest) of Mode B (lint, na bevestiging). Nooit door Hans, Gemini, rclone, n8n, Notion of routine-stap 0.
2. `log.md` en `COWORK_MASTER.md`: append-only, elke schrijver eigen regel met tag (INGEST, HARVEST, PROBE, REAPER, BRIDGE-HARVEST, DRIVE-INTAKE, NOTION-SYNC).
3. Nieuwe schrijver: eerst regel hier, dan REGISTRY.md, dan pas de eerste run.
4. Drive-snapshot `1sy_` en stale kopie `1S9koE` zijn geen schrijvers en geen bronnen.
