---
type: service
title: "Axiom"
description: "Log management — 0.5 TB ingest / 30-day retention free."
tags: [logs, observability, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: log-management
provider: axiom
free_tier: "0.5 TB ingest/month, 30-day retention, unlimited query"
swap_cost: medium
---

# Axiom

## Role

Receives structured logs from the Hono Worker and from GitHub Actions
ingesters. Queryable from a single dashboard.

## Free tier

- 500 GB ingest / month
- 30-day retention
- Unlimited query volume
- Unlimited users

## Card / subscription required?

**NO.** Free tier is no-credit-card per the Axiom docs.

## Alternatives

- OpenObserve self-hosted (200 GB/mo free)
- Logflare
- Bugfender

## Swap cost

Medium — query language differs (Axiom uses APL, Logflare/OpenObserve
have their own DSLs). Sender code (HTTP POST of NDJSON) is portable.

## Why this is our pick

Half-terabyte ingest is generous, retention is enough for incident
review, and the APL query language is solid.

## Cross-refs

- [GlitchTip](./glitchtip.md)
- [Cloudflare Workers](./cloudflare-workers.md)
