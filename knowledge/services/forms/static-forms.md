---
type: service
title: "Static Forms"
description: "Form-submission backend — fallback to Web3Forms. Free unlimited submissions. No card. Different vendor + edge so a Web3Forms outage / quota cliff never takes contact forms down."
tags: [forms, contact, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: contact-form-backend-fallback
provider: static-forms
free_tier: "Unlimited submissions, unlimited forms, email forwarding, spam filtering, file attachments, no per-month cap"
swap_cost: low
related:
  - services/forms/web3forms
  - services/forms/tally
  - decisions/architecture/forms-trio
  - rules/no-card-on-file
---

# Static Forms

## Role

The **fallback** contact-form backend. The `<ContactForm>` component
in <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) --> posts to
[Web3Forms](./web3forms.md) by default; on `5xx` / network failure
or when an env-var flips, the same payload goes to Static Forms
instead. Different vendor, different edge — a Web3Forms outage or
quota cliff never blocks contact submissions across the family.

## Free tier

- Unlimited submissions per form
- Unlimited forms
- Email forwarding to any address
- Spam filtering (built-in honeypot + reCAPTCHA opt-in)
- File attachments
- No per-month cap, no per-form cap documented at family scale

## Card / subscription required?

**NO.** Email-only signup; the form's access key arrives via email.
No payment method requested.

## Alternatives

- [Web3Forms](./web3forms.md) — primary; Static Forms is its sibling.
- [Formspree](./formspree.md) — second documented swap target.
- [Tally](./tally.md) — different role (rich, multi-step forms).

## Swap cost

**Low.** Same `application/x-www-form-urlencoded` shape as Web3Forms.
The fallback is wired by toggling the `<ContactForm>` component's
`provider` prop at build time per site, or by `onError` handler at
runtime. Wrapped behind a single import surface in oriz-kit.

## Why this is our pick

The user's direction was: *"I want a free service for everything"*
plus *"+ Static Forms"* — interpreted as defense-in-depth on the
contact-form path. Web3Forms covers the common case; Static Forms is
the sibling on a different vendor + different edge so neither a
vendor outage nor an unannounced quota cap can break "users can
contact us."

## Cross-refs

- [Forms services index](./index.md)
- [Web3Forms — primary sibling](./web3forms.md)
- [Tally — rich form builder, different role](./tally.md)
- [Forms trio decision](../../decisions/architecture/forms-trio.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
