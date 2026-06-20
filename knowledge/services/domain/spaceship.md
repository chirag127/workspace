---
type: service
title: "Spaceship (registrar)"
description: "Existing domain registrar — chirag127 holds family domains here. NS records delegate to Cloudflare DNS; email forwards via Cloudflare Email Routing → Gmail."
tags: [domain, spaceship, registrar, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: domain-registrar
provider: spaceship
free_tier: "Free WHOIS privacy. Domain registration / renewal is paid (industry-standard wholesale-ish pricing)."
swap_cost: low
---

# Spaceship (registrar)

## Role

Holds the registration for `oriz.in`, `oriz.me`, and any other
family domains. Spaceship is the **registrar of record**; DNS hosting
is delegated to Cloudflare via NS records, and email forwarding goes
through [Cloudflare Email Routing](./cloudflare-email-routing.md) →
Gmail.

This **supersedes the family's earlier plan** to use
[Cloudflare Registrar](./cloudflare-registrar.md) — see the
[`spaceship-registrar-cloudflare-dns.md`](../../decisions/infrastructure/spaceship-registrar-cloudflare-dns.md)
decision file for context.

## Free tier / pricing

- Free WHOIS privacy (`Spaceship Privacy`).
- Domain registration / renewal is paid (e.g. `.in` ~₹800/yr, `.me` ~$25/yr, `.com` ~$10/yr — varies by TLD; promo pricing on first year).
- No registrar markup beyond standard pricing; the family treats domain renewal as a separate budget line, NOT as a free-tier service.
- Free DNS hosting included BUT we don't use it — DNS is delegated to Cloudflare.

## Card / subscription required?

**Yes**, only at registration / renewal — domains are inherently
paid. Holding existing domains at Spaceship needs a payment method
on file at the renewal moment. The family treats this as the same
narrow exception as [Cloudflare Registrar](./cloudflare-registrar.md):
domain renewal is the only place the [no-card-on-file rule](../../rules/no-card-on-file.md)
bends, because the alternative is losing the domain.

## Alternatives

- [Cloudflare Registrar](./cloudflare-registrar.md) — at-cost, same dashboard
- Namecheap
- Porkbun

## Swap cost

Low — initiate domain transfer (5-7 day process). DNS records stay
on Cloudflare DNS regardless of registrar, so a transfer is purely
a registrar swap with no resolution downtime.

## Why this is our pick

The user already runs Spaceship as their existing registrar across
their personal domains; consolidating the new `oriz*` domains there
keeps renewal management in one place rather than splitting across
Spaceship + Cloudflare Registrar.

## Implementation notes

- At Spaceship: set NS records to Cloudflare's nameservers (the pair Cloudflare assigns when adding the zone — typically `xxx.ns.cloudflare.com`).
- Verify NS propagation (`dig NS oriz.in`).
- All other DNS (A, AAAA, CNAME, MX, TXT) is managed at [Cloudflare DNS](./cloudflare-dns.md).
- Email forwarding for `*@oriz.in`, `*@oriz.me`, etc. goes through [Cloudflare Email Routing](./cloudflare-email-routing.md) — NOT Spaceship's email forwarder, so MX records point at Cloudflare.
- Renewal notices route to the user's primary Gmail; auto-renew enabled with a reminder window long enough to swap funding source if needed.

## Cross-refs

- [Spaceship registrar + Cloudflare DNS decision](../../decisions/infrastructure/spaceship-registrar-cloudflare-dns.md)
- [Cloudflare DNS](./cloudflare-dns.md)
- [Cloudflare Email Routing](./cloudflare-email-routing.md)
- [Cloudflare Registrar — alternative, not used today](./cloudflare-registrar.md)
- [No card-on-file rule — domain-renewal exception](../../rules/no-card-on-file.md)
