---
title: "HansOS Toegang: waar staat wat en hoe kom je erbij"
type: meta
scope: [CCP, HVL, MPG, HansOS]
status: active
created: 2026-10-16
last_reviewed: 2026-10-16
aliases: [HANSOS-TOEGANG, toegang, startpunt]
tags: [hansos, toegang, agents, obsidian, notion, drive]
sources: ["[[2026-10-14-secondbrain-next-step]]", "[[2026-10-14-meta-writers]]", "[[2026-10-14-meta-denylist]]"]
hansos.id: meta-2026-10-16-hansos-toegang
record_kind: meta
skill_ids: []
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
classification: internal
---

# HansOS Toegang

Eén startpunt voor Hans en voor elk AI-systeem, web en lokaal. Over toegang en schrijfpaden wint dit bestand bij tegenspraak met AGENTS.md, claude.md of GEMINI.md. Voor wiki-conventies blijft claude.md leidend.

## 1. Waar staat wat

| Wat | Waar | Zo open je het |
|---|---|---|
| Vault (enige waarheid) | `C:\Users\Malle Flappie\Documents\SecondBrainVault` op Gandalf | Verkenner |
| Obsidian | dezelfde map | Dubbelklik `Open-Vault-in-Obsidian.bat` in de vault-root. Eerste keer: Obsidian starten, "Open folder as vault", kies de vault-map. Geen Obsidian? Installeer via obsidian.md. |
| Brein over tijd | `_meta/brein-over-tijd.base` en Graph view | In Obsidian het bestand openen. Graph: Ctrl+G, tandwiel, Animate aan. |
| Review-achterstand | `_meta/review-achterstand.base` | In Obsidian openen |
| Notion HansOS Hub | https://app.notion.com/p/3f9bafaba5018154b20dff43e742fc47 | Notion, linkerbalk, Private, HansOS Hub |
| Wiki-leeskopie (voor web-AI) | Google Drive: `Mijn Drive/HansOS-wiki-lees` | Alleen wiki/, index.md, HANSOS.md, START-HERE.md en dit bestand. Zonder confidential en secrets. Dagelijks ververst. |
| Intake voor web-AI | Drive `AI-en-automatisering/_vault-inbox` | https://drive.google.com/drive/folders/1J3qP69iLzCVc3bmK1FRU-pSNuYgjm4Ck |
| Versie en backup | GitHub `jowikroon/hansos-vault-backup` (privé) | Alleen lezen, dagelijks bijgewerkt |
| Taken en issues | Linear HAN-194 | https://linear.app/hansvanleeuwen/issue/HAN-194 |
| Voorstel en bridge-drops | GitHub PR smart-content-orchestra #6 | https://github.com/jowikroon/smart-content-orchestra/pull/6 |

## 2. Per systeem: lezen, schrijven, startbestand

| Systeem | Leest | Schrijft nieuwe kennis naar | Startbestand |
|---|---|---|---|
| Claude Code en Cowork op Gandalf | vault (mount) | `_connector/bridge/inbox/cowork/`; `wiki/` alleen als Wiki Agent (claude.md Mode A en B) | claude.md, daarna START-HERE.md |
| Antigravity (PC) | vault als workspace | `_connector/bridge/inbox/antigravity/` | AGENTS.md |
| Gemini CLI (PC) | vault | `_connector/bridge/inbox/gemini/` | GEMINI.md |
| Codex (PC) | vault | `_connector/bridge/inbox/codex/` | AGENTS.md |
| Claude web, Claude app, Claude Code cloud | GitHub-backup, Notion, Drive-leeskopie | Drive `_vault-inbox` | Notion-pagina "HansOS Toegang" |
| Gemini web en app, NotebookLM | Drive `HansOS-wiki-lees` | Drive `_vault-inbox` | `HansOS-wiki-lees/HANSOS-TOEGANG.md` |
| ChatGPT | Drive `HansOS-wiki-lees`, Notion | Drive `_vault-inbox` | `HansOS-wiki-lees/HANSOS-TOEGANG.md` |
| Samantha en OpenClaw (Pi) | Syncthing-mirror, alleen lezen | niets in de vault | dit bestand in de mirror |
| n8n (VPS) | VPS2-mirror [unverified] | niets in `wiki/` | n.v.t. |

De routine "Vault bridge drain + ingest" (dagelijks 22:48) haalt elke map onder `_connector/bridge/inbox/` leeg naar raw/ en ingest naar wiki/.

**Vervallen route.** De Drive-kopieën `My Computer/SecondBrainVault` en `Flappie/Documents/SecondBrainVault` zijn geen bron meer. Ze bevatten secrets. Wie daar las, leest nu `HansOS-wiki-lees`.

## 3. Regels voor elk systeem

1. De vault op Gandalf is de waarheid. Elke andere plek is een kopie.
2. Schrijf niet direct in `wiki/`, tenzij je de Wiki Agent bent. Nieuwe kennis gaat naar een inbox.
3. Lees, kopieer of citeer nooit secrets. Laad everything.env alleen lokaal en alleen als de taak het vraagt.
4. `log.md` en `COWORK_MASTER.md` vul je alleen aan, nooit bewerken.
5. Confidential gaat nooit naar web-AI of een publiek endpoint. De classifier beslist.
6. Hans beoordeelt. Geen AI keurt iets goed namens Hans.

## 4. De ene prompt (werkt in elk systeem)

```
Lees HANSOS-TOEGANG: het bestand HANSOS-TOEGANG.md in de vault-root, of de Notion-pagina "HansOS Toegang", of Google Drive HansOS-wiki-lees/HANSOS-TOEGANG.md (de eerste die je kunt openen). Doe daarna de toegangscheck uit sectie 5 en antwoord alleen met de tabel.
```

## 5. Toegangscheck

Antwoord als tabel met 3 kolommen: check, OK of NEE, bewijs.

1. **Bron.** Welke plek kon je openen? Bewijs: het pad of de link.
2. **Lezen.** Noem de datum van de laatste regel in log.md. Zonder vaulttoegang: noem de titel van 1 bestand in `HansOS-wiki-lees`.
3. **Notion.** Noem de 3 databases in de HansOS Hub.
4. **Drive.** Hoeveel bestanden staan er in `_vault-inbox`?
5. **Schrijfpad.** In welke map zet jij nieuwe kennis? Het antwoord moet uit sectie 2 komen.
6. **Grenzen.** Noem 2 dingen die je nooit doet, uit sectie 3.

6 keer OK betekent dat het systeem klaar is. Geef bij elke NEE de letterlijke reden, zoals geen connector, geen bestandstoegang of map ontbreekt.

## 6. Terugkoppelregel

Elke sessie die iets maakt of wijzigt, eindigt met het blok **"Waar staat het"**. Daarin staan per artefact het pad of de link, hoe je het opent en de status (concept of live). Zonder link is een taak niet af.

## 7. Onderhoud

- Lokale check en reparatie: `Install-HansOS-Toegang.ps1` in de vault-root. Het script is opnieuw te draaien en alleen-lezen met `-AlleenTest`.
- Antigravity-hookfout (`googlecloudtools.datacloud_telemetry`): het script verplaatst die plugin naar `.gemini\plugins-uitgeschakeld`. Terugzetten kan door de map terug te verplaatsen.
- Secrets in de GitHub-backup: zie Linear HAN-132.
