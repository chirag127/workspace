---
type: policy
title: "Public / private visibility tiers"
description: "Four tiers govern every piece of content across the family: public, age-gated-18, aggregates-only, private. Inner-life metrics surface only as weekly aggregates."
tags: [policy, privacy, visibility]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: true
related:
  - policy/age-gating
  - policy/journal-not-public
  - policy/data-canonical-store
---

# Public / private visibility tiers

## The policy

Every datum the family stores or renders falls into exactly one of four
visibility tiers, and the tier — not the URL or the page template —
determines what a non-authenticated visitor sees.

## Scope

- All lifestream events in `chirag127/oriz-me-data`.
- All Firestore documents under `users/{uid}/...`.
- All build-time JSON / JSONL / MDX content baked into static sites.
- All API responses from `api.oriz.in`.

## Rules

- **Tier 1 — `public`.** Default for blog posts, datasheet content,
  finance calculator inputs, books / cards directories, public lifestream
  rows. Indexable, cacheable, exportable. No login, no gate.
- **Tier 2 — `age-gated-18`.** Renders only after the 18+ cookie
  attestation per [`age-gating.md`](./age-gating.md). `noindex`. No
  sitemap entry.
- **Tier 3 — `aggregates-only`.** The raw row is private; only a
  computed aggregate over a time window is published. Sleep, mood,
  weight, heart rate, journal word counts surface here — as weekly or
  monthly numbers, never per-event. The aggregate must be coarse enough
  that no single underlying event can be reverse-engineered from a
  diff between two snapshots.
- **Tier 4 — `private`.** Auth-gated by Firebase. Requires
  `request.auth.uid == owner_uid` per the canonical security rules.
  Journal entries, draft posts, subscription state, preferences.
  Default-deny everything else.
- **Tier is a property of the data, not the page.** A row's tier is
  written at ingest time and travels with it through every cache. A
  page that mixes tiers takes the most restrictive one for the page as
  a whole.
- **Inner-life metrics.** Sleep, mood, energy, weight, heart-rate,
  meditation duration, journal word count: `aggregates-only`. Render
  as weekly bars or monthly totals on `me.oriz.in`. Never per-event.
- **Tier downgrades require a new event.** Once a row is published
  `public`, edits to its tier do NOT retroactively reach caches or
  exports — issue a deletion + re-publish if a leak must be undone.

## Exceptions

- **The annual public-archive event.** On Chirag's death, the
  `aggregates-only` tier remains as-is; the `private` tier becomes
  visible only for the subset explicitly listed in the 100-year strategy
  (high-level life summary, not journal text).
- **Build-time pre-aggregation.** `aggregates-only` rows may be
  pre-aggregated at build time and the aggregate published as `public`
  — that is the intended path, not an exception.

## Annual review

Each year, audit one random sample of 20 lifestream rows from each
tier and confirm the tier still reflects current intent. Tier drift is
the most common privacy bug; the audit catches it.

## Cross-refs

- [`./age-gating.md`](./age-gating.md) — the gate guarding tier 2
- [`./journal-not-public.md`](./journal-not-public.md) — the canonical example of a tier-3-only inner-life metric
- [`./data-canonical-store.md`](./data-canonical-store.md) — where the tier flag lives on each row
