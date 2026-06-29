---
type: service
title: "Cloudflare Cron Triggers"
description: "In-Worker scheduled jobs — sub-second invocation, free unlimited"
tags: [cron, cloudflare, workers, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: cron-low-latency
provider: cloudflare
free_tier: "Unlimited cron invocations on the Workers Free plan; counts against the 100K req/day Worker quota"
swap_cost: low
---

# Cloudflare Cron Triggers

## Role

Runs scheduled jobs **inside** the Hono Worker at `api.oriz.in` (and
on any other family Worker). Jobs trigger via a `scheduled()` handler
in the Worker module — same runtime, same bindings (KV, R2, D1,
Service Bindings), same observability.

## Free tier

- Unlimited cron invocations on the Workers Free plan.
- Each invocation counts against the Worker's 100K req/day budget,
  not a separate quota.
- Sub-second invocation latency (Cloudflare's edge schedules).
- Fails-closed at the Worker quota — never auto-bills.

## Card / subscription required?

**NO.** Same Cloudflare account as Pages / Workers / DNS / R2; no
payment method needed.

## What we run on it

| Job | Cadence | Why CF Cron |
|---|---|---|
| RSS feed poll inside oriz-omnipost Worker (when migrated from GH Actions) | every 5 min | Sub-minute trigger; reads R2 / KV directly |
| Cache rebuild for site indexes | every 15 min | Touches Worker KV; no git involvement |
| Idempotency-table sweep (Razorpay webhook dedupe) | hourly | Worker reads its own KV |
| Heartbeat ping to [healthchecks.io](../monitoring/healthchecks-io.md) for "Worker is up" | every 5 min | Fires from inside the Worker — proves the Worker can both schedule and fetch |

Anything that needs `pnpm`, `wrangler deploy`, or a repo checkout
goes to [GitHub Actions schedule](./github-actions-schedule.md)
instead — see the
[cron split decision](../../decisions/architecture/cron-split-cf-vs-gh.md).

## Alternatives

- [GitHub Actions schedule](./github-actions-schedule.md) — sister substrate; different job shape
- Vercel Cron Jobs (free tier exists but ties us to Vercel hosting)
- Deno Deploy cron

## Swap cost

Low — the `scheduled()` handler is ~10 lines of TS. Swapping out
means moving the same job into another runtime.

## Why this is our pick

For jobs that live in the Worker runtime, this is the lowest-latency
+ lowest-friction substrate. No token plumbing, no checkout, no
runner cold start.

## Cross-refs

- [Cron split decision](../../decisions/architecture/cron-split-cf-vs-gh.md)
- [GitHub Actions schedule](./github-actions-schedule.md) — sister cron
- [Cloudflare Workers](../compute/cloudflare-workers.md)
- [API umbrella — Hono Worker](../../decisions/compute/api-umbrella-hono-worker.md)
- [healthchecks.io](../monitoring/healthchecks-io.md)
