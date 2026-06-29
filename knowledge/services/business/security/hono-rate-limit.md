---
type: service
title: "Hono rate-limit middleware (per-IP, sliding window via KV)"
description: "Custom per-IP rate-limit via Hono + KV — fine-grained per-route throttling"
tags: [security, anti-bot, rate-limit, hono, cloudflare-workers, kv, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: anti-bot-rate-limit
provider: self-hosted
free_tier: "Runs on existing Cloudflare Workers + KV free tier — no separate vendor, no card. KV: 100k reads/day, 1k writes/day, 1 GiB."
swap_cost: low
related:
  - services/business/security/cloudflare-waf
  - services/business/security/cloudflare-turnstile
  - services/infra/compute/cloudflare-workers
  - security/anti-bot-defense-in-depth
  - decisions/architecture/hono-worker-api-umbrella
  - decisions/architecture/cf-worker-quota-mitigation
  - rules/no-card-on-file
---

# Hono rate-limit middleware

## Role

The **API-layer** of the family's anti-bot defense-in-depth. A
custom Hono middleware in the
[umbrella api.oriz.in Worker](../../decisions/architecture/hono-worker-api-umbrella.md)
that throttles requests on a **per-IP, sliding-window** basis using
Workers KV as the counter store. Sits behind the
[Cloudflare WAF](./cloudflare-waf.md) (zone-wide coarse limits) and
in front of the route handlers. Each route declares its own budget.

## Why custom rather than Cloudflare zone-level rate-limit

- **Cloudflare's free zone-level rate-limit** allows a coarse 10K
  req/10min envelope per zone. That covers DDoS but not per-route
  abuse — a `POST /api/contact` flood and a `GET /api/og` flood
  both look the same to the zone-level rule.
- **Hono middleware** runs after route resolution, so it can apply a
  different budget per route (`10/min for /api/contact`,
  `100/min for /api/og`, `1000/min for /api/feed`).
- **Same Worker, same account, same KV** — no new vendor surface.

## Implementation sketch

```ts
import { rateLimit } from "@chirag127/oriz-kit/server";

app.use(
  "/api/contact",
  rateLimit({
    namespace: env.RATE_LIMIT_KV,   // KV binding
    windowMs: 60_000,                // 1-minute sliding window
    limit: 10,                       // 10 req / IP / minute
    keyBy: (c) => c.req.header("CF-Connecting-IP") ?? "unknown",
    onLimit: (c) => c.json({ error: "too many requests" }, 429),
  }),
);
```

Lives in `@chirag127/oriz-kit/server` so every Worker route in the
family imports the same middleware — no per-Worker re-implementation.

## Free tier

Runs entirely on existing free-tier resources:

- **Cloudflare Workers** — middleware adds <1ms CPU per request
  (single KV `get` + `put`); fits inside the
  [10ms CPU/request budget](../../decisions/architecture/cf-worker-quota-mitigation.md).
- **Workers KV** (`RATE_LIMIT_KV` namespace) — 100k reads/day, 1k
  writes/day, 1 GiB storage. Reads dominate (one per gated request);
  writes are coalesced (one per IP per window).
- No third-party rate-limit service, no card.

## Card / subscription required?

**NO.** No external vendor; runs on the existing Cloudflare account.

## KV-write quota: the only thing to watch

The 1k writes/day KV cap is the binding constraint. Mitigations
(per the [worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)):

- **Coalesce writes** — increment the counter in memory across many
  requests from the same IP; flush to KV at most every N seconds.
- **Skip write when over limit** — once an IP is rate-limited, the
  middleware short-circuits to 429 without re-writing the counter.
- **Split namespaces by route severity** — public-facing endpoints
  (likely targets) get a dedicated KV namespace; internal cron-only
  endpoints share one.

## Alternatives

- [Upstash Ratelimit](https://upstash.com/docs/ratelimit) — Redis-based
  sliding-window; free tier 10k commands/day. Documented swap target
  if KV writes ever cap.
- Cloudflare Durable Objects — better consistency than KV; **not
  free** (Durable Objects are paid past 1M req/mo on Workers Paid
  plan, fights [`no-card-on-file`](../../rules/interaction/no-card-on-file.md)).
- Cloudflare zone-level rate-limit — coarser, already configured by
  the [WAF service](./cloudflare-waf.md).

## Swap cost

**Low.** Middleware lives in `@chirag127/oriz-kit/server`; swap the
storage backend (KV → Upstash) by replacing the `namespace` adapter.
Per-route budgets stay declarative.

## Why this is our pick

Three layers of bot defense
([decision](../../security/anti-bot-defense-in-depth.md))
need a per-route, fine-grained throttle. Cloudflare's free WAF
covers the zone; Turnstile covers form-submit; Hono rate-limit
covers everything else — and runs on substrate the family already
pays nothing for.

## Cross-refs

- [Security services index](./index.md)
- [Anti-bot defense-in-depth decision](../../security/anti-bot-defense-in-depth.md)
- [Cloudflare WAF — zone-layer sibling](./cloudflare-waf.md)
- [Cloudflare Turnstile — form-submit sibling](./cloudflare-turnstile.md)
- [Umbrella Hono Worker decision](../../decisions/architecture/hono-worker-api-umbrella.md)
- [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
