---
type: service
title: "Alpha Vantage"
description: "Free finance / market-data API. 25 requests/day + 5/minute on the free tier, no card required. API key needed (free signup). Locked as the family's market-data source for oriz-finance and any future stock / forex / crypto surface."
tags: [services, data-api, finance, stocks, forex, crypto, alpha-vantage, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: finance-api
provider: alpha-vantage
free_tier: "25 API requests/day, 5 requests/minute, free API key (email signup), covers stocks + forex + crypto + commodities + economic indicators + technical indicators"
swap_cost: medium
related:
  - decisions/architecture/data-apis-open-meteo-alpha-vantage
  - decisions/architecture/cf-worker-quota-mitigation
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Alpha Vantage

## Role

The family's locked **finance / market-data API**. Powers any
site that needs stock quotes, forex pairs, crypto prices,
commodity prices, economic indicators, or technical indicators.
Primary consumer is the in-flight `oriz-finance` site (forward
reference); future surfaces (any blog post embedding a live
ticker, any extension showing a market widget) reuse the same
account.

## Free tier

- **25 API requests / day** (rolling 24h)
- **5 API requests / minute** burst cap
- **Free API key**, email-only signup, no card
- All endpoint families on the free tier — TIME_SERIES_DAILY,
  GLOBAL_QUOTE, FX_DAILY, CRYPTO_INTRADAY, technical indicators
  (RSI, MACD, BBANDS, etc.), fundamentals (earnings, balance
  sheet), economic indicators (CPI, GDP, unemployment).

## Card / subscription required?

**NO.** Free-tier signup at
`https://www.alphavantage.co/support/#api-key` is email-only.
The API key arrives in the inbox; no payment method requested.
Card-on-file is required only for the paid premium tiers, which
the family does not use per
[no-card-on-file](../../rules/interaction/no-card-on-file.md).

## Quota mitigation — aggressive caching

25 requests/day is the **tightest free-tier envelope** in the
data-api/ subdir. Every call goes through the umbrella Hono
Worker per
[data-apis-open-meteo-alpha-vantage](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md)
with a [Workers KV](../compute/cloudflare-workers.md) cache and
**1-day TTL on EOD market data** (per the
[CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
step #7). For hot tickers (top-50 by family-wide view count),
the cron-driven warm-cache job pre-populates KV at 18:00 UTC
after US market close — burning ~10–15 of the 25 daily requests
on a deterministic schedule, leaving headroom for ad-hoc lookups.

Use shape:

```ts
// In the umbrella Worker — never call Alpha Vantage from the browser
const r = await fetch(
  'https://www.alphavantage.co/query?' +
  new URLSearchParams({
    function: 'GLOBAL_QUOTE',
    symbol: 'IBM',
    apikey: env.ALPHA_VANTAGE_KEY,
  }),
);
```

API key originates in [Doppler](../secrets/doppler.md), mirrored
to the Worker via `wrangler secret put` (per
[secrets-management-doppler](../../decisions/security/secrets-management-doppler.md)).
Never embed the key in client code — would burn the family's
single key in minutes.

## Why this is our pick

- **No card** required at signup or quota-exhaustion — the
  request fails-closed at 25/day, no surprise bill.
- **Coverage breadth** — stocks + forex + crypto + commodities
  + macro indicators + technical indicators on one key. Beats
  IEX Cloud (US-stocks-only on free), Twelve Data (8 calls/min
  on free), and Finnhub (60 calls/min but card required after
  trial).
- **Stable JSON shape** — well-documented endpoint families,
  consistent date formatting, predictable error envelopes.

## Alternatives

- **Twelve Data** — 800 requests/day free, 8 req/min. Higher
  daily cap but card prompted for any plan upgrade; rejected on
  signup-friction grounds.
- **Finnhub** — 60 req/min free, requires card past trial.
  Rejected on [no-card-on-file](../../rules/interaction/no-card-on-file.md).
- **IEX Cloud** — discontinued free tier in 2024; out.
- **Yahoo Finance unofficial** (`query2.finance.yahoo.com`) —
  no key, no card, but no SLA, frequent rate-limit changes,
  unstable schema. Documented as **emergency fallback** when
  Alpha Vantage hits its 25/day cap mid-day.
- **Polygon.io** — 5 req/min free, US stocks only, card past
  free. Rejected on coverage + card grounds.

## Swap cost

Medium — endpoint shape and parameter naming differ across
providers; the umbrella Worker keeps a per-provider adapter
(`adapters/alpha-vantage.ts`, `adapters/twelve-data.ts`) so the
swap is a one-line `provider:` flip in the route handler. The
client-facing JSON envelope returned to the browser stays
constant.

## Cross-refs

- [Data APIs index](./index.md)
- [Open-Meteo — weather API counterpart](./open-meteo.md)
- [Data APIs decision (Open-Meteo + Alpha Vantage)](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md)
- [CF Worker quota mitigation playbook — KV caching](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [Doppler — API key vault](../secrets/doppler.md)
- [Secrets management decision](../../decisions/security/secrets-management-doppler.md)
- [Workers KV — 1-day TTL EOD cache](../compute/cloudflare-workers.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
