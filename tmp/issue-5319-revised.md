## ⚠️ Issue revised 2026-06-29

**Original framing was wrong.** I claimed OmniRoute has no `bulk-import` endpoint. That was incorrect — OmniRoute has multiple bulk endpoints already:

- `POST /api/providers/bulk` — bulk-add keys to one provider (`{provider, entries: [{name, apiKey}]}` per `bulkCreateProviderSchema` in `src/shared/validation/schemas/provider.ts:379`)
- `POST /api/providers/bulk-web-session` — bulk web sessions
- `POST /api/providers/agy-auth/import-bulk`, `claude-auth/import-bulk`, `codex-auth/import-bulk`, `glm-auth/import-bulk` — per-auth-flavor bulk imports

Apologies for the noise. Below is the narrowed-scope ask, after reading the existing surfaces.

---

## Narrowed gap: `.env`-block-paste parser + capability suffix

The existing bulk endpoints are all **single-provider** shape — operator picks one provider, posts an array of keys. They don't handle:

1. A **multi-provider `.env` paste** in one go (`GROQ_API_KEY=... \n GEMINI_API_KEY=... \n CLOUDFLARE_*=... \n MY_CUSTOM_PREFIX_API_KEY=... \n MY_CUSTOM_PREFIX_BASE_URL=... \n MY_CUSTOM_PREFIX_CUSTOM_MODELS=...`).
2. **Capability-suffix parsing on model ids** (`-TOOLS` / `-VISION` / `-TOOLS-VISION` trailing strip → set flags).

### Why these are separate from the existing bulk endpoints

`bulkCreateProviderSchema` requires an explicit `provider: string` field. A `.env` paste has 5+ providers in it; the operator wants ALL of them upserted in one action. Today they'd have to call the bulk endpoint once per provider, after manually grouping their env vars by provider.

The capability suffix is orthogonal — it's about how the model id is registered, not which endpoint registers it. Useful for any custom model registration, not just bulk.

### Proposed shapes

#### 1. `POST /api/keys/bulk-import` — paste a `.env` block (orchestrator)

Server parses the paste, fans out the right combination of existing endpoints. Two pasted forms detected:

```env
# Built-in single-key form → fans out to /api/providers/bulk per provider
GROQ_API_KEY=...
GEMINI_API_KEY=...
CLOUDFLARE_API_KEY=...
CLOUDFLARE_ACCOUNT_ID=...   # joined as account:key per existing convention

# Custom OpenAI-compatible triple form → calls existing custom-provider register
ROUTEWAY_API_KEY=...
ROUTEWAY_BASE_URL=https://routeway.example/v1
ROUTEWAY_CUSTOM_MODELS=model-1,model-2,model-3
```

Pure-orchestrator shape: parses pasted block, dispatches to existing endpoints. No new storage shape — composes with what already exists.

Reference impl: [oriz-org/freellmapi@4166f04](https://github.com/oriz-org/freellmapi/commit/4166f04) + [c806589](https://github.com/oriz-org/freellmapi/commit/c806589). freellmapi's shape is the same orchestrator pattern over upstream's existing `POST /custom` endpoint.

#### 2. `-TOOLS` / `-VISION` suffix parser on custom model ids

Trailing suffix on the model id strips into the stored id + sets capability flags on the existing `mergeModelCompatOverride()` surface (which already accepts capability patches at `src/lib/db/models.ts:181`):

```env
ROUTEWAY_CUSTOM_MODELS=gpt-4.1-TOOLS,claude-4-sonnet-TOOLS-VISION,gemini-3-flash-VISION
# →  three models stored with the right capability flags set via existing
#    mergeModelCompatOverride() instead of three extra UI clicks
```

Trailing-only regex so it won't corrupt a future model whose name contains `TOOLS` or `VISION` mid-string.

Reference impl: [oriz-org/freellmapi@c9821e7](https://github.com/oriz-org/freellmapi/commit/c9821e7) + [f254e1f](https://github.com/oriz-org/freellmapi/commit/f254e1f) + [6be74c7](https://github.com/oriz-org/freellmapi/commit/6be74c7).

### Why it pairs well with existing OmniRoute surfaces

The suffix parser composes with `mergeModelCompatOverride()` — capability flag merging is already in place. The bulk-orchestrator composes with `POST /api/providers/bulk` + the custom-provider register endpoint. Both pieces are **pure addition** at the entry-point layer; no schema migration, no new storage surface.

### Reference

Filed as theme 3 of 4 in `tashfeenahmed/freellmapi` — see [freellmapi#382](https://github.com/tashfeenahmed/freellmapi/issues/382). Same commits as reference impl.

Happy to scope a PR to either piece (or both). The capability suffix parser is the simpler standalone — `~30 LOC` pure-leaf utility — and useful even without the bulk orchestrator.
