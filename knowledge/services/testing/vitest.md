---
type: service
title: "Vitest"
description: "Vite-native unit + integration test runner. Free, OSS, fast in-memory. Already on Vite via Astro — no extra config."
tags: [testing, unit, vitest, vite, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-unit
provider: vitest
free_tier: "Unlimited — MIT OSS, no account, no quota, no service"
swap_cost: low
related:
  - services/testing/playwright
  - services/testing/storybook
  - services/testing/chromatic
  - decisions/architecture/testing-three-layer
---

# Vitest

## Role

The family's **unit + integration** test runner. Every Astro / React
package or site already runs on Vite, so Vitest shares the dev
config (path aliases, plugins, env loading) without a parallel
`jest.config.ts`. Used for:

- Pure-function tests in `@chirag127/oriz-kit` and the other
  [5 oriz-ui packages](../../decisions/architecture/oriz-ui-split-into-5-packages.md)
- React component logic with `@testing-library/react` (browser
  behaviour goes through [Playwright](./playwright.md), not JSDOM)
- Hono Worker handler tests using `@hono/vite-test-utils`
- Schema + zod validator round-trips against fixture JSONL from the
  [lifestream canonical store](../../decisions/architecture/lifestream-jsonl-canonical.md)

## Free tier

- Unlimited — MIT OSS via `vitest`
- No account, no API key, no rate limit
- Watch mode + UI dashboard included free
- Native ESM, native TypeScript, no Babel

## Card / subscription required?

**NO.** OSS — installed via `pnpm add -D vitest @vitest/ui`.

## How CI consumes it

```yaml
- name: Unit tests
  run: pnpm vitest run --reporter=verbose --coverage
```

Coverage uploads to [Sonarcloud](../code-quality/sonarcloud.md) via
its `coverage/lcov.info` artefact — same wiring the
[code-quality stack](../../decisions/process/code-quality-stack.md)
already expects.

## Alternatives

- Jest — slower on Vite-native projects; requires duplicate config.
- Node `node:test` — usable but no React / DOM helpers; rejected
  for the family's React-heavy surface.
- uvu / tape — too minimal for component-shaped suites.

## Swap cost

Low — Vitest's API is Jest-compatible (`describe` / `it` / `expect`).
A swap to Jest would be mechanical for the test files; the cost is
re-introducing a parallel config tree.

## Why this is our pick

Same engine as the dev server (Vite), so reload loops are fast,
config is unified, and ESM-only packages just work. Free, OSS,
unlimited. Pairs with Playwright for E2E +
Storybook/Chromatic for visual regression — the
[three-layer testing stack](../../decisions/architecture/testing-three-layer.md).

## Cross-refs

- [testing services index](./index.md)
- [Playwright — E2E sibling](./playwright.md)
- [Storybook — component sandbox sibling](./storybook.md)
- [Chromatic — visual regression sibling](./chromatic.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [Code-quality stack decision](../../decisions/process/code-quality-stack.md)
- [Sonarcloud — coverage upload target](../code-quality/sonarcloud.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
