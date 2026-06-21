---
type: rule
title: "Design divergence is NOT duplication"
description: "Per-app design-brief variants (Header / Footer / Wordmark, blog's MultiSearch, blog's astro.config) are intentionally divergent across apps and must NOT be forced into generic slot-based components. The 25-lines × 3-apps dedup threshold applies to TRUE duplicates, not to components that share a name but implement different design briefs."
tags: [rules, design-system, dedup, packages, components]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/the-six-packages
  - decisions/design/datasheet-dark
  - rules/match-surrounding-style
---

# Design divergence is NOT duplication

The dedup-sweep threshold for extracting shared code into an
`@chirag127/*` package is **≥25 lines duplicated across ≥3 consumers
AND no community library covers it** (see
[`the-six-packages`](../decisions/architecture/the-six-packages.md)).

That threshold applies to **TRUE duplicates** — byte-identical or
trivially-parameterisable code. It does NOT apply to components that
share a *name* but implement a different *design brief* per app.

## Components currently kept per-app on purpose

| Component | Why divergent |
|---|---|
| `Header` | Each app's nav, logo treatment, and mode (sticky / static / translucent) is part of its design brief |
| `Footer` | Per-app link sets, legal addenda (`/privacy/<site>` per [family-wide-privacy-page](../decisions/branding/family-wide-privacy-page.md)), social links |
| `Wordmark` | Per-app brand stamp ("ORIZ · pdf", "ORIZ · paisa", etc.) per [datasheet-dark](../decisions/design/datasheet-dark.md) |
| blog's `MultiSearch` | Blog-specific search providers + result formatting; not a fit for the kit's generic `<MultiSearch />` |
| blog's `astro.config` | Blog uses `@astrojs/mdx` + RSS plugins others don't need |

## When unification would cost more than divergence

A generic slot-based component (`<Header><slot name="logo"/><slot
name="nav"/></Header>`) with N apps each supplying a slot config can
easily be **larger** than the N variants combined — once you count
the slot wiring, prop drilling, and per-app config files. The unified
component "wins" only when the variants are mostly identical and the
divergence is data-shaped (text strings, link arrays). When the
divergence is layout-shaped (different DOM structure per app), keep
the variants.

## Heuristic before forcing consolidation

1. **Diff the candidates line-by-line.** If <25 lines repeat literally
   across <3 apps, do not consolidate.
2. **Estimate the slot-API line count.** If `(slot wiring + per-app
   configs) ≥ Σ(variants)`, the consolidation is a net loss.
3. **Check the design brief.** If the per-app design brief actually
   specifies a different layout, the divergence is the feature.

## See also

- [`the-six-packages`](../decisions/architecture/the-six-packages.md) — the 25 × 3 threshold for true duplicates
- [`datasheet-dark`](../decisions/design/datasheet-dark.md) — family-wide tokens stay shared; per-app chrome stays per-app
- [`match-surrounding-style`](./match-surrounding-style.md) — sibling rule for style discipline per file
