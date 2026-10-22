# Eigen LLM-laag voor MPG en CCP — overdracht 8 oktober 2026

Vervolg op het Cowork-onderzoek "Eigen LLM-laag voor MPG en CCP" (scenario B:
OpenClaw-gateway op VPS2 als eerste laag, directe sleutels als reserve).
Deze map bevat de stand van zaken, de bewijzen, en de code die nog in de
`jowikroon/marketplacegrowth`-repo moet landen.

## Status roadmap

| Stap | Omschrijving | Status 8 okt 01:30 CEST | Bewijs |
|---|---|---|---|
| 1 | OAuth-profiel voor API-profiel in OpenClaw (`auth.order.openai`) | **gedaan** | `openclaw.json`: `auth.order.openai = [openai:hansvl3@gmail.com, openai:service-account]` (SSH-arm run 211226) |
| 2 | Agent `contentpiper` + HTTP-endpoint + `llm.ts` via gateway | **gedaan en geverifieerd** | agent bestaat (gpt-5.5, fallback `ollama/qwen3:4b-instruct-4k`, tools `deny *`, thinking off); `gateway.http.endpoints.chatCompletions.enabled = true`; `content-builder-generate` v34 draait met provider-keten `openclaw,anthropic,gemini,openai`; `llm-probe` vanuit Supabase: provider `openclaw`, 4,5 s, antwoord `OK` (2x, 01:30 CEST) |
| 3 | EU-laag kopen (Mistral prepaid 20 EUR, Cloudflare Workers AI) | **open, Hans, 15 min** | nog geen Mistral-/Workers AI-profiel in OpenClaw (`models.providers = anthropic, ollama, google`) |
| 4 | Bewaking: generatietest per 6 h, token-verloop melding, usage.cost | **half**: de probe-functie staat live, de n8n-koppeling nog niet | `llm-probe` edge function v1, zie hieronder |

## Wat vannacht is gebeurd (reconstructie uit n8n-executions en Supabase)

1. 00:43–00:49 CEST (SSH-arm `Hk5dzk10QyDlMTAN`, runs 211174–211184): OpenClaw-container
   opnieuw gestart na upgrade naar 2026.9.8; gateway weigerde te starten (exit 78, sqlite-migratie
   `audit-events-v2`), `openclaw doctor --fix` stopte op de Telegram-state-migratie en de
   codex-plugin (EACCES). Sqlite-backup gemaakt: `openclaw.sqlite.bak-20261008-0046`.
2. 00:50–01:17 CEST (SSH-arm `Z8ngQHvWbvofcZVI`, runs 211187–211222): per-agent sqlite-backups
   (`*.pre-startup-migration-*.bak`) teruggezet, gateway weer `ready` om 01:12 CEST met 10 plugins
   (browser, codex, device-pair, elevenlabs, google, memory-core, ollama, telegram, whatsapp,
   workboard). Agent `contentpiper` aangemaakt; testvraag gaf "A.B.S. Remschijf voorzijde
   geventileerd 280 mm" in 9 s (prompt 11.966 tokens, waarvan 6.656 gecachet).
   `/v1/chat/completions` via de Hostinger-wrapper op poort 3000 werkt alleen met een
   niet-JSON `Content-Type` (text/plain, octet-stream): `express.json()` in de wrapper slikt
   een JSON-body op voor de proxy.
3. 01:19 CEST: `content-builder-generate` v34 naar Supabase (`pesfakewujjwkyybwaom`) gedeployd
   met de nieuwe `_shared/llm.ts` (openclaw vooraan). **Die wijziging staat niet in de
   marketplacegrowth-repo**: HEAD `1cf3742` (#27, 23:56 CEST) heeft nog de keten
   anthropic,gemini,openai. Zie "Nog in de repo te landen".
4. 01:30 CEST (deze sessie): `llm-probe` v1 gedeployd en twee keer aangeroepen vanuit Supabase.
   Resultaat beide keren: `provider: openclaw`, `providers: [openclaw, anthropic, gemini, openai]`,
   `latency_ms` 4.511 en 4.836, `sample: OK`. Daarmee zijn `OPENCLAW_GATEWAY_URL` en
   `OPENCLAW_GATEWAY_TOKEN` aantoonbaar als secrets gezet en werkt het pad
   Supabase → Traefik → wrapper → gateway → contentpiper → GPT-5.5.

Niet gedaan: de volledige `content-builder-generate`-run op project `5a293b2d` (Michelle
kidnapper, bolcom NL). Dat project staat al op `review` met alle 12 velden gevuld (Gemini-run
van 23:50 CEST), dus een nieuwe run zou door de resume-logica nul LLM-calls doen; een run met een
leeg project vereist een gebruikers-JWT en is een productie-actie die deze sessie niet mocht
uitvoeren. De probe gebruikt exact dezelfde `llm.ts`-keten, dus het bewijs is gelijkwaardig.

## Nog in de repo te landen (marketplacegrowth)

Push naar `jowikroon/marketplacegrowth` was vanuit deze sessie niet toegestaan. De bestanden
staan copy-ready onder `docs/llm-layer/marketplacegrowth/`:

| Bestand | Wat |
|---|---|
| `supabase/functions/_shared/llm.ts` | identiek aan de gedeployde v34-keten, plus `callLlmDetailed()` (geeft provider + latency terug), een succes-logregel `LLM provider <naam> answered in <ms>ms`, en een foutmelding die de gateway-variabelen noemt. `callLlm()` blijft bestaan voor de bestaande callers. |
| `supabase/functions/llm-probe/index.ts` | nieuwe functie, staat al live als v1. |

Toepassen: kopieer beide paden naar de repo-root van marketplacegrowth, commit op een branch
("LLM client: OpenClaw gateway first, llm-probe health check"), PR na #27. Daarna
`content-builder-generate` opnieuw deployen vanuit de repo zodat de succes-logregel ook daar
verschijnt (gedrag verandert niet; v34 werkt al).

## Configuratie (geen waarden hier; sleutels staan in Supabase secrets en `_skill/adapters/.env`)

| Variabele | Waar | Betekenis |
|---|---|---|
| `OPENCLAW_GATEWAY_URL` | Supabase secrets | `https://openclaw-cvpd.srv1411336.hstgr.cloud` (Traefik → Hostinger-wrapper :3000 → gateway :18789) |
| `OPENCLAW_GATEWAY_TOKEN` | Supabase secrets | gateway-token (`gateway.auth.mode = token`); de wrapper zet hem door als Bearer |
| `OPENCLAW_MODEL` | optioneel | standaard `openclaw/contentpiper` |
| `OPENCLAW_TIMEOUT_MS` | optioneel | standaard 90000; een timeout telt als transient en valt door naar de directe sleutels |
| `LLM_PROVIDER_ORDER` | optioneel | standaard `openclaw,anthropic,gemini,openai` |

OpenClaw-agent `contentpiper` (uit `openclaw.json`, run 211226):
primair `openai/gpt-5.5` via het ChatGPT-OAuth-profiel, fallback `ollama/qwen3:4b-instruct-4k`,
`tools.deny: ["*"]`, `thinkingDefault: off`, `heartbeat.every: 0`, workspace
`/data/workspaces/contentpiper`. De agent-keten in OpenClaw heeft dus nog geen Gemini-laag;
Gemini zit nu alleen in de Supabase-reserve. Na stap 3 horen Mistral en Workers AI als
fallback 2 en 3 in deze agent, voor Ollama.

## Bewaking (stap 4, nog te koppelen)

`llm-probe` aanroepen (Bearer = anon key of service-role key, functie heeft `verify_jwt`):

```
POST https://pesfakewujjwkyybwaom.supabase.co/functions/v1/llm-probe
Authorization: Bearer <SUPABASE_ANON_KEY>
apikey: <SUPABASE_ANON_KEY>
```

Antwoord: `{ ok, provider, latency_ms, providers, skipped, sample, checked_at }`; bij uitval
van alle lagen HTTP 503 met `attempts` en `permanent`. Voor InfraWacht: elke 6 uur aanroepen,
melden als `ok=false`, als `provider != openclaw` (gateway uit, reserve actief), of als
`latency_ms > 20000`. Dit vervangt de huidige OpenClaw-check in InfraWacht die "down" meldt en
toch met "All systems nominal" afsluit (bevinding 1 uit het onderzoek).

## Bevindingen deze sessie

- `openclaw --version` in de container meldt `2026.7.1-2 (0790d9f)` terwijl het geïnstalleerde
  npm-pakket 2026.9.8 is en de gateway om 01:12 CEST met codex-plugin startte. Welke binary
  daadwerkelijk draait is [unverified]; controleren met `openclaw gateway status` voor de
  volgende update-poging. De `doctor --fix`-weigering (Telegram-state, codex EACCES) is niet
  opgelost, alleen omzeild met de teruggezette backups.
- De Traefik-route antwoordt zonder token met HTTP 200 (login-pagina van de wrapper) op elk pad,
  ook `POST /v1/chat/completions`. De API zelf is token-beschermd, maar de UI blijft publiek:
  bevinding 2 uit het onderzoek (IP-allowlist of Tailscale) staat nog open.
- `auth.profiles` in `openclaw.json` is leeg; de OAuth- en API-profielen leven in de
  agent-sqlite, niet in JSON. De `order` staat wel goed.
- De contentpiper-systemprompt is groot (11.966 prompt-tokens per call, 6.656 gecachet). Bij
  honderden listings per dag telt dat in het ChatGPT-weekvenster; overweeg de FIELD_PROMPTS
  in de Supabase-call te laten en de agent-prompt tot de stijlregels te beperken.
- Project `5a293b2d` draaide om 23:43–23:50 CEST nog volledig op de reserve (anthropic 400
  credit balance, gemini 429/503, openai 429 no credits) voordat de gateway-laag erin zat; dat
  is de laatste run met fouten in de logs.

## Volgende acties

1. Hans: stap 3 (Mistral-sleutel met budgetlimiet, Workers AI aanzetten) en beide als fallback
   in agent `contentpiper` zetten.
2. Cowork/Claude: bestanden uit `docs/llm-layer/marketplacegrowth/` in de marketplacegrowth-repo
   landen (PR na #27) en `content-builder-generate` vanuit de repo redeployen.
3. Cowork/Claude: InfraWacht laten pollen op `llm-probe` (6 h) en de OpenClaw-cron voor
   token-verloop (3 dagen vooraf, Telegram) aanzetten.
4. Daarna: OpenClaw-versie en `doctor --fix` netjes afronden, UI achter allowlist.

## Log-regel voor `log.md` (SecondBrainVault, append-only; vault niet bereikbaar vanuit deze sessie)

```
2026-10-08 · LLM-laag MPG/CCP, overdracht van Cowork · gereconstrueerd wat Cowork 00:43–01:19 deed (gateway-upgrade, contentpiper, llm.ts v34) · llm-probe edge function gedeployd (pesfakewujjwkyybwaom) en 2x geverifieerd: provider openclaw, 4,5 s · stap 1+2 van de roadmap afgevinkt, 3 (Hans) en 4 (n8n-koppeling) open · files: smart-content-orchestra/docs/llm-layer/*, Supabase llm-probe v1, n8n Z8ngQHvWbvofcZVI (node-command vervangen door read-only recon) · open: llm.ts + llm-probe in marketplacegrowth-repo committen (push vanuit sessie geweigerd), InfraWacht-koppeling, UI-exposure VPS2
```
