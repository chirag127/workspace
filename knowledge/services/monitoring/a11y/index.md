---
type: index
title: "Accessibility (a11y) services"
description: "Three-tool a11y stack on every PR — axe-core (static rules) + Pa11y (dynamic, different ruleset) + Lighthouse CI (score + perf)."
tags: [services, a11y, accessibility, ci, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Accessibility (a11y) services

The family runs **all three** of the major a11y CI tools on every
PR. Each catches a slightly different category of issue; together
they form a defensive a11y net.

| Service | Status | One-line role |
|---|---|---|
| [axe-core.md](./axe-core.md) | active | Industry-standard static rule engine via `@axe-core/playwright` |
| [pa11y.md](./pa11y.md) | active | Dynamic runner with HTMLCS + axe rulesets |
| [lighthouse-ci.md](./lighthouse-ci.md) | active | Score + perf-budget enforcement, PR comment |

## Why all three?

- **axe-core** — static rule engine, the Deque catalog. Catches
  programmatic violations (missing labels, ARIA misuse, contrast).
  De-facto industry standard.
- **Pa11y** — dynamic runner with a different default ruleset
  (HTMLCS). Catches issues axe alone misses (some pseudo-element
  contrast cases, structural rules from a different rubric).
- **Lighthouse CI** — score-based view + perf budgets. Pillars
  (a11y, perf, best-practices, SEO) reported as a PR comment so
  reviewers see deltas at a glance.

PR fails on any new violation in **any** of the three tools. The
policy is locked in
[decisions/architecture/a11y-three-tools.md](../../decisions/architecture/a11y-three-tools.md).

## Cross-refs

- [a11y three-tools decision](../../decisions/architecture/a11y-three-tools.md)
- [Vercel Speed Insights — RUM, pairs with Lighthouse CI lab perf](../perf/vercel-speed-insights.md)
- [Code-quality stack decision](../../decisions/process/code-quality-stack.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
