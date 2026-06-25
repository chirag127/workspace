---
type: service
title: "axe-core"
description: "Industry-standard a11y rule engine, run via @axe-core/playwright in CI. Static-rule WCAG checks on every PR. Free, OSS."
tags: [a11y, accessibility, axe, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: a11y-axe-rules
provider: deque
free_tier: "Unlimited — MPL-2.0 OSS, no account required"
swap_cost: medium
related:
  - services/a11y/pa11y
  - services/a11y/lighthouse-ci
  - decisions/architecture/a11y-three-tools
---

# axe-core

## Role

Static-rule a11y engine — runs Deque's WCAG 2.1 / 2.2 ruleset
against rendered pages and emits violations. The family runs
`@axe-core/playwright` in every site's PR CI as one of the
[three a11y tools](../../decisions/architecture/a11y-three-tools.md);
PR fails on any new violation.

## Free tier

- Unlimited — MPL-2.0 open-source npm package
- No account, no API key, no rate limit
- Bundles the Deque rule catalog locally; no network call at run
  time

## Card / subscription required?

**NO.** OSS — installed via `pnpm add -D @axe-core/playwright`.

## How CI consumes it

```ts
// tests/a11y.spec.ts
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('a11y (axe)', () => {
  for (const path of ['/', '/about', '/support']) {
    test(`no violations on ${path}`, async ({ page }) => {
      await page.goto(path);
      const results = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
        .analyze();
      expect(results.violations).toEqual([]);
    });
  }
});
```

Runs alongside the [Pa11y](./pa11y.md) and
[Lighthouse CI](./lighthouse-ci.md) jobs in the same PR.

## What it catches

- Missing labels (`<input>`, `<button>`, `<a>` without text)
- Insufficient color contrast (4.5:1 for body, 3:1 for large text)
- Missing landmarks
- Non-unique IDs
- Missing alt text
- ARIA misuse
- Heading hierarchy violations

## Alternatives

- [Pa11y](./pa11y.md) — different ruleset (HTML_CodeSniffer or axe);
  we run alongside, not instead.
- [Lighthouse CI](./lighthouse-ci.md) — also includes axe rules but
  scoring-focused; we run alongside.
- WAVE API — paid past free tier.
- accessibility-checker (IBM) — alternative ruleset, smaller
  community.

## Swap cost

Medium — axe is the de-facto a11y rule engine; Pa11y can run axe as
its backend, so dropping `@axe-core/playwright` and pointing Pa11y
at axe-runner keeps coverage. Test files would need rewriting.

## Why this is our pick

The industry-standard ruleset — Deque maintains it, Microsoft and
Google contribute. Playwright integration runs in the existing
browser context (no extra infrastructure). Free, OSS, unlimited.
Pairs with Pa11y (different ruleset) and Lighthouse CI (scoring) for
[three-tool a11y coverage](../../decisions/architecture/a11y-three-tools.md).

## Cross-refs

- [a11y services index](./index.md)
- [Pa11y — sibling tool, different ruleset](./pa11y.md)
- [Lighthouse CI — score + perf in PR comments](./lighthouse-ci.md)
- [a11y three-tools decision](../../decisions/architecture/a11y-three-tools.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
