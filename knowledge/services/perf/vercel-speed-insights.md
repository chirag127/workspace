---
type: service
title: "Vercel Speed Insights"
description: "Real-User Monitoring for Web Vitals across every site. Free tier on every site, no Vercel hosting required — works on Cloudflare Pages."
tags: [perf, rum, web-vitals, vercel, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: rum-web-vitals
provider: vercel
free_tier: "10,000 data points/month per project, all Web Vitals (LCP, FID/INP, CLS, FCP, TTFB), 30-day retention"
swap_cost: low
related:
  - services/monitoring/sentry
  - services/analytics/cloudflare-web-analytics
  - decisions/architecture/perf-monitoring-vercel-speed-insights
---

# Vercel Speed Insights

## Role

**Real-User Monitoring (RUM)** for Web Vitals on every family site.
A small client script (`@vercel/speed-insights`) reports LCP, INP,
CLS, FCP, and TTFB from real visitors back to Vercel's dashboard.

Critically — Speed Insights does **not** require Vercel hosting. The
script works on any host that can serve a `<script>` tag, including
[Cloudflare Pages](./../hosting/cloudflare-pages.md), which is the
family's primary host. We pair it with [Sentry's performance
traces](../monitoring/sentry.md) (server-side / API timing) and
Cloudflare Web Vitals (server-side, edge-measured) for the full
picture.

## Free tier

- 10,000 data points / month per project
- All Web Vitals: LCP, INP (replaces FID in 2024+), CLS, FCP, TTFB
- 30-day retention
- Per-route breakdown
- Device + connection-type segmentation
- No Vercel hosting required — script-based pageview reporting

## Card / subscription required?

**NO.** Free tier sign-up is GitHub OAuth or email. No payment method
requested. Stays free as long as monthly volume per project stays
under 10K data points; per-site env-var toggle keeps low-traffic
sites silent for headroom (same pattern as
[Sentry's ENABLE_SENTRY toggle](../monitoring/sentry.md#per-site-env-var-toggle-the-never-hit-quotas-pattern)).

## Why we run it on every site

Web Vitals are the only perf signal Google ranks SEO on. Lab metrics
(Lighthouse CI in PRs) and edge-measured metrics (Cloudflare Web
Analytics) both miss the actual user experience: real devices, real
networks, real conditions. Speed Insights fills that gap.

## How it integrates (Cloudflare Pages, no Vercel hosting)

```ts
// inside @chirag127/oriz-kit
import { injectSpeedInsights } from '@vercel/speed-insights';
if (import.meta.env.ENABLE_SPEED_INSIGHTS === 'true') {
  injectSpeedInsights();
}
```

Vercel issues a free project ID per site for the script to phone
home to. No Vercel deployment needed — the dashboard receives data
from any origin you configure.

## Alternatives

- **Cloudflare Web Vitals** — server-side / edge-measured, not RUM.
  Complementary, not a replacement.
- **Sentry Performance** — covers traces (API + Worker timing) but
  the JS SDK's Web Vitals capture is sample-based and less detailed
  than Speed Insights. Complementary.
- **DebugBear** — free 100 page audits/mo, lab-only (no RUM).
- **SpeedCurve** — paid only.
- **Self-rolled** with `web-vitals` npm package + a Worker endpoint
  — re-implements dashboards / alerts that Vercel gives us free.

## Swap cost

Low — `web-vitals` (the W3C standard package) is the underlying
library. Swapping means replacing `injectSpeedInsights()` with a
direct `web-vitals` listener that posts to a different endpoint.

## Why this is our pick

Free, no card, vendor-neutral (works on Cloudflare Pages). Captures
the exact metrics Google SEO measures. Drops into
`@chirag127/oriz-kit` as one import. Pairs cleanly with Sentry
(traces) and Cloudflare Web Analytics (server-side) — together =
full perf picture.

## Cross-refs

- [perf services index](./index.md)
- [Sentry — error tracking + perf traces](../monitoring/sentry.md)
- [Cloudflare Web Analytics](../analytics/cloudflare-web-analytics.md)
- [Cloudflare Pages — primary host](../hosting/cloudflare-pages.md)
- [Perf monitoring decision](../../decisions/architecture/perf-monitoring-vercel-speed-insights.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
