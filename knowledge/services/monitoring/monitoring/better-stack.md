---
type: service
title: "Better Stack"
description: "Uptime monitoring + status page — 10 monitors free"
tags: [uptime, status-page, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: uptime-and-status-page
provider: better-stack
free_tier: "10 monitors, 3-min check interval, unlimited team, 1 status page"
swap_cost: low
---

# Better Stack

## Role

Pings every public oriz site + `api.oriz.in` and publishes the rolled-up
status to `status.oriz.in`.

## Free tier

- 10 HTTP monitors
- 3-minute check interval
- Unlimited team members
- 1 hosted status page (custom domain supported)

## Card / subscription required?

**NO.** Free tier sign-up needs no payment method.

## Alternatives

- UptimeRobot
- Servervana
- Cronitor
- [healthchecks.io](./healthchecks-io.md) — for heartbeat, not for HTTP probes

## Swap cost

Low — re-create monitors on the alternative; status page is a CNAME swap.

## Why this is our pick

Uptime + status page in one tool. 10 monitors fits the family with
room to grow.

## Role within the health-check split (2026-06-20)

Per [`health-check-cron-plus-uptime`](../../decisions/architecture/health-check-cron-plus-uptime.md),
Better Stack owns **HTTP endpoint uptime** (active probe, 3-min
interval); [healthchecks.io](./healthchecks-io.md) owns **cron-job
liveness** (heartbeat / dead-man switch). Different surfaces, no
overlap.

**Heartbeat-monitor mode is also enabled** on this Better Stack
account as a backup channel — same account already running uptime,
status page, and [Better Stack Logs](./better-stack-logs.md) per the
[logs-better-stack-plus-cf-tail decision](../../decisions/architecture/logs-better-stack-plus-cf-tail.md).
Three products on one account; healthchecks.io stays the primary
for cron heartbeats.

Configured to monitor only the `oriz.in` apex; *.oriz.in subdomains
inherit via Cloudflare cert auto-rotation. See
[`decisions/monitor-apex-only.md`](../../infrastructure/monitor-apex-only.md).

## Why two status pages?

Better Stack hosts our **primary** status page at `status.oriz.in`,
but a single hosted status page is a single point of failure for the
exact thing it's meant to communicate. If Better Stack's edge or
status-page rendering layer goes down, visitors hitting
`status.oriz.in` see nothing — and we lose the channel we'd use to
say "we know, here's an ETA."

[Instatus](./instatus.md) runs the redundant mirror at
`status-backup.oriz.in` on a different infrastructure stack
(different cloud + edge + team) so a Better Stack outage doesn't
propagate. Better Stack monitor webhooks update both pages in sync —
we don't maintain two sources of truth. If Better Stack itself is
the outage, healthchecks.io's heartbeat miss posts directly to
Instatus's API as a manual incident.

Every site footer links both:

```text
Status: status.oriz.in (primary) · status-backup.oriz.in (if primary is down)
```

## Cross-refs

- [healthchecks.io](./healthchecks-io.md)
- [Instatus](./instatus.md) — redundant status page mirror
- [GlitchTip](./glitchtip.md)
