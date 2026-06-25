---
type: service
title: "Pa11y"
description: "Dynamic a11y test runner — different ruleset from axe (HTML_CodeSniffer + axe). Free CLI in PR CI."
tags: [a11y, accessibility, pa11y, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: a11y-pa11y-rules
provider: pa11y
free_tier: "Unlimited — LGPL-3.0 OSS, no account required"
swap_cost: low
related:
  - services/a11y/axe-core
  - services/a11y/lighthouse-ci
  - decisions/architecture/a11y-three-tools
---

# Pa11y

## Role

Dynamic a11y test runner using the **HTML_CodeSniffer** (HTMLCS)
ruleset — different from axe's catalog. Catches a slightly different
set of WCAG violations; we run it alongside
[axe-core](./axe-core.md) and [Lighthouse CI](./lighthouse-ci.md)
as the [three-tool a11y stack](../../decisions/architecture/a11y-three-tools.md).

## Free tier

- Unlimited — LGPL-3.0 open-source CLI (`pa11y`)
- Pa11y CI variant for batch test runs in CI
- No account, no API key, no rate limit
- Headless Chromium under the hood — bundles via Puppeteer

## Card / subscription required?

**NO.** OSS — installed via `pnpm add -D pa11y-ci`.

## How CI consumes it

```yaml
- name: a11y (Pa11y)
  run: |
    npx pa11y-ci --config .pa11yci.json
```

```json
// .pa11yci.json
{
  "defaults": {
    "standard": "WCAG2AA",
    "runners": ["htmlcs", "axe"],
    "timeout": 30000
  },
  "urls": [
    "$PREVIEW_URL/",
    "$PREVIEW_URL/about",
    "$PREVIEW_URL/support"
  ]
}
```

Pa11y is configured to run **both** the HTMLCS and axe runners — so
it catches violations from both rulesets in a single tool.

## What it catches (vs axe alone)

- HTMLCS catches some visual / structural issues axe doesn't (e.g.
  text-only contrast in pseudo-elements, certain ARIA-required
  parent / child combos).
- Pa11y's CLI emits per-URL HTML reports useful for PR comments.
- Configurable per-URL action sequences (e.g. "click cookie banner
  first") — handles auth-walled pages that axe-via-Playwright would
  also handle but with different ergonomics.

## Alternatives

- [axe-core](./axe-core.md) — sibling, different default ruleset;
  we run both.
- [Lighthouse CI](./lighthouse-ci.md) — score-focused; we run all
  three.
- accessibility-checker (IBM) — alternative, smaller community.

## Swap cost

Low — Pa11y's config is portable. Dropping it and configuring
@axe-core/playwright with HTMLCS rules retains most coverage; the
visual rules are the gap.

## Why this is our pick

Different ruleset from axe-core means we catch issues neither would
on its own. CLI-driven, runs in the existing PR pipeline, free. The
three-tool stack (axe + Pa11y + Lighthouse CI) is locked in
[a11y-three-tools.md](../../decisions/architecture/a11y-three-tools.md).

## Cross-refs

- [a11y services index](./index.md)
- [axe-core — sibling tool](./axe-core.md)
- [Lighthouse CI — score + PR comments](./lighthouse-ci.md)
- [a11y three-tools decision](../../decisions/architecture/a11y-three-tools.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
