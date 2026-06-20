---
type: service
title: "PostHog"
description: "Product analytics + feature flags + A/B — 1M events/month free."
tags: [analytics, product, posthog, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: product-analytics
provider: posthog
free_tier: "1M events/mo, 5K session recordings/mo, 1M feature-flag requests/mo, 1-yr retention"
swap_cost: medium
---

# PostHog

## Role

Tracks named product events (sign-ups, conversions, feature usage),
runs feature flags, and powers any A/B test we set up.

## Free tier

- 1,000,000 events / month
- 5,000 session recordings / month
- 1,000,000 feature flag requests / month
- 1-year retention
- Unlimited team seats

## Card / subscription required?

**NO.** Free tier sign-up requires only email verification.

## Alternatives

- Mixpanel free (100K MTU)
- Statsig (1M events)
- Amplitude free

## Swap cost

Medium — event names + property schemas would be re-mapped. Swap is
isolated behind `@chirag127/analytics`.

## Why this is our pick

The free tier is the most generous of any product-analytics tool, and
feature flags + A/B in the same place save a tool.

## Cross-refs

- [Cloudflare Web Analytics](./cloudflare-web-analytics.md)
- [Microsoft Clarity](./microsoft-clarity.md)
