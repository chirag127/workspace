---
type: decision
title: "me.oriz.in does NOT publish journal; journal stays auth-gated"
description: 'Journal: numeric aggregates public, text auth-gated'
tags: [journal, privacy, public-private, lifestream]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - decisions/content/100-year-strategy-locked
  - decisions/content/age-gating-policy-adopted
  - policy/public-private-line
---

# me.oriz.in does NOT publish journal; journal stays auth-gated

## Decision

`me.oriz.in` (the public lifestream / digital twin site) does NOT
publish journal entries. The journal remains at `journal.oriz.in`
behind Firebase Auth, with entries readable only by Chirag.
`me.oriz.in` may surface NUMERIC aggregates from the journal API
(entry count, streak, average length per month) but never the
entry text itself.

## Why

An earlier draft of the 100-year strategy considered making the
journal fully public as part of "everything public including
inner life." On reflection that was a thesis-level overreach: the
journal contains personal, often unfiltered content that doesn't
serve the recruiter audience and creates real career risk. Numeric
aggregates preserve the "I keep a journal" signal without leaking
content.

## Implications

- `journal.oriz.in` keeps Firebase Auth gating with default-deny Firestore rules — no public read.
- `me.oriz.in/me` section reads aggregates via the umbrella API (`apps/api/routes/firestore/journal-stats`) which projects entry-level data down to counts/streaks/word-counts before returning.
- Per the 100-year strategy annual-review checklist, this decision is re-read every birthday — if the framing flips again, both sides update together.
- Three public/private/gated tiers across the family: PUBLIC (career, code, books, music, fitness aggregates), AGE-GATED 18+ (adult-content metadata items, see [age-gating-policy-adopted](./age-gating-policy-adopted.md)), AGGREGATES-ONLY (journal counts, sleep/mood weekly), HIDDEN (raw GPS, sub-day timestamps, raw HR).
- The journal site continues to use the same `@chirag127/oriz-kit` primitives but its data flow is fully separate from `me.oriz.in`'s build pipeline.

## Cross-refs

- [100-year strategy locked](./100-year-strategy-locked.md) — §6 public/private line
- [Age-gating policy adopted](./age-gating-policy-adopted.md)
- [Public-private line policy](../policy/public-private-line.md)
