# Tracking: features inspired by freellmapi (audited against `release/v3.8.40`)

This is a tracking issue. After a side-by-side audit of [`tashfeenahmed/freellmapi`](https://github.com/tashfeenahmed/freellmapi) (MIT) against the current `release/v3.8.40` codebase, the items below are organised into three groups: confirmed gaps that are PR-actionable, items already shipped (closed for the record), and items where I'm not sure whether the existing implementation covers the freellmapi pattern.

**Update 2026-06-29:** the original list was over-broad. Ten of the original fifteen items proved already shipped after running `grep` against `release/v3.8.40`; they are listed in the second section with file references so the audit is reproducible. Apologies for the noise — I should have grepped before filing.

A first PR for one of the confirmed gaps is open as [#5314](https://github.com/diegosouzapw/OmniRoute/pull/5314).

---

## 1. Confirmed gaps (PR-actionable)

### a. Per-model `context_length` on `/v1/models` non-combo entries

Combos already emit `context_length` in `src/app/api/v1/models/catalog.ts:738`. Per-platform entries (`<alias>/<model>` and `<provider>/<model>` rows at lines 830-859) do not. Downstream clients that follow the OpenRouter/OpenAI convention — for example `@ai-sdk/openai-compatible` and several Vercel AI SDK wrappers — read `entry.context_length` to size their own prompt truncation. When the field is absent they fall back to `context_length: 0` and over-truncate to 4k/8k. The same client class is referenced by an existing comment in `tests/unit/v1-models-by-id-4674.test.ts:47`.

Reference: [freellmapi#282](https://github.com/tashfeenahmed/freellmapi/pull/282). PR: [#5314](https://github.com/diegosouzapw/OmniRoute/pull/5314).

### b. `X-Fallback-Attempts` response header

`X-OmniRoute-Provider` and `X-OmniRoute-Model` already exist on every `/v1/*` response via `src/domain/omnirouteResponseMeta.ts`. Adding `X-Fallback-Attempts: N` would surface how many failovers a successful response cost — useful for client-side observability and quota-debugging dashboards. Small additive diff in the same helper.

Reference: freellmapi README section "Using the API".

### c. Content-negotiated `GET /v1/models`

Return the Anthropic shape `{data:[{id, type: "model", display_name, created_at}]}` when the request carries an `anthropic-version` header, and the existing OpenAI shape otherwise. This lets the official Anthropic SDKs and Claude Code discover models without provider-specific code.

Reference: [freellmapi#361](https://github.com/tashfeenahmed/freellmapi/pull/361). May address part of the #4674 regression class.

### d. Sticky-session model affinity

Pin a chat session to one model for a configurable window (default 30 minutes), keyed by `X-Session-Id` or a hash of the first user message. The goal is to reduce mid-conversation hallucination spikes when combo routing fails over to a different model partway through a thread.

This is distinct from the closed #3840 (which was sticky-batch — request-throughput-shaped, not chat-quality-shaped).

Reference: freellmapi README section "Sticky sessions".

### e. Z.ai (Singapore) native API as a standalone provider

`api.z.ai` is currently wired only as the GLM Coding cookie path and the Z.AI Anthropic-compatible bridge (`src/lib/providers/validation.ts:494`, `open-sse/config/glmProvider.ts:14`). The native API-key auth at `api.z.ai/api/paas/v4` is a separate surface with its own model list, independent of the GLM cookie route — it survives cookie expiry, which currently breaks the web-session paths.

---

## 2. Already shipped (closed for the record)

Each item below was in the original draft but proved already present after a `grep` against `release/v3.8.40`. Listing them with file references so the audit is reproducible.

- [x] **Family-based embedding routing** — `src/lib/embeddings/familyGuard.ts` plus dimension-conflict guard in `src/lib/embeddings/service.ts:53-86`.
- [x] **`dimensions` parameter on `/v1/embeddings`** — `src/lib/embeddings/service.ts:85` honours `body.dimensions`.
- [x] **Honor upstream `Retry-After` on 429** — parsed and applied across `open-sse/services/accountFallback.ts:958` (body), `:1334` (header), `open-sse/handlers/chatCore.ts:2290`, and `open-sse/executors/antigravity.ts:930`.
- [x] **`X-OmniRoute-Provider` / `X-OmniRoute-Model` headers on every `/v1/*` response** — `src/domain/omnirouteResponseMeta.ts`. (Originally I claimed these were stream-only; that was wrong.)
- [x] **`google_search` → Gemini native `googleSearch` grounding translation** — `open-sse/translator/helpers/geminiToolsSanitizer.ts:149-159`.
- [x] **`fusion` virtual model** — `open-sse/services/fusion.ts` (12.3 KB, 17th routing strategy).
- [x] **OVH AI Endpoints** — `open-sse/config/providers/registry/ovhcloud/index.ts`.
- [x] **Reka, Agnes AI, BazaarLink, AINative, FreeTheAI** — present across `src/shared/constants/providers/apikey/gateways.ts` and `open-sse/config/providers/registry/zenmux-free/index.ts`. (FreeTheAI is wired as the `fta` alias.)
- [x] **Alibaba DashScope** — `bailian-coding-plan` and `dashscope-intl.aliyuncs.com` integrations across `src/app/api/v1/`, plus `src/app/api/providers/[id]/models/route.ts:473`.
- [x] **LLM7 first-class provider entry** — `src/shared/constants/providers/apikey/gateways.ts:208`. (The keyless-route audit from freellmapi may still be useful; flagged below.)

---

## 3. Unknown — please confirm scope or close

These items I could not verify either way from `grep` alone. If they're already covered, happy to close them; if scope is partial, happy to scope a PR to the gap.

- [ ] **Vision-only routing with explicit `422 no_vision_model`** — the catalog tracks vision capability (`supportsVision` / `inputModalities`), but I couldn't find a router-level check that restricts model selection when the request body contains `image_url` content blocks. Reference: freellmapi README "Vision / image input".
- [ ] **Context-handoff system message on combo failover** — closed #2652 ("universal context handoff") may already cover this. Reference: [freellmapi#279](https://github.com/tashfeenahmed/freellmapi/pull/279) — env-gated, in-memory, 3-hour TTL.
- [ ] **NULL-limit hit-count rate-limit heuristic** — the existing circuit breaker handles per-provider failure thresholds. The freellmapi pattern adds a per-key hit-count heuristic for providers that don't advertise a rate limit. Reference: [freellmapi#392](https://github.com/tashfeenahmed/freellmapi/pull/392).
- [ ] **Durable hourly aggregates + lifetime counters surviving raw-row prune** — analytics retention shape. Reference: [freellmapi#410](https://github.com/tashfeenahmed/freellmapi/pull/410).
- [ ] **Keyless free routes for LLM7** — first-class provider exists; not sure whether the keyless GPT-OSS / Llama 3.1 / GLM routes documented in freellmapi are exposed.
- [ ] **AI Horde provider** — added in [freellmapi#405](https://github.com/tashfeenahmed/freellmapi/pull/405). Not found via `grep`, but may be present under a different alias.
- [ ] **Pollinations as first-class free chat** — current support appears image-leaning (#3981). freellmapi exposes GPT-OSS 20B anonymously on the chat side. Confirm coverage parity.

---

## Notes

- All freellmapi PRs linked above are MIT-licensed and small enough to be copyable references.
- Each item is independent. Happy to split any of the confirmed gaps into its own issue if that fits the maintainer's workflow better.
- The OmniRoute scope is already much larger than freellmapi (231 providers, 17 routing strategies, MCP/A2A, MITM, desktop). These are narrow gaps where freellmapi's implementation could serve as a reference, not adversarial parity claims.
