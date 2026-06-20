---
type: index
title: "knowledge/design — design briefs index"
description: "Index of the family design contract plus all 11 per-site v2 briefs and the packages-split decision. Each entry points at one concept file."
tags: [design, index, v2]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - _okf
  - design/_family-rules
---

# knowledge/design — design briefs index

This directory holds the locked v2 visual language of the oriz family: one
cross-site contract, eleven per-site briefs, and one architectural decision
about the shared component packages. Read [`_family-rules.md`](./_family-rules.md)
first — every per-site brief is downstream of it.

All 11 per-site v2 designs were implemented in commit `e69214e`
(2026-06-19). Status across briefs is `active` unless noted.

## Cross-site contract

- [`_family-rules.md`](./_family-rules.md) — surface distribution, typeface
  budget, accent colour distribution, no-compromise briefs, universal
  constraints. The contract every per-site brief sits inside.

## Per-site design briefs (11)

Cream / paper surfaces (4):

- [`oriz-blog.md`](./oriz-blog.md) — engineer's working notebook; cream
  paper, Fraunces drop-cap, cobalt accent, series-spine signature.
- [`oriz-book-lore.md`](./oriz-book-lore.md) — aged-cream reading-room
  with pencil-red marginalia, bottle-green narration ribbon, brass
  page numbers.
- [`oriz-pdf-tools.md`](./oriz-pdf-tools.md) — typesetter's desk: cream
  manuscript, all-serif type stack, ledger-green CTAs, vermilion only
  for redaction.
- [`oriz-urls-to-md.md`](./oriz-urls-to-md.md) — URL → Markdown converter
  where the site IS a `.md` file: literal `#` headings, `[bracketed]`
  buttons, hot-red `#` glyph as the brand.

Dark surfaces (4):

- [`oriz-books.md`](./oriz-books.md) — NCERT textbook directory as a
  library catalogue drawer: ink-block desk, bone catalogue cards,
  cinnabar accent, Plex Serif + Sans Devanagari.
- [`oriz-image-tools.md`](./oriz-image-tools.md) — browser darkroom:
  13 client-side image tools, dark surface, Space Grotesk, phosphor
  `#C8FF3C` accent. Histogram is the brand.
- [`oriz-journal.md`](./oriz-journal.md) — auth-gated PWA: dusk surface
  with cream entry pages, animated wax seal, seal-red accent, GT Sectra
  titles, libsodium client-side encryption.
- [`oriz-home.md`](./oriz-home.md) — master hub / portal route: dark
  leather-spine surface, monochrome until hover, mustard-yellow primary,
  one vermilion `start anywhere ↓` arrow.

Other surfaces (3):

- [`oriz-finance.md`](./oriz-finance.md) — calculator workbench:
  literal printed graph-paper grid, hairline tan rules, decimal-aligned
  tabular numbers, graph-teal accent, Fraunces display.
- [`oriz-cards.md`](./oriz-cards.md) — Bloomberg-terminal-for-Indian-
  credit-cards: cool slate surface, carbon-blue primary, vermilion only
  on negative numbers, wide-mono display, embossed-card signature.
- [`oriz-me.md`](./oriz-me.md) — personal site as build manifest:
  datasheet white, archival-blue accent, Plex Sans Condensed, provenance
  strip with live build timestamp + 4px pulsing sync dot.

## Architectural decisions adjacent to design

- [`packages-split-plan.md`](./packages-split-plan.md) — the plan to
  split `@chirag127/oriz-ui` v1.1.0 into five independently-publishable
  packages. Status: `completed` — shipped 2026-06-19. Sites no longer
  share a header / footer; only Button, Input, Modal, AuthModal, and
  Firebase init are shared via the split packages (since renamed to
  `oriz-kit`).

## How these files relate

Every per-site brief opens with surface tokens, type stack, layout
sketches, signature element, and a "what NOT to do" no-compromise list.
The cross-site rules in `_family-rules.md` constrain the choices
available to each per-site brief: surface, display typeface, primary
accent, and the no-compromise commitments are pre-allocated across the
family so any two adjacent sites read as different.

When updating a per-site brief, also re-read `_family-rules.md` — the
contract may have shifted.
