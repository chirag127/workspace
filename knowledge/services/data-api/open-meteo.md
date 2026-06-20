---
type: service
title: "Open-Meteo"
description: "Free unlimited weather API. No auth, no API key, no card. Documented as the family's locked weather data source for any future site that needs forecast / current-conditions / historical weather."
tags: [services, data-api, weather, open-meteo, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: weather-api
provider: open-meteo
free_tier: "Unlimited non-commercial use, no auth, no API key, ~10,000 requests/day soft cap; commercial requires paid plan"
swap_cost: low
related:
  - decisions/architecture/data-apis-open-meteo-alpha-vantage
  - decisions/architecture/cf-worker-quota-mitigation
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Open-Meteo

## Role

The family's locked **weather data source**. When any site needs
forecast / current-conditions / historical weather (none today —
locked as the approved choice for when the need lands), it calls
Open-Meteo. Picked over OpenWeatherMap, WeatherAPI, Tomorrow.io,
and Visual Crossing on free-tier generosity + no-auth + no-card
grounds.

## Free tier

- **Unlimited requests** for non-commercial use (soft cap
  ~10,000 requests/day before the operator nudges)
- **No API key, no auth header** — REST calls are anonymous
- **No card** at any point
- Forecast (up to 16 days ahead), current conditions, historical
  archive (1940 → present), marine, air quality, climate change
  scenarios, all on the same free envelope
- JSON responses, predictable schema, multi-model ensemble

## Card / subscription required?

**NO.** Anonymous public API. No sign-up, no API key, no
billing relationship. Pure HTTP `fetch()` against
`https://api.open-meteo.com/v1/forecast?...`.

## Use shape

```ts
const r = await fetch(
  'https://api.open-meteo.com/v1/forecast?' +
  new URLSearchParams({
    latitude: '12.97',
    longitude: '77.59',
    current: 'temperature_2m,weather_code',
    timezone: 'auto',
  }),
);
const { current } = await r.json();
```

Cache aggressively at the
[CF Worker edge](../../decisions/architecture/cf-worker-quota-mitigation.md):
1-hour TTL on forecast, 24-hour TTL on historical. Per
[data-apis-open-meteo-alpha-vantage](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md),
the umbrella Hono Worker fronts every weather call with a
[Workers KV](../compute/cloudflare-workers.md) cache so realistic
family-wide load stays well under the soft cap.

## Why this is our pick

- **No API key** removes a secret-rotation surface — nothing to
  put in [Doppler](../secrets/doppler.md), nothing to leak.
- **Unlimited free** removes the [never-hit-quotas](../../rules/never-hit-quotas.md)
  worry on the provider side; CF Worker quota is the only cap to
  manage, and the existing
  [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
  covers that surface.
- **Multi-model ensemble** — the response averages forecasts from
  GFS / ECMWF / GEM / UKMO / Météo-France, which is the
  highest-quality forecast-on-the-free-tier the family found.
- **Open** — Open-Meteo's data and APIs are CC BY 4.0, mirrors
  the family's everything-is-public-OSS posture.

## Alternatives

- **OpenWeatherMap** — 1,000 calls/day free, requires API key,
  geocoding bundled. Rejected on key-rotation overhead and
  tighter cap.
- **WeatherAPI.com** — 1M calls/month free, requires API key.
  Higher cap than OWM but still narrower than Open-Meteo's
  unlimited.
- **Tomorrow.io** — 500 calls/day, requires card after trial.
  Rejected on [no-card-on-file](../../rules/no-card-on-file.md).
- **Visual Crossing** — 1,000 records/day free, requires card
  past trial. Rejected on the same grounds.
- **NOAA / NWS direct** (US only) — free, no key. Geo-restricted
  so doesn't cover the family's international audience.

## Swap cost

Low — Open-Meteo's response shape is JSON with predictable
keys; remapping to OpenWeatherMap / WeatherAPI is a per-field
transform in the umbrella Worker. No client SDK lock-in.

## Cross-refs

- [Data APIs index](./index.md)
- [Alpha Vantage — finance API counterpart](./alpha-vantage.md)
- [Data APIs decision (Open-Meteo + Alpha Vantage)](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md)
- [CF Worker quota mitigation playbook — caching policy](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [Workers KV — hot-path cache for weather payloads](../compute/cloudflare-workers.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
