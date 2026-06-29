---
type: service
title: "Mediavine"
description: "Fallback ad provider — higher RPM, requires 50K sessions/month"
tags: [ads, monetisation, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: ad-network-fallback
provider: mediavine
free_tier: "No platform fee — revenue share. Requires 50,000 monthly sessions for entry."
swap_cost: low
---

# Mediavine

## Role

Documented fallback ad network for sites that have grown past the
50K-sessions/month threshold.

## Free tier / pricing

- No platform fee, no monthly cost
- Mediavine takes a revenue share
- **50,000 monthly sessions minimum** to qualify

## Card / subscription required?

**NO.** Application-based (manual approval). No card on file required.

## Alternatives

- [Ezoic](./ezoic.md) — no minimum traffic
- Raptive
- Google AdSense

## Swap cost

Low — ad-script tag + slot updates.

## Why fallback only

Higher RPM than Ezoic but the 50K threshold gates entry. Most family
sites are pre-50K. Subscriptions remain the primary monetization.

## Cross-refs

- [Ezoic](./ezoic.md)
- [Razorpay](../payment/razorpay.md)
