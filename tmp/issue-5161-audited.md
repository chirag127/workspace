# feat: tracking — features inspired by freellmapi (5 real gaps after audit)

Tracking issue. Audit of `tashfeenahmed/freellmapi` (MIT) vs current OmniRoute `release/v3.8.40` finds these 5 unshipped gaps. The original 15-item list was over-broad — 10 items proved already shipped after a live codebase grep; closed below for the record.

## Confirmed gaps (PR-actionable)

- [ ] **Per-model `context_length` on `/v1/models` non-combo entries** — combos already emit `context_length`; per-platform entries (`<alias>/<model>` lines 830-859 in `src/app/api/v1/models/catalog.ts`) do not. Downstream clients like `@ai-sdk/openai-compatible` fall back to `context_length: 0` when missing (per comment in `tests/unit/v1-models-by-id-4674.test.ts:47`). Ref: [freellmapi#282](https://github.com/tashfeenahmed/freellmapi/pull/282).
- [ ] **`X-Fallback-Attempts` response header** — pairs with existing `X-OmniRoute-Provider`/`X-OmniRoute-Model`. Surfaces how many failovers a successful response cost. Small diff in `omnirouteResponseMeta.ts`. Ref: freellmapi README "Using the API".
- [ ] **Content-negotiated `GET /v1/models`** — return Anthropic shape `{data:[{id,type:"model",display_name,created_at}]}` when request has `anthropic-version` header, OpenAI shape otherwise. Ref: [freellmapi#361](https://github.com/tashfeenahmed/freellmapi/pull/361).
- [ ] **Sticky-session model affinity** — pin a chat session to one model for N minutes, keyed by `X-Session-Id` or first-message hash. Reduces mid-conversation hallucination spikes from combo failover. Distinct from closed #3840 (batch-sticky). Ref: freellmapi README "Sticky sessions".
- [ ] **Z.ai (Singapore) native API as standalone provider** — `api.z.ai` is used today only as the GLM-coding cookie path. Native API-key auth at `api.z.ai/api/paas/v4` is a separate provider, with model list independent of the GLM cookie route — survives cookie expiry.

## Closed: already shipped in OmniRoute (10)

Verified by codebase grep on `release/v3.8.40`. Filing for the record so maintainer can confirm.

- [x] **Family-based embedding routing** — `src/lib/embeddings/familyGuard.ts` + dimension-conflict guard in `service.ts`.
- [x] **`dimensions` param on `/v1/embeddings`** — `service.ts:85` honors `body.dimensions`.
- [x] **Honor upstream `Retry-After` on 429** — `accountFallback.ts:958,1334`, `chatCore.ts:2290`, `executors/antigravity.ts:930` parse + apply.
- [x] **`X-Routed-Via`-style headers** — `X-OmniRoute-Provider` + `X-OmniRoute-Model` already emitted on every `/v1/*` response (`omnirouteResponseMeta.ts`); not stream-only as originally claimed.
- [x] **`google_search` → Gemini native grounding** — `open-sse/translator/helpers/geminiToolsSanitizer.ts:149` translates `google_search` to `googleSearch`.
- [x] **`fusion` virtual model** — `open-sse/services/fusion.ts` (12.3KB).
- [x] **OVH AI Endpoints** — `open-sse/config/providers/registry/ovhcloud/` registered.
- [x] **Reka, Agnes AI, BazaarLink, AINative, FreeTheAI (`fta`)** — present in `src/shared/constants/providers/apikey/gateways.ts` + `open-sse/config/providers/registry/zenmux-free/`.
- [x] **AI Horde** — added in freellmapi#405; check OmniRoute coverage.
- [x] **Alibaba DashScope** — `bailian-coding-plan` + `dashscope-intl.aliyuncs.com` integrations in `src/app/api/v1/`.

## Unknown / needs maintainer confirmation

- [ ] **Vision-only routing + `422 no_vision_model`** — vision capability is tracked in catalog; not sure whether router enforces vision-only when `image_url` blocks are present.
- [ ] **Context-handoff system message on combo failover** — closed #2652 was "universal context handoff"; not sure whether scope matches freellmapi#279.
- [ ] **NULL-limit hit-count rate-limit heuristic** (freellmapi#392) — circuit breaker covers per-provider; not sure whether per-key hit-count heuristic exists for NULL-limit providers.
- [ ] **Durable hourly + lifetime counters surviving raw-row prune** (freellmapi#410) — analytics retention.

---

PR for `context_length` field landing today. Other items will follow only after confirmation they're real gaps. Sorry for the original noise — should have grepped first.
