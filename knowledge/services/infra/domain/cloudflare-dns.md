---
type: service
title: "Cloudflare DNS"
description: "DNS host for oriz.in and all subdomains — free, fast, same dashboard"
tags: [dns, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: dns-host
provider: cloudflare
free_tier: "Unlimited domains, unlimited records, anycast DNS, free DDoS protection"
swap_cost: low
---

# Cloudflare DNS

## Role

Hosts every zone for the family — `oriz.in`, `auth.oriz.in`,
`api.oriz.in`, per-site subdomains.

## Free tier

- Unlimited zones / records
- Anycast DNS, sub-15ms global resolution
- Free DDoS protection
- DNSSEC included

## Card / subscription required?

**NO.** Free plan needs only the same Cloudflare account.

## Alternatives

- dns.he.net (Hurricane Electric)
- deSEC
- Hetzner DNS

## Swap cost

Low — zone export is BIND format, importable anywhere.

## Why this is our pick

Same dashboard, automatic Pages / Workers / R2 wiring, free DDoS
protection bundled.

## Cross-refs

- [Cloudflare Registrar](./cloudflare-registrar.md)
- [Cloudflare Pages](../hosting/cloudflare-pages.md)
