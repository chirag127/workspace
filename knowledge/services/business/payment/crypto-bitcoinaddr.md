---
type: service
title: "Crypto addresses (BTC / ETH / USDC)"
description: "Crypto wallet addresses for tips — no KYC, tax-reportable"
tags: [donations, crypto, bitcoin, ethereum, usdc, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: crypto-fallback
provider: self-custody
free_tier: "Free — wallets are self-custodial; only on-chain network fees apply (paid by sender)"
swap_cost: low
related:
  - monetisation/max-payment-methods
  - services/business/payment/paypal-me
  - rules/no-card-on-file
---

# Crypto addresses (BTC / ETH / USDC)

## Role

Fallback donation channel for senders who specifically want to tip in
crypto — privacy-preferring donors, international tippers in
banking-restricted countries, and the "I have crypto sitting around"
crowd. Lives on the family-wide `/support` page as three labelled
addresses + QR codes.

## Free tier

- Free — self-custodial wallets. No platform fee, no monthly fee
- Only on-chain network fees (paid by the sender, not by us)
- No exchange / no custodian — addresses point to a self-custodied
  hardware wallet

## Methods exposed to the sender

- BTC — native Bitcoin address (bc1… bech32)
- ETH — Ethereum mainnet address (0x…)
- USDC — same Ethereum mainnet address; USDC ERC-20 contract

L2s (Base, Arbitrum, Optimism) deliberately omitted from the public
support page to keep instructions short. Power users can ask.

## Card / subscription required?

**NO.** Self-custody — we hold the private keys offline.

## Caveats

- **Tax-reportable.** Crypto receipts are taxable income at fair
  market value at the moment of receipt under Indian crypto-tax law
  (Section 115BBH at 30% flat + 1% TDS on transfers > threshold).
  Track every inbound transaction with USD/INR FMV at receipt time
  for annual filing.
- **No refunds, no chargebacks.** Once received, a payment is
  irreversible — fine for tips, never use for paid-product checkout.
- **No KYC needed from the sender** — that is the entire point.

## Alternatives

- Coinbase Commerce — would add KYC + a custodian (rejected: card on
  file with Coinbase, plus they're a custodian)
- BTCPay Server (self-hosted) — rejected family-wide per the
  no-self-host rule
- OpenNode — Lightning + on-chain, but requires KYC + business
  account

## Swap cost

Low — three address strings + three QR images on the `/support`
page.

## Why this is our pick

Self-custody addresses are the simplest, fee-free, KYC-free way to
accept tips from senders who want crypto. Pairing them with the
fiat channels (UPI / PayPal / Ko-fi / BMC) gives donors maximum
choice.

## Cross-refs

- [Max payment methods decision](../../monetisation/max-payment-methods.md)
- [PayPal.me](./paypal-me.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
