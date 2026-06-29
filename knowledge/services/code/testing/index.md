---
type: index
title: "Testing services"
description: "Three-layer testing stack — Vitest (unit) + Playwright (E2E) + Storybook+Chromatic (visual regression). API mocks via MSW (in-process) + Mockoon (out-of-process). All free, no card."
tags: [services, testing, vitest, playwright, storybook, chromatic, msw, mockoon, ci, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Testing services

The family runs a **three-layer testing stack** on every PR. Each
layer answers a different question; together they form a
defensive net comparable to the
[three-tool a11y stack](../../decisions/architecture/a11y-three-tools.md).

- **Unit / integration** — [Vitest](./vitest.md). Vite-native runner;
  every Astro / React site is already on Vite, so the runner
  shares the dev config.
- **End-to-end** — [Playwright](./playwright.md). Cross-browser
  (Chromium + WebKit + Firefox) automation. Already the substrate
  the [a11y axe-core suite](../a11y/axe-core.md) rides on.
- **Component sandbox** — [Storybook](./storybook.md). Renders every
  oriz-kit + per-site component in isolation. Ships in CI as the
  source for the visual snapshots.
- **Visual regression** — [Chromatic](./chromatic.md). Diffs
  Storybook snapshots against the baseline; PR fails on undeclared
  visual change. Free 5K snapshots/mo.

API mocks split by surface (locked 2026-06-20 —
[api-mocks-msw-plus-mockoon](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)):

- **In-process mocks** — [MSW](./msw.md). Service Worker in browser;
  Node interceptor in tests. Used for Vitest unit suites, Storybook
  stories, and `pnpm dev` deterministic mocking.
- **Out-of-process mocks** — [Mockoon](./mockoon.md). Free OSS desktop
  app + headless CLI. Used for E2E tests against third-party APIs
  the family doesn't own (Razorpay sandbox, Open-Meteo, Alpha Vantage)
  and for manual exploratory dev.

| Service | Status | One-line role |
|---|---|---|
| [vitest.md](./vitest.md) | active | Unit + integration runner — Vite-native, free OSS |
| [playwright.md](./playwright.md) | active | E2E + cross-browser automation — also runs the a11y axe-core suite |
| [storybook.md](./storybook.md) | active | Component sandbox — feeds Chromatic snapshots, also doubles as visual docs |
| [chromatic.md](./chromatic.md) | active | Visual regression diff against Storybook — 5K snapshots/mo free |
| [msw.md](./msw.md) | active | In-process API mocks — Vitest + Storybook + dev (Service Worker / Node interceptor) |
| [mockoon.md](./mockoon.md) | active | Out-of-process API mocks — E2E + manual dev against third-party APIs (Razorpay sandbox, data APIs offline) |

## Why all three (four)?

- **Vitest** — fast, in-memory unit tests; runs against Vite's
  module graph so dev + test config stays one file.
- **Playwright** — flushes out browser-only bugs (focus, scroll,
  keyboard nav) that JSDOM-based runners miss. Already required by
  the a11y trio so the install cost is amortised.
- **Storybook** — codifies component state as canonical stories;
  the visual diffs feed Chromatic and the component docs feed
  reviewers + future contributors.
- **Chromatic** — catches "this CSS change broke an unrelated
  component" diffs that no functional test would. The 5K
  snapshots/mo free tier covers the family's surface area.

PR fails on any failure in any layer. The policy is locked in
[decisions/architecture/testing-three-layer.md](../../decisions/architecture/testing-three-layer.md).

## Why two API-mock tools?

Different surfaces, different process models — same posture as the
[AI split](../../decisions/architecture/ai-puter-plus-cf-workers-ai.md):

- **MSW for in-process** — when the code-under-test is the family's
  own JS, MSW intercepts inside the same process. Handlers live in
  TypeScript, run identically in Vitest + Storybook + dev.
- **Mockoon for out-of-process** — when the code-under-test is the
  deployed Hono Worker hitting a third-party upstream, Mockoon stands
  up a real HTTP server on `localhost:3001` and the Worker's
  `BASE_URL_*` env-var points at it. Used for Razorpay sandbox / data
  APIs in CI to preserve quotas + survive offline dev.

Both free, both OSS. Locked in
[api-mocks-msw-plus-mockoon](../../decisions/architecture/api-mocks-msw-plus-mockoon.md).

## Cross-refs

- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [API mocks split decision](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)
- [a11y three-tools decision — rides on Playwright](../../decisions/architecture/a11y-three-tools.md)
- [a11y services index](../a11y/index.md)
- [Code-quality stack decision](../../decisions/process/code-quality-stack.md)
- [Per-repo CI workflows decision](../../decisions/process/per-repo-ci-workflows.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
