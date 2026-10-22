export interface LlmMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

export interface LlmOptions {
  temperature?: number;
  maxTokens?: number;
}

/** Result of a successful call, with the provider that actually answered. */
export interface LlmResult {
  text: string;
  provider: string;
  latencyMs: number;
  /** Failure messages of the providers tried before the one that answered. */
  attempts: string[];
}

/**
 * Thrown when every configured provider failed. `permanent` is true when the
 * failures are account-level (no credits, invalid key, retired model), so the
 * caller should stop instead of retrying the same call for every product.
 */
export class LlmUnavailableError extends Error {
  permanent: boolean;
  attempts: string[];
  constructor(attempts: string[], permanent: boolean) {
    super(
      attempts.length
        ? `No LLM provider could answer. ${attempts.join(" | ")}`
        : "No LLM provider configured. Set OPENCLAW_GATEWAY_URL + OPENCLAW_GATEWAY_TOKEN, or ANTHROPIC_API_KEY, GEMINI_API_KEY or OPENAI_API_KEY in Supabase Edge Function secrets.",
    );
    this.name = "LlmUnavailableError";
    this.permanent = permanent;
    this.attempts = attempts;
  }
}

// Models are overridable per project without a redeploy.
const ANTHROPIC_MODEL = Deno.env.get("ANTHROPIC_MODEL") ?? "claude-haiku-4-5-20251001";
// gemini-2.0-flash is retired (404). 3.5-flash answers in ~1s; 3.8-flash was
// returning 503 "high demand" on most calls on 2026-10-07, so it is not the default.
const GEMINI_MODELS = (Deno.env.get("GEMINI_MODEL") ?? "gemini-3.5-flash,gemini-3.5-flash-lite")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);
const OPENAI_MODEL = Deno.env.get("OPENAI_MODEL") ?? "gpt-4o-mini";

// OpenClaw gateway on VPS2: OpenAI-compatible endpoint with its own failover chain
// (ChatGPT subscription -> Gemini -> local Ollama). Configured via OPENCLAW_GATEWAY_URL
// (e.g. https://openclaw-cvpd.srv1411336.hstgr.cloud) + OPENCLAW_GATEWAY_TOKEN; the agent
// target defaults to openclaw/contentpiper.
const OPENCLAW_URL = (Deno.env.get("OPENCLAW_GATEWAY_URL") ?? "").replace(/\/$/, "");
const OPENCLAW_MODEL = Deno.env.get("OPENCLAW_MODEL") ?? "openclaw/contentpiper";

// Provider order: OPENCLAW,ANTHROPIC,GEMINI,OPENAI by default; override with LLM_PROVIDER_ORDER.
// The gateway goes first; the direct keys stay configured as the reserve path for
// the case where the gateway itself is down.
const PROVIDER_ORDER = (Deno.env.get("LLM_PROVIDER_ORDER") ?? "openclaw,anthropic,gemini,openai")
  .split(",")
  .map((s) => s.trim().toLowerCase())
  .filter(Boolean);

type Provider = { name: string; key: string | undefined; call: (key: string, m: LlmMessage[], o?: LlmOptions) => Promise<string> };

const TRANSIENT_RETRIES = Number(Deno.env.get("LLM_TRANSIENT_RETRIES") ?? "1");
const TRANSIENT_BACKOFF_MS = Number(Deno.env.get("LLM_TRANSIENT_BACKOFF_MS") ?? "1500");

function isTransient(err: unknown): boolean {
  return err instanceof ProviderError && !err.permanent && [408, 429, 500, 502, 503, 504, 529].includes(err.status);
}

async function withTransientRetry(name: string, fn: () => Promise<string>): Promise<string> {
  let attempt = 0;
  for (;;) {
    try {
      return await fn();
    } catch (err) {
      if (attempt >= TRANSIENT_RETRIES || !isTransient(err)) throw err;
      attempt++;
      console.warn(`LLM provider ${name}: transient failure, retry ${attempt}/${TRANSIENT_RETRIES} in ${TRANSIENT_BACKOFF_MS * attempt}ms`);
      await new Promise((r) => setTimeout(r, TRANSIENT_BACKOFF_MS * attempt));
    }
  }
}

function providers(): Provider[] {
  const all: Record<string, Provider> = {
    openclaw: { name: "openclaw", key: OPENCLAW_URL ? Deno.env.get("OPENCLAW_GATEWAY_TOKEN") : undefined, call: callOpenClaw },
    anthropic: { name: "anthropic", key: Deno.env.get("ANTHROPIC_API_KEY"), call: callAnthropic },
    gemini: { name: "gemini", key: Deno.env.get("GEMINI_API_KEY"), call: callGemini },
    openai: { name: "openai", key: Deno.env.get("OPENAI_API_KEY"), call: callOpenAi },
  };
  return PROVIDER_ORDER.map((p) => all[p]).filter((p): p is Provider => !!p && !!p.key);
}

/** Account-level failures that will not resolve by retrying the same request. */
function isPermanentFailure(status: number, body: string): boolean {
  if (status === 401 || status === 403 || status === 404) return true;
  const b = body.toLowerCase();
  return (
    b.includes("credit balance") ||
    b.includes("insufficient_quota") ||
    b.includes("no credits") ||
    b.includes("exceeded your current quota") ||
    b.includes("no longer available") ||
    b.includes("invalid x-api-key") ||
    b.includes("api key not valid")
  );
}

export class ProviderError extends Error {
  status: number;
  permanent: boolean;
  constructor(provider: string, status: number, body: string) {
    super(`${provider} ${status}: ${body.slice(0, 200)}`);
    this.name = "ProviderError";
    this.status = status;
    this.permanent = isPermanentFailure(status, body);
  }
}

/**
 * Calls the first provider that answers and reports which one it was. Falls
 * through to the next configured provider on any error, so an empty Anthropic
 * balance no longer takes the whole Content Builder down when the gateway or a
 * Gemini/OpenAI key is configured.
 */
export async function callLlmDetailed(messages: LlmMessage[], options?: LlmOptions): Promise<LlmResult> {
  const chain = providers();
  const attempts: string[] = [];
  let allPermanent = chain.length > 0;

  for (const p of chain) {
    const started = Date.now();
    try {
      const text = await withTransientRetry(p.name, () => p.call(p.key as string, messages, options));
      const latencyMs = Date.now() - started;
      if (text.trim()) {
        console.log(`LLM provider ${p.name} answered in ${latencyMs}ms`);
        return { text, provider: p.name, latencyMs, attempts };
      }
      attempts.push(`${p.name}: empty response`);
      allPermanent = false;
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      attempts.push(msg);
      if (!(err instanceof ProviderError && err.permanent)) allPermanent = false;
      console.warn(`LLM provider ${p.name} failed, trying next:`, msg);
    }
  }

  throw new LlmUnavailableError(attempts, allPermanent);
}

/** Text-only variant of callLlmDetailed, kept for existing callers. */
export async function callLlm(messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  return (await callLlmDetailed(messages, options)).text;
}

/** Names of the providers that have a key configured, in call order, for diagnostics. */
export function configuredProviders(): string[] {
  return providers().map((p) => p.name);
}

async function callOpenClaw(token: string, messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), Number(Deno.env.get("OPENCLAW_TIMEOUT_MS") ?? "90000"));
  try {
    // Content-Type is deliberately text/plain: the Hostinger wrapper in front of the
    // gateway runs express.json() before its proxy, which swallows an application/json
    // body and leaves the gateway waiting. A non-JSON type passes the body through intact
    // and the gateway parses it anyway (verified 2026-10-08, 3-4 s per call).
    const response = await fetch(`${OPENCLAW_URL}/v1/chat/completions`, {
      method: "POST",
      headers: { "Content-Type": "text/plain", Authorization: `Bearer ${token}` },
      body: JSON.stringify({
        model: OPENCLAW_MODEL,
        temperature: options?.temperature ?? 0.7,
        max_tokens: options?.maxTokens ?? 2048,
        messages: messages.map((m) => ({ role: m.role, content: m.content })),
      }),
      signal: controller.signal,
    });
    if (!response.ok) throw new ProviderError("openclaw", response.status, await response.text());
    const data = await response.json();
    return data.choices?.[0]?.message?.content ?? "";
  } catch (err) {
    // A gateway timeout is transient for us: the chain simply moves on to the direct keys.
    if (err instanceof Error && err.name === "AbortError") throw new ProviderError("openclaw", 504, "gateway timeout");
    throw err;
  } finally {
    clearTimeout(timer);
  }
}

async function callAnthropic(apiKey: string, messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  const system = messages.filter((m) => m.role === "system").map((m) => m.content).join("\n\n");
  const conversation = messages.filter((m) => m.role !== "system").map((m) => ({ role: m.role, content: m.content }));

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "x-api-key": apiKey,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: ANTHROPIC_MODEL,
      max_tokens: options?.maxTokens ?? 2048,
      temperature: options?.temperature ?? 0.7,
      system: system || undefined,
      messages: conversation,
    }),
  });

  if (!response.ok) throw new ProviderError("anthropic", response.status, await response.text());
  const data = await response.json();
  return data.content?.[0]?.text ?? "";
}

async function callGemini(apiKey: string, messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  let lastErr: unknown;
  for (const model of GEMINI_MODELS) {
    try {
      return await callGeminiModel(model, apiKey, messages, options);
    } catch (err) {
      lastErr = err;
      // A retired, overloaded or quota-exhausted model (free-tier quotas are
      // per model): try the next configured Gemini model.
      if (err instanceof ProviderError && (err.status === 404 || err.status === 429 || isTransient(err))) {
        console.warn(`gemini model ${model} failed (${err.status}), trying next model`);
        continue;
      }
      throw err;
    }
  }
  throw lastErr;
}

async function callGeminiModel(model: string, apiKey: string, messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  const systemInstruction = messages.filter((m) => m.role === "system").map((m) => m.content).join("\n");
  const contents = messages
    .filter((m) => m.role !== "system")
    .map((m) => ({ role: m.role === "assistant" ? "model" : "user", parts: [{ text: m.content }] }));

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`,
    {
      method: "POST",
      // Key in a header, not in the URL, so it never lands in access logs.
      headers: { "Content-Type": "application/json", "x-goog-api-key": apiKey },
      body: JSON.stringify({
        systemInstruction: systemInstruction ? { parts: [{ text: systemInstruction }] } : undefined,
        contents,
        generationConfig: {
          temperature: options?.temperature ?? 0.7,
          maxOutputTokens: options?.maxTokens ?? 2048,
        },
      }),
    },
  );

  if (!response.ok) throw new ProviderError(`gemini/${model}`, response.status, await response.text());
  const data = await response.json();
  return data.candidates?.[0]?.content?.parts?.map((p: { text?: string }) => p.text ?? "").join("") ?? "";
}

async function callOpenAi(apiKey: string, messages: LlmMessage[], options?: LlmOptions): Promise<string> {
  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${apiKey}` },
    body: JSON.stringify({
      model: OPENAI_MODEL,
      temperature: options?.temperature ?? 0.7,
      max_tokens: options?.maxTokens ?? 2048,
      messages: messages.map((m) => ({ role: m.role, content: m.content })),
    }),
  });

  if (!response.ok) throw new ProviderError("openai", response.status, await response.text());
  const data = await response.json();
  return data.choices?.[0]?.message?.content ?? "";
}
