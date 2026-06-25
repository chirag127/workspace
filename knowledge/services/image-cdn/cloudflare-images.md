---
type: service
title: "Cloudflare Images"
description: "Primary image CDN — first link in the 3-tier fallback chain. Free tier shipped with Cloudflare Pages, no card."
tags: [images, cdn, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-cdn-primary
provider: cloudflare
free_tier: "Bundled with Cloudflare Pages free; transformations + delivery counted against Pages plan, no card required"
swap_cost: low
related:
  - services/image-cdn/wsrv-nl
  - services/image-cdn/imagekit
  - decisions/architecture/image-cdn-fallback-chain
  - decisions/infrastructure/cloudflare-pages-for-all-sites
  - rules/no-card-on-file
---

# Cloudflare Images

## Role

First link in the family's **3-tier image-CDN fallback chain**. Every
`<Image>` rendered through `@chirag127/oriz-kit` first attempts to
resolve through Cloudflare Images — co-located with our Pages
deployments, served from the same edge as the originating site, no
extra DNS hop. On 5xx (or transformation error) the kit's wrapper
falls through to [wsrv.nl](./wsrv-nl.md), then to
[ImageKit](./imagekit.md). See
[`decisions/architecture/image-cdn-fallback-chain.md`](../../decisions/architecture/image-cdn-fallback-chain.md).

## Free tier

- Bundled with the Cloudflare Pages free plan
- Image Resizing + Polish + WebP/AVIF auto-conversion at the edge
- Per-Pages-project quota — no separate billing surface
- All variants reachable at `/cdn-cgi/image/<opts>/<src>` URLs

## Card / subscription required?

**NO.** Cloudflare Images on the free Pages plan does not require a
billing method. The paid Cloudflare Images product (the standalone
SKU at `imagedelivery.net`) is a separate add-on and is **not** what
we use — we use the Pages-bundled transform endpoint only.

## Alternatives

- [wsrv.nl](./wsrv-nl.md) — fallback 1 (URL-transform proxy, no auth)
- [ImageKit](./imagekit.md) — fallback 2 (20 GB/mo, DAM features)
- Cloudinary — already documented under [tooling/cloudinary.md](../tooling/cloudinary.md)

## Swap cost

Low — the Astro `<Image>` wrapper in `@chirag127/oriz-kit` owns the
URL composition. Changing primary means swapping one helper.

## Why this is our pick

Same edge as our Pages sites, no separate signup, no card. First-link
latency is best-in-class because the request never leaves the
Cloudflare edge.

## Cross-refs

- [Image CDN fallback chain decision](../../decisions/architecture/image-cdn-fallback-chain.md)
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- [wsrv.nl](./wsrv-nl.md)
- [ImageKit](./imagekit.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
