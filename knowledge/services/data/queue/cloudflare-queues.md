---
type: service
title: "Cloudflare Queues"
description: "Primary durable queue — native to Workers, 1M ops/mo free"
tags: [queue, cloudflare, workers, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: queue-primary
provider: cloudflare
free_tier: "1,000,000 operations / month, native binding from any Worker"
swap_cost: medium
related:
  - services/data/queue/upstash-qstash
  - services/data/queue/inngest
  - decisions/architecture/queue-cloudflare-native
  - infrastructure/cloudflare-pages-for-all-sites
  - rules/no-card-on-file
---

# Cloudflare Queues

## Role

The family's primary durable message queue. Producer + consumer are
both Cloudflare Workers, bound at deploy time via `wrangler.toml` —
no extra service to provision, no separate dashboard. Used by the
api.oriz.in umbrella Worker for: cross-post fan-out (oriz-omnipost
adapter dispatch), webhook back-pressure relief downstream of
[Hookdeck](../tooling/hookdeck.md), retry buffers for any flaky
external API.

## Free tier

- 1,000,000 operations / month
- Native binding from any Worker — no HTTP hop
- Built-in retry + dead-letter queue support
- Up to 100 queues per account

## Card / subscription required?

**NO** for free tier sign-up. Cloudflare Queues is part of the same
account as Pages / Workers / R2 / DNS — adding it does not require a
billing method.

## Alternatives

- [Upstash QStash](./upstash-qstash.md) — deferred fallback (HTTP queue)
- [Inngest](./inngest.md) — deferred fallback (durable functions)

## Swap cost

Medium — producer/consumer code uses the Cloudflare-native binding
API; swapping to QStash or Inngest means swapping the binding for an
HTTP call and re-modelling the consumer.

## Why this is our pick

Stack cohesion, not feature richness. Every other layer of the family
runs on Cloudflare (Pages, Workers, DNS, Registrar, R2). A queue that
is bound natively to the Worker producing and consuming messages
eliminates an HTTP round-trip and an extra credentials surface. The
1M ops/month cap is an order of magnitude above realistic family
traffic.

## Cross-refs

- [Cloudflare-native queue decision](../../decisions/architecture/queue-cloudflare-native.md)
- [Cloudflare Pages for all sites](../../infrastructure/cloudflare-pages-for-all-sites.md)
- [Upstash QStash](./upstash-qstash.md) — deferred alternative
- [Inngest](./inngest.md) — deferred alternative
- [Hookdeck](../tooling/hookdeck.md) — webhook reliability layer that pushes into this queue
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
