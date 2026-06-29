---
type: index
title: "Performance services"
description: "Real-user perf measurement (Web Vitals RUM). Pairs with Sentry traces and Cloudflare server-side analytics for the full perf picture."
tags: [services, perf, rum, web-vitals, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Performance services

Three layers of perf observability, deliberately split across tools
because no single free tier covers all three:

- **Real-User Monitoring (RUM, client-side Web Vitals)** —
  [Vercel Speed Insights](./vercel-speed-insights.md). Free, runs
  on any host. Captures real users on real devices.
- **Server-side / edge-measured perf** —
  [Cloudflare Web Analytics](../analytics/cloudflare-web-analytics.md)
  (already in use for analytics). Free, unlimited, no script.
- **Performance traces (API + Worker timing)** —
  [Sentry Performance](../monitoring/sentry.md). Sampled traces in
  the same dashboard as errors.

| Service | Status | One-line role |
|---|---|---|
| [vercel-speed-insights.md](./vercel-speed-insights.md) | active | RUM Web Vitals on every site — free, no Vercel hosting required |

## Why all three?

- Cloudflare Web Vitals is **server-side**, measured at the edge —
  it tells us what the network and CDN delivered, not what the user
  saw. Misses CLS entirely (CLS only happens after paint).
- Sentry Performance is **trace-focused** — great for "why is this
  API slow", weaker for "what did 50% of mobile users on 4G see".
- Speed Insights is **real-user**, captures every Web Vital from
  real devices and real networks. The only signal Google ranks SEO
  on.

Together = full picture. Each is free with no card.

## Cross-refs

- [Perf monitoring decision](../../decisions/architecture/perf-monitoring-vercel-speed-insights.md)
- [Sentry — error tracking + perf traces](../monitoring/sentry.md)
- [Cloudflare Web Analytics](../analytics/cloudflare-web-analytics.md)
- [Lighthouse CI — lab-only score in PRs](../a11y/lighthouse-ci.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
