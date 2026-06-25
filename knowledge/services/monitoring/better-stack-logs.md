---
type: service
title: "Better Stack Logs"
description: "Log aggregation + 30-day retention + searchable + alertable. 3 GB/mo free. Same Better Stack account as the family's status page + uptime monitors — three products, one account."
tags: [logs, observability, better-stack, aggregation, retention, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: logs-aggregation
provider: better-stack
free_tier: "3 GB ingest/month, 30-day retention, searchable, alertable, unlimited team, dashboards"
swap_cost: low
related:
  - services/monitoring/cloudflare-workers-tail
  - services/monitoring/better-stack
  - services/monitoring/instatus
  - services/monitoring/sentry
  - services/monitoring/healthchecks-io
  - services/tooling/axiom
  - services/secrets/doppler
  - decisions/architecture/logs-better-stack-plus-cf-tail
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Better Stack Logs

## Role

Aggregates structured log lines from every Cloudflare Worker in the
family (`api.oriz.in` umbrella, `s.oriz.in` shortener, OG card route,
omnipost endpoints) into a searchable, alertable, 30-day-retained
store. The "what happened yesterday at 03:14 UTC?" answer.

Pairs with [Cloudflare Workers Tail](./cloudflare-workers-tail.md)
for live debugging — see
[logs-better-stack-plus-cf-tail](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
for the layered strategy.

## Free tier

- **3 GB log ingest / month** — at ~1 KB/req × ~1K req/day family-wide ≈ 30 MB/mo realistic load → ~100x headroom
- **30-day retention**
- **Searchable** by structured fields (level, route, status, latency, etc.)
- **Alertable** — pattern / threshold alerts via email + Slack + webhook
- **Unlimited team members**
- **Dashboards** — pinned saved searches, trend charts
- **HTTP source tokens** — one per environment (Worker), keyed by Doppler

## Card / subscription required?

**NO.** Free-tier sign-up is email-only. No payment method requested.
Stays free forever as long as you don't exceed the monthly cap.

## Same vendor as

- [Better Stack uptime monitoring + status page](./better-stack.md) (10 monitors free, hosts `status.oriz.in`)
- Better Stack Incidents (incident management — auto-derived from monitor state, no separate setup)

Three products on **one Better Stack account**. The
[Doppler](../secrets/doppler.md)-stored `BETTER_STACK_TOKEN` covers
all three.

The redundant status page mirror at
[Instatus](./instatus.md) intentionally lives on a different vendor
for status-page redundancy. Logs do NOT need the same redundancy
posture — see the
[logs strategy decision](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
for why.

## How Workers consume it

A thin `log()` helper in `@chirag127/oriz-kit/server/logging`
(forward reference) calls both `console.log` (for Workers Tail) and
fires-and-forgets an HTTP push to Better Stack via
`ctx.waitUntil()`:

```ts
// inside the Worker
import { log } from '@chirag127/oriz-kit/server/logging';

log({ level: 'info', msg: 'razorpay webhook received', payment_id, route: '/webhook/razorpay' });
```

Behind the scenes:

```ts
function log(payload) {
  console.log(JSON.stringify(payload));                     // Workers Tail sees this
  if (env.ENABLE_BETTER_STACK_LOGS === 'true') {
    ctx.waitUntil(
      fetch('https://in.logs.betterstack.com/', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${env.BETTER_STACK_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      })
    );
  }
}
```

## The `ENABLE_BETTER_STACK_LOGS=true` per-Worker toggle

Same per-site env-var pattern as
[Sentry](./sentry.md). Default is `false` for low-traffic Workers;
flip to `true` only on Workers currently being debugged or recently
deployed. Combined with the 3 GB/mo cap, this prevents a runaway log
loop on one Worker from burning the family-wide budget. Documented
under [`rules/interaction/never-hit-quotas.md`](../../rules/interaction/never-hit-quotas.md).

## Quota math

- ~1 KB / log line (level, msg, request_id, route, status, latency, geo, ua, env)
- ~1K Worker requests / day at family scale across all Workers
- = **~30 MB / month** vs the 3 GB / month free cap → **~100x headroom**
- Even a 10x error spike on one Worker still fits comfortably

## Alternatives

- [Cloudflare Workers Tail](./cloudflare-workers-tail.md) — sibling,
  picked alongside for live debugging. NOT a competitor — different
  retention horizon.
- [Axiom](../tooling/axiom.md) — already in the catalog, used for
  metrics-shaped event ingest + dashboards (e.g. CF Worker quota
  alarms per the
  [quota mitigation playbook](../../decisions/architecture/cf-worker-quota-mitigation.md)).
  Different shape, different destination — Axiom is metrics; Better
  Stack Logs is text-line search + alerts.
- Logtail — was acquired by Better Stack and is now exactly Better
  Stack Logs.
- Datadog Logs — paid past trial; fights the no-paid-tier posture.
- Loggly / Papertrail / Sumo Logic — paid past trial.
- Self-hosted Loki / Grafana — fights the no-self-host posture.

## Swap cost

Low — log emission goes through one helper file in oriz-kit. A swap
to a sibling (Axiom Logs, a future provider) would change the URL +
auth header in one place; structured field shape is portable.

## Why this is our pick

Same vendor as [Better Stack status page + uptime](./better-stack.md)
— three products on one account, one Doppler token. Free 3 GB/mo is
~100x our realistic load. 30-day retention + search + alerts cover
every retroactive log question we'd ask. Pairs cleanly with
[Workers Tail](./cloudflare-workers-tail.md) for the live-debugging
plane and [Sentry](./sentry.md) for the error plane.

## Cross-refs

- [Logs strategy decision](../../decisions/architecture/logs-better-stack-plus-cf-tail.md)
- [Cloudflare Workers Tail — live-tail sibling](./cloudflare-workers-tail.md)
- [Better Stack — same vendor (status + uptime)](./better-stack.md)
- [Instatus — redundant status page mirror (logs intentionally not mirrored)](./instatus.md)
- [Sentry — error / exception sibling](./sentry.md)
- [healthchecks.io — heartbeat sibling](./healthchecks-io.md)
- [Axiom — metrics-shaped events sibling](../tooling/axiom.md)
- [Doppler — token source-of-truth](../secrets/doppler.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
