---
type: service
title: "Turso (libSQL)"
description: "Read-only warm cache for lifestream events — edge replicas, free tier"
tags: [database, turso, libsql, cache]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: event-read-cache
provider: turso
free_tier: "500 databases, 9 GB total storage, 1 billion row reads/mo, 25 million row writes/mo, 3 locations"
swap_cost: medium
---

# Turso (libSQL)

## Role

Read-optimised cache populated at build from the canonical JSONL in
`oriz-me-data`. Reads happen at the edge so the lifestream loads
under 100 ms anywhere.

## Free tier

- 500 databases
- 9 GB total storage
- 1 billion row reads/month
- 25 million row writes/month
- 3 replica locations

## Card / subscription required?

**NO.** Free Starter plan needs only an email-verified account.

## Alternatives

- Cloudflare D1
- TinyBase static
- Postgres on [Supabase](../auth/supabase.md)

## Swap cost

Medium — the rebuild script that walks JSONL and writes to libSQL is
~50 lines and would be rewritten for any SQLite/Postgres target.

## Why this is our pick

Edge replication, generous reads, libSQL is just SQLite with a
network. Rebuildable from canonical at any time.

## Cross-refs

- [Canonical store JSONL](../../decisions/database/canonical-store-jsonl.md)
- [Layer 4 — database by shape](../../decisions/database/layer-4-database-by-shape.md)
