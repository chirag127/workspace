# feat: tracking — 15 features inspired by freellmapi

Tracking issue. 15 narrow gaps where `tashfeenahmed/freellmapi` (MIT) has a shipped reference. Filed comparatively, not adversarially. Maintainers may split, close, or merge as desired.

## Routing / API correctness

- [ ] **Family-based embedding routing** — never fail over across embedding models; vector spaces are incompatible across model identities. Ref: [freellmapi#195](https://github.com/tashfeenahmed/freellmapi/pull/195). Related: closed #2297, #496, #1260.
- [ ] **`dimensions` param on `/v1/embeddings`** — OpenAI-standard MRL truncation. Ref: [freellmapi#393](https://github.com/tashfeenahmed/freellmapi/pull/393).
- [ ] **Sticky-session model affinity (30 min)** — pin a chat to one model for N minutes; reduces mid-conversation hallucination spikes. Keyed by `X-Session-Id` or first-message hash. Different from closed #3840 (sticky-batch). Ref: freellmapi README "Sticky sessions".
- [ ] **Context-handoff system message on combo failover** — inject one compact "picking up an existing task" system message when router switches model mid-conversation. Env-gated, in-memory, 3h TTL. Ref: [freellmapi#279](https://github.com/tashfeenahmed/freellmapi/pull/279). Closed #2652 may already cover — please confirm.
- [ ] **Honor upstream `Retry-After` on 429** — bench the offending key for exactly the header value, clamped to a sane max. Ref: [freellmapi#261](https://github.com/tashfeenahmed/freellmapi/pull/261). May close #3954.
- [ ] **Vision-only routing + `422 no_vision_model`** — when request has `image_url` content, restrict to vision-capable models; structured 422 when none enabled instead of silent drop. Ref: freellmapi README. Related: #4264, #4012, closed #1425.
- [ ] **NULL-limit hit-count rate-limit heuristic** — escalate cooldowns on providers with no published rate-limit using observed 429 frequency. Ref: [freellmapi#392](https://github.com/tashfeenahmed/freellmapi/pull/392).

## Observability

- [ ] **Uniform `X-Routed-Via` + `X-Fallback-Attempts` on every `/v1/*` response** — current `x-omniroute-model` is stream-only (#4074); make it contract-uniform. Ref: freellmapi README "Using the API".
- [ ] **Durable hourly + lifetime counters surviving raw-row prune** — analytics retention pattern. Ref: [freellmapi#410](https://github.com/tashfeenahmed/freellmapi/pull/410).

## API compatibility

- [ ] **Content-negotiated `GET /v1/models`** — return Anthropic shape when `anthropic-version` header present, OpenAI shape otherwise. Lets Claude Code + Anthropic SDKs discover models. Ref: [freellmapi#361](https://github.com/tashfeenahmed/freellmapi/pull/361). May address #4674.
- [ ] **Per-model `context_window` field on `/v1/models`** — OpenAI SDK wrappers use this to size truncation; without it they default to 4k/8k. Ref: [freellmapi#282](https://github.com/tashfeenahmed/freellmapi/pull/282), #309. Related: #4424, #5004.
- [ ] **Family-aware `/v1/models` unification** — collapse duplicate model IDs across providers into one entry + per-model detail endpoint listing all providers. Ref: [freellmapi#335](https://github.com/tashfeenahmed/freellmapi/pull/335), #341, #347. Related: closed #4424, #4517.

## Provider translations

- [ ] **`google_search` tool → Gemini `googleSearch` grounding** — translate OpenAI-shape tool into Gemini native grounding directive + citations back into tool-result content. Ref: [freellmapi#301](https://github.com/tashfeenahmed/freellmapi/pull/301).

## Routing extras

- [ ] **`fusion` virtual model** — fan-out N free models from distinct families + judge synthesis (OpenRouter-Fusion style, free pool). Tool-call support in fusion mode shipped freellmapi#400. Ref: [freellmapi#326](https://github.com/tashfeenahmed/freellmapi/pull/326), #329, #331, [#400](https://github.com/tashfeenahmed/freellmapi/pull/400). Closed #3912 may already cover — please confirm.

## Providers (bulk-add tracking)

OpenAI-compatible adapters merged in freellmapi but missing in OmniRoute. Each is a thin adapter with seeded model list + rate-limit profile.

- [ ] **OVH AI Endpoints** — anonymous 2 req/min/IP/model; Qwen3.5 397B, GPT-OSS, Llama 3.3. `https://oai.endpoints.kepler.ai.cloud.ovh.net/v1`. Ref: freellmapi README + commit `e403bc5`.
- [ ] **Z.ai (Singapore) native API** — `api.z.ai`, API-key auth. Distinct from #3873, #3905 (cookie-based GLM Coding / Z.AI web).
- [ ] **Reka** — Ref: [freellmapi#334](https://github.com/tashfeenahmed/freellmapi/pull/334).
- [ ] **Agnes AI** — Ref: [freellmapi#323](https://github.com/tashfeenahmed/freellmapi/pull/323).
- [ ] **Routeway / BazaarLink / AINative** — Ref: [freellmapi#385](https://github.com/tashfeenahmed/freellmapi/pull/385).
- [ ] **FreeTheAi** — 50 aliases including 1M-ctx Nemotron Ultra + TTS/STT/search. Ref: [freellmapi#384](https://github.com/tashfeenahmed/freellmapi/pull/384).
- [ ] **DGrid Free Models Router** — Ref: [freellmapi#383](https://github.com/tashfeenahmed/freellmapi/issues/383).
- [ ] **Alibaba DashScope (dynamic model sync)** — Ref: [freellmapi#376](https://github.com/tashfeenahmed/freellmapi/issues/376).
- [ ] **AI Horde** — community-hosted free pool. Ref: [freellmapi#405](https://github.com/tashfeenahmed/freellmapi/pull/405) / #345.
- [ ] **LLM7 as first-class free provider** — #3976 partially fixes `/models`; keyless free routes (GPT-OSS / Llama 3.1 / GLM) still not exposed per freellmapi docs.
- [ ] **Pollinations as first-class free chat** — current OmniRoute support appears image-leaning / partial (#3981); freellmapi exposes GPT-OSS 20B anonymously.

---

PRs will follow this week — happy to scope each one to a single item from this list. Ping me to split / close / reprioritize.
