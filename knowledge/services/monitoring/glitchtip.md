---
type: service
title: "GlitchTip"
description: "Error tracking — Sentry SDK compatible, 1K events/month free, self-hostable. Rejected 2026-06-20 in favour of Sentry."
tags: [errors, monitoring, sentry-compat, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
rejection_reason: "User decision 2026-06-20 — switching to Sentry as sole error tracker for best integration; env-var toggle handles quota concerns. GlitchTip kept as rejected stub for future reconsideration."
role: error-tracking
provider: glitchtip
free_tier: "1,000 events/month, unlimited projects, unlimited team members, 30-day retention"
swap_cost: low
related:
  - services/monitoring/sentry
---

# GlitchTip

> **Status: rejected (2026-06-20).** Replaced by [Sentry](./sentry.md).
> Kept as a documented stub in case Sentry's quota or pricing model
> changes and the family wants to reconsider. The reasoning was
> straightforward: Sentry has the best integration coverage of any
> error tracker, and an env-var per-site toggle (`ENABLE_SENTRY`)
> keeps us comfortably under the 5K events/month cap.

## Role (historical)

Caught uncaught exceptions on every site. Wired in via the Sentry
JS SDK pointing at GlitchTip's DSN.

## Free tier

- 1,000 events / month (cloud-hosted)
- Unlimited projects
- Unlimited team members
- 30-day retention
- Self-hosting is free with no event cap

## Card / subscription required?

**NO.** Cloud free tier needs email verification only.

## Alternatives

- [Sentry](./sentry.md) — current primary
- Bugsink
- Rollbar (5K errors)

## Swap cost

Low — the Sentry JS SDK is the standard. Swap DSN, done.

## Why this was previously our pick

Sentry-compatible API + open-source + self-hostable escape hatch if
the cloud quota gets tight. Belt-and-braces. Superseded once the user
locked Sentry as the single error tracker.

## Cross-refs

- [Sentry](./sentry.md) — current primary
- [Axiom](../tooling/axiom.md) — for log aggregation
- [Better Stack](./better-stack.md) — for uptime
