---
type: service
title: "Cloudflare Registrar"
description: "Domain registrar at wholesale cost — no markup, free WHOIS privacy"
tags: [domain, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: domain-registrar
provider: cloudflare
free_tier: "At-cost pricing (no markup), free WHOIS privacy, free DNSSEC. Domain itself is paid."
swap_cost: low
---

# Cloudflare Registrar

## Role

Holds the registration for `oriz.in` and any other domains the family
acquires.

## Free tier / pricing

- At-cost: Cloudflare passes through wholesale prices (e.g. .com ~$10/yr)
- Free WHOIS privacy
- Free DNSSEC
- Cloudflare itself takes no margin

## Card / subscription required?

**Yes**, but only at the moment of domain purchase / renewal —
domains are inherently paid. Holding an existing domain at Cloudflare
needs a payment method tied to renewals; some users accept this as a
narrow exception to no-card-on-file because the alternative is losing
the domain. The family treats domain renewal as a separate budget
line, not a free-tier service.

## Alternatives

- Namecheap
- Spaceship
- Porkbun

## Swap cost

Low — initiate domain transfer (5-7 day process). DNS records move
with the zone (kept on Cloudflare DNS regardless of registrar).

## Why this is our pick

Wholesale pricing, no markup, integrates with the same dashboard.

## Cross-refs

- [Cloudflare DNS](./cloudflare-dns.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md) — domain-renewal exception
