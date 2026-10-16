<#
.SYNOPSIS
  HansOS Toegang: één script dat de toegang voor alle AI-systemen herstelt en controleert.

.DESCRIPTION
  Stappen (allemaal omkeerbaar, met .bak-kopie vóór elke wijziging):
   1. Antigravity: verplaatst de falende plugin googlecloudtools.datacloud_telemetry
      naar %USERPROFILE%\.gemini\plugins-uitgeschakeld (terug te zetten).
   2. Zet HANSOS-TOEGANG.md in de vault-root.
   3. Zet 1 verwijsregel bovenaan AGENTS.md en claude.md, en maakt GEMINI.md aan.
   4. Maakt inbox-mappen voor antigravity, gemini, codex en drive.
   5. Plaatst de Obsidian Bases in _meta\ als ze er nog niet staan.
   6. Optioneel: verwerkt een gedownloade _vault-inbox.zip uit Drive naar de juiste inbox.
   7. Optioneel: ververst de wiki-leeskopie in Google Drive voor web-AI.
   8. Draait de toegangscheck, zet het rapport op het bureaublad en op het klembord.
   9. Opent Obsidian en de Notion Hub.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1 -AlleenTest
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1 -Leeskopie -RegistreerTaak
#>
[CmdletBinding()]
param(
  [string]$Vault = (Join-Path $env:USERPROFILE 'Documents\SecondBrainVault'),
  [switch]$AlleenTest,
  [string]$InboxZip,
  [switch]$Leeskopie,
  [string]$LeeskopieDoel,
  [switch]$AlleenLeeskopie,
  [switch]$RegistreerTaak,
  [switch]$NietOpenen
)

$ErrorActionPreference = 'Stop'
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'
$today  = Get-Date -Format 'yyyy-MM-dd'
$utf8   = New-Object System.Text.UTF8Encoding($false)
$script:Wijzigingen = New-Object System.Collections.Generic.List[string]
$NotionHub = 'https://app.notion.com/p/3f9bafaba5018154b20dff43e742fc47'
$Pointer   = '> Toegang en schrijfpaden: lees eerst HANSOS-TOEGANG.md in deze map. Bij tegenspraak over toegang wint dat bestand.'
$SecretNamePattern    = '(\.env$|\.env\.(?!example)|_ed25519|\.pem$|\.key$|\.pfx$|\.rdp$|pass\.txt$|\.mcp\.json|everything\.env|CREDENTIAL|SECRETS)'
$SecretFilePattern    = '(\.env$|_ed25519$|\.pem$|\.key$|\.pfx$|\.rdp$|pass\.txt$|\.mcp\.json(\.bak[^/]*)?$|everything\.env$)'
$SecretContentPattern = '(?i)(api[_-]?key|secret[_-]?key|service[_-]?role|access[_-]?token|refresh[_-]?token|client[_-]?secret)\s*[:=]\s*\S{8,}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'

function Write-Utf8([string]$Path, [string]$Text) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}
function Read-Utf8([string]$Path) { [System.IO.File]::ReadAllText($Path, $utf8) }
function Backup-File([string]$Path) {
  if (Test-Path -LiteralPath $Path) { Copy-Item -LiteralPath $Path -Destination "$Path.bak-$stamp" -Force }
}
function Note([string]$t) { $script:Wijzigingen.Add($t); Write-Host "  + $t" -ForegroundColor Green }

$ToegangMd = @'
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
'@
$BaseBrein = @'
# Bestemming: _meta/brein-over-tijd.base  (Obsidian Bases, kern-plugin, 1.14+)
# Record van het brein over tijd: elke wiki-pagina op frontmatter `created`.
# Pagina's zonder `created` vallen onderaan en zijn zo zichtbaar als header-gap.
filters:
  and:
    - file.inFolder("wiki")
    - file.ext == "md"
formulas:
  leeftijd_dagen: 'if(note.created, (today() - date(note.created)).days, "")'
  week: 'if(note.created, date(note.created).format("YYYY-[W]WW"), "zonder created")'
properties:
  note.created:
    displayName: Aangemaakt
  note.last_reviewed:
    displayName: Laatst beoordeeld
  note.record_kind:
    displayName: Soort
  note.scope:
    displayName: Scope
  note.status:
    displayName: Status
  note.ai_generator:
    displayName: Generator
  formula.leeftijd_dagen:
    displayName: Dagen oud
  formula.week:
    displayName: Week
views:
  - type: table
    name: Tijdlijn
    order:
      - file.name
      - note.created
      - note.type
      - note.record_kind
      - note.scope
      - note.status
      - note.last_reviewed
      - formula.leeftijd_dagen
    sort:
      - property: note.created
        direction: DESC
  - type: cards
    name: Laatste 30 dagen
    filters:
      and:
        - 'date(note.created) >= today() - duration("30d")'
    order:
      - file.name
      - note.created
      - note.scope
      - note.ai_generator
    sort:
      - property: note.created
        direction: DESC
    cardSize: 220
  - type: table
    name: Per week
    groupBy:
      property: formula.week
      direction: DESC
    order:
      - file.name
      - note.created
      - note.record_kind
    sort:
      - property: note.created
        direction: DESC
  - type: kanban
    name: Status
    groupBy:
      property: note.status
    order:
      - file.name
      - note.created
      - note.scope
    sort:
      - property: note.created
        direction: DESC
'@
$BaseReview = @'
# Bestemming: _meta/review-achterstand.base  (Obsidian Bases, kern-plugin, 1.14+)
# Curate-lijst: wat wacht op Hans. Bronnen zonder review, pagina's >60 dagen niet beoordeeld, header-gaps.
filters:
  and:
    - file.inFolder("wiki")
    - file.ext == "md"
formulas:
  dagen_sinds_review: 'if(note.last_reviewed, (today() - date(note.last_reviewed)).days, "")'
  header_gap: 'if(!note.created || !note.status || !note.type, "ja", "")'
properties:
  note.created:
    displayName: Aangemaakt
  note.last_reviewed:
    displayName: Laatst beoordeeld
  formula.dagen_sinds_review:
    displayName: Dagen sinds review
  formula.header_gap:
    displayName: Header-gap
views:
  - type: table
    name: Bronnen zonder review
    filters:
      and:
        - note.type == "source"
        - 'note.status == "draft" || !note.last_reviewed'
    order:
      - file.name
      - note.created
      - note.ai_generator
      - note.source_kind
      - note.status
    sort:
      - property: note.created
        direction: ASC
  - type: table
    name: Ouder dan 60 dagen
    filters:
      and:
        - 'date(note.last_reviewed) < today() - duration("60d")'
    order:
      - file.name
      - note.last_reviewed
      - formula.dagen_sinds_review
      - note.type
    sort:
      - property: note.last_reviewed
        direction: ASC
  - type: table
    name: Header-gaps
    filters:
      and:
        - 'formula.header_gap == "ja"'
    order:
      - file.name
      - note.created
      - note.status
      - note.type
    sort:
      - property: file.name
        direction: ASC
  - type: table
    name: Reviews
    filters:
      and:
        - note.record_kind == "review"
    order:
      - file.name
      - note.created
      - note.case_ids
      - note.skill_ids
    sort:
      - property: note.created
        direction: DESC
'@

if (-not (Test-Path -LiteralPath $Vault)) { throw "Vault niet gevonden: $Vault. Geef het juiste pad mee met -Vault." }

function Find-DriveRoot {
  $cands = @()
  foreach ($d in (Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) {
    foreach ($n in @('Mijn Drive','My Drive')) {
      $p = Join-Path $d.Root $n
      if (Test-Path -LiteralPath $p) { $cands += $p }
    }
  }
  foreach ($n in @('Google Drive\Mijn Drive','Google Drive\My Drive','Mijn Drive','My Drive')) {
    $p = Join-Path $env:USERPROFILE $n
    if (Test-Path -LiteralPath $p) { $cands += $p }
  }
  if ($cands.Count -gt 0) { return $cands[0] } else { return $null }
}

function Sync-Leeskopie([string]$Doel) {
  if (-not $Doel) {
    $root = Find-DriveRoot
    if (-not $root) { Write-Warning 'Google Drive-map niet gevonden. Geef -LeeskopieDoel "G:\Mijn Drive\HansOS-wiki-lees" mee.'; return }
    $Doel = Join-Path $root 'HansOS-wiki-lees'
  }
  if (-not (Test-Path -LiteralPath $Doel)) { New-Item -ItemType Directory -Force -Path $Doel | Out-Null }
  $bronnen = @()
  $bronnen += Get-ChildItem -LiteralPath (Join-Path $Vault 'wiki') -Recurse -File -Filter *.md -ErrorAction SilentlyContinue
  foreach ($f in @('index.md','HANSOS.md','START-HERE.md','HANSOS-TOEGANG.md')) {
    $p = Join-Path $Vault $f; if (Test-Path -LiteralPath $p) { $bronnen += Get-Item -LiteralPath $p }
  }
  $toegestaan = @{}; $gekopieerd = 0; $overgeslagen = 0
  foreach ($b in $bronnen) {
    $rel = $b.FullName.Substring($Vault.Length).TrimStart('\','/')
    if ($rel -match $SecretNamePattern) { $overgeslagen++; continue }
    $txt = Read-Utf8 $b.FullName
    if ($txt -match '(?m)^classification:\s*confidential' -or $txt -match $SecretContentPattern) { $overgeslagen++; continue }
    $dst = Join-Path $Doel $rel
    $toegestaan[$dst.ToLowerInvariant()] = $true
    $nieuw = $true
    if (Test-Path -LiteralPath $dst) {
      $nieuw = (Get-FileHash -LiteralPath $dst).Hash -ne (Get-FileHash -LiteralPath $b.FullName).Hash
    }
    if ($nieuw) {
      $dd = Split-Path -Parent $dst
      if (-not (Test-Path -LiteralPath $dd)) { New-Item -ItemType Directory -Force -Path $dd | Out-Null }
      Copy-Item -LiteralPath $b.FullName -Destination $dst -Force; $gekopieerd++
    }
  }
  $verwijderd = 0
  foreach ($x in (Get-ChildItem -LiteralPath $Doel -Recurse -File -Filter *.md -ErrorAction SilentlyContinue)) {
    if (-not $toegestaan.ContainsKey($x.FullName.ToLowerInvariant())) { Remove-Item -LiteralPath $x.FullName -Force; $verwijderd++ }
  }
  Write-Utf8 (Join-Path $Doel 'LEESKOPIE-INFO.txt') ("HansOS wiki-leeskopie. Alleen lezen. Bron: $Vault`r`nBijgewerkt: $(Get-Date -Format s)`r`nBestanden: $($toegestaan.Count), overgeslagen (confidential of secret): $overgeslagen`r`nNieuwe kennis gaat naar Drive AI-en-automatisering/_vault-inbox, niet hierheen.`r`n")
  Note "Leeskopie $Doel bijgewerkt: $gekopieerd gekopieerd, $verwijderd verwijderd, $overgeslagen overgeslagen"
  if ($RegistreerTaak) {
    $self = $PSCommandPath
    $arg  = "-NoProfile -ExecutionPolicy Bypass -File `"$self`" -AlleenLeeskopie -NietOpenen -Vault `"$Vault`" -LeeskopieDoel `"$Doel`""
    $act  = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg
    $trg  = New-ScheduledTaskTrigger -Daily -At 07:10
    Register-ScheduledTask -TaskName 'HansOS wiki-leeskopie' -Action $act -Trigger $trg -Description 'Ververst Drive HansOS-wiki-lees uit de vault (zonder confidential en secrets).' -Force | Out-Null
    Note 'Taak "HansOS wiki-leeskopie" geregistreerd (dagelijks 07:10)'
  }
}

if ($AlleenLeeskopie) { Sync-Leeskopie $LeeskopieDoel; exit 0 }

if (-not $AlleenTest) {
  Write-Host "`n[1] Antigravity-plugin" -ForegroundColor Cyan
  $plugin = Join-Path $env:USERPROFILE '.gemini\config\plugins\googlecloudtools.datacloud_telemetry'
  if (Test-Path -LiteralPath $plugin) {
    $park = Join-Path $env:USERPROFILE '.gemini\plugins-uitgeschakeld'
    New-Item -ItemType Directory -Force -Path $park | Out-Null
    Move-Item -LiteralPath $plugin -Destination (Join-Path $park "googlecloudtools.datacloud_telemetry-$stamp")
    Note "Antigravity-plugin verplaatst naar $park (herstart Antigravity)"
  } else { Write-Host '  plugin staat niet (meer) in config\plugins' }

  Write-Host "`n[2] HANSOS-TOEGANG.md" -ForegroundColor Cyan
  $tPath = Join-Path $Vault 'HANSOS-TOEGANG.md'
  $tNew  = $ToegangMd.Trim() + "`n"
  if (-not (Test-Path -LiteralPath $tPath) -or (Read-Utf8 $tPath) -ne $tNew) { Backup-File $tPath; Write-Utf8 $tPath $tNew; Note 'HANSOS-TOEGANG.md geschreven' } else { Write-Host '  al actueel' }

  Write-Host "`n[3] Verwijsregels" -ForegroundColor Cyan
  foreach ($f in @('AGENTS.md','claude.md')) {
    $p = Join-Path $Vault $f
    if (Test-Path -LiteralPath $p) {
      $t = Read-Utf8 $p
      if ($t -notmatch 'HANSOS-TOEGANG\.md') { Backup-File $p; Write-Utf8 $p ($Pointer + "`n`n" + $t); Note "Verwijsregel bovenaan $f" } else { Write-Host "  $f heeft al een verwijsregel" }
    } else { Write-Warning "$f ontbreekt in de vault" }
  }
  $g = Join-Path $Vault 'GEMINI.md'
  if (-not (Test-Path -LiteralPath $g)) {
    Write-Utf8 $g ("# GEMINI.md`n`n$Pointer`n`nVolg daarna AGENTS.md voor werkregels en claude.md voor wiki-conventies. Nieuwe kennis gaat naar _connector/bridge/inbox/gemini/.`n")
    Note 'GEMINI.md aangemaakt'
  } elseif ((Read-Utf8 $g) -notmatch 'HANSOS-TOEGANG\.md') { Backup-File $g; Write-Utf8 $g ($Pointer + "`n`n" + (Read-Utf8 $g)); Note 'Verwijsregel bovenaan GEMINI.md' }

  Write-Host "`n[4] Inbox-mappen" -ForegroundColor Cyan
  foreach ($b in @('antigravity','gemini','codex','drive','cowork')) {
    $p = Join-Path $Vault "_connector\bridge\inbox\$b"
    if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null; Note "Inbox $b aangemaakt" }
  }

  Write-Host "`n[5] Obsidian Bases" -ForegroundColor Cyan
  foreach ($pair in @(@('brein-over-tijd.base',$BaseBrein), @('review-achterstand.base',$BaseReview))) {
    $p = Join-Path $Vault ("_meta\" + $pair[0])
    if (-not (Test-Path -LiteralPath $p)) { Write-Utf8 $p ($pair[1].Trim() + "`n"); Note "_meta\$($pair[0]) geplaatst" } else { Write-Host "  _meta\$($pair[0]) bestaat al" }
  }

  Write-Host "`n[6] Drive _vault-inbox zip" -ForegroundColor Cyan
  if (-not $InboxZip) {
    $dl = Join-Path $env:USERPROFILE 'Downloads'
    $z = Get-ChildItem -LiteralPath $dl -Filter '_vault-inbox*.zip' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($z) { $InboxZip = $z.FullName }
  }
  if ($InboxZip -and (Test-Path -LiteralPath $InboxZip)) {
    $tmp = Join-Path $env:TEMP "vault-inbox-$stamp"
    Expand-Archive -LiteralPath $InboxZip -DestinationPath $tmp -Force
    foreach ($f in (Get-ChildItem -LiteralPath $tmp -Recurse -File)) {
      $n = $f.Name; $dst = $null
      if ($n -match $SecretNamePattern) { continue }
      if ($n -match '^\d{4}-\d{2}-\d{2}_(ai|hvl|ccp|mpg)_.+\.md$' -and $n -notmatch 'labelcontract') { $dst = "_connector\bridge\inbox\drive\$n" }
      elseif ($n -match '\.md$' -and $n -notmatch 'log-regels-voorstel') { $dst = "_connector\bridge\inbox\cowork\$n" }
      elseif ($n -match '\.base$' -or $n -match 'header-gap-manifest\.csv$') { $dst = "_meta\$n" }
      if (-not $dst) { continue }
      $full = Join-Path $Vault $dst
      $rawDup = (Test-Path -LiteralPath (Join-Path $Vault "raw\$n")) -or (Test-Path -LiteralPath (Join-Path $Vault "raw\_archive\$n"))
      if ((Test-Path -LiteralPath $full) -or $rawDup) { Write-Host "  overgeslagen (bestaat al): $n"; continue }
      Copy-Item -LiteralPath $f.FullName -Destination $full
      Note "Inbox: $dst"
    }
    Remove-Item -LiteralPath $tmp -Recurse -Force
  } else { Write-Host '  geen _vault-inbox*.zip gevonden in Downloads (Drive: map _vault-inbox, rechtsklik, Downloaden)' }

  if ($Leeskopie -or $LeeskopieDoel) { Write-Host "`n[7] Wiki-leeskopie" -ForegroundColor Cyan; Sync-Leeskopie $LeeskopieDoel }
}

Write-Host "`n[8] Toegangscheck" -ForegroundColor Cyan
$res = New-Object System.Collections.Generic.List[object]
function Add-Check([string]$c, [bool]$ok, [string]$d) { $res.Add([pscustomobject]@{ Check = $c; Status = $(if ($ok) { 'OK' } else { 'NEE' }); Detail = $d }) }

Add-Check 'Vault aanwezig' $true $Vault
$missing = @('claude.md','index.md','HANSOS.md','START-HERE.md','AGENTS.md','HANSOS-TOEGANG.md','GEMINI.md') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Vault $_)) }
Add-Check 'Startbestanden' ($missing.Count -eq 0) $(if ($missing.Count) { 'ontbreekt: ' + ($missing -join ', ') } else { 'alle 7 aanwezig' })
$ptrMiss = @('AGENTS.md','claude.md','GEMINI.md') | Where-Object { $p = Join-Path $Vault $_; -not ((Test-Path -LiteralPath $p) -and ((Read-Utf8 $p) -match 'HANSOS-TOEGANG\.md')) }
Add-Check 'Verwijsregels' ($ptrMiss.Count -eq 0) $(if ($ptrMiss.Count) { 'mist in: ' + ($ptrMiss -join ', ') } else { 'AGENTS.md, claude.md, GEMINI.md' })
$obsExe = @((Join-Path $env:LOCALAPPDATA 'Programs\obsidian\Obsidian.exe'), (Join-Path $env:LOCALAPPDATA 'Obsidian\Obsidian.exe')) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
$obsUri = Test-Path -LiteralPath 'Registry::HKEY_CLASSES_ROOT\obsidian'
Add-Check 'Obsidian geinstalleerd' ([bool]$obsExe -or $obsUri) $(if ($obsExe) { $obsExe } elseif ($obsUri) { 'obsidian:// geregistreerd' } else { 'niet gevonden: installeer via https://obsidian.md' })
Add-Check 'Vault is Obsidian-vault' (Test-Path -LiteralPath (Join-Path $Vault '.obsidian')) '.obsidian-map'
$bases = @('brein-over-tijd.base','review-achterstand.base') | Where-Object { Test-Path -LiteralPath (Join-Path $Vault "_meta\$_") }
Add-Check 'Bases in _meta' ($bases.Count -eq 2) ("$($bases.Count) van 2")
$plg = Test-Path -LiteralPath (Join-Path $env:USERPROFILE '.gemini\config\plugins\googlecloudtools.datacloud_telemetry')
Add-Check 'Antigravity-hook' (-not $plg) $(if ($plg) { 'plugin staat nog in config\plugins' } else { 'falende plugin niet actief' })
$inboxRoot = Join-Path $Vault '_connector\bridge\inbox'
$pending = 0; if (Test-Path -LiteralPath $inboxRoot) { $pending = (Get-ChildItem -LiteralPath $inboxRoot -Directory | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -File -Filter *.md -ErrorAction SilentlyContinue } | Measure-Object).Count }
Add-Check 'Inbox wachtrij' $true "$pending bestanden wachten op de routine van 22:48"
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git -and (Test-Path -LiteralPath (Join-Path $Vault '.git'))) {
  $last = & git -C $Vault log -1 --format=%cI 2>$null
  $age = if ($last) { [math]::Round(((Get-Date) - [datetime]$last).TotalHours, 1) } else { 999 }
  Add-Check 'Backup naar GitHub' ($age -lt 36) "laatste commit $age uur geleden"
  $tracked = & git -C $Vault ls-files 2>$null | Where-Object { $_ -match $SecretFilePattern }
  Add-Check 'Geen secrets in backup' ($tracked.Count -eq 0) $(if ($tracked.Count) { "$($tracked.Count) secret-bestanden staan in git (zie HAN-132): " + (($tracked | Select-Object -First 6) -join ', ') } else { 'schoon' })
} else { Add-Check 'Backup naar GitHub' $false 'git of .git niet gevonden' }
$root = Find-DriveRoot
if ($root) {
  $info = Join-Path $root 'HansOS-wiki-lees\LEESKOPIE-INFO.txt'
  if (Test-Path -LiteralPath $info) { $h = [math]::Round(((Get-Date) - (Get-Item -LiteralPath $info).LastWriteTime).TotalHours, 1); Add-Check 'Wiki-leeskopie (web-AI)' ($h -lt 30) "$h uur oud" }
  else { Add-Check 'Wiki-leeskopie (web-AI)' $false 'nog niet aangemaakt: draai met -Leeskopie -RegistreerTaak' }
  $old = Join-Path $root 'SecondBrainVault'
  Add-Check 'Oude vault-kopie in Mijn Drive' (-not (Test-Path -LiteralPath $old)) $(if (Test-Path -LiteralPath $old) { "$old bestaat nog" } else { 'niet in Mijn Drive-root' })
} else { Add-Check 'Google Drive voor desktop' $false 'geen Mijn Drive-map gevonden' }

$res | Format-Table -AutoSize | Out-String -Width 220 | Write-Host
$ok = ($res | Where-Object { $_.Status -eq 'OK' }).Count
$rep = "# HansOS toegangscheck $today`n`nScore: $ok van $($res.Count) OK`n`n| Check | Status | Detail |`n|---|---|---|`n" + (($res | ForEach-Object { "| $($_.Check) | $($_.Status) | $($_.Detail) |" }) -join "`n") + "`n"
if ($script:Wijzigingen.Count) { $rep += "`n## Gewijzigd deze run`n" + (($script:Wijzigingen | ForEach-Object { "- $_" }) -join "`n") + "`n" }
$rep += "`n## Waar staat het`n- Vault: $Vault`n- Toegang: $Vault\HANSOS-TOEGANG.md`n- Obsidian: dubbelklik Open-Vault-in-Obsidian.bat in de vault-root`n- Notion Hub: $NotionHub`n- Drive intake: https://drive.google.com/drive/folders/1J3qP69iLzCVc3bmK1FRU-pSNuYgjm4Ck`n"
$desk = [Environment]::GetFolderPath('Desktop')
$repPath = Join-Path $desk "HansOS-toegangscheck-$today.md"
Write-Utf8 $repPath $rep
try { Set-Clipboard -Value $rep } catch { }
Write-Host "Rapport: $repPath (ook op het klembord). Score: $ok van $($res.Count)." -ForegroundColor Yellow

if (-not $AlleenTest -and $script:Wijzigingen.Count) {
  $logLine = "- $today TOEGANG Install-HansOS-Toegang.ps1: " + ($script:Wijzigingen -join '; ') + " (check $ok/$($res.Count))"
  [System.IO.File]::AppendAllText((Join-Path $Vault 'log.md'), "`n$logLine`n", $utf8)
}

if (-not $NietOpenen) {
  try { Start-Process ("obsidian://open?path=" + [uri]::EscapeDataString($Vault)) } catch { Write-Warning 'Obsidian kon niet geopend worden.' }
  try { Start-Process $NotionHub } catch { }
}
