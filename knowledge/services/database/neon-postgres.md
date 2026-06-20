---
type: service
title: "Neon Postgres"
description: "Serverless Postgres for relational workloads — free tier confirmed no card, scale-to-zero, branching for previews."
tags: [database, postgres, relational, neon, serverless, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: db-postgres-relational
provider: neon
free_tier: "Free plan, no card required: 100 projects, 100 CU-hours / project / month, 0.5 GB storage / project, 5 GB egress / month, scale-to-zero after 5 min idle, 6 h instant restore window, up to 60K Neon Auth MAU"
swap_cost: medium
related:
  - services/database/turso
  - services/auth/firebase-spark
  - decisions/architecture/db-add-neon-postgres
  - decisions/architecture/firebase-rest-firestore-not-admin
  - decisions/architecture/lifestream-jsonl-canonical
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Neon Postgres

## Role

Relational tier of the family's 4-tier DB stack — used **only when a
workload needs SQL joins, aggregates, foreign keys, or strong
relational integrity** that don't fit a Firestore document or a
read-only libSQL replica. Concrete examples:

- `oriz-finance` ledger — multi-table joins between accounts /
  transactions / categories / budgets, with reconciliation queries.
- `oriz-cards` relational tags — many-to-many between cards / decks /
  tags / sessions, with set-difference queries.
- Any future feature where a JSONL → libSQL flatten loses too much
  schema for the query shape required.

For document-shaped data (auth, app config, lifestream events), the
family stays on [Firestore](../auth/firebase-spark.md) /
[Turso libSQL](./turso.md) / JSONL — see
[`decisions/architecture/firebase-rest-firestore-not-admin.md`](../../decisions/architecture/firebase-rest-firestore-not-admin.md)
and [`decisions/architecture/lifestream-jsonl-canonical.md`](../../decisions/architecture/lifestream-jsonl-canonical.md).

## Free tier (confirmed 2026-06-20, screenshot of pricing page)

- **No card required** for Free plan
- 100 projects per account
- 100 compute-hours per project per month
- 0.5 GB storage per project
- 5 GB egress / month
- **Scale-to-zero** after 5 min idle (compute-hours stop counting)
- 6 h instant point-in-time restore window
- Database branching (one branch per preview deploy)
- Up to 60K Neon Auth MAU (Neon-bundled auth, not used here — we
  stay on Firebase Auth, see [`services/auth/firebase-auth.md`](../auth/firebase-auth.md))

## Card / subscription required?

**NO.** Confirmed from Neon's pricing page on 2026-06-20.

## Quota-headroom plan

Per [`rules/never-hit-quotas.md`](../../rules/never-hit-quotas.md), the
family runs Neon at safe headroom:

- **Compute autoscaling capped at 2 CU** on every project. Higher
  burst would burn the 100 CU-hours / project / month budget in days.
- One **project per relational app** (`oriz-finance`,
  `oriz-cards`, …) so each gets its own 0.5 GB + 100 CU-hours
  envelope. We have 100 projects to spend.
- **Scale-to-zero relied on aggressively** — the umbrella Hono Worker
  reconnects on cold start; libSQL serves cached reads in front of
  Neon for hot paths.
- Migrations and bulk imports run during low-traffic windows so the
  egress budget is preserved for live queries.

## Branching for previews

Neon's free plan includes branching — one Neon branch per Cloudflare
Pages preview deploy. The Pages preview job creates a branch from
`main` at deploy, runs migrations on the branch, tears it down on
merge. Zero risk to the main DB.

## Alternatives

- [Turso libSQL](./turso.md) — already in the stack as the warm
  read-cache; use for read-heavy lifestream queries, NOT for
  relational write paths
- [Supabase](../auth/supabase.md) — fallback Postgres + Auth (auth
  layer is rejected since we stay on Firebase; the Postgres layer
  could be a future swap target if Neon's quota cliff hits)
- Cloudflare D1 — SQLite-only, no Postgres semantics
- Xata — free tier exists but smaller than Neon's
- Aiven for PostgreSQL — free tier ended 2024

## Swap cost

Medium — wire-protocol Postgres is portable; a swap to Supabase
Postgres or self-hosted Postgres is a connection-string change plus
re-running migrations. The family's relational adapters live behind a
single `db/` module per app so the swap surface is one file per app.

## Why this is our pick

Free plan with **no card**, scale-to-zero (kills idle compute cost
mathematically, not just practically), branching for previews, and a
wire-protocol-Postgres surface that's portable to any other Postgres
provider if the cliff hits. The 4-tier DB stack now covers every
shape of data the family touches.

## Cross-refs

- [DB add Neon Postgres decision](../../decisions/architecture/db-add-neon-postgres.md)
- [Database services index](./index.md)
- [Turso (libSQL)](./turso.md) — sibling, warm cache for documents
- [Firebase Spark — Auth + Firestore](../auth/firebase-spark.md)
- [firebase-rest-firestore decision](../../decisions/architecture/firebase-rest-firestore-not-admin.md)
- [Lifestream JSONL canonical decision](../../decisions/architecture/lifestream-jsonl-canonical.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
