---
type: service
title: "wsrv.nl"
description: "Public URL-transform image proxy — second link in the 3-tier fallback chain. No signup, no auth, no card."
tags: [images, cdn, proxy, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-cdn-fallback-1
provider: wsrv-nl
free_tier: "Public service — no signup, no auth, no quota declared, no card"
swap_cost: low
related:
  - services/image-cdn/cloudflare-images
  - services/image-cdn/imagekit
  - decisions/architecture/image-cdn-fallback-chain
  - rules/no-card-on-file
---

# wsrv.nl

## Role

Second link in the family's **3-tier image-CDN fallback chain**.
When [Cloudflare Images](./cloudflare-images.md) returns 5xx the
oriz-kit `<Image>` wrapper retries against wsrv.nl, which is a
public URL-transform proxy. Origin URL goes in a query param, the
service applies the transforms in URL space and streams back the
result — no API key, no signup.

## Free tier

- Public service — no account, no auth header, no quota table
- URL-driven: `https://wsrv.nl/?url=<encoded-src>&w=<width>&h=<height>&q=<quality>&output=<format>`
- WebP / AVIF / JPEG / PNG output supported
- Caching is handled by the wsrv.nl edge

## Card / subscription required?

**NO.** wsrv.nl has no concept of an account; there is nothing to
attach a card to. It runs on a donation model.

## Alternatives

- [Cloudflare Images](./cloudflare-images.md) — primary
- [ImageKit](./imagekit.md) — fallback 2 (DAM + 20 GB/mo)
- statically.io — similar URL-transform proxy

## Swap cost

Low — URL-transform syntax. The kit wrapper owns the helper.

## Why this is our pick (for fallback 1)

It's the only well-known image proxy that requires no account and
no card, so it can survive failures of any authenticated provider
without operator intervention. Sits between our auth'd primary and
auth'd secondary as the "always available" middle rung.

## Cross-refs

- [Image CDN fallback chain decision](../../decisions/architecture/image-cdn-fallback-chain.md)
- [Cloudflare Images](./cloudflare-images.md) — primary
- [ImageKit](./imagekit.md) — fallback 2
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
