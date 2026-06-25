---
type: index
title: "Image CDN services"
description: "3-tier fallback chain for image delivery: Cloudflare Images → wsrv.nl → ImageKit."
tags: [services, image-cdn, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Image CDN services

The family runs a **3-tier fallback chain** for every image rendered
through the `@chirag127/oriz-kit` `<Image>` wrapper:

1. **[Cloudflare Images](./cloudflare-images.md)** — primary. Same
   edge as our Pages deploys, bundled with the free Pages plan.
2. **[wsrv.nl](./wsrv-nl.md)** — fallback 1. Public URL-transform
   proxy, no signup, no auth — survives outages of any authenticated
   provider.
3. **[ImageKit](./imagekit.md)** — fallback 2. 20 GB/mo + real DAM,
   email-only signup.

The chain is documented in
[`decisions/architecture/image-cdn-fallback-chain.md`](../../decisions/architecture/image-cdn-fallback-chain.md).
The kit's `<Image>` wrapper owns the `onError` handoff between rungs.

| Service | Status | Role | Free tier headline |
|---|---|---|---|
| [cloudflare-images.md](./cloudflare-images.md) | active | image-cdn-primary | Bundled with Pages free |
| [wsrv-nl.md](./wsrv-nl.md) | active | image-cdn-fallback-1 | Public proxy, no account |
| [imagekit.md](./imagekit.md) | active | image-cdn-fallback-2 | 20 GB/mo + DAM |

## Note on prior tooling/ entries

A separate [tooling/imagekit.md](../tooling/imagekit.md) and
[tooling/cloudinary.md](../tooling/cloudinary.md) pre-date this
fallback chain. Those entries continue to document ImageKit and
Cloudinary as **tooling** picks (DAM / transforms / general image
ops). The files in this directory document them as **CDN
fallback** roles specifically. Both views are valid.

## Cross-refs

- [Image CDN fallback chain decision](../../decisions/architecture/image-cdn-fallback-chain.md)
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
