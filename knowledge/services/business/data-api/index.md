---
type: index
title: "Data APIs (weather + finance)"
description: "Locked external data APIs the family uses for non-first-party data. Open-Meteo for weather, Alpha Vantage for finance. Geocoding deferred (no current need). All free, no card."
tags: [services, data-api, weather, finance, geocoding, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Data APIs (weather + finance)

External read-only data sources the family calls from the
[umbrella Hono Worker](../../decisions/architecture/hono-worker-api-umbrella.md).
Distinct from the rest of `services/` — these aren't tools the
family runs, they're upstreams the family reads.

Locked decision:
[data-apis-open-meteo-alpha-vantage](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md).

## Active picks

| Service | Status | Role | Free tier |
|---|---|---|---|
| [open-meteo.md](./open-meteo.md) | active | Weather API (forecast / current / historical) | Unlimited non-commercial, no auth, no card |
| [alpha-vantage.md](./alpha-vantage.md) | active | Finance API (stocks / forex / crypto / macro / TI) | 25 req/day, 5 req/min, free API key, no card |

## Quota envelope at a glance

| Provider | Cap | Cache TTL (CF Worker KV) | Notes |
|---|---|---|---|
| Open-Meteo | unlimited (~10K/day soft) | 1h on forecast, 24h on historical | No key — anonymous fetch |
| Alpha Vantage | 25 req/day, 5 req/min | 1d on EOD market data, 5min on intraday | API key in [Doppler](../secrets/doppler.md); cron-driven warm-cache for top-50 tickers |

Alpha Vantage's 25/day envelope is the tightest cap in the
catalog — the
[CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
applies aggressively. Every consumer hits the umbrella Worker
KV cache first; only true cache-misses hit Alpha Vantage.

## Geocoding — deferred (no current need)

No geocoding service today per
[geocoding-deferred](../../decisions/architecture/geocoding-deferred.md).
None of the 11 sites need address ↔ coordinate translation;
Cloudflare's free `CF-IPCountry` header (per
[consent-management-multi-category](../../security/consent-management-multi-category.md))
covers every current geo-routing surface.

When a future site lands a map view (likely candidates:
`oriz-finance` regional broker map, `oriz-me` visited-cities
panel), the swap targets are documented:

| Future provider | Free tier | Card | Pick when |
|---|---|---|---|
| OpenStreetMap Nominatim (public) | 1 req/sec | No | Low volume, OSS, attribution acceptable |
| Mapbox | 100K geocoding / 50K map loads / mo | No | Moderate volume, polished tiles, brand-mark acceptable |

Both stay un-adopted in 2026-06-20 — see
[geocoding-deferred](../../decisions/architecture/geocoding-deferred.md)
for the trigger conditions.

## Why both APIs?

- **Open-Meteo** is unlimited free with no auth — there's no
  reason not to lock it now even though no current site needs
  weather data. Adopting in advance means the swap cost is
  nil when the first weather-shaped feature lands.
- **Alpha Vantage** is the tightest free envelope but the
  broadest coverage (stocks + forex + crypto + macro + TI on
  one key). The active consumer is `oriz-finance` (forward
  reference) — already in-flight, the API choice unblocks the
  Worker route definition.
- **Both free, both no-card** — fits
  [no-card-on-file](../../rules/interaction/no-card-on-file.md) and
  [no-subscriptions](../../rules/infrastructure/no-subscriptions.md).

## Cross-refs

- [Data APIs decision (Open-Meteo + Alpha Vantage)](../../decisions/architecture/data-apis-open-meteo-alpha-vantage.md)
- [Geocoding deferred decision](../../decisions/architecture/geocoding-deferred.md)
- [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [Umbrella Hono Worker — fronts every data-api call](../../decisions/architecture/hono-worker-api-umbrella.md)
- [Doppler — API key vault for Alpha Vantage](../secrets/doppler.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
