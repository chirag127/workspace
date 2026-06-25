---
type: service
title: "Open Collective"
description: "Transparent fund accounting for OSS / community projects — every transaction public, fiscal-host model, free for OSS, 5% platform fee for non-OSS."
tags: [donations, opencollective, transparent, oss, fiscal-host]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: donation-transparent
provider: open-collective
free_tier: "Free for OSS / community projects via the OSS fiscal hosts (Open Source Collective 501(c)(6), Open Collective Europe, etc.); ~5% platform fee for non-OSS hosts; payment-processor fees apply on top"
swap_cost: low
related:
  - decisions/monetisation/max-payment-methods
  - services/payment/github-sponsors
  - services/payment/ko-fi
  - services/payment/buymeacoffee
  - services/payment/polar-sh
  - services/payment/liberapay
---

# Open Collective

## Role

**Transparent fund accounting** rail on the family-wide `/support`
page. The point isn't competitive fees (it's mid-range at ~5% for
non-OSS hosts) — it's that **every donation and every expense is
public**. For visitors who want their support to be auditable
("where did that ₹500 actually go?"), Open Collective is the only
rail in the family stack that answers that question by design.

## Free tier

- **Free** when joining one of the OSS-aligned fiscal hosts
  (Open Source Collective 501(c)(6) for US-tax-deductible donations,
  Open Collective Europe for EU, Open Collective NZ, etc.)
- ~5% platform fee for non-OSS fiscal hosts
- Payment-processor fees on top (Stripe ~2.9% + 30¢, paid by donor)
- Public ledger — every donation, every expense, every reimbursement
  visible at `opencollective.com/<slug>`
- Recurring + one-off donations
- Expense submission + approval workflow built in (collective
  members submit; admins approve; OC issues payouts)

## Card / subscription required?

**NO.** Free-tier sign-up is email + collective application to a
fiscal host. No payment method requested from us.

## Methods exposed to the donor

Card (Stripe), Apple Pay, Google Pay, ACH (US), bank transfer (EU
SEPA via OC Europe), PayPal, gift cards. Donor optionally publishes
their name on the public ledger or stays anonymous.

## Why "transparent" matters in the family stack

Open Collective is the only rail that publishes a verifiable
**where-the-money-goes** trail. If the family's `/support` page ever
needs to credibly say "your contribution funded the Cloudflare
domain renewal" or "your contribution covered the GitHub Pages
storage costs", the OC ledger backs that claim with a public expense
record. The other donation rails (Ko-fi, BMC, Sponsors) deposit
funds into a personal account with no public accounting — same
person, same outcome, no audit trail.

## Where it sits on /support

In the donations grid alongside
[GitHub Sponsors](./github-sponsors.md), [Ko-fi](./ko-fi.md),
[Buy Me a Coffee](./buymeacoffee.md), and
[Liberapay](./liberapay.md). Tagged "transparent ledger" so
trust-sensitive donors self-route here.

## Alternatives

- [GitHub Sponsors](./github-sponsors.md) — 0% platform, dev-targeted
- [Ko-fi](./ko-fi.md) — 0% platform, broader UX
- [Buy Me a Coffee](./buymeacoffee.md) — 5% platform, similar UX
- [Liberapay](./liberapay.md) — 0% platform, recurring-only
- [Polar.sh](./polar-sh.md) — OSS-friendly checkout with MoR

## Swap cost

Low — single button on `/support`; deep-link is
`https://opencollective.com/<slug>/donate`. The collective itself is
the fiscal-host's record, not ours; if we ever close the collective
we point the URL at one of the other donation rails.

## Why this is our pick

- **Transparency by default** — covers the "where does the money
  go?" trust gap none of the other rails address
- **Free for OSS** via the Open Source Collective fiscal host (no
  card required, no monthly platform fee)
- **501(c)(6) tax receipts** for US donors via OSC — the only rail
  in the family stack that issues US-tax-deductible receipts
- **Mature** (founded 2015) and well-funded; low operational risk
- **Coexists cleanly** with the other donation rails — no overlap
  on audience or motivation

## Quirks worth knowing

- Open Collective requires a **collective application** to a fiscal
  host before it goes live; not instant.
- The public ledger is a feature, not a bug — donors who want
  privacy use a different rail (Liberapay or BMC).
- Expense submissions require receipts attached, which adds
  bookkeeping discipline that the other rails don't enforce.

## Cross-refs

- [Max payment methods decision](../../decisions/monetisation/max-payment-methods.md)
- [GitHub Sponsors (0% fee, dev-targeted)](./github-sponsors.md)
- [Ko-fi (0% fee, broader UX)](./ko-fi.md)
- [Buy Me a Coffee (5% fee)](./buymeacoffee.md)
- [Liberapay (0% fee, recurring-only)](./liberapay.md)
- [Polar.sh (OSS-friendly checkout)](./polar-sh.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
