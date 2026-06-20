---
type: rule
title: "No subscription required for any service we use"
description: "Stricter than no-card-on-file. No service that requires a subscription to use, ever. No 'free trial then pay'. Free tier must be perpetual and unconditional."
tags: [rules, billing, free-tier, sustainability]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/no-card-on-file
  - rules/never-hit-quotas
  - services/index
---

# No subscription required for any service we use

No service in the family stack may require a recurring subscription
to use. The free tier we depend on must be perpetual and
unconditional — not "free for 14 days", not "free for the first 1000
users then pay", not "free during beta".

## Why

This is stricter than [no-card-on-file](./no-card-on-file.md) and
catches a different failure mode:

- **No-card** stops the bleeding when something goes wrong.
- **No-subscription** ensures nothing CAN go wrong because the bill
  never starts.

Any service with a subscription dependency is a future single-point-of-
failure: the day they raise prices, change tiers, or kill the free
plan, every site that depends on it breaks. We pick services where the
free tier is the sustainable business model (ad-supported, freemium-
upsell, infrastructure-cost-near-zero), not services where the free
tier is a customer-acquisition cost.

## What this means concretely

- "Free trial, then $X/month" services are excluded outright.
- "Free for personal use, paid for commercial" services are excluded
  if any of our sites monetise (most do, via AdSense + Razorpay).
- "Free tier with credit card required to sign up" is excluded by the
  no-card rule already, but doubly excluded here.
- A locked pick that quietly moves its free tier behind a subscription
  triggers an immediate swap to the documented alternative (see the
  service catalog's "swap cost" column).

## Exceptions

None. If a feature can only be built on a subscription-gated service,
the feature is wrong, or the package wrapping that service should
abstract it so the next provider drops in.

## See also

- [`no-card-on-file.md`](./no-card-on-file.md) — the broader rule
- AGENTS.md service catalog — every service must have a documented
  alternative
