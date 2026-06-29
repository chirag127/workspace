---
type: decision
title: "All 11 sites have v2 designs landed"
description: v2 designs committed + pushed for all 11 sites. Cross-links fixed
tags: [design, v2, sites, milestone, design-briefs]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - branding/oriz-me-added-to-family
  - design/_family-rules
---

# All 11 sites have v2 designs landed

## Decision

As of 2026-06-19, every one of the 11 current sites in the family
has its v2 design implementation written, committed, and pushed
(see commit `e69214e` in master: "feat(submodules): bump all 11
sites to v2 design implementations"). The design briefs in
`knowledge/design/` (formerly `design-briefs/`) reference each
site's v2 implementation; those references now resolve.

## Why

The design briefs at `design-briefs/_FAMILY-RULES.md` and
`design-briefs/oriz-<site>.md` had been written months before the
sites caught up to them — many design-brief cross-links pointed at
v2 components that didn't yet exist on disk. Landing v2 across all
11 sites in one push closes that gap. Every brief's "see
implementation at..." link now points at a real file in the
appropriate submodule. Recruiters viewing any site see the same
design-quality bar.

## Implications

- All 11 site submodules now ship v2-design React components per their `design-briefs/oriz-<site>.md` (now `knowledge/design/oriz-<site>.md`) brief.
- The family rules at `knowledge/design/_family-rules.md` (formerly `design-briefs/_FAMILY-RULES.md`) — surface diversity, type budget, accent distribution, no-compromise briefs — are now enforced uniformly.
- Future design refreshes happen as v3+ briefs; v2 is the locked baseline.
- Per-site visual identity is preserved (each site picks its own accent / typography from the family rules); the kit ships no styles.
- This decision is the "this fixes the broken cross-link many design briefs reference" milestone the OKF migration relies on.

## Cross-refs

- [oriz-me added to family](../branding/oriz-me-added-to-family.md)
- [Family design rules](../design/_family-rules.md)
- Master commit `e69214e`: "feat(submodules): bump all 11 sites to v2 design implementations"
- Design brief index: [`../../design/index.md`](../design/index.md)
