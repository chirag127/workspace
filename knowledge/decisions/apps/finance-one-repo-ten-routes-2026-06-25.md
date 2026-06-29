---
type: decision
title: Finance — one repo, ten routes at finance.oriz.in
description: 10 finance calculators into single repo. Shared @oriz/finance package
tags:
- decision
- apps
- finance
- consolidation
- routing
- repo-shape
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
- decisions/apps/fleet-strategy-build-gate-2026-06-25
- branding/subdomain-path-based-on-category-2026-06-25
- decisions/packages/five-shared-npm-packages-2026-06-25
- decisions/frontend/framework-astro-react-tailwind-shadcn-2026-06-25
---

# Finance — one repo, ten routes

## Decision

One repo (`finance`, on GitHub at `oriz-org/finance`, deployed to `finance.oriz.in`) serves all ten finance calculators as routes:

| Route | Tool |
|---|---|
| `/emi` | EMI / loan calculator |
| `/sip` | SIP returns |
| `/tax-80c` | Section 80C tax savings |
| `/hra` | HRA exemption |
| `/ppf` | PPF maturity |
| `/nps` | NPS corpus |
| `/retirement` | Retirement corpus + drawdown |
| `/gst` | GST inclusive/exclusive |
| `/fd` | Fixed deposit maturity |
| `/lumpsum` | Lumpsum returns |

Math primitives live in the `@oriz/finance` shared npm package. Reverses the earlier "one repo per calculator" split.

## Why

- **Shared chrome and primitives** — header, footer, account widget, theme toggle, currency formatter, INR locale handling all reused across ten routes for free.
- **SEO compounds** — internal links between calculators (e.g. EMI page links to FD and lumpsum) build authority for `finance.oriz.in` as a destination.
- **One deploy workflow, one CF Pages project** instead of ten.
- **Maintenance ratio** — a dependency bump touches one repo, not ten.
- **Aligned with category subdomain routing** (subdomain-path-based-on-category-2026-06-25).
- **`@oriz/finance` package** isolates the math so the same primitives can power a CLI or an MCP server later without re-implementing.

## Implications

- The ten reserved per-calculator repos either get archived (saturated case) or merged into `finance`. Slug squat: keep their names on the org as redirects until any inbound links die.
- Internal navigation across the ten routes is built once in `finance` — sidebar links between siblings, footer cross-links.
- Per-tool SEO content (300-500 words each) lives at the route level, not as a separate repo.
- Tests, lint, and CI run once over the consolidated repo.
- Same pattern is the template for any future category (e.g. text utilities, dev tools): one repo, many routes, shared package for primitives.
