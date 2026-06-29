## Problem

Two related operator pain points emerge once a catalog-sync runs on a regular tick against a database where the operator has made local edits:

### 1. Deleted seeded models silently come back

When the catalog-sync pump re-INSERTs every catalog model that isn't present locally, any model the operator has deliberately deleted reappears on the next tick. "Delete `gemini-2.5-pro`" yesterday → it's back this morning. The deletion has no durable record.

### 2. Capability toggles get clobbered by catalog-sync

User report shape: "Vision and tool calling enablement get removed for some of the things." Cause: the catalog-sync UPDATE path overwrites `supports_vision` and `supports_tools` from the catalog payload every tick. If the catalog says `false` and the user toggled `true` in the UI, the catalog overwrites the toggle.

Both are the same bug class: **operator intent is in-memory, catalog state is durable, the durable layer wins on every tick.**

## Proposed fix (same shape for both)

Two small fork-local tables that record operator intent, plus passive pumps that re-apply intent whenever catalog-sync clobbers the live row.

### Table 1: `deleted_seed_models`

```sql
CREATE TABLE IF NOT EXISTS deleted_seed_models (
  kind TEXT NOT NULL,       -- 'chat' | 'embedding'
  platform TEXT NOT NULL,
  model_id TEXT NOT NULL,
  deleted_at INTEGER NOT NULL,
  PRIMARY KEY (kind, platform, model_id)
);
```

Boot purge + 60s setInterval re-deletes anything tombstoned that has reappeared. Custom-registered models bypass tombstones (no upstream re-add).

### Table 2: `capability_overrides`

```sql
CREATE TABLE IF NOT EXISTS capability_overrides (
  platform TEXT NOT NULL,
  model_id TEXT NOT NULL,
  supports_tools INTEGER,   -- nullable; only set columns are pinned
  supports_vision INTEGER,
  updated_at INTEGER NOT NULL,
  PRIMARY KEY (platform, model_id)
);
```

Same shape: boot apply + 60s pump. Per-axis nullable columns so toggling one flag doesn't pin the other; the pump UPDATEs only when the live row differs (cheap when nothing has been clobbered).

Reference impl: [oriz-org/freellmapi@2ab44be](https://github.com/oriz-org/freellmapi/commit/2ab44be) (tombstones), [oriz-org/freellmapi@109325e](https://github.com/oriz-org/freellmapi/commit/109325e) (capability overrides), [oriz-org/freellmapi@58a1a77](https://github.com/oriz-org/freellmapi/commit/58a1a77) (cache-invalidate follow-up).

## Current state in OmniRoute

`grep "tombstone\|deleted_seed_models\|capability_overrides"` in `src/lib/db/`: **zero hits**.

OmniRoute does have a model-hide mechanism (`getModelIsHidden` is called in `src/app/api/v1/models/catalog.ts:825`), which is the right primitive for tombstones — but it doesn't appear to be wired to a catalog-sync clobber-resistance layer. Likewise capability flags live on the model row directly and get overwritten when synced data lands.

This isn't a bug today only because OmniRoute's catalog-sync cadence is different from freellmapi's. The bug class shows up whenever operator-edit and catalog-write race for the same row.

## Why it matters now vs later

OmniRoute already runs synced-capability writes — see `src/lib/modelsDevSync.ts` and the synced-capability merge at `src/app/api/v1/models/catalog.ts:542,548`. Adding tombstones + capability-overrides preempts a future class of "why did my toggle revert?" issues that scale with catalog growth.

## Reference

Filed as part of theme 1 in `tashfeenahmed/freellmapi` — see [freellmapi#381](https://github.com/tashfeenahmed/freellmapi/issues/381). Tombstones + capability-overrides are sub-items 5 and 7 of that issue.

Pure-leaf shape: both tables are lazy-created (`CREATE TABLE IF NOT EXISTS` outside `migrations.ts`), pumps are passive (cheap when no clobber happens). Happy to PR if maintainer confirms the bug class is in-scope — would land as a new `src/lib/db/operatorIntent.ts` leaf with two tables + boot + interval pumps.
