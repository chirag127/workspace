---
type: glossary
title: "family anchor site"
description: "oriz-home, the site whose v2 design defines patterns the other 10 reuse."
tags: [glossary, design, oriz-home]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# family anchor site

## Definition

The family anchor site is `oriz-home` (`oriz.in`) — the datasheet
portal whose v2 design language sets the patterns that the other 10
sites adapt to their own visual identities.

## Expanded

`oriz-home` is also the canonical home for the Firestore security
rules (`oriz-home/firestore.rules`) and the Cloudflare Pages reference
configuration. When a shared primitive in `@chirag127/oriz-kit` lands
new `[data-oriz-*]` hooks, `oriz-home` is where the canonical styling
example lives, and the per-site briefs reference it.

Every site has its own visual identity per its `design-briefs/` brief;
the anchor sets surface diversity, type budget, and accent
distribution rules they vary against.

## See also

- [family](./family.md)
- [oriz-kit](./oriz-kit.md)
