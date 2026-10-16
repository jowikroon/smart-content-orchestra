---
title: "Vault-labelcontract v0.1-draft, zoals vastgelegd in het HansOS Brand Design Book (13 okt 2026)"
type: source
scope: [HVL, HansOS]
status: active
created: 2026-10-13
last_reviewed: 2026-10-14
aliases: [labelcontract-v0.1, vault-labelsysteem-voorstel]
tags: [hansos, vault, labels, brand-book, pilotcases]
sources: []
source: cowork-bridge
source_kind: pdf
source_url: "upload HansOS-Brand-Design-Book-2026-10-13.pdf (32 p.), p. 7, 8, 20, 27"
ingested_from: _connector/bridge/inbox/cowork/2026-10-13_hvl_vault-labelcontract-v0.1-uit-brand-book.md
ingested_on: ""
hansos.id: src-2026-10-13-vault-labelcontract-v0-1-brand-book
record_kind: source
skill_ids: []
case_ids: [case-2026-10-hansos-next-step]
contract_version: 0.2-draft
ai_generator: human
classification: internal
notion_id: ""
---

## Herkomst
De bestanden `vault-labelcontract-v0.1.md`, `pilotcases-v0.1` en `vault-labelsysteem-voorstel.md` die het Brand Book als bron noemt, staan niet in de backup-repo (HEAD 13 okt 06:15) en niet in Drive. Locatie [unverified]. Deze pagina legt vast wat het Brand Book zelf over v0.1 zegt, zodat v0.2 een traceerbare voorganger heeft. Tekst via pdftotext, 14 okt 2026; layout versimpeld, inhoud niet gewijzigd.

## Inhoud (Brand Book p. 8, "Kennisarchitectuur / huidige stand en voorstel")
Labels zijn nog geen leersysteem. Er is een basisschema. Een volledig gekoppeld systeem voor ervaringen, stem, skills en portfolio is nog niet aangetoond.

Headerinventaris 10 oktober 2026 / 339 markdown-bestanden: 202 met negen sleutels, 137 incompleet. Aanwezigheid van keys, geen inhoudelijke kwaliteits- of YAML-validatie. Geen actuele vault-healthscore.

| Bestaande basis | Voorstel v0.1-draft | Menselijk te beoordelen |
|---|---|---|
| Document ordenen. Type, scope, status, data, aliases, tags en bronverwijzingen. Vrije tags vormen nog geen uniforme skill-taxonomie. | Relaties toevoegen. Vier offline cases koppelen claims en kandidaat-skills aan bron, beslissing en versie. Nog niet in de vault ingevoerd. | Betekenis vastleggen. Welke les herken ik? Welke keuze was van mij? Welke stemregel past professioneel? Goedkeuring is geen label dat AI zelf mag invullen. |
| title / type / scope / status / created / last_reviewed / aliases / tags / sources | hansos.id / record_kind / skill_ids / case_ids / contract_version | bewijs != skillniveau != publicatieakkoord |

Keten: Skill > Case > Beslissing > Versie + review > Uitkomst > Les.

Bronnen (volgens het boek): vault-labelcontract-v0.1.md en pilotcases-v0.1. Voorbeeld-IDs zijn niet importeerklaar. Geen nieuwe categorieen of wijzigingen aan websitefilters. Publicatiecontrole blijft apart; de eerder gesignaleerde classifier/publisher-afwijking is in deze editie niet opnieuw geaudit of gerepareerd.

## Inhoud (p. 7, "SecondBrainVault")
Een les heeft context: raw (bron + herkomst) > beoordelen (selectie + context) > wiki (curated kennis). Vragen per les: Bron (waar komt de informatie vandaan?), Beslissing (wat veranderde?), Verificatie, Hergebruik, Versie. Twee Pi-roots bevatten elk 172 markdown-bestanden, de derde 4; niet bij elkaar optellen als unieke kennis. Synchronisatie, actieve ingest en dekking buiten deze roots: onbekend. Bron: vault-labelsysteem-voorstel.md, audit 10 oktober 2026. Drie rollen zijn een functioneel model.

## Inhoud (p. 20, "voorgesteld reviewprotocol")
Klopt het? (feitelijk: bron, artikelscope, juiste claim, bedoelde eindtoestand; wie kan dit inhoudelijk goedkeuren?) Werkt het? (gedrag en UX: wat moet iemand begrijpen of doen; vindbaar, begrijpelijk, bruikbaar?) Voelt het juist? (visueel en merk: hierarchie, ritme, consistentie, merkgevoel). Hans beoordeelt de exacte versie. Leg het eigen oordeel vast naast inhoudelijke checks. Een agent mag geen eureka-moment of menselijke goedkeuring verzinnen. Bewaar per ronde kritiek, wijziging en resterende twijfel. Drie agents en vijf rondes zijn een werkvorm, geen bewijs dat het ontwerp werkt.

## Inhoud (p. 27, "Het portfolio verdiepen")
Vault en labels: audit 10 oktober + voorstel. Gedocumenteerde start 24 mei 2026, structuur, Pi-scope en headerinventaris. Geen live healthclaim of geactiveerd labelcontract. Wat nog nodig is voor publicatie: de interactieve versie bevat drie workflowdemonstraties en downloadbare bronbestanden.

## Connections
- Related: [[2026-10-14-labelcontract-v0.2-draft]], [[Second-Brain-Architecture]], [[Obsidian-As-Reader]]
- Domains: [[HVL]]

## Open Questions
- Waar staan de 3 originele labelbestanden? Zodra gevonden: als raw-bron ingesten en deze pagina als afgeleide markeren.
