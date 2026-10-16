# HansOS next step: SecondBrainVault als brein over tijd

Werkmap van de Claude-cloud sessie van 2026-10-14 (branch `claude/loving-goodall-ze3mps`). Alles hier is een voorstel of een bridge-drop; niets is direct in de vault geschreven.

## Wat staat hier

| Pad | Wat | Bestemming |
|---|---|---|
| `2026-10-14-secondbrain-next-step.md` | Het volledige voorstel (plan, fasen, besluiten) | Lezen; ook als Notion-bijlage |
| `2026-10-14-header-gap-manifest.csv` | 138 wiki-bestanden met ontbrekende frontmatter-sleutels (gemeten op backup HEAD 13 okt) | Hans valideert; batch-write door Claude-lokaal na restore point |
| `2026-10-14-drive-dedupe-rename-manifest.csv` | Dedupe en hernoemvoorstel voor Drive-map AI-en-automatisering | Hans voert uit in Drive |
| `vault-inbox/` | Bridge-drops: bronnen, contracten, registers, .base-bestanden | Kopiëren naar `_connector/bridge/inbox/drive/` (bronnen) of `_connector/bridge/inbox/cowork/` (rest); de dagelijkse routine "Vault bridge drain + ingest" neemt ze mee |

## Zo landt het in de vault

1. Dezelfde bestanden staan in Google Drive: `AI-en-automatisering/_vault-inbox` (map-id `1J3qP69iLzCVc3bmK1FRU-pSNuYgjm4Ck`).
2. Tot de routine stap 0 (Drive-intake) heeft, kopieert Hans de map naar `C:\Users\Malle Flappie\Documents\SecondBrainVault\_connector\bridge\inbox\drive\`.
3. De routine draineert naar `raw/` en ingest naar `wiki/` volgens `claude.md` Mode A. Niets wordt rechtstreeks in `wiki/` gezet.
4. `.base`-bestanden en `_meta/*.md` horen niet in raw/: die kopieert Hans (of Claude-lokaal op opdracht) naar `_meta/`.

## Regels die hier gelden

- `log.md` en `COWORK_MASTER.md` zijn append-only; dit pakket bevat een voorgestelde log-regel, geen edit.
- Classifier (`_skill/classifier/classify-rules.yml`) is autoritair vóór elke externe push. Bronnen in `vault-inbox/` zijn `internal` tenzij anders gemarkeerd.
- Geen secrets. Zie `vault-inbox/2026-10-14-meta-denylist.md`.
