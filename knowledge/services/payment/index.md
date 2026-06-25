---
type: index
title: "Payment services"
description: "Every payment rail the family supports — geo-routed checkout, license-key fulfilment, OSS-friendly checkout, and nine donation channels on /support."
tags: [services, payment, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Payment services

Routing logic + the locked decision behind these picks lives at
[`decisions/monetisation/max-payment-methods.md`](../../decisions/monetisation/max-payment-methods.md).
The full rail count is now **12** — three checkouts (India + international + OSS-friendly),
one license-key fulfilment, and eight donation channels.

| Service | Status | Role | Tier / fee |
|---|---|---|---|
| [razorpay.md](./razorpay.md) | active | Checkout — Indian buyers (UPI / cards / netbanking / wallets / EMI / pay-later) | 2-3% per txn, no monthly fee |
| [lemon-squeezy.md](./lemon-squeezy.md) | active | Checkout — international buyers, merchant-of-record (auto VAT/GST) | 5% + 50¢ per txn, no monthly fee |
| [polar-sh.md](./polar-sh.md) | active | Checkout — OSS-friendly merchant-of-record (sponsor + product + subscription) | 4% + 40¢ per txn, no monthly fee |
| [keygen-sh.md](./keygen-sh.md) | active | License-key fulfilment for VS Code ext / browser ext premium / npm SDK paid | 50 active licenses free, no card |
| [github-sponsors.md](./github-sponsors.md) | active | Donations — developer-targeted | 0% platform fee |
| [ko-fi.md](./ko-fi.md) | active | Donations — creator-targeted | 0% platform fee |
| [buymeacoffee.md](./buymeacoffee.md) | active | Donations — creator-targeted (alt. to Ko-fi) | 5% platform fee |
| [liberapay.md](./liberapay.md) | active | Donations — recurring-only (weekly/monthly), OSS, EU-friendly | 0% platform fee |
| [opencollective.md](./opencollective.md) | active | Donations — transparent fund accounting, public ledger | Free for OSS hosts; ~5% non-OSS |
| [paypal-me.md](./paypal-me.md) | active | P2P payout link (international tippers) | F&F free, G&S ~3.49% |
| [upi-direct.md](./upi-direct.md) | active | P2P direct (Indian-resident inbound, zero-fee) | 0% — UPI is NPCI infra |
| [crypto-bitcoinaddr.md](./crypto-bitcoinaddr.md) | active | Crypto fallback (BTC / ETH / USDC) — self-custody | 0% platform, on-chain fees only |

Webhook reliability for Razorpay → Worker delivery is layered through
Hookdeck — see [tooling/hookdeck.md](../tooling/hookdeck.md). Lemon
Squeezy webhooks route through the same Hookdeck queue.

## Cross-refs

- [decisions/monetisation/max-payment-methods](../../decisions/monetisation/max-payment-methods.md)
- [decisions/monetisation/razorpay-as-primary-billing](../../decisions/monetisation/razorpay-as-primary-billing.md)
- [decisions/monetisation/one-subscription-unlocks-all](../../decisions/monetisation/one-subscription-unlocks-all.md)
- [decisions/infrastructure/hookdeck-for-webhook-reliability](../../decisions/infrastructure/hookdeck-for-webhook-reliability.md)
- [rules/no-card-on-file](../../rules/interaction/no-card-on-file.md)
