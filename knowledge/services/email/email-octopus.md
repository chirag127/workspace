---
type: service
title: "EmailOctopus"
description: "Marketing email + newsletter — 2.5K subscribers / 10K emails per month free. Used for general / marketing audiences; Buttondown handles the technical-blog digest."
tags: [email, newsletter, marketing, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: marketing-email
provider: email-octopus
free_tier: "2,500 subscribers, 10,000 emails/month, automations, landing pages, signup forms"
swap_cost: low
related:
  - services/email/buttondown
  - services/email/resend
  - decisions/architecture/newsletter-split-buttondown-emailoctopus
---

# EmailOctopus

## Role

Sends **marketing / announcement** email to the family's general
audience — product launches, occasional digests, drip campaigns. The
**technical / developer** audience is served separately by
[Buttondown](./buttondown.md) per
[`decisions/architecture/newsletter-split-buttondown-emailoctopus.md`](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md).

Distinct from [Resend](./resend.md), which handles transactional
email (sign-in links, receipts, auto-replies) only.

| Audience                                         | Sender                            | Free tier                         |
| ------------------------------------------------ | --------------------------------- | --------------------------------- |
| General / marketing (visual editor, larger list) | EmailOctopus                      | 2,500 subs / 10K sends per month  |
| Technical / developer (Markdown, API-driven)     | [Buttondown](./buttondown.md)     | 100 subs                          |

## Free tier

- 2,500 subscribers
- 10,000 emails / month
- Automations and drip sequences
- Landing pages and signup forms
- Reports and analytics
- API access

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested.
Account review may apply on first send (standard for marketing email
providers).

## Alternatives

- [Buttondown](./buttondown.md) — sibling, technical/dev audience (100 subs)
- [MailerLite](./mailerlite.md) — fallback (1K subs)
- Sender (15K emails free)
- Mailchimp (paid past 500 contacts — rejected)
- Brevo / Sendinblue

## Swap cost

Low — subscriber list exports as CSV, imports into any alternative.
Templates are HTML, portable. Signup-form embeds are the only
hard-coded URL.

## Why this is our pick (for marketing)

2.5K subscribers / 10K sends without a card is the most generous
no-card-required free tier for **marketing-style** email. The
visual editor + landing-page builder fit hand-composed announcement
campaigns. For Markdown-native, API-driven technical digests we use
[Buttondown](./buttondown.md) — see
[`decisions/architecture/newsletter-split-buttondown-emailoctopus.md`](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md).

## Cross-refs

- [Buttondown](./buttondown.md) — sibling, technical/dev audience
- [Newsletter split decision](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md)
- [Resend](./resend.md) — transactional email only, not marketing
- [MailerLite](./mailerlite.md) — fallback marketing provider
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
