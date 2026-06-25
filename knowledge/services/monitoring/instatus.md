---
type: service
title: "Instatus"
description: "Redundant status page at status-backup.oriz.in — kicks in if Better Stack itself is down. Free 5 components / 25K subscribers, no card."
tags: [status-page, monitoring, redundancy, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: status-page-redundant
provider: instatus
free_tier: "5 components, 25,000 subscribers, unlimited incidents, custom domain, public status page, email + Slack + webhook notifications"
swap_cost: low
related:
  - services/monitoring/better-stack
  - services/monitoring/healthchecks-io
  - services/monitoring/sentry
  - decisions/infrastructure/monitor-apex-only
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Instatus

## Role

Hosts the **redundant** status page at `status-backup.oriz.in` — a
mirror of the same 5 component states that
[Better Stack](./better-stack.md) publishes at `status.oriz.in`.
The point isn't a richer feature set; it's that **if Better Stack
itself goes down, our status page doesn't go down with it**.

## Free tier

- 5 components (matches our component count: oriz.in apex, api.oriz.in Worker, auth.oriz.in, status.oriz.in itself, jsdelivr-cached oriz-kit)
- 25,000 subscribers (we'll never hit this)
- Unlimited incidents
- Custom domain (`status-backup.oriz.in` via CNAME)
- Public status page
- Email + Slack + Discord + webhook notifications

## Card / subscription required?

**NO.** Free-tier sign-up is email-only. No payment method requested.

## Why two status pages?

A single hosted status page is a single point of failure for the
exact thing it's supposed to communicate. If Better Stack's edge or
their status-page rendering layer goes down, visitors hitting
`status.oriz.in` see nothing — and we lose the channel we'd use to
say "yes, we know, here's an ETA."

Instatus runs on a different infrastructure stack (different cloud,
different DNS edge, different team) so a Better Stack outage does
not propagate to `status-backup.oriz.in`. The footer of every site
links both:

```text
Status: status.oriz.in (primary) · status-backup.oriz.in (if primary is down)
```

This is a redundancy strategy, not a feature comparison — Better Stack
remains primary because of its tighter uptime-monitoring integration
(monitors + status page in one tool). Instatus is updated by the
**same** Better Stack monitor webhooks, so the two pages stay in sync
without us writing dual updates.

## Update flow

```text
Better Stack monitor detects outage on oriz.in
        ├── publishes to status.oriz.in (Better Stack hosted)
        └── webhook → Instatus API → status-backup.oriz.in
```

If Better Stack itself is the outage, healthchecks.io's heartbeat
miss fires a Cloudflare Worker that posts directly to Instatus's
API as a manual incident — bypassing Better Stack entirely.

## Alternatives

- [Better Stack](./better-stack.md) — primary, kept; this file documents the *redundant* pick
- Statuspage.io (Atlassian) — no free tier
- Cachet — self-hosted OSS, but self-hosting a status page on the same infra it monitors defeats the redundancy goal
- Openstatus — promising OSS, but free hosted tier is small and the project is young

## Swap cost

Low — status pages are throwaway by design. The CNAME is the only
DNS-side coupling; component definitions are five lines of JSON we
can recreate anywhere in 10 minutes.

## Why this is our pick

Different cloud + edge stack from Better Stack (the redundancy goal),
free tier easily fits our 5 components, no card, custom domain
support on free, and webhook-driven updates so we're not maintaining
two manual sources of truth.

## Cross-refs

- [Better Stack](./better-stack.md) — primary status page; this is its redundant mirror
- [healthchecks.io](./healthchecks-io.md) — heartbeat fallback that posts to Instatus directly if Better Stack is the outage
- [decisions/infrastructure/monitor-apex-only](../../decisions/infrastructure/monitor-apex-only.md) — same apex-only scope applies to both status pages
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
