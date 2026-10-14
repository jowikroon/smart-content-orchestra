---
title: "Secrets-denylist (padsoorten) voor sync, fanout en Notion-upload"
type: meta
scope: [CCP, HVL, MPG]
status: active
created: 2026-10-14
last_reviewed: 2026-10-14
aliases: [denylist, secrets-denylist]
tags: [security, classifier, fanout, notion]
sources: ["[[2026-10-14-ch00-baseline]]"]
hansos.id: meta-2026-10-14-denylist
record_kind: meta
contract_version: 0.2-draft
classification: internal
---

# Secrets-denylist

Bestemming: `_meta/denylist.md`. Wordt gelezen door de classifier (`_skill/classifier/classify.ps1`) vóór elke harvest, fanout, Drive-sync en Notion-upload. Een treffer = het bestand gaat nergens heen en krijgt `classification: confidential`. Alleen padsoorten en patronen; nooit waarden.

## Padsoorten (altijd confidential, nooit naar buiten)
| Patroon | Soort | Waarom |
|---|---|---|
| `_skill/adapters/.env*`, `_skill/adapters/*.secret` | adapter-secrets (PAT, service-role, OAuth refresh) | kopie van everything.env |
| `**/everything.env`, `**/ENV-INVULLEN-*.env`, `**/*.env`, `**/*.env.local` | env-bestanden | bevatten of verwachten sleutels |
| `.mcp.json`, `**/claude_desktop_config.json`, `**/.claude.json` | MCP-config met tokens | server-URL's en tokens |
| `_connector/bridge/outbox/**` | push-specs | branches en tokens vóór merge |
| `_prive/**`, `PRIVE/**`, `**/credentials-NAZIEN/**` | privé en wachtende credentials | buiten scope, nooit syncen |
| `raw/**` (behalve `raw/_archive/` na ingest-classificatie) | onbeoordeeld bronmateriaal | classifier-regel bestaat al |
| `_meta/lint-*.md` | lint-rapporten | kunnen confidential gaten noemen |
| `**/*.rdp`, `**/*.pem`, `**/*.key`, `**/id_ed25519*`, `**/*.pfx` | verbindings- en sleutelbestanden | login raspberry pi OS RDP.rdp staat in de vault-root |
| `**/vault_gateway.py`, `**/deploy-vault.py` | scripts met ingebedde secrets [unverified] | drive-sweep 14 okt; eerst controleren, dan opschonen |
| `_cowork/artefacts/backup-n8n-*/**`, `**/n8n-workflows*.json` | n8n-exports | 40+ nodes met plaintext tokens (audit 25 jul) |
| `_cowork/samantha-pi/tests/**` | red-team-materiaal | threat-model en prompts |

## Inhoudspatronen (aanvulling op classify-rules.yml)
- `(?i)(api[_-]?key|secret[_-]?key|service[_-]?role|access[_-]?token|refresh[_-]?token|client[_-]?secret)\s*[:=]\s*\S{8,}`
- `sk-[A-Za-z0-9]{20,}`, `ghp_[A-Za-z0-9]{30,}`, `xox[baprs]-[A-Za-z0-9-]{10,}`, `AIza[0-9A-Za-z_-]{30,}`, `eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+`
- `Bearer\s+[A-Za-z0-9._-]{20,}`
- `(?i)\b(password|passwd|wachtwoord|pwd)\s*[:=]\s*\S+`
- IBAN/BIC, USt-IdNr, DE + 9 cijfers (bestaande regels)

## Wat er nu al fout staat (Hans-actie, Fase 0)
1. Drive-snapshot `1sy_...` (My Computer, 16 aug) bevat `_skill/` en `ENV-INVULLEN-2026-07-11.env`: uit desktop-sync halen of `_skill/` en `*.env` uitsluiten.
2. `PRIVE/credentials-NAZIEN` staat in Drive: verplaatsen naar een wachtwoordmanager, map daarna leeg laten of verwijderen.
3. Vault-root: `login raspberry pi OS RDP.rdp` en `ENV-INVULLEN-2026-07-11.env` horen niet in een gesyncte vault; verplaatsen naar `C:\Users\Malle Flappie\Documents\Hans\env\`.
4. `.mcp.json` in de vault-root: controleren op tokens; zo ja, verplaatsen en in de vault alleen een verwijzing laten.

## Proefrun (Claude-cloud, 14 okt)
9 intakekandidaten in `_vault-inbox` gecontroleerd op de inhoudspatronen: 0 treffers. Zie per bestand `classification` in de frontmatter.
