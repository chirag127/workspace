---
type: service
title: "healthchecks.io"
description: "Heartbeat monitoring for ingesters — 20 checks free"
tags: [monitoring, heartbeat, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: heartbeat-monitoring
provider: healthchecks-io
free_tier: "20 checks, 5 team members, 100 SMS/mo, all integrations"
swap_cost: low
---

# healthchecks.io

## Role

Each scheduled GitHub Actions ingester pings a unique URL on success.
If the ping is missing for the configured grace period, healthchecks
fires an alert. Dead-man's switch for cron.

## Free tier

- 20 checks
- 5 team members
- 100 SMS notifications / month
- All integrations (Slack, Discord, email, PagerDuty)

## Card / subscription required?

**NO.** Free tier needs only email verification.

## Alternatives

- Cronitor (5 free)
- pingmeter
- Better Stack heartbeat (separate from its uptime monitors)

## Swap cost

Low — change the ping URL in each cron workflow.

## Why this is our pick

Right-sized for our cron count, generous enough that we don't hit
the limit, and the dead-man semantics fit ingesters perfectly.

## Role within the health-check split (2026-06-20)

Per [`health-check-cron-plus-uptime`](../../decisions/architecture/health-check-cron-plus-uptime.md),
healthchecks.io owns **cron-job liveness** (heartbeat / dead-man
switch); [Better Stack](./better-stack.md) owns **HTTP endpoint
uptime** (active probe). Different surfaces, no overlap. Better
Stack also runs heartbeat-monitor mode as a backup on the same
account, but healthchecks.io stays the primary for cron coverage.

Pinged by every scheduled job in the family — including the two
[lifestream auto-event-source crons](../../decisions/architecture/lifestream-auto-event-sources.md)
(Wakatime daily, CF Web Analytics daily), the
[restic backup cron](../../decisions/architecture/backup-restic-to-b2.md),
the [Raindrop linkroll re-deploy cron](../../decisions/architecture/linkroll-raindrop-to-links-page.md),
oriz-omnipost cron, and the
[family /stats page nightly re-deploy](../../decisions/architecture/family-wide-stats-page.md).

## Cross-refs

- [Better Stack — HTTP uptime sibling](./better-stack.md)
- [Health-check split decision (cron + uptime)](../../decisions/architecture/health-check-cron-plus-uptime.md)
- [Lifestream auto-event-sources decision](../../decisions/architecture/lifestream-auto-event-sources.md)
- [GitHub Actions schedule](../cron/github-actions-schedule.md)
