---
type: service
title: "MSW (Mock Service Worker)"
description: "In-process API mocking for browser + Node — SW in browser, interceptor in tests"
tags: [testing, api-mock, msw, in-process, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-api-mock
provider: msw
free_tier: "Unlimited — MIT OSS, no account, no quota, no service"
swap_cost: medium
related:
  - services/code/testing/mockoon
  - services/code/testing/vitest
  - services/code/testing/storybook
  - services/code/testing/playwright
  - decisions/architecture/api-mocks-msw-plus-mockoon
  - decisions/architecture/testing-three-layer
---

# MSW (Mock Service Worker)

## Role

The family's **in-process** API-mock tool. Used for the surfaces where
the code-under-test is the family's own JavaScript and the test wants
to intercept `fetch` / `XMLHttpRequest` calls without standing up a
separate HTTP server:

- [Vitest](./vitest.md) unit + integration tests (`setupServer()` from `msw/node`)
- [Storybook](./storybook.md) stories that need network responses (`setupWorker()` via Storybook MSW addon)
- `pnpm dev` opt-in mocking when developing offline / against deterministic fixtures
- Schema round-trip tests against the
  [JSONL canonical store](../../decisions/architecture/lifestream-jsonl-canonical.md) shape

Out-of-process E2E mocking against third-party APIs lives at
[Mockoon](./mockoon.md) — see
[api-mocks-msw-plus-mockoon](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)
for the surface split.

## Free tier

- Unlimited — MIT OSS via `msw`
- No account, no API key, no rate limit
- Service Worker (browser) + Node interceptor (tests) — single mental model
- Same handler shape across Vitest + Storybook + dev

## Card / subscription required?

**NO.** OSS — installed via `pnpm add -D msw` and
`pnpm exec msw init public/ --save` (browser worker scaffolding).

## How CI consumes it

```ts
// vitest.setup.ts
import { setupServer } from 'msw/node';
import { handlers } from '@chirag127/oriz-kit/testing/msw/handlers';

const server = setupServer(...handlers);
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }));
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

```ts
// .storybook/preview.ts
import { initialize, mswLoader } from 'msw-storybook-addon';
import { handlers } from '@chirag127/oriz-kit/testing/msw/handlers';

initialize();
export const parameters = { msw: { handlers } };
export const loaders = [mswLoader];
```

Shared handlers ship from
`@chirag127/oriz-kit/testing/msw/handlers.ts` covering the family's
internal upstreams (Hono RPC routes, Firebase REST, Razorpay sandbox
shape, etc.); per-site handlers in `tests/msw/handlers.ts` extend the
shared list.

## Alternatives

- [Mockoon](./mockoon.md) — sibling, picked alongside MSW for the
  out-of-process E2E surface, NOT a competitor.
- nock — Node-only; can't reach Storybook stories.
- json-server — generic REST mock; lacks request-matcher expressiveness.
- whatwg-fetch + hand-rolled stubs — what MSW replaces; loses
  cross-surface (Storybook + Vitest + dev) consistency.

## Swap cost

Medium — handler syntax is MSW-specific (`http.get('/api/foo', ...)`).
A swap would re-write `handlers.ts`. The CI plumbing + test wiring is
small.

## Why this is our pick

Same handlers run in three places (Vitest tests, Storybook stories,
`pnpm dev` browser) without rewrites. Free, OSS, MIT, no service to
manage. The Service Worker model means the app code-under-test never
knows it's mocked — same `fetch` calls, same response shapes, same
error paths.

## Cross-refs

- [testing services index](./index.md)
- [Mockoon — sibling out-of-process tool](./mockoon.md)
- [Vitest — primary consumer](./vitest.md)
- [Storybook — primary consumer](./storybook.md)
- [Playwright — uses `page.route()` instead of MSW for E2E browser intercepts](./playwright.md)
- [API mocks split decision](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
