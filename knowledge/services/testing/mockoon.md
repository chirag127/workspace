---
type: service
title: "Mockoon"
description: "Out-of-process API mock — free OSS desktop app + headless CLI. Stands up a real HTTP server on localhost. Used for E2E tests against third-party APIs (Razorpay sandbox, Open-Meteo, Alpha Vantage when offline) and for manual dev mocking."
tags: [testing, api-mock, mockoon, out-of-process, e2e, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-api-mock-e2e
provider: mockoon
free_tier: "Unlimited — MIT OSS, free desktop app, free CLI, no account, no telemetry by default"
swap_cost: low
related:
  - services/testing/msw
  - services/testing/playwright
  - services/data-api/open-meteo
  - services/data-api/alpha-vantage
  - services/payment/razorpay
  - decisions/architecture/api-mocks-msw-plus-mockoon
  - decisions/architecture/testing-three-layer
  - decisions/architecture/data-apis-open-meteo-alpha-vantage
---

# Mockoon

## Role

The family's **out-of-process** API-mock tool. Used for the surfaces
where the code-under-test is the deployed Hono Worker (or a local
`wrangler dev`) hitting a third-party API the family doesn't own —
the test points the Worker at `http://localhost:3001` and Mockoon
serves the third-party shape on that port:

- E2E ([Playwright](./playwright.md)) suites against
  [Razorpay sandbox](../payment/razorpay.md)
- Offline / quota-conscious testing against
  [Open-Meteo](../data-api/open-meteo.md) and
  [Alpha Vantage](../data-api/alpha-vantage.md) (per the
  [data-APIs decision](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md), Alpha Vantage's 25 req/day budget is the family's tightest cap — burning it from CI is wasteful)
- Manual exploratory dev when an upstream is rate-limited / down

In-process unit / Storybook mocking lives at [MSW](./msw.md) — see
[api-mocks-msw-plus-mockoon](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)
for the surface split.

## Free tier

- Unlimited — MIT OSS
- Desktop app for Windows / macOS / Linux (Electron — but only for the
  GUI; the actual mock server is plain Node)
- Headless CLI (`@mockoon/cli`) for CI usage — no GUI required
- No account, no telemetry by default, no quota

## Card / subscription required?

**NO.** OSS, distributed via the Mockoon site + `npm i -g @mockoon/cli`.

## How CI consumes it

```yaml
- name: Install Mockoon CLI
  run: pnpm add -D @mockoon/cli

- name: Start Mockoon (Razorpay sandbox shape)
  run: |
    pnpm exec mockoon-cli start \
      --data tests/mockoon/razorpay.json \
      --port 3001 \
      --daemon-off &
    sleep 2

- name: E2E against mocked Razorpay
  run: pnpm playwright test
  env:
    BASE_URL_RAZORPAY: http://localhost:3001
    PREVIEW_URL: ${{ steps.deploy-preview.outputs.url }}
```

Mockoon environment files (JSON) ship from
`@chirag127/oriz-kit/testing/mockoon/` — one per third-party shape
(`razorpay.json`, `open-meteo.json`, `alpha-vantage.json`). They're
version-controlled alongside the rest of the test scaffolding.

## Manual dev usage

```bash
# Launch the GUI for exploratory work:
mockoon-cli start --data ~/.config/mockoon/razorpay.json --port 3001
# Or open the GUI app, load the environment, hit "Start"
# Then point your local Worker at it:
echo 'BASE_URL_RAZORPAY=http://localhost:3001' >> .env
pnpm dev
```

## Alternatives

- [MSW](./msw.md) — sibling, picked alongside Mockoon for in-process
  surfaces, NOT a competitor.
- WireMock — JVM-based; install + JVM dependency overhead too heavy
  for the family's all-Node toolchain.
- json-server — too thin; doesn't model error paths / latency / state
  transitions the way Mockoon does.
- Postman Mock Server — paid past trial; fights
  [`rules/no-card-on-file.md`](../../rules/no-card-on-file.md).
- Beeceptor — paid past free tier; same.
- Mocky.io — paid past free tier; same.

## Swap cost

Low — Mockoon environments are a JSON dump of routes + responses.
A swap to WireMock / json-server would translate the JSON shape but
keep the test plumbing (CI step, `BASE_URL_*` env-var) intact.

## Why this is our pick

Free, OSS, Node-based (no JVM), GUI for exploratory work AND CLI for
CI — same JSON definition either way. Importantly: the third-party
APIs the family hits (Razorpay, Open-Meteo, Alpha Vantage) all have
quota limits or sandbox throttles, and Mockoon's process model is the
right shape for the deployed Worker → upstream pattern that hits
those limits hardest.

## Cross-refs

- [testing services index](./index.md)
- [MSW — sibling in-process tool](./msw.md)
- [Playwright — primary consumer](./playwright.md)
- [Razorpay — primary mocked upstream](../payment/razorpay.md)
- [Open-Meteo — mocked when offline](../data-api/open-meteo.md)
- [Alpha Vantage — mocked to preserve 25 req/day](../data-api/alpha-vantage.md)
- [API mocks split decision](../../decisions/architecture/api-mocks-msw-plus-mockoon.md)
- [Data APIs decision](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
