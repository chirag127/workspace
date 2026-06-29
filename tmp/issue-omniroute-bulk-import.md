## Problem

When an operator has ~100 models to wire up across a mix of built-in providers + custom OpenAI-compatible endpoints, the current dashboard flow is a manual grind: click-add-key per provider, click-add-model per model, toggle capability flags per row. For someone running OmniRoute as a personal aggregator on top of 16+ free tiers + custom endpoints, this scales badly.

Two patches help here, both shipped in the `tashfeenahmed/freellmapi` fork:

### 1. `POST /api/keys/bulk-import` — paste a `.env` block

Server upserts every recognised provider from a pasted `.env`. Two pasted shapes:

```env
# Built-in single-key form
GROQ_API_KEY=...
GEMINI_API_KEY=...
CLOUDFLARE_API_KEY=...
CLOUDFLARE_ACCOUNT_ID=...   # joined as account:key per existing convention

# Custom OpenAI-compatible triple
ROUTEWAY_API_KEY=...
ROUTEWAY_BASE_URL=https://routeway.example/v1
ROUTEWAY_CUSTOM_MODELS=model-1,model-2,model-3
```

Reference impl: [oriz-org/freellmapi@4166f04](https://github.com/oriz-org/freellmapi/commit/4166f04) + [c806589](https://github.com/oriz-org/freellmapi/commit/c806589).

### 2. `-TOOLS` / `-VISION` capability-suffix parser on model ids

Trailing suffix on the model id strips into the stored id + sets `supports_tools` / `supports_vision`:

```env
ROUTEWAY_CUSTOM_MODELS=gpt-4.1-TOOLS,claude-4-sonnet-TOOLS-VISION,gemini-3-flash-VISION
# →  three models stored with the right capability flags, no extra UI clicks
```

Trailing-only regex so it won't corrupt a future model whose name contains `TOOLS` or `VISION` mid-string. For embedding models, the same suffix routes them to `register-embedding` instead.

Reference impl: [oriz-org/freellmapi@c9821e7](https://github.com/oriz-org/freellmapi/commit/c9821e7) + [f254e1f](https://github.com/oriz-org/freellmapi/commit/f254e1f) + [6be74c7](https://github.com/oriz-org/freellmapi/commit/6be74c7).

## Current state in OmniRoute

`grep "bulk-import\|-TOOLS$\|-VISION$\|capability.*suffix" src/app/api/keys/` returns **zero hits**. OmniRoute has a custom-provider endpoint (`POST /api/keys/custom`) and a model-registration endpoint, but no bulk `.env` parser and no capability-suffix shape.

`src/app/api/keys/` mostly handles per-key CRUD + per-model PATCH; nothing parses a multi-provider env block.

## Why it pairs well with OmniRoute

OmniRoute already supports custom OpenAI-compatible endpoints (each with its own `base_url` + model list). The bulk-import + suffix parser is **pure addition** at the entry point — it composes existing `POST /api/keys/custom` and the model PATCH endpoints rather than introducing a new storage shape. Operators paste an env block, fork-local parser fans out the right combination of upstream calls, the existing endpoints do the heavy lifting unchanged.

The `-TOOLS` / `-VISION` parser is independently useful even without bulk-import — a single env-line addition (`MY_MODEL_ID-TOOLS-VISION`) is the smallest possible UX for marking a custom model as tool- + vision-capable.

## Reference

Filed as theme 3 of 4 in `tashfeenahmed/freellmapi` — see [freellmapi#382](https://github.com/tashfeenahmed/freellmapi/issues/382). Same shape, same commits as reference.

Happy to scope a PR to either piece (or both) once OmniRoute's preferred API surface is confirmed — the bulk-import endpoint shape (`POST /api/keys/bulk-import` body, response envelope) wants alignment with existing patterns before any code lands.
