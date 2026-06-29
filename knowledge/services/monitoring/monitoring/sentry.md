---
type: service
title: "Sentry"
description: "Primary error tracking — 5K events/mo, per-site env toggle"
tags: [errors, monitoring, sentry, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: error-tracking-primary
provider: sentry
free_tier: "5,000 errors/month, 1 user, 1 project (developer plan), 30-day retention"
swap_cost: low
related:
  - services/monitoring/monitoring/glitchtip
  - architecture/api-umbrella-hono-worker
  - rules/never-hit-quotas
  - rules/no-card-on-file
---

# Sentry

## Role

Catches uncaught exceptions across every site + the api.oriz.in
Hono Worker + every Chrome extension. Replaces GlitchTip as of
2026-06-20 — the user's reasoning was "Sentry has the best
integration with everything", and the family's existing
[never-hit-quotas](../../rules/interaction/never-hit-quotas.md) rule is satisfied
by an env-var toggle (see below) rather than a quota-busting log
sink.

## Free tier

- 5,000 errors / month (developer plan)
- 1 user, 1 organization
- 30-day data retention
- All SDKs (browser, Node, Worker, Python, etc.)
- Source maps, releases, performance traces (sampled)
- Email + Slack + Discord alerts

## Card / subscription required?

**NO.** Free-tier sign-up is email-only. No payment method requested.
Stays free forever as long as you don't exceed the monthly cap.

## Per-site env-var toggle (the never-hit-quotas pattern)

Every site reads `ENABLE_SENTRY=true|false` at build time. Default is
`false` — Sentry only initialises when the env-var is explicitly
truthy. This keeps low-traffic sites silent and lets us turn Sentry on
selectively for the sites currently being debugged or recently
deployed. Combined with the 5K/month cap, the toggle prevents a
runaway error loop on one site from burning the family-wide budget.

```ts
// inside @chirag127/oriz-kit
if (import.meta.env.ENABLE_SENTRY === 'true') {
  Sentry.init({ dsn: import.meta.env.SENTRY_DSN, ... });
}
```

The toggle is documented under
[rules/never-hit-quotas](../../rules/interaction/never-hit-quotas.md). NO R2
logging fallback — R2 costs money and is explicitly rejected as an
error sink.

## Alternatives

- [GlitchTip](./glitchtip.md) — rejected 2026-06-20, kept as stub
- Bugsink — self-hosted, rejected family-wide
- Rollbar — 5K errors/month free, weaker integration story
- Honeybadger — 12K errors/month free, but smaller integration list

## Swap cost

Low — Sentry's SDK is the de-facto standard. Most "alternatives" are
DSN-compatible; swap means changing the DSN env-var.

## Why this is our pick

Best integration coverage of any error tracker — Vercel, Cloudflare
Workers, Next.js, Vite, Hono, GitHub Actions, Slack, Discord, Linear,
Razorpay-via-webhook all have first-party Sentry hooks. The 5K/month
cap is fine when paired with the per-site toggle.

## Cross-refs

- [GlitchTip](./glitchtip.md) — rejected predecessor
- [API umbrella Hono Worker](../../decisions/compute/api-umbrella-hono-worker.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
