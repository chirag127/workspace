---
type: index
title: "Database services"
description: "The 4-tier database stack — Firestore (documents) + Turso libSQL (warm cache) + JSONL canonical (in oriz-me-data) + Neon Postgres (relational). Picked by data shape, not by vendor preference."
tags: [services, database, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Database services

The family runs a **4-tier DB stack**, picked by data **shape**:

| Tier | Service | Shape it owns | Status |
|---|---|---|---|
| Documents + auth | [Firebase Spark — Firestore](../auth/firebase-spark.md) | App config, auth user docs, real-time docs | active |
| Canonical archive | JSONL in [`chirag127/oriz-me-data`](../../glossary/i-n/master-repo.md) | Append-only event stream, source-of-truth for lifestream | active |
| Warm read cache | [turso.md](./turso.md) | Edge-replicated libSQL, rebuilt nightly from JSONL | active |
| Relational | [neon-postgres.md](./neon-postgres.md) | SQL joins, foreign keys, ledgers, many-to-many tags | active |

Every cloud DB is a **cache rebuildable from the canonical**. The
canonical is JSONL in git — every other DB can be torn down and
rebuilt from the JSONL + per-app schema migrations.

## Per-tier services

| Service | Status | One-line role |
|---|---|---|
| [turso.md](./turso.md) | active | libSQL warm cache for lifestream events; rebuilt nightly from JSONL |
| [neon-postgres.md](./neon-postgres.md) | active | Postgres for relational workloads (oriz-finance ledger, oriz-cards tags); free, no card, scale-to-zero |

Auth user records live in Firestore — see [auth/firebase-spark.md](../auth/firebase-spark.md).

## Why a Postgres tier on top of the existing 3

Firestore is fast at document reads + auth, but joins are painful and
relational integrity (foreign keys, transactions across documents) is
not its design. JSONL + libSQL handle event-stream reads beautifully
but flatten relational structure. Some apps in the family — concrete
near-term: `oriz-finance` (multi-table ledger), `oriz-cards`
(many-to-many decks/tags) — need real SQL. Neon's free plan covers
those workloads with no card and scale-to-zero, so we add it as the
4th tier rather than forcing relational shape into Firestore. See
[`decisions/architecture/db-add-neon-postgres.md`](../../decisions/architecture/db-add-neon-postgres.md).

## Cross-refs

- [Layer 4 — database by shape](../../architecture/layer-4-database-by-shape.md)
- [architecture/canonical-store-jsonl](../../architecture/canonical-store-jsonl.md)
- [architecture/cloud-dbs-as-caches](../../architecture/cloud-dbs-as-caches.md)
- [decisions/architecture/lifestream-jsonl-canonical](../../decisions/architecture/lifestream-jsonl-canonical.md)
- [decisions/architecture/db-add-neon-postgres](../../decisions/architecture/db-add-neon-postgres.md)
- [decisions/architecture/firebase-rest-firestore-not-admin](../../decisions/architecture/firebase-rest-firestore-not-admin.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
