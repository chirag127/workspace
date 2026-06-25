---
type: decision
title: "Family-wide design system locked: Oriz Datasheet Dark"
description: "Every chirag127 site, extension, and CLI doc page shares one locked dark design system — Oriz Datasheet Dark — with monospace display, ledger-paper text, burnt-sienna stamp accent, and identical 4-region chrome."
tags: [design, theme, tokens, typography, layout, family]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related: [user-prefers-strict-no-toggle, sidebar-4-tier, repo-naming-suffixes]
---

# Family-wide design system locked: Oriz Datasheet Dark

## Decision

Every chirag127 site (and every chrome extension, VS Code extension, CLI doc page) shares the "Oriz Datasheet Dark" design system. Locked 2026-06-20.

## Subject grounding

- Subject: a polymath shipping ~30 small precision tools + sites under one banner.
- Visual world: vintage technical reference, library catalog cards, oscilloscope phosphor, terminal command lines, ledger paper.
- Avoids the three AI-default looks: warm-cream + terracotta, pure-black + acid-green, newspaper hairlines.

## Tokens

Color palette (CSS custom properties — set in @chirag127/astro-chrome/tokens.css):

| Token | Hex | Use |
|---|---|---|
| --ink-0 | #08090B | page bg — near-black, NOT pure (keeps detail) |
| --ink-1 | #11141A | raised surface (sidebar, cards, header) |
| --ink-2 | #1A1F28 | borders, hairlines, dividers |
| --ink-3 | #2A323F | hover, focus, active border |
| --paper | #E6E8EC | primary text — warm paper, NOT #FFF |
| --paper-2 | #9EA4B0 | secondary text |
| --paper-3 | #5C6271 | metadata, captions, timestamps |
| --stamp | #D55A38 | single chromatic accent — burnt sienna |
| --stamp-trace | #3E1A0F | low-alpha stamp tint for soft highlights |

Type scale: 12 / 14 / 16 / 20 / 28 / 40 / 64 (px).

## Typography

| Role | Family | License | Source |
|---|---|---|---|
| Display | Iosevka Etoile | OFL | @fontsource/iosevka-etoile |
| Body | Public Sans | OFL (USWDS) | @fontsource/public-sans |
| Code | Iosevka Term | OFL | @fontsource/iosevka-term |

All self-hosted via @fontsource. No Google Fonts CDN (privacy + offline).

## Layout (every site, identical chrome)

Wireframe:
```
┌─ HEADER ──────────────────────────────────────┐
│ [Stamp] site-name           search · auth      │
├─ SIDEBAR ──┬─ MAIN ───────────────────────────┤
│ /         │                                    │
│ /sub      │   content                          │
├───────────┴─ BOTTOM-BAR ──────────────────────┤
│ // updated YYYY-MM-DD   §toc   ↩ top           │
├─ FOOTER ──────────────────────────────────────┤
│ this site's pages   family directory           │
└────────────────────────────────────────────────┘
```

4 chrome regions: Header (60px) + Sidebar (260px desktop / hamburger drawer mobile) + BottomBar (32px) + Footer (auto).

## Signature element

Rubber-stamp mark — top-left of every page. SVG with offset noise + slight rotation (-2deg). Reads "ORIZ · {siteName}". Color: --stamp on --ink-0. Single accessory per Chanel — used NOWHERE else outside the active-state indicator.

## Risk taken

Monospace as display face for a portfolio that has longform content. Conventional advice says mono = code only. Inverting it makes every page read as "technical reference written by a human" — distinct from both code-blog tropes and corporate-portfolio tropes.

## Implications

- @chirag127/astro-chrome owns the tokens + fonts CSS + all 4 chrome components + Stamp signature.
- Every site imports `@chirag127/astro-chrome/tokens.css` + `@chirag127/astro-chrome/fonts.css` from src/styles.css.
- No light theme anywhere (per user-prefers-strict-no-toggle).
- No per-site accent colors — --stamp is family-wide.
- Mobile sidebar = full-screen drawer triggered by hamburger in header.
- Tool sites use the SAME chrome but with their own brand wordmark in the stamp ("ORIZ · pdf" etc.).

## Rejected alternatives

- AMOLED zinc + emerald (too AI-default per frontend-design skill calibration)
- Slate dark + violet (Linear/Vercel default, not distinctive)
- Stone dark + amber (warm dark, considered, rejected — colder direction fits subject better)
- Per-site accent (rejected — defeats family unity)
- Phosphor terminal (CRT green-on-black; too costume)
- Newsprint dark (broadsheet hairlines; falls into AI-default #3)

## Cross-refs

- [user-prefers-strict-no-toggle](../../rules/interaction/user-prefers-strict-no-toggle.md)
- [sidebar-4-tier](../architecture/sidebar-4-tier.md)
- [user-prefers-pure-tool-brand](../../rules/interaction/user-prefers-pure-tool-brand.md)
- [title-case-oriz](../branding/title-case-oriz.md)
