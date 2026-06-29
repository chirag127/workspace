---
type: service
title: "Cloudflare Email Routing"
description: "Free email forwarder — *@oriz.in and extension subdomains into Gmail"
tags: [email, forwarding, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: email-forward
provider: cloudflare
free_tier: "Up to 200 routing addresses per zone, unlimited forwarding volume"
swap_cost: low
---

# Cloudflare Email Routing

## Role

Receives mail for `*@oriz.in`, `*@oriz.me`, and per-extension
subdomains (`*@<ext>.oriz.in`) and **forwards** each address to the
user's single Gmail inbox. The family does NOT host mailboxes — it
only routes incoming mail. Outbound transactional email is sent from
[Resend](../email/resend.md), not from this routing layer.

## Free tier

- Up to **200 routing addresses per zone** (more than enough for the family — even with one address per site + per extension we're under 50).
- Unlimited forwarding volume.
- Catch-all rule supported (`*@oriz.in → primary-gmail@gmail.com`).
- Spam filtering on by default (Cloudflare's pre-filter; Gmail filters again on receipt).

## Card / subscription required?

**NO.** Same Cloudflare account as DNS / Pages / Workers. No payment
method needed. No upgrade path — Email Routing is free-only as a
product.

## Alternatives

- ImprovMX (free 25 aliases — tighter cap than CF)
- ForwardEmail.net
- Spaceship's built-in forwarder (would re-couple us to the registrar)
- Self-hosted Postfix on Oracle Cloud (rejected — Oracle Cloud is rejected family-wide)

## Swap cost

Low — change MX records at Cloudflare DNS, recreate aliases at the
new provider. Mail-in-flight during the swap routes to whichever MX
the sender's resolver caches; ~24h tail.

## Why this is our pick

- The family already runs DNS at Cloudflare; Email Routing is two clicks in the same dashboard.
- Free at any volume the family will hit.
- Catch-all + per-address rules cover both "anything-goes" addresses (e.g. tagging: `signups+stripe@oriz.in`) and curated ones (e.g. `support@oriz.in`).
- Pairs cleanly with [Resend](../email/resend.md) for outbound — receive on Cloudflare, send on Resend, both free.

## Implementation notes

- Cloudflare dashboard → Email → Email Routing → enable per zone.
- Default rule: `* → <user>@gmail.com` (catch-all).
- Per-purpose rules override:
  - `support@oriz.in → <user>@gmail.com` (with Gmail filter → label `oriz/support`)
  - `security@oriz.in → <user>@gmail.com` (filter → label `oriz/security` + star)
  - `noreply@oriz.in` → drop (used as `From:` for some Resend sends; we don't want replies)
- MX records: Cloudflare auto-creates `route1.mx.cloudflare.net`, `route2.mx.cloudflare.net`, `route3.mx.cloudflare.net`.
- SPF: `v=spf1 include:_spf.mx.cloudflare.net -all` PLUS Resend's include for outbound — verify the merged SPF doesn't blow the 10-lookup limit.
- DMARC: `v=DMARC1; p=quarantine; rua=mailto:dmarc@oriz.in;` (which itself forwards to Gmail).
- DKIM: Resend's keys for outbound signing; Email Routing forwards the original DKIM-verified state to Gmail.

## Cross-refs

- [Spaceship registrar + Cloudflare DNS decision](../../infrastructure/spaceship-registrar-cloudflare-dns.md)
- [Cloudflare DNS](./cloudflare-dns.md)
- [Spaceship registrar](./spaceship.md)
- [Resend — outbound transactional email](../email/resend.md)
- [No subscriptions anywhere](../../monetisation/no-subscriptions-anywhere.md)
