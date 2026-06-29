---
type: index
title: "Domain services"
description: "DNS hosting and domain registrar — both Cloudflare."
tags: [services, domain, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Domain services

Three roles across two vendors: **Spaceship** is the registrar of record (the user's existing registrar), **Cloudflare** hosts DNS via NS delegation, and **Cloudflare Email Routing** forwards every `*@oriz.*` address to a single Gmail inbox. The full architecture is locked at [`infrastructure/spaceship-registrar-cloudflare-dns.md`](../../infrastructure/spaceship-registrar-cloudflare-dns.md).

| Service | Status | One-line role |
|---|---|---|
| [spaceship.md](./spaceship.md) | active | Domain registrar of record — `oriz.in`, `oriz.me`, future family domains (NEW 2026-06-20) |
| [cloudflare-dns.md](./cloudflare-dns.md) | active | Free DNS hosting (NS-delegated from Spaceship) for `oriz.in` and every subdomain |
| [cloudflare-email-routing.md](./cloudflare-email-routing.md) | active | Free email forwarding `*@oriz.in` / `*@oriz.me` → single Gmail inbox (NEW 2026-06-20) |
| [cloudflare-registrar.md](./cloudflare-registrar.md) | swap-target | Documented swap target if Spaceship is ever moved away from |

## Cross-refs

- [Spaceship registrar + Cloudflare DNS decision](../../infrastructure/spaceship-registrar-cloudflare-dns.md)
- [Subdomains under oriz.in](../../infrastructure/subdomains-under-oriz-in.md)
- [Cloudflare Pages for all sites](../../infrastructure/cloudflare-pages-for-all-sites.md)
