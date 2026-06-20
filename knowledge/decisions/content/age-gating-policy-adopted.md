---
type: decision
title: "Age-gating policy adopted for adult-content sections"
description: "Tracked items carrying adult-content metadata (movies, anime, possibly others) render behind an 18+ confirmation gate, not silently published or silently hidden."
tags: [age-gating, policy, content, privacy, compliance]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - decisions/content/journal-stays-auth-gated
  - decisions/content/100-year-strategy-locked
  - policy/age-gating
---

# Age-gating policy adopted for adult-content sections

## Decision

Sections of the family that surface tracked content with
adult-content metadata (movies on Letterboxd / simkl, anime on
AniList / simkl, manga, games, possibly other categories) render
behind an 18+ confirmation gate. The default state on first visit
shows the gate, not the content. Public unauthenticated visitors
must affirmatively confirm 18+ before the gated content renders.

## Why

The 100-year strategy commits to publishing inner-life data
including media consumption, but raw adult-content listings are
both a compliance risk under UK Online Safety Act / EU DSA / India
IT Rules and a recruiter-experience risk on the front-door site.
Age-gating threads the needle: the data still gets published (per
the everything-public default), but adult-only items are gated so
casual visitors and search crawlers don't surface them
unintentionally.

## Implications

- Each tracked item in the lifestream JSONL carries an `adult: boolean` field (or equivalent metadata flag from the upstream API).
- An `<AgeGate>` component lives in `@chirag127/oriz-kit` and intercepts rendering of any section containing one or more adult-flagged items.
- Confirmation persists per browser via `localStorage` — gate shows once per device, not per page load.
- The gate's confirmation does NOT bypass the existing Firebase Auth checks on private/auth-gated routes. It's a layer on top, not a replacement.
- Annually re-evaluate the age-gate policy against current jurisdictional rules (UK OSA / EU DSA / India IT Rules / etc.) — listed in the 100-year-strategy review checklist.
- Any source that has been age-gated 3+ times in a year gets a hard re-evaluation: keep with the gate, or drop the source from the site entirely.

## Cross-refs

- [me.oriz.in journal stays auth-gated](./journal-stays-auth-gated.md)
- [100-year strategy locked](./100-year-strategy-locked.md) — §6 public/private line
- [Age-gating policy](../../policy/age-gating.md)
