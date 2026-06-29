---
type: service
title: "Cloudflare Workers Tail"
description: "Live Worker console tail via wrangler — free, 5 min retention, active debugging"
tags: [logs, observability, cloudflare, workers, live-tail, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: logs-cf-native
provider: cloudflare
free_tier: "Unlimited — included with Cloudflare Workers free tier"
swap_cost: low
related:
  - services/monitoring/monitoring/better-stack-logs
  - services/monitoring/monitoring/sentry
  - services/infra/compute/cloudflare-workers
  - architecture/api-umbrella-hono-worker
  - decisions/architecture/logs-better-stack-plus-cf-tail
  - decisions/architecture/cf-worker-quota-mitigation
---

# Cloudflare Workers Tail

## Role

Live `console.log` / `console.error` stream from any Cloudflare
Worker, delivered to a developer's terminal over WebSocket via
`wrangler tail <worker-name>`. The "what's the Worker actually doing
right now?" answer.

Used during active debugging — pair with a `curl` / browser request
in another terminal to see the Worker's logs as they're emitted.
Retention is the WebSocket session; close it and the data is gone.
For retroactive log search, use
[Better Stack Logs](./better-stack-logs.md) — see
[logs-better-stack-plus-cf-tail](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
for the layered strategy.

## Free tier

- Unlimited — included with the Cloudflare Workers free tier
- No request-count cap, no event-volume cap
- All Workers in the family's Cloudflare account streamable
- Sampled-tail mode for high-traffic Workers (`--sampling-rate 0.1`)

## Card / subscription required?

**NO.** Workers free tier (the family's existing posture per
[CF Worker quota mitigation](../../decisions/architecture/cf-worker-quota-mitigation.md))
includes Tail. No card on file.

## How developers consume it

```bash
# Live tail of the umbrella Hono Worker
wrangler tail oriz-api

# Filter to errors only
wrangler tail oriz-api --status error

# Filter by IP / method / sampling
wrangler tail oriz-api --method POST --sampling-rate 0.1

# Pretty-print JSON logs
wrangler tail oriz-api --format pretty
```

Works against `wrangler dev` (local Worker) and against deployed
Workers identically. The `--format json` mode is useful for piping
into `jq` for ad-hoc filtering.

## What's logged

Anything the Worker calls `console.log()` / `console.error()` /
`console.warn()` on. The family's `log()` helper in
`@chirag127/oriz-kit/server/logging` (forward reference) always
calls `console.log()` so Workers Tail sees every structured log
line — see
[logs-better-stack-plus-cf-tail](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
for the full helper shape.

Cloudflare also adds request metadata to each event (URL, method,
status, ray ID, geo, latency) automatically.

## Limitations

- **Retention is the session.** Close `wrangler tail` and history is
  gone. Better Stack Logs covers retroactive search.
- **Not alertable.** Workers Tail is purely interactive — there's no
  "page me on this log line" surface. Sentry handles that for errors;
  Better Stack Logs handles it for non-error patterns.
- **Sampled at high traffic.** Workers Tail samples automatically when
  request volume is high to keep the WebSocket healthy. The family's
  scale is well below that threshold.

## Alternatives

- [Better Stack Logs](./better-stack-logs.md) — sibling, picked
  alongside for retroactive aggregation. NOT a competitor — different
  retention horizon.
- `wrangler dev` console — what you see when running locally; same
  data, local only.
- Logpush to R2 / external — Workers Paid feature; rejected on
  card-on-file grounds.

## Swap cost

Low — `wrangler tail` is a developer tool, not a piece of production
infra. There's nothing to swap; if Cloudflare retired it, developers
would fall back to Better Stack Logs's tail UI.

## Why this is our pick

Free, zero-config, native to the Workers runtime the family already
uses. Sub-100ms log-to-terminal is the right shape for "I changed
something in `wrangler dev`, what does it log?" workflows. No log
sink to configure, no retention cost, no quota.

## Cross-refs

- [Logs strategy decision](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
- [Better Stack Logs — retroactive sibling](./better-stack-logs.md)
- [Sentry — error / exception sibling](./sentry.md)
- [Cloudflare Workers service](../compute/cloudflare-workers.md)
- [API umbrella Hono Worker](../../decisions/compute/api-umbrella-hono-worker.md)
- [CF Worker quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
