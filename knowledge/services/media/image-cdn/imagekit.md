---
type: service
title: "ImageKit"
description: "Final image CDN fallback — 20 GB/mo + DAM, no card"
tags: [images, cdn, dam, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-cdn-fallback-2
provider: imagekit
free_tier: "20 GB bandwidth/mo, 20 GB media storage, unlimited transformations, DAM features"
swap_cost: medium
related:
  - services/media/image-cdn/cloudflare-images
  - services/media/image-cdn/wsrv-nl
  - services/business/tooling/imagekit
  - decisions/architecture/image-cdn-fallback-chain
  - rules/no-card-on-file
---

# ImageKit

## Role

Third / final link in the family's **3-tier image-CDN fallback
chain**. If both [Cloudflare Images](./cloudflare-images.md) and
[wsrv.nl](./wsrv-nl.md) are unavailable, the oriz-kit `<Image>`
wrapper resolves through an authenticated ImageKit endpoint. Doubles
as the family's DAM (digital-asset manager) for hand-curated
originals — see [tooling/imagekit.md](../tooling/imagekit.md) for
the original tooling-side entry.

## Free tier

- 20 GB bandwidth / month
- 20 GB media storage
- Unlimited transformations
- Unlimited requests
- DAM (folders, tags, search, version history)

## Card / subscription required?

**NO.** Free Developer plan: email-only sign-up, no card.

## Alternatives

- [Cloudflare Images](./cloudflare-images.md) — primary
- [wsrv.nl](./wsrv-nl.md) — fallback 1
- [Cloudinary](../tooling/cloudinary.md) — separate fallback already
  documented under tooling

## Swap cost

Medium — URL transform syntax differs across providers, but the
oriz-kit `<Image>` wrapper isolates this.

## Why this is our pick (for fallback 2)

The strongest free tier with a real DAM and a stable signed URL
scheme — useful both as a CDN-of-last-resort and as the canonical
home for hand-curated photo / illustration assets.

## Note on duplication

A separate entry [tooling/imagekit.md](../tooling/imagekit.md) covers
ImageKit's role as the family's image-tooling option. This file is
the **image-cdn-fallback-2** role specifically. Both reference the
same account and same free tier.

## Cross-refs

- [Image CDN fallback chain decision](../../decisions/architecture/image-cdn-fallback-chain.md)
- [Cloudflare Images](./cloudflare-images.md) — primary
- [wsrv.nl](./wsrv-nl.md) — fallback 1
- [tooling/imagekit](../tooling/imagekit.md) — sibling DAM entry
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
