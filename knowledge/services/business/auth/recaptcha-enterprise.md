---
type: service
title: "reCAPTCHA Enterprise"
description: "Bot-defense assessments wired into Firebase App Check — 10K/mo free"
tags: [security, captcha, google-cloud, audit-card]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: bot-defense-assessments
provider: google-cloud
free_tier: "10,000 assessments/month before per-call billing kicks in"
swap_cost: medium
---

# reCAPTCHA Enterprise

## Role

Provides assessments consumed by Firebase App Check. Wraps risk
scoring around Firestore reads/writes that originate from browsers.

## Free tier

- 10,000 assessments / month
- After 10K, $1 per 1,000 assessments (we never reach this)

## Card / subscription required?

**YES — flagged.** reCAPTCHA Enterprise lives inside Google Cloud
Platform. To enable the API on a project, GCP requires a billing
account linked to the project, even when usage stays inside the free
quota. The billing account itself requires a payment method.

This is a soft violation of the no-card-on-file rule. The family
accepts it because:

1. The free quota of 10K assessments / month is far above our traffic.
2. GCP free-tier usage does not auto-charge if usage stays below the
   threshold and quota alerts are configured.
3. Firebase App Check has no equivalent free provider that ties as
   cleanly into Firestore security rules.

If we choose to honor the rule strictly, swap to Cloudflare
Turnstile (free, unlimited, no GCP billing account) — see Alternatives.

## Alternatives

- **Cloudflare Turnstile** — free, unlimited, no card. Drop-in for
  most use-cases but App Check integration is custom.
- hCaptcha free
- Friendly Captcha

## Swap cost

Medium — App Check provider is configurable, but the verifier code in
`@chirag127/firebase-init` is reCAPTCHA-shaped today.

## Why this is our pick (with the caveat)

Tightest Firebase integration; verified-bot heuristics work without a
visible challenge for real users. The card requirement is the
trade-off we explicitly accept until we hit a strict no-card moment.

## Cross-refs

- [No card-on-file rule](../../rules/interaction/no-card-on-file.md) — exception documented
- [App Check](./app-check-firebase.md)
- [Firebase Spark](./firebase-spark.md)
