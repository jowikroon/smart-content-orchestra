// llm-probe: one real generation through the shared LLM chain, reporting which
// provider answered. This is the gate for the "always-available LLM layer":
// provider must be "openclaw" when the VPS2 gateway is healthy, and one of the
// direct keys when it is not. Cheap by design (maxTokens 8). Wire it into
// InfraWacht (every 6 h) and alert when `provider` changes or `ok` is false.
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { handleCors, jsonResponse } from "../_shared/cors.ts";
import { callLlmDetailed, configuredProviders, LlmUnavailableError } from "../_shared/llm.ts";

serve(async (req) => {
  const cors = handleCors(req);
  if (cors) return cors;

  const providers = configuredProviders();
  const started = Date.now();
  try {
    const result = await callLlmDetailed(
      [
        { role: "system", content: "You are a health probe. Reply with exactly: OK" },
        { role: "user", content: "ping" },
      ],
      { temperature: 0, maxTokens: 8 },
    );
    return jsonResponse({
      ok: true,
      provider: result.provider,
      latency_ms: result.latencyMs,
      total_ms: Date.now() - started,
      providers,
      skipped: result.attempts,
      sample: result.text.trim().slice(0, 80),
      checked_at: new Date().toISOString(),
    });
  } catch (err) {
    if (err instanceof LlmUnavailableError) {
      return jsonResponse({
        ok: false,
        permanent: err.permanent,
        providers,
        attempts: err.attempts,
        total_ms: Date.now() - started,
        checked_at: new Date().toISOString(),
      }, 503);
    }
    return jsonResponse({ ok: false, providers, error: err instanceof Error ? err.message : String(err) }, 500);
  }
});
