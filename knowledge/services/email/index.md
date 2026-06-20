---
type: index
title: "Email services"
description: "Three distinct email roles: transactional (Resend), marketing newsletter (EmailOctopus), technical newsletter (Buttondown)."
tags: [services, email, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Email services

Three distinct roles, never overlapping:

- **Transactional** — sign-in links, receipts, contact-form replies. One sender: [Resend](./resend.md).
- **Marketing newsletter** — general audience announcements, drip campaigns, hand-composed visual emails. [EmailOctopus](./email-octopus.md), 2.5K subs free.
- **Technical newsletter** — Markdown-native, API-driven digest for the developer audience. [Buttondown](./buttondown.md), 100 subs free.

The technical / marketing split is locked in
[`decisions/architecture/newsletter-split-buttondown-emailoctopus.md`](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md).
The Buttondown adapter is wired into
[`@chirag127/oriz-omnipost`](../../glossary/o-r/omnipost.md) per
[`decisions/architecture/cross-post-engine.md`](../../decisions/architecture/cross-post-engine.md).

| Service                          | Status   | One-line role                                                              |
| -------------------------------- | -------- | -------------------------------------------------------------------------- |
| [resend.md](./resend.md)         | active   | Transactional email (auth flows, receipts, alerts)                         |
| [email-octopus.md](./email-octopus.md) | active   | Marketing / general-audience newsletter — 2.5K subs, 10K sends/mo free |
| [buttondown.md](./buttondown.md) | active   | Technical / developer newsletter — Markdown native, API-driven, 100 subs   |
| [mailerlite.md](./mailerlite.md) | fallback | Marketing-email swap target                                                |

## Cross-refs

- [Newsletter split decision](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md)
- [Cross-post engine decision](../../decisions/architecture/cross-post-engine.md)
- [oriz-omnipost glossary](../../glossary/o-r/omnipost.md)
- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md)
