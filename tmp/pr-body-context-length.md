## What

Emit `context_length`, `max_input_tokens`, and `max_output_tokens` on per-platform `/v1/models` entries (the `<alias>/<model>` + `<provider>/<model>` rows in `catalog.ts:830-859`). Combos already emit `context_length` (line 738); per-platform entries did not.

Refs #5161.

## Why

Downstream clients that follow the OpenRouter/OpenAI `/v1/models` convention (`@ai-sdk/openai-compatible` + Vercel AI SDK + several Anthropic SDK wrappers) read `entry.context_length` to size their own prompt truncation. When the field is missing, they fall back to `context_length: 0` and over-truncate prompts down to 4k/8k.

The same client class is referenced by an existing comment in `tests/unit/v1-models-by-id-4674.test.ts:47` — the case-insensitive lookup in #5082 was added because clients hitting this fallback path silently corrupted long-context conversations. Adding the field at source closes the gap at the catalog level.

freellmapi shipped the same field via [PR #282](https://github.com/tashfeenahmed/freellmapi/pull/282) (MIT-licensed reference).

## How

Source order matches the existing `getComboTargetCatalogMetadata` precedence:

1. Synced capability (`limit_context` / `limit_input` / `limit_output` from `getSyncedCapability()`)
2. Registry model (`contextLength` from `getRegistryModel()` — already on `model` in scope)
3. Model spec (`contextWindow` / `maxOutputTokens` from `getModelSpec()`)
4. Token-limit fallback (`getTokenLimit()`)

When no window is known anywhere, the spread collapses to `{}` — no shape change, fully backward-compatible.

## Test

`tests/unit/v1-models-context-length-5161.test.ts` — asserts:

1. Every non-combo entry whose id matches a well-known long-context model pattern (`gemini-2`, `claude-sonnet-4`, `gpt-5`, `deepseek-v3`, `llama-3.x`) carries `context_length > 0`. Skips assertion if the candidate set is empty (e.g. CI without provider config) to avoid flakiness.
2. When `context_length` is set, `max_input_tokens` is also positive.

Runs via `node --import tsx/esm --test tests/unit/v1-models-context-length-5161.test.ts`.

## Risk

Pure additive — no shape change on existing fields, no behaviour change when no window is known. Vision fields are spread after the limit fields so any future conflict is resolved in favour of `visionFields` (matches the existing alias-row ordering).

## Checklist

- [x] Tests added (`v1-models-context-length-5161.test.ts`)
- [x] No raw `err.message`/`err.stack` in any response (Hard Rule 12 — N/A, no error paths touched)
- [x] No `eval`/`new Function` (Hard Rule 3 — N/A)
- [x] Branched off `release/v3.8.40` (not `main`) per worktree-isolation rule
- [x] No AI-tool credit in commit / PR description (Hard Rule 16)
- [x] Conventional commits

cc @diegosouzapw
