---
type: policy
title: "Journal text is never public"
description: Numeric journal aggregates on me.oriz.in. Text auth-gated
tags: [policy, privacy, journal, aggregates]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
annual_review: false
related:
  - policy/public-private-line
  - policy/age-gating
---

# Journal text is never public

## The policy

`me.oriz.in` publishes zero journal text or excerpts; the only journal
data it surfaces is coarse numeric aggregates, and the journal itself
remains auth-gated at `journal.oriz.in`.

## Scope

- The public lifestream feed on `me.oriz.in`.
- All build-time exports from `chirag127/oriz-me-data` to any
  consumer.
- The Cloudflare R2 / Turso caches that feed the live home page.
- Any future "year in review" or "all-time" public summary page.

## Rules

- **No journal body text leaves the auth perimeter.** Not in HTML, not
  in JSON snapshots, not in build-time MDX, not in Turso, not in R2,
  not in OG tags, not in RSS.
- **Allowed aggregates.** Entry count (per day / week / month / year),
  current streak, longest streak, monthly word count, words-written
  totals, time-of-day histograms (binned into 4-hour buckets, never
  finer).
- **Disallowed surfaces.** Per-entry word count (correlates back to
  individual entries), per-day word count (too leaky on quiet days),
  topic / mood tags from journal entries, sentiment scores derived from
  journal content, search indices over journal body, AI-summarised
  highlights.
- **Journal lives at `journal.oriz.in`.** Reached via Firebase Auth.
  Same Firebase user works on `me.oriz.in` for the rest of the
  lifestream UI but the journal route requires the auth check.
- **Aggregates are computed inside the auth perimeter.** The journal
  build step inside `journal.oriz.in` (or a server-side function it
  trusts) writes the aggregate JSON; `me.oriz.in` reads only that
  pre-computed aggregate file. Never derive an aggregate by reading
  raw entries from the public side.

## Exceptions

- **None for journal body.** This is the strictest tier-4 rule in the
  family. No "just one quote" carve-out, no "anonymised excerpt"
  carve-out.
- **Death-archive carve-out (future).** The 100-year strategy may
  promote selected journal content to public after death; that
  promotion happens via explicit list, not via this policy's rules
  changing.

## Annual review

Not on the annual cycle — this rule is intended to be permanent. If a
future product idea seems to need journal text on `me.oriz.in`, the
correct response is to redesign the product, not to revise this
policy.

## Cross-refs

- [`./public-private-line.md`](./public-private-line.md) — `aggregates-only` is the tier this policy operationalises
- [`./age-gating.md`](./age-gating.md) — the adjacent gate (auth here, attestation there)
- `../../AGENTS.md` § Decided history — "me.oriz.in journal stays auth-gated at journal.oriz.in"
