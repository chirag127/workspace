---
type: service
title: "Cloudinary"
description: "Image CDN fallback — 25 monthly credits free"
tags: [images, cdn, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-fallback
provider: cloudinary
free_tier: "25 monthly credits (1 credit = 1k transformations OR 1 GB CDN bandwidth OR 1 GB storage)"
swap_cost: low
---

# Cloudinary

## Role

Second image CDN behind [ImageKit](./imagekit.md). The
[never-hit-quotas rule](../../rules/interaction/never-hit-quotas.md) requires a
documented swap target the moment the primary's free tier looks
likely to tip — Cloudinary is that target for images. ImageKit's 20
GB/month bandwidth covers the family at current scale; if a viral
post pushes us toward the cap, the family-wide image helper in
`@chirag127/oriz-kit` rewrites URLs to Cloudinary for the rest of
that month.

## Free tier

- 25 monthly credits (one credit = 1,000 transformations OR 1 GB CDN
  bandwidth OR 1 GB managed storage)
- Unlimited requests
- All transformations (resize, format, quality, AI background removal)
- Custom domains on free tier

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested,
no trial expiry.

## Alternatives

- [ImageKit](./imagekit.md) — primary
- imgix
- Cloudflare Images (paid)
- Sirv
- wsrv.nl (emergency open-proxy backup, no account needed)

## Swap cost

Low — both Cloudinary and ImageKit speak `<img src=...>` URLs with
inline transform parameters. Switching means changing the rewrite
rule in the <!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) -->
image helper. No origin migration: both can pull from
[Cloudflare R2](../compute/cloudflare-r2.md).

## Why this is our pick (as fallback)

Most generous no-card-required image CDN free tier after ImageKit.
The credit model gives us flexible headroom: 25 GB of CDN bandwidth
OR 25k transformations OR a mix. Plays well with the family
preference for swap-cost-low alternatives.

## Cross-refs

- [ImageKit](./imagekit.md) — primary image CDN
- [Cloudflare R2](../compute/cloudflare-r2.md) — origin
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
