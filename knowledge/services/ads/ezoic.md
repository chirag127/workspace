---
type: service
title: "Ezoic"
description: "Fallback ad provider — no minimum traffic."
tags: [ads, monetisation, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: ad-network-fallback
provider: ezoic
free_tier: "No platform fee — Ezoic takes a revenue share of ad earnings; no minimum traffic"
swap_cost: low
---

# Ezoic

## Role

Documented fallback ad network for sites that monetize via ads
(distinct from the subscription path).

## Free tier / pricing

- No platform fee, no monthly cost
- Ezoic takes a share of ad revenue
- No minimum traffic requirement (unlike Mediavine / AdThrive)

## Card / subscription required?

**NO.** Sign-up is approval-based, not payment-based. No card on file.

## Alternatives

- [Mediavine](./mediavine.md) — better revenue, requires 50K monthly sessions
- Google AdSense
- Raptive (formerly AdThrive)

## Swap cost

Low — swap an ad-script tag in the site's `<head>` and ad slots in
the layout.

## Why fallback only

The family's primary monetization path is subscriptions via Razorpay,
not ads. Ezoic is documented for sites where ads make sense and
traffic is too low for Mediavine.

## Cross-refs

- [Mediavine](./mediavine.md)
- [Razorpay](../payment/razorpay.md) — primary monetization path
