---
type: policy
title: "Canonical store is the git repo; cloud DBs are caches"
description: "The chirag127/oriz-me-data git repo is the authoritative store for lifestream events. Firestore / Turso / R2 are caches rebuilt from git on every deploy."
tags: [policy, data, storage, git, lifestream]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: false
related:
  - policy/ingester-contract
  - policy/public-private-line
  - architecture/canonical-store-jsonl
---

# Canonical store is the git repo; cloud DBs are caches

## The policy

The `chirag127/oriz-me-data` git repository is the single authoritative
store for lifestream events; every cloud database (Firestore, Turso,
Cloudflare R2, Cloudflare KV) is a derived cache that can be fully
rebuilt from the git repo on a fresh deploy.

## Scope

- All lifestream event data that feeds `me.oriz.in`.
- All other family `*-data` repos that follow the same pattern (e.g.
  future per-site canonical-data repos).
- Every site, extension, and Worker that reads or writes lifestream
  events.

## Rules

- **Authority.** When the cache and the git repo disagree, the git
  repo wins and the cache is rebuilt. Never edit a cached row by hand
  — write to the JSONL canonical store and let the rebuild script
  propagate.
- **Cache rebuilds are deterministic.** A `pnpm rebuild-cache` (or its
  GitHub Action equivalent) re-reads the JSONL and writes the cache
  from scratch; no incremental drift. If a cache row exists that the
  rebuild does not recreate, it gets dropped.
- **Cache failure modes are recoverable.** If Turso dies, the next
  deploy rebuilds the cache from git. If Firestore data is corrupted,
  the next deploy rebuilds it. If GitHub itself dies, `git clone` to
  a new host (Codeberg, GitLab, self-hosted Forgejo) and re-target.
- **JSONL append-only.** Lifestream events append to date-sharded
  JSONL files (e.g. `events/2026/06.jsonl`). Edits are issued as new
  events with a `corrects` reference; the corrected event is never
  removed from history.
- **Idempotency keys travel with rows.** The
  `(source, external_id, occurred_at)` tuple is the dedup key
  everywhere — JSONL append, Turso upsert, Firestore write. See
  [`./ingester-contract.md`](./ingester-contract.md) property (1).
- **Tier flag travels with rows.** Each row carries its
  `visibility` field per [`./public-private-line.md`](./public-private-line.md).
  Caches inherit the tier; they never re-classify.
- **No write path bypasses git.** Direct writes to Turso or Firestore
  that do not flow through the JSONL store are forbidden. Every
  ingester writes JSONL first, cache second.

## Exceptions

- **User account data in Firestore.** `users/{uid}/...` documents
  (subscription state, preferences) are stored in Firestore as their
  authoritative location, NOT in the lifestream git repo. They are
  user-specific and the canonical-git-repo pattern does not apply.
- **Build-time-only caches.** Turso warm caches and R2 image
  thumbnails may be deleted any time without coordination — the next
  build rebuilds them.
- **Hot edge state.** Cloudflare KV entries holding rate-limit
  counters, ephemeral session state, or webhook idempotency markers
  are not "data" in this policy's sense.

## Annual review

Not on the annual cycle — re-evaluate when GitHub policy changes
materially (e.g. private-repo storage caps, public-repo size limits)
or when the JSONL volume approaches a GitHub repo size soft limit.

## Cross-refs

- [`./ingester-contract.md`](./ingester-contract.md) — the contract that keeps writes idempotent
- [`./public-private-line.md`](./public-private-line.md) — the tier model attached to every row
- [`../architecture/canonical-store-jsonl.md`](../architecture/canonical-store-jsonl.md) — the storage architecture this policy operationalises
