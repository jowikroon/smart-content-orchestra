---
title: "Nate Herk stack vs HansOS (bron van het vault-idee)"
type: source
scope: [HVL, MPG, CCP]
status: active
created: 2026-10-16
last_reviewed: 2026-10-16
aliases: [Nate Herk, nateherk, Herk2, AIS-OS]
tags: [second-brain, obsidian, claude-code, karpathy, stack, research]
sources: []
source: cowork-bridge
source_kind: research
source_url: "https://www.youtube.com/watch?v=sboNwYmH3AY"
ai_generator: claude
ingested_from: _connector/bridge/inbox/drive/2026-10-16_ai_nate-herk-stack-vs-hansos.md
ingested_on: ""
hansos.id: src-2026-10-16-nate-herk-stack-vs-hansos
record_kind: source
skill_ids: []
case_ids: []
contract_version: 0.2-draft
classification: public
notion_id: ""
---

## Correctie op bestaande bron
- [[2026-05-24-karpathy-second-brain]] noemt als bron "video summary" met `channel: (source video)`. De video `sboNwYmH3AY` is **niet van Karpathy**: het is "Andrej Karpathy Just 10x'd Everyone's Claude Code" van **Nate Herk | AI Automation** (@nateherk), ca. 5 april 2026, 17:48 min (YouTube oEmbed, 2026-10-16).
- Karpathy leverde het patroon (X-post + gist over LLM Wiki). Nate Herk leverde de implementatie die deze vault 1-op-1 volgt: Obsidian installeren, vault, Claude Code in die map, init-prompt, Web Clipper naar `raw/`, ingest, lint.
- Ingest-actie: `source_url` blijft, voeg `channel: Nate Herk | AI Automation` toe, maak `wiki/people/Nate-Herk.md`, link vanuit [[Second-Brain-Architecture]] en [[Andrej-Karpathy]].

## Wie
Nate Herkelman, Chicago, ex-Goldman Sachs BI-analist. Oprichter AI Automation Society (Skool, 450K+ leden), Uppit AI (agency), eerder TrueHorizon AI (exit dec 2025). YouTube 1M+ subs. GitHub `nateherkai`.

## Zijn stack (stand mei-okt 2026)

| Laag | Wat hij gebruikt | Bron |
|---|---|---|
| Runtime (S-tier, dagelijks) | Claude Code in VS Code (statusline). Alles draait vanuit 1 repo: **Herk2** | tier-list X, video 12 features |
| Tweede runtime | Codex (A-tier), zelfde bestanden via `AGENTS.md`-kopie van `CLAUDE.md`. Claude Code sneller, Codex 2-5x minder output-tokens | X-artikel Claude Code vs Codex |
| Snelle vragen | Claude chat (A-tier) | tier-list |
| Spraak | **Glaido** (verving Wispr Flow) | tier-list |
| Beeld (B-tier) | Nano Banana 2, GPT Image 2 | tier-list |
| Experimenten (C-tier) | Gemini, Ollama, Manus | tier-list |
| Automatisering | n8n: was kern, nu secundair. "Stop learning n8n in 2026" | about-pagina, video |
| Connecties | ClickUp, Gmail, Slack, Google Workspace (CLI), **Fireflies** (meeting-agent "Fire"), QuickBooks, lokale files. Via MCP of direct API | X-post AI OS |
| Security | Aparte ClickUp-account voor de assistent met eigen API-key, niet zijn persoonlijke key | X-artikel "$3M/yr business" |
| Always-on | **Hermes Agent** op Hostinger VPS (KVM 2, Ubuntu 24.04, Docker 1-click). Geheugen: USER.md, MEMORY.md, SOUL.md, AGENTS.md + SQL-sessiearchief | Hermes-course mei 2026 |
| Scraping | Apify | about-pagina |
| Kosten | eigen `token-dashboard` (Claude Code JSONL naar lokale kostenanalyse) | GitHub |

### Second brain (video "Every Level of a Claude Second Brain Explained", 21 jun 2026)
1. **Niveau 1**: `CLAUDE.md` als router + `context/` (about-me, stack, decisions) + `projects/`.
2. **Niveau 2, wat hij zelf draait**: LLM-wiki per domein (YouTube-transcripts-wiki: 36 video's in 14 min naar 23 pagina's; meeting-wiki), Claude automemory (`memory.md`). **Obsidian opent hij zelden**: alleen viewer en graph.
3. Niveau 3 vector search (Pinecone, Supabase, Qdrant): demo, niet dagelijks.
4. Niveau 4 knowledge graph (LightRAG, GraphRAG) + `/grill-me`: geëxperimenteerd, niet dagelijks.
5. Niveau 5 GBrain (Garry Tan) met Hermes: test, draait niet.

Regels die hij hanteert: kies het laagste niveau dat de pijn oplost; alleen evergreen context in het brein; Slack en e-mail **niet ingesten**, maar als laatste fallback live doorzoeken (volgorde: files, wiki, transcripts, dan ClickUp/Slack/mail).

Extra uit de Karpathy-video: `hot.md` = cache van ca. 500 tekens met de meest recente context, gelezen bij sessiestart. Herk2 leest de "Herc Brain"-wiki via een pad in `CLAUDE.md` en dat scheelde tokens.

### AIS-OS (github.com/nateherkai/AIS-OS, MIT, 1,7K sterren)
Starter-kit van zijn eigen OS: `CLAUDE.md` + `AGENTS.md`, `connections.md` (register van wat het OS kan bereiken), `context/`, `decisions/log.md` (append-only), `brainstorms/`, `audits/`, `archives/` (verplaatsen, niet verwijderen). Skills: `/onboard`, `/grill-me`, `/audit` (5 retrieval-probes, gedateerd rapport, bevinding pas dicht met nieuw bewijs), `/link`, `/level-up`, **`/3d-brain`** (lokale 3D-globe over Markdown-mappen, zoeken, "Play demo" = groei-replay langs echte links, geen historische tijdlijn; Node 22, `node serve.mjs`, localhost). Kader: Four C's (Context, Connections, Capabilities, Cadence; cadence als laatste) en Three M's (Mindset, Method, Machine).

## Vergelijking met HansOS

| Onderdeel | Nate Herk | HansOS nu | Verschil |
|---|---|---|---|
| Kennisbron | Herk2-repo, wiki per domein | SecondBrainVault raw/ naar wiki/ | Gelijk patroon. Wij zijn strenger: classifier, labelcontract, append-only log |
| Obsidian | Viewer, zelden open | Viewer ([[Obsidian-As-Reader]]), nu ook in menu hansvanleeuwen.com | Gelijk |
| Runtimes | Claude Code + Codex (AGENTS.md) | Cowork, Claude Code, Codex, Gemini CLI, OpenClaw, Samantha | Wij hebben meer schrijvers: risico, zie writers-register |
| Always-on | Hermes op VPS | Hermes Agent op Pi 5 (`nousresearch/hermes-agent:v2026.6.5`), OpenClaw, n8n VPS1 | Wij lopen voor |
| Spraak | Glaido | Wispr Flow | Hij stapte over; wij niet getest |
| Meetings | Fireflies + meeting-wiki | Wispr Flow meetings (connector), geen meeting-wiki | Gat |
| Taken | ClickUp | Linear + Notion Hub + Monday | Wij hebben 3 sporen, hij 1 |
| Volatiele data | Niet ingesten, live fallback | gmail-labeled harvester schrijft naar raw/ | Afwijking, bewust houden of herzien |
| Sessiecache | `hot.md` (~500 tekens) | Geen (4 bestanden bij sessiestart) | Gat, goedkoop te dichten |
| Audit | `/audit` met 5 retrieval-probes | vault-lint + vault-probe | Probes ontbreken |
| Interview naar kennis | `/grill-me` naar brainstorms/ | Geen | Gat |
| Visualisatie | `/3d-brain` | Graph Animate + Bases-tijdlijn (plan) | Optie voor demo 2 van 3 |
| Vector/graph | Demo, niet dagelijks | Bewust niet (plan sectie 7) | Gelijk besluit |
| Kosten | token-dashboard | [[Token-Cost-Control]] | Gelijk |

## Voorstel (omkeerbaar, Tier 1 tenzij anders)
1. `hot.md` in vault-root: 500 tekens, door de 22:48-routine overschreven na de drain. Sessiestart leest het als eerste. Kleinste ingreep, grootste tokenwinst.
2. Retrieval-probes in vault-probe: 5 vaste vragen met verwacht antwoord + wikilink, score per run op het Command-Board.
3. `/grill-me`-variant als skill die naar `raw/` schrijft (record_kind `review` of `decision`), nooit direct naar wiki/.
4. `/3d-brain` uit AIS-OS lokaal testen op een **kopie** van wiki/ (MIT, localhost, geen upload). Kandidaat voor de Brand Book-demo. Zelfde kanttekening als Graph Animate: groei-replay, geen tijdlijn.
5. Meeting-wiki als apart domein uit Wispr Flow-meetings, pas na labelcontract v0.2.
6. Glaido naast Wispr Flow testen: Tier 3, Hans.
7. Niet overnemen: LightRAG, vector-DB, GBrain (hij draait ze zelf ook niet dagelijks).

## Bronnen
- YouTube oEmbed `sboNwYmH3AY` (2026-10-16): titel en kanaal.
- Transcript "Andrej Karpathy Just 10x'd Everyone's Claude Code": https://sozai.app/transcript/andrej-karpathy-10x-claude-code/
- Transcript "Every Level of a Claude Second Brain Explained": https://sozai.app/transcript/every-level-claude-second-brain-explained/ en https://openclawdatabase.com/news/videos/2026-06-21-claude-second-brain-levels/
- Transcript "I Tested Every Claude Code Feature, These 12 Are the Best": https://sozai.app/transcript/tested-claude-code-best-features/
- AIS-OS: https://github.com/nateherkai/AIS-OS ; profiel https://github.com/nateherkai
- About: https://www.nateherk.com/about
- Hermes-course: https://openclawdatabase.com/news/videos/2026-05-10-hermes-agent-zero-to-personal-ai-assistant/index.md
- AI OS-course (1 mei 2026): https://openclawdatabase.com/news/videos/2026-05-01-claude-code-ai-operating-system/
- AI OS samenvatting: https://thusie.com/nate-herk-ai-operating-system-claude-code-productivity.html
- Tier-list, AI OS-connecties, security: X-posts @nateherk (status 2052567911328301222, 2060373513014292919, 2094263221645377911, artikel 2050116705322512766), via zoekresultaten; X zelf gaf 402/403, dus [indicatief].
