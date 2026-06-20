---
type: service
title: "keygen.sh"
description: "License-key fulfilment service — issues + validates keys for VS Code extensions, browser extensions premium tier, npm SDK paid tier."
tags: [billing, keygen, licensing, fulfilment]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: license-key-fulfilment
provider: keygen-sh
free_tier: "50 active licenses, unlimited validations, no card required"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/razorpay
  - services/payment/lemon-squeezy
  - glossary/d-h/extension-suffix
  - rules/no-card-on-file
---

# keygen.sh

## Role

Issues and validates license keys for any paid distribution that runs
outside a logged-in Firebase Auth session — VS Code extensions, the
premium tier of `oriz-<name>-ext` browser extensions (see
[`extension-suffix`](../../glossary/d-h/extension-suffix.md)), and
the paid tier of npm SDKs published under `@chirag127/*`. Triggered
by the Razorpay or Lemon Squeezy webhook landing in the Hono Worker:
on a successful purchase, the Worker calls keygen.sh's API to mint a
key, then emails it to the buyer via Resend.

## Free tier

- 50 active licenses
- Unlimited license validations (offline + online)
- 1 product, multiple distributions
- HMAC-signed key validation (works offline after first check-in)
- No card required

The 50-license cap is the binding constraint; once we cross 50 paid
license-keyed customers, we revisit. Subscription-based unlocks
through Firebase Auth do NOT count against this cap.

## Card / subscription required?

**NO.** Email-only sign-up. Free forever within the 50-license cap.

## How it fits

```
Buyer → Razorpay / Lemon Squeezy Checkout
      → webhook to api.oriz.in (Hono Worker)
      → Worker calls keygen.sh API to mint license
      → Worker calls Resend to email key to buyer
      → Buyer pastes key into VS Code extension / browser ext / SDK
      → Extension calls keygen.sh /validate (HMAC-signed)
```

## Alternatives

- LemonSqueezy License Keys (built-in, but tied to LS-only; doesn't
  fulfil Razorpay-bought keys)
- Gumroad license keys (would require Gumroad as a third checkout)
- Self-rolled HMAC keygen (cheaper, but no revocation dashboard)

## Swap cost

Low — keygen.sh's API is wrapped behind a `@chirag127/license-keygen`
package (planned). Swap to LS license keys is a webhook-handler
rewrite.

## Why this is our pick

Decouples key fulfilment from the checkout provider, so the same key
infrastructure works whether the buyer paid via Razorpay (India) or
Lemon Squeezy (international). 50-license free tier is enough until
we have meaningful paid-extension revenue.

## Cross-refs

- [Razorpay](./razorpay.md)
- [Lemon Squeezy](./lemon-squeezy.md)
- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [-ext suffix glossary](../../glossary/d-h/extension-suffix.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
