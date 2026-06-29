---
type: service
title: "Playwright"
description: "Cross-browser E2E test runner — Chromium + WebKit + Firefox, free OSS"
tags: [testing, e2e, playwright, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-e2e
provider: microsoft
free_tier: "Unlimited — Apache-2.0 OSS, signed binaries (works under Defender ASR), no account"
swap_cost: medium
related:
  - services/code/testing/vitest
  - services/code/testing/storybook
  - services/code/testing/chromatic
  - services/monitoring/a11y/axe-core
  - services/monitoring/a11y/pa11y
  - decisions/architecture/testing-three-layer
  - decisions/architecture/a11y-three-tools
---

# Playwright

## Role

The family's **E2E + cross-browser** test runner. Drives Chromium,
WebKit, and Firefox against the per-PR Cloudflare Pages preview
URL, exercising real browser behaviour (focus, keyboard nav,
scroll, clipboard, file pickers). Also the substrate that the
[a11y axe-core suite](../a11y/axe-core.md) rides on — same
install, same browser context, two reporters.

## Free tier

- Unlimited — Apache-2.0 OSS via `@playwright/test`
- All three browsers bundled (Chromium, WebKit, Firefox)
- Trace viewer, video capture, screenshot diff included free
- Signed binaries — installs cleanly under Defender ASR (one
  reason this is the agent-browser-of-record on the family's
  Windows dev box)

## Card / subscription required?

**NO.** OSS — installed via `pnpm add -D @playwright/test` then
`pnpm exec playwright install --with-deps`.

## How CI consumes it

```yaml
- name: Install Playwright browsers
  run: pnpm exec playwright install --with-deps chromium webkit firefox
- name: E2E tests
  run: pnpm playwright test --reporter=html
  env:
    BASE_URL: ${{ env.PREVIEW_URL }}
- name: Upload trace
  if: failure()
  uses: actions/upload-artifact@v4
  with:
    name: playwright-trace
    path: test-results/
```

Test files live under `tests/e2e/` per site and per package. The
[axe-core](../a11y/axe-core.md) suite reuses the same browser
context — `tests/a11y/` files import `AxeBuilder` and run alongside
the E2E suite in the same job-graph step.

## Alternatives

- Cypress — single-browser focus historically; multi-browser is
  paid past the free tier.
- WebDriverIO — lower-level, more boilerplate.
- Selenium — outdated DX for the family's React-heavy surface.

## Swap cost

Medium — test file syntax is Playwright-specific; a swap would
re-write `tests/e2e/` and `tests/a11y/`. The CI job-graph and
preview-URL plumbing stay portable.

## Why this is our pick

Free, OSS, signed binaries, all three browsers in one install,
trace viewer for failure triage, and already paying for itself by
hosting the a11y axe-core run. Microsoft maintains it; community
breadth is comparable to Cypress without the multi-browser paid
upsell.

## Cross-refs

- [testing services index](./index.md)
- [Vitest — unit / integration sibling](./vitest.md)
- [Storybook — component sandbox sibling](./storybook.md)
- [Chromatic — visual regression sibling](./chromatic.md)
- [axe-core — rides on Playwright's browser context](../a11y/axe-core.md)
- [a11y three-tools decision](../../decisions/architecture/a11y-three-tools.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
