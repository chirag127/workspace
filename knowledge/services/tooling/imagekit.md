---
type: service
title: "ImageKit"
description: "Image CDN + on-the-fly transforms — 20 GB bandwidth/month free."
tags: [images, cdn, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-cdn-and-transforms
provider: imagekit
free_tier: "20 GB bandwidth/mo, 20 GB media storage, unlimited transformations"
swap_cost: medium
---

# ImageKit

## Role

Sits in front of [Cloudflare R2](../compute/cloudflare-r2.md) (or any origin)
and serves transformed / optimized images to every site.

## Free tier

- 20 GB bandwidth / month
- 20 GB media storage
- Unlimited transformations
- Unlimited requests

## Card / subscription required?

**NO.** Free Developer plan: email-only sign-up, no card.

## Alternatives

- Cloudinary (25 credits/mo)
- imgix
- Cloudflare Images
- Sirv

## Swap cost

Medium — URL transform syntax differs across providers. Wrap behind
a small `getImageUrl(src, transforms)` helper.

## Why this is our pick

Truly free at our scale, transforms are powerful, R2-as-origin is
documented.

## Cross-refs

- [Cloudflare R2](../compute/cloudflare-r2.md) — origin
