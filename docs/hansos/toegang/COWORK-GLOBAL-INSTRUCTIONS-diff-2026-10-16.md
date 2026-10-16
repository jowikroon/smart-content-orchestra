# Voorstel: aanvulling Cowork global instructions (2026-10-16)

Bestemming: `_cowork/COWORK-GLOBAL-INSTRUCTIONS.md`. Hans plakt dit handmatig in Settings. Werk ook de last-reviewed datum bovenaan bij naar 2026-10-16.

## Diff

```diff
 ═══════════════════════════════════════════
 0 · Session start
 ═══════════════════════════════════════════
 Lees in volgorde:
+0. C:\Users\Malle Flappie\Documents\SecondBrainVault\HANSOS-TOEGANG.md  (waar staat wat, schrijfpaden per systeem)
 1. C:\Users\Malle Flappie\Documents\SecondBrainVault\claude.md  (Wiki Agent: INGEST/LINT/QUERY/EXPLORE)
@@
 ═══════════════════════════════════════════
 3 · Antwoordformat
 ═══════════════════════════════════════════
@@
+Terugkoppelregel (altijd): elke sessie die iets maakt of wijzigt eindigt met blok
+"Waar staat het": per artefact pad of link, hoe te openen (Obsidian / Notion / Drive /
+GitHub / Linear), status (concept of live). Geen link = taak niet af.
@@
 ═══════════════════════════════════════════
 6 · Connectors
 ═══════════════════════════════════════════
+Web-AI (Claude web, Gemini, ChatGPT, NotebookLM) leest Drive "HansOS-wiki-lees" en schrijft
+naar Drive "AI-en-automatisering/_vault-inbox". De Drive-kopieen van de hele vault vervallen.
+Lokale agents schrijven naar _connector/bridge/inbox/<systeem>/ (antigravity, gemini, codex, cowork).
```
