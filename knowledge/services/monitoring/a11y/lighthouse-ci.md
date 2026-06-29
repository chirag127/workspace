---
type: service
title: "Lighthouse CI"
description: "Lighthouse score + a11y + perf budgets enforced per PR via free GitHub App"
tags: [a11y, accessibility, lighthouse, ci, perf, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: a11y-lighthouse-score
provider: google
free_tier: "Unlimited — Apache-2.0 OSS GitHub Action; free hosted Lighthouse CI Server (or self-hosted)"
swap_cost: low
related:
  - services/monitoring/a11y/axe-core
  - services/monitoring/a11y/pa11y
  - services/monitoring/monitoring/perf/vercel-speed-insights
  - decisions/architecture/a11y-three-tools
  - decisions/architecture/perf-monitoring-vercel-speed-insights
---

# Lighthouse CI

## Role

Lab-grade scoring tool — runs Google Lighthouse on the PR preview
URL and reports the four pillars: **Accessibility**, **Performance**,
**Best Practices**, **SEO**. Posted as a comment on every PR. Sits
alongside [axe-core](./axe-core.md) and [Pa11y](./pa11y.md) as the
[three-tool a11y stack](../../decisions/architecture/a11y-three-tools.md);
its perf score also complements [Vercel Speed Insights RUM](../perf/vercel-speed-insights.md)
(lab vs real-user).

## Free tier

- Unlimited — Apache-2.0 OSS (`@lhci/cli`,
  `treosh/lighthouse-ci-action` for GitHub Actions)
- Hosted Lighthouse CI Server is free + self-hostable
- No account, no rate limit on the action itself

## Card / subscription required?

**NO.** OSS, runs in the existing GitHub Actions runner.

## How CI consumes it

```yaml
- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v11
  with:
    urls: |
      ${{ env.PREVIEW_URL }}
      ${{ env.PREVIEW_URL }}/about
    uploadArtifacts: true
    temporaryPublicStorage: true
    configPath: ./lighthouserc.json
```

```json
// lighthouserc.json
{
  "ci": {
    "assert": {
      "assertions": {
        "categories:accessibility": ["error", { "minScore": 1.0 }],
        "categories:performance":   ["error", { "minScore": 0.9 }],
        "categories:best-practices":["error", { "minScore": 0.95 }],
        "categories:seo":           ["error", { "minScore": 1.0 }]
      }
    }
  }
}
```

A11y category is set to require **100** (`1.0`) — any violation
fails the PR.

## What it catches (beyond axe + Pa11y)

- Score-based view (a11y score, not just pass/fail)
- Perf budget enforcement (LCP, TBT, CLS in a lab environment)
- SEO baseline (meta description, robots, hreflang)
- Best-practices category — HTTPS, console errors, deprecated APIs,
  PWA icons

## Alternatives

- WebPageTest — broader, but free tier is rate-limited.
- Calibre — paid only.
- DebugBear — free 100 page audits/mo, similar function, paid past
  that.

## Swap cost

Low — Lighthouse is the underlying tool everyone runs. Dropping the
treosh action and running `@lhci/cli` directly is a one-line change.

## Why this is our pick

Free, OSS, posts the score directly as a PR comment so reviewers see
deltas at a glance. Rounds out the three-tool a11y stack with a
**score** view (axe + Pa11y give violations only). Its perf score
also gives us a lab snapshot per PR — Speed Insights gives the
real-user picture once shipped.

## Cross-refs

- [a11y services index](./index.md)
- [axe-core — sibling tool](./axe-core.md)
- [Pa11y — sibling tool](./pa11y.md)
- [Vercel Speed Insights — RUM, complementary perf signal](../perf/vercel-speed-insights.md)
- [a11y three-tools decision](../../decisions/architecture/a11y-three-tools.md)
- [Perf monitoring decision](../../decisions/architecture/perf-monitoring-vercel-speed-insights.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
