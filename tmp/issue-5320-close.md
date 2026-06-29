## ⚠️ Closing as already shipped 2026-06-29

**My original framing was wrong.** I claimed `grep tombstone|deleted_seed_models|capability_overrides` returns zero hits and that the catalog-sync clobber would silently revert operator edits. After a closer read of `src/lib/db/models.ts`, this is **not a real gap** — OmniRoute already has the same functional shape under different names.

What I missed:

| freellmapi pattern | OmniRoute equivalent | Location |
|---|---|---|
| `deleted_seed_models` tombstone table | `ModelCompatOverrides.isDeleted` + `mergeModelCompatOverride(provider, modelId, { isDeleted: true })` | `src/lib/db/models.ts:181`, used at `src/app/api/provider-models/route.ts:423` |
| Hide-survives-sync | `setModelIsHidden(providerId, modelId, hidden: boolean)` + `getModelIsHidden()` (catalog reads it at `src/app/api/v1/models/catalog.ts:825`) | `src/lib/db/models.ts:1161`, persistent |
| `capability_overrides` table | `ModelCompatOverrides` (same `models.ts` shape; merges capability patches without clobbering catalog row) | `src/lib/db/models.ts:158`, `:181`, `:247` |
| Clobber-resistance pump | Override layer is **read on every catalog emission** (`getModelCompatOverrides` called at `src/app/api/provider-models/route.ts:61, 250, 348`), not a periodic re-apply — but functionally equivalent because the override is the source of truth, the catalog row is just a base. |

The `mergeModelCompatOverride(provider, modelId, { isDeleted: true, isHidden: true })` call at `src/app/api/provider-models/route.ts:423` is literally a tombstone write. The override layer is consulted on every model emission so a clobber in the catalog row doesn't matter — the override always wins.

freellmapi's pattern (separate `deleted_seed_models` + `capability_overrides` tables + periodic pumps) and OmniRoute's pattern (unified `ModelCompatOverrides` + read-on-emission) solve the same problem with different shapes.

**Apologies for filing without first reading `src/lib/db/models.ts`.** Closing.

If there's a specific gap in `ModelCompatOverrides` I haven't found (e.g. no API surface for bulk operator-intent restore across deploys, no UI to surface "your override is in force"), I'll file a narrower issue against that specific gap with file refs.

cc @diegosouzapw — sorry for the noise.
