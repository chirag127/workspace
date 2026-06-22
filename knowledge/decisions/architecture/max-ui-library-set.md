---
type: decision
title: "[SUPERSEDED 2026-06-22] Maximum UI library set — reversed for performance"
description: "Original 'use as many UI libraries as possible' decision. SUPERSEDED hours later on 2026-06-22 by performance concern. See [[decisions/architecture/minimal-ui-library-set]] for the current pick (shadcn + Radix + Lucide + Chart.js + Tailwind/View-Transitions/Motion-One/Anime.js)."
tags: [decision, ui, libraries, superseded]
timestamp: 2026-06-22
format_version: okf-v0.1
status: superseded
superseded_by: decisions/architecture/minimal-ui-library-set
superseded_on: 2026-06-22
related:
  - decisions/architecture/minimal-ui-library-set
---

# [SUPERSEDED 2026-06-22] Maximum UI library set

Reversed within hours. See [[decisions/architecture/minimal-ui-library-set]] for current pick.

Kept for audit trail per [[rules/keep-knowledge-fresh]].

# Maximum UI library set (2026-06-22)

## Decision

Family-wide UI tooling: use as many MIT/Apache-2.0 libraries as fit, pick the best for each component type. User mandate: "use as many as possible — more libraries = more polish."

## Components

| Library | License | Role |
|---|---|---|
| **`@chirag127/astro-chrome`** | MIT (ours) | Family chrome: Footer (consolidated), Sidebar/BottomBar shells (consolidated), embed components |
| **shadcn/ui** | MIT | Copy-paste primitives (Button, Card, Dialog, Form, Input, Select, Tabs, Toast). Per-app vendored. |
| **Radix UI primitives** | MIT | Headless behavior (Dropdown, Popover, Accordion, Tooltip, Toast). Powers shadcn underneath. |
| **Headless UI (Tailwind Labs)** | MIT | Lighter alternative for Combobox, Listbox, Disclosure. |
| **Park UI + Ark UI** | MIT | Framework-agnostic; use for components Radix doesn't have (Editable, Pin Input, Steps, Tags Input). |

Selection rule: for a given component need, prefer in order: astro-chrome → shadcn → Radix → Headless → Park/Ark → custom.

## Icons

**Iconify aggregator** — one engine, many sets:
- **Lucide** (default, 1,500+ icons)
- **Tabler** (4,800+ icons)
- **Phosphor** (1,400+ icons, multi-weight)
- **Material Symbols** (3,000+ Google icons)
- **Heroicons** (Tailwind's, 300+ icons)
- **Simple Icons** (3,200+ brand logos for tools/social)

Astro integration: `astro-icon` + `@iconify/json`. Tree-shaken per-page; only used icons ship.

## Charts

**Apache ECharts** — Apache-2.0, broadest feature set (line, area, bar, candlestick, heatmap, treemap, sankey, sunburst, gauge, radar, geo, parallel, polar, calendar, custom). Used by:
- janaushdhi price-history graphs
- paisa-finance FII/DII candlesticks
- backup-status dashboard
- family-wide-stats dashboard

Stack: `echarts` + `astro-echarts` wrapper (or custom thin component in `@chirag127/astro-widgets`).

## Animation

Adopted ALL family-friendly libraries (each handles a different scope):

| Library | License | Scope |
|---|---|---|
| **Tailwind transitions** | MIT | Class-based simple transitions (hover, focus, group-hover) |
| **Astro View Transitions** | MIT | Native page-to-page animation (built-in) |
| **Motion One** | MIT | Light WAAPI wrapper; replaces Framer Motion for complex motion |
| **Anime.js** | MIT | Timeline-based; complex multi-property sequences |

**Rejected:** GSAP (commercial-use license required → card-on-file → violates `no-card-on-file`).

## Forms

- **React Hook Form** + **Zod** (already in `@chirag127/astro-forms`)
- **Conform.dev** for progressive enhancement when RHF isn't appropriate.

## Modals + toasts

- **Sonner** (toast notifications, MIT) — already common with shadcn.
- **Vaul** (mobile sheet/drawer, MIT) — bottom-sheet for mobile.

## Tables

- **TanStack Table** (headless, MIT, paired with shadcn DataTable recipe).

## Date/time

- **date-fns** (modular MIT) — preferred over Day.js.
- **Temporal polyfill** for newer apps targeting Node 24+.

## Drag-and-drop (where needed)

- **dnd-kit** (MIT, accessible) — for roam-journal entries, tabs-cards collections.

## Why "more libraries"

Each library is best-of-breed in its narrow scope. Combining them gives every component the most-polished implementation without writing it ourselves. Tree-shaking + Astro's per-route island hydration means we don't pay for unused libraries.

Per [[rules/no-card-on-file]] all picks are MIT/Apache-2.0 + free + no payment required.

## Cross-refs

- 4-nav-surfaces decision → [[decisions/architecture/four-nav-surfaces-every-app]]
- Stack picks → [[decisions/architecture/stack-picks-2026-06-22]]
- No card on file → [[rules/no-card-on-file]]
