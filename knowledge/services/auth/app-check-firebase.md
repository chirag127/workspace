---
type: service
title: "Firebase App Check"
description: "Bot defense layer for Firestore — required by every security rule in the family."
tags: [firebase, security, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: firestore-bot-defense
provider: google-firebase
free_tier: "Unlimited"
swap_cost: high
---

# Firebase App Check

## Role

Every Firestore rule in the family requires `request.app != null` —
that's App Check. Issues short-lived tokens that prove a request came
from a real, attested client.

## Free tier

- Unlimited token issuance
- Unlimited verification calls
- Included in Firebase Spark

## Card / subscription required?

**NO** for App Check itself. Note: the family's chosen attestation
provider is reCAPTCHA Enterprise, which DOES need a GCP billing
account — see [recaptcha-enterprise.md](./recaptcha-enterprise.md).
If you swap to Turnstile-based attestation the card requirement
disappears.

## Alternatives

- App Check with debug provider (dev only)
- Custom attestation provider via App Check's BYO API
- No bot defense (NOT acceptable — every rule requires it)

## Swap cost

High — every Firestore rule references `appChecked()`. Removing it
means rewriting the rule file and accepting open access.

## Why this is our pick

It's the only Firestore-native bot defense. Mandatory by family
security rules.

## Cross-refs

- [Firebase Spark](./firebase-spark.md)
- [reCAPTCHA Enterprise](./recaptcha-enterprise.md) — attestation provider
- [Firestore rules](../../architecture/layer-3-auth-firebase-spark.md)
