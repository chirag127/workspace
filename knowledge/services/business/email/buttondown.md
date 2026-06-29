---
type: service
title: "Buttondown"
description: "Developer-friendly newsletter — Markdown-native, API-first, 100 subs free"
tags: [email, newsletter, technical, markdown, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: newsletter-developer
provider: buttondown
free_tier: "100 subscribers, Markdown-native composition, full REST API, RSS-to-email automation, custom domain"
swap_cost: low
related:
  - services/business/email/email-octopus
  - services/business/email/resend
  - decisions/architecture/newsletter-split-buttondown-emailoctopus
  - decisions/architecture/cross-post-engine
  - rules/no-card-on-file
---

# Buttondown

## Role

The family's **technical / developer audience** newsletter. Used by
[oriz-blog-site](../../glossary/o-r/oriz.md) as the digest sender for
deep-dive engineering posts and by the
[`@chirag127/oriz-omnipost`](../../glossary/o-r/omnipost.md) cross-post
engine as one of its publish targets.

Distinct from [EmailOctopus](./email-octopus.md), which sends visual
marketing campaigns to a wider audience. Different audience, different
tone, different free-tier ceiling.

## Free tier

- 100 subscribers
- Markdown-native composition (the editor is Markdown, not WYSIWYG)
- Full REST API (programmatic publish + subscriber management)
- RSS-to-email automation
- Custom domain for sending
- Embed-able subscribe form

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested.

## Alternatives

- [EmailOctopus](./email-octopus.md) — sibling, larger audience tier
- [MailerLite](./mailerlite.md) — fallback marketing
- [Resend](./resend.md) — transactional only, not newsletter
- Substack — rejected, takes a 10% cut and platform-locks the audience

## Swap cost

Low — Markdown content + CSV subscriber list export to anywhere. The
oriz-omnipost adapter wraps the API behind the standard adapter
interface from
[`decisions/architecture/cross-post-engine.md`](../../decisions/architecture/cross-post-engine.md).

## Why this is our pick (for the developer audience)

Markdown + REST API + RSS-to-email is the right shape for a
technical-blog digest where the content already lives as Markdown
files in a git repo. WYSIWYG marketing tools (EmailOctopus,
MailerLite) are wrong for that workflow — they fight the source of
truth. Buttondown's 100-subscriber cap is fine for a deep-dive
newsletter that doesn't want a wide audience.

## Cross-refs

- [Newsletter split decision](../../decisions/architecture/newsletter-split-buttondown-emailoctopus.md)
- [EmailOctopus](./email-octopus.md) — marketing audience
- [Resend](./resend.md) — transactional
- [oriz-omnipost glossary](../../glossary/o-r/omnipost.md)
- [Cross-post engine decision](../../decisions/architecture/cross-post-engine.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
