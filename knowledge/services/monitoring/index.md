---
type: index
title: "Monitoring services"
description: "Uptime, heartbeat, error-tracking, and log services."
tags: [services, monitoring, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Monitoring services

Better Stack handles uptime + status page + SSL expiry monitoring (10 free monitors covers all 11+ sites). healthchecks.io confirms cron jobs ran. **Sentry** ingests application errors as of 2026-06-20 — replacing GlitchTip, which is kept as a rejected stub. **Instatus** mirrors the status page at `status-backup.oriz.in` so a Better Stack outage doesn't take our status communication down with it (added 2026-06-20). **Logs run on a two-layer plane** as of 2026-06-20 — [Cloudflare Workers Tail](./cloudflare-workers-tail.md) for live debugging (free, ~5 min retention via `wrangler tail`) + [Better Stack Logs](./better-stack-logs.md) for aggregation, search, alerts, 30-day retention (3 GB/mo free, same Better Stack account as the status page + uptime monitors — three products, one account). Locked in [logs-better-stack-plus-cf-tail](../../decisions/architecture/logs-better-stack-plus-cf-tail.md).

Note: **Otterwatch** was considered for SSL monitoring but rejected — its free tier covers 5 domains, and the family runs 11+ sites. Better Stack's 10-monitor free tier already covers SSL expiry alongside uptime.

## Two-status-page redundancy strategy

A single hosted status page is a single point of failure for the
thing it's meant to communicate. We run two:

- **Primary** — `status.oriz.in` on [Better Stack](./better-stack.md). Same tool that runs our uptime monitors, so monitor → page is one webhook away.
- **Redundant mirror** — `status-backup.oriz.in` on [Instatus](./instatus.md). Different cloud, different edge, different team. If Better Stack itself is the outage, healthchecks.io's heartbeat miss posts directly to Instatus's API as a manual incident.

Better Stack monitor webhooks update both pages in sync — we don't
maintain two sources of truth. Every site footer links both URLs.

| Service | Status | One-line role |
|---|---|---|
| [better-stack.md](./better-stack.md) | active | Uptime + status page (primary) + SSL expiry (10 monitors free) |
| [instatus.md](./instatus.md) | active | Status page (redundant mirror at status-backup.oriz.in) |
| [healthchecks-io.md](./healthchecks-io.md) | active | Heartbeat / dead-man-switch for cron jobs |
| [sentry.md](./sentry.md) | active | Error tracking — best integration coverage; env-var per-site toggle keeps under 5K events/mo cap |
| [cloudflare-workers-tail.md](./cloudflare-workers-tail.md) | active | Live tail of Worker `console.log` via `wrangler tail` — sub-100ms, free, ~5 min retention |
| [better-stack-logs.md](./better-stack-logs.md) | active | Log aggregation + 30-day retention + search + alerts; 3 GB/mo free; same Better Stack account as status + uptime |
| [glitchtip.md](./glitchtip.md) | rejected | Sentry-compatible OSS error tracker — replaced by Sentry on 2026-06-20 |

## Health-check split (2026-06-20)

Per [`decisions/architecture/health-check-cron-plus-uptime.md`](../../decisions/architecture/health-check-cron-plus-uptime.md),
health-check coverage splits cleanly across two free tools:

| Surface | Tool | Mode |
|---|---|---|
| Cron-job liveness (did this run?) | [healthchecks.io](./healthchecks-io.md) | Dead-man-switch heartbeat (20 free) |
| HTTP endpoint uptime (is this URL serving?) | [Better Stack](./better-stack.md) | Active probe, 3-min interval (10 free) |

healthchecks.io is the primary for cron heartbeats; Better Stack
also runs heartbeat-monitor mode as a backup channel on the same
account. Together they verify every auto-tracked surface in the
family without human polling — the [`auto-only-tracking`](../../rules/auto-only-tracking.md)
posture extends to the watchdogs themselves.

## Cross-refs

- [rules/never-hit-quotas](../../rules/never-hit-quotas.md)
- [decisions/architecture/multi-engine-search-button](../../decisions/architecture/multi-engine-search-button.md) (unrelated, but new on the same date)
