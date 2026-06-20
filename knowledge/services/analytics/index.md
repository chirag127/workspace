---
type: index
title: "Analytics services"
description: "5-tier analytics stack — CFWA (raw load) + GA4 (marketing funnel) + PostHog (product + replay + flags) + Clarity (heatmaps + redundant replay) + UTM (attribution convention). All free, no card. Each layer covered by an ENABLE_<TOOL> env-var kill-switch."
tags: [services, analytics, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Analytics services

The family runs a **5-tier analytics stack**, each layer answering a
different question with no overlap. Locked at
[`decisions/architecture/analytics-five-tier-stack.md`](../../decisions/architecture/analytics-five-tier-stack.md).
All five are free, no card; each has a per-site
`ENABLE_<TOOL>=true|false` env-var so a single quota cliff never
breaks a site.

| # | Service | Status | One-line role |
|---|---|---|---|
| 1 | [cloudflare-web-analytics.md](./cloudflare-web-analytics.md) | active | Cookieless pageview analytics — edge / raw load |
| 2 | [google-analytics.md](./google-analytics.md) | active | Marketing funnel — acquisition / engagement / conversion against advertiser-standard definitions; Consent Mode v2, gated by Klaro in EU/UK |
| 3 | [posthog.md](./posthog.md) | active | Product analytics + funnels + session replay (primary) + feature flags (1M events/mo free) |
| 4 | [microsoft-clarity.md](./microsoft-clarity.md) | active | Heatmaps + Microsoft-side session replay (vendor-redundant — covers PostHog quota / outage) |
| 5 | [utm-tracking.md](./utm-tracking.md) | active | Marketing attribution via `utm_*` query params, read by tiers 2-4; `<UtmLink>` in oriz-kit enforces naming |

## Marketing attribution

UTM-only attribution (locked in
[`decisions/architecture/utm-attribution-strategy.md`](../../decisions/architecture/utm-attribution-strategy.md)):
no paid attribution tool, no SaaS click-tracker, no bounce-redirect
domain. UTM parameters ride on the real link; PostHog + CFWA capture
them; oriz-kit's `<UtmLink>` enforces the kebab-case naming
convention so attribution data stays clean.

## Why two replay vendors (PostHog + Clarity)?

Defense-in-depth on the most valuable signal. PostHog is primary
(richer integration with funnels + flags); Clarity is the redundant
second so a PostHog quota / outage doesn't blind us to user
behaviour. Same pattern as the
[double security-headers audit](../security/index.md) and the
[two-captcha pair](../security/cloudflare-turnstile.md).

## Cross-refs

- [5-tier analytics stack decision](../../decisions/architecture/analytics-five-tier-stack.md)
- [UTM attribution strategy decision](../../decisions/architecture/utm-attribution-strategy.md)
- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) — `<UtmLink>` + `<Analytics />` live here
- [No card-on-file rule](../../rules/no-card-on-file.md)
