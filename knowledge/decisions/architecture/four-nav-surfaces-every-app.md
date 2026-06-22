---
type: decision
title: "Every app ships all 4 navigation surfaces: Header + Footer + Sidebar + BottomBar"
description: "Every oriz app must include all 4 navigation surfaces (Header at top, Footer at bottom, Sidebar at side, BottomBar mobile-tab-bar at bottom-fixed) so users have maximum navigation options. Surfaces are served from @chirag127/astro-chrome package — identical across every app. Header keeps very few buttons (it's narrow); the bulk of navigation lives in Footer + Sidebar + BottomBar. Reverses earlier minimal-header decision."
tags: [decision, navigation, design-system, package, family-wide, mobile-first]
timestamp: 2026-06-22
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/single-pricing-page-package.md
  - rules/design-divergence-vs-dedup
  - rules/confirm-knowledge-deltas
---

# All 4 navigation surfaces on every app

## Decision

Every app in the oriz family ships ALL FOUR navigation surfaces. No app is allowed to drop any of them. The set:

1. **Header** (top of page) — narrow, very few buttons. Wordmark + login chip + 2-3 critical links only.
2. **Footer** (bottom of page, end of content) — mega-sitemap. Every app, every book, every package, support, newsletter.
3. **Sidebar** (left or right, collapsible) — per-app nav (sections, chapters, tools). On mobile: hidden under hamburger drawer.
4. **BottomBar** (bottom-fixed, mobile-only) — primary actions for the current app (4-5 icons). Hidden on desktop.

User mandate: "It doesn't matter just to include everything into every website. The header will be including only few buttons."

## Why

Maximum navigation paths. Users can reach every surface from any page via any of the 4 surfaces. Different users prefer different navigation styles (top-nav, sidebar, mobile tab-bar) — give them all.

## Architecture

All 4 surfaces shipped from `@chirag127/astro-chrome` (bump to v0.1.4):
- `./Header.astro` — already exists at v0.1.3, will be narrowed in v0.1.4
- `./Footer.astro` — already exists at v0.1.3, stays as mega-sitemap
- `./Sidebar.astro` — NEW in v0.1.4. Slot-driven (each app fills its own nav tree)
- `./BottomBar.astro` — NEW in v0.1.4. Props-driven (apps pass `actions=[{icon, label, href}]`)
- `./Layout.astro` — NEW wrapper that composes all 4 + main content area

Apps mount `<Layout>` once in `BaseLayout.astro` and pass slot content for sidebar + bottombar.

## Responsive behaviour

| Surface | Mobile (<768px) | Tablet (768-1024px) | Desktop (>1024px) |
|---|---|---|---|
| Header | 56px sticky, hamburger button | 60px sticky, mini nav | 60px sticky, full nav |
| Footer | Stacked single col | 2 col | 4 col mega-sitemap |
| Sidebar | Hidden, opens via hamburger | Hidden by default, expandable | Visible 240px wide |
| BottomBar | Visible 56px fixed-bottom | Hidden | Hidden |

## Apps with reduced chrome

None. Even `oriz-cs-me-app` and `oriz-janaushdhi-app` (no ads) get all 4 surfaces.

## Cross-refs

- Single pricing page package → [[decisions/architecture/single-pricing-page-package]]
- Design divergence rule (NOT applicable here — chrome is family-wide consolidated, per-app divergence is for in-content design) → [[rules/design-divergence-vs-dedup]]
- Confirmed via knowledge-delta rule in 2026-06-22 conversation → [[rules/confirm-knowledge-deltas]]
