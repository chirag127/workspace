---
type: service
title: "Cloudflare Web Analytics"
description: "Privacy-friendly pageview analytics — free, no cookie banner"
tags: [analytics, cloudflare, privacy, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: web-analytics
provider: cloudflare
free_tier: "Unlimited pageviews, no event quota, no retention cap"
swap_cost: low
---

# Cloudflare Web Analytics

## Role

Tracks pageviews + Core Web Vitals on every site. No cookies, no
PII, so no cookie banner needed in EU.

## Free tier

- Unlimited pageviews
- Unlimited sites
- Real User Monitoring (Web Vitals) included
- Forever-free

## Card / subscription required?

**NO.** Same Cloudflare account, no billing.

## Alternatives

- Umami self-hosted
- Plausible self-hosted
- Rybbit
- GoatCounter

## Swap cost

Low — replace the `<script>` tag in the kit's `<head>`.

## Why this is our pick

Truly free, no banner needed, integrated with Cloudflare Pages so the
beacon is fast. Pairs with [Microsoft Clarity](./microsoft-clarity.md)
for session recording and [PostHog](./posthog.md) for product
analytics.

## Cross-refs

- [Microsoft Clarity](./microsoft-clarity.md)
- [PostHog](./posthog.md)
