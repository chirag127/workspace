---
type: decision
title: "Minimal UI library set (PERFORMANCE-FIRST, supersedes 'max libraries' decision from same day)"
description: "Performance-first UI library set. Supersedes the earlier 'maximum libraries' decision (same day, 2026-06-22) after user reconsidered. Final picks: shadcn/ui + Radix primitives (single ecosystem; shadcn vendored as copy-paste, Radix as runtime). Icons: Lucide only via astro-icon (tree-shaken). Charts: Chart.js (95 KB gzip vs ECharts 300 KB). Animation: Tailwind transitions + Astro View Transitions + Motion One + Anime.js (user wanted full set despite perf hit; Motion One 6 KB + Anime.js 10 KB = acceptable). No Park UI, no Headless UI, no Iconify multi-set, no ECharts. Tree-shaking + Astro per-route islands keep bundle minimal."
tags: [decision, ui, libraries, performance, shadcn, radix, lucide, chartjs, supersedes]
timestamp: 2026-06-22
format_version: okf-v0.1
status: active
supersedes: decisions/architecture/max-ui-library-set
related:
  - decisions/architecture/four-nav-surfaces-every-app
  - decisions/architecture/stack-picks-2026-06-22
  - architecture/the-18-packages
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Minimal UI library set — performance over polish

## Decision

User reconsidered "max libraries" picks the same day and locked PERFORMANCE-FIRST defaults:

| Surface | Pick | Bundle | License | Why |
|---|---|---|---|---|
| **Components** | `@chirag127/astro-chrome` + **shadcn/ui** + **Radix primitives** | shadcn is copy-paste (vendored, zero runtime). Radix tree-shakable. | MIT | One ecosystem (shadcn ships Radix). No fragmentation. |
| **Icons** | **Lucide** via `astro-icon` (single set) | Tree-shaken; only used icons ship | ISC | Smallest viable lib. 1,500+ icons covers everything. |
| **Charts** | **Chart.js** | ~95 KB gzip | MIT | Light, modular, covers janaushdhi / paisa / stats. ECharts (300 KB) deferred to v1 if needed. |
| **Animation** | Tailwind transitions + Astro View Transitions + **Motion One** (6 KB) + **Anime.js** (10 KB) | ~16 KB combined | MIT | User wanted full set; bundle stays under 20 KB. |
| **Forms** | React Hook Form + Zod | RHF ~10 KB | MIT | Already in `astro-forms`. |
| **Toasts** | Sonner | ~5 KB | MIT | shadcn-compatible. |
| **Mobile sheets** | Vaul | ~7 KB | MIT | Used for BottomBar drawer. |
| **Tables** | TanStack Table | tree-shaken | MIT | Used in janaushdhi price table + family-stats. |
| **Date/time** | date-fns | modular | MIT | Tree-shaken per function. |
| **DnD** | dnd-kit (where needed) | lazy-loaded | MIT | Only roam-journal + tabs-cards load it. |

## What was rejected (vs the earlier "max libraries" decision)

| Library | Why dropped |
|---|---|
| **Headless UI (Tailwind Labs)** | Overlaps with Radix; one or the other suffices. |
| **Park UI + Ark UI** | Different ecosystem from shadcn/Radix; would fragment styles. |
| **Iconify multi-set (Tabler / Phosphor / Material / Heroicons / Simple Icons)** | Larger bundle. Lucide alone covers needs. Add specific sets in v1 if a real icon-gap emerges. |
| **Apache ECharts** | 300 KB gzip vs Chart.js 95 KB. Deferred to v1 for advanced visualizations only. |
| **Visx** | Adds D3 (large dep). Defer. |
| **Conform.dev** | RHF + Zod is enough for v0. |
| **GSAP** | Commercial license; card required. |

## Bundle budget per page (v0 target)

- Critical CSS + JS: < 50 KB gzip
- Non-critical JS (lazy-loaded islands): < 200 KB gzip per page
- Total page weight: < 500 KB gzip first paint

Pa11y CI + Lighthouse perf ≥90 enforced in CI.

## When to revisit

If during build of paisa-finance or stats-dashboard a Chart.js chart type proves missing, upgrade to ECharts (single app only, lazy-loaded). Don't roll out family-wide.

If users report icon gaps, add specific Iconify sets via `astro-icon`'s collection feature (still tree-shaken).

## Supersedes

`decisions/architecture/max-ui-library-set.md` — locked the SAME day, reversed within hours. Both files kept (max-libraries with status: superseded; this one active). Audit-trail per `keep-knowledge-fresh`.

## Cross-refs

- The reversed earlier decision → [[decisions/architecture/max-ui-library-set]]
- 4-nav surfaces → [[decisions/architecture/four-nav-surfaces-every-app]]
- Stack picks → [[decisions/architecture/stack-picks-2026-06-22]]
- Never hit quotas → [[rules/never-hit-quotas]]
