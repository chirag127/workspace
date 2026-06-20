---
type: service
title: "Repo-hosted images on Cloudflare Pages"
description: "Tier 1 image origin — static image files committed to each site's repo, served from Cloudflare Pages alongside the rest of the site."
tags: [images, host, origin, repo-hosted, cloudflare-pages, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-host-primary
provider: cloudflare-pages + git
free_tier: "Unlimited static asset bandwidth on Cloudflare Pages free; image bytes count against the same plan as the HTML they ship with — no separate quota"
swap_cost: low
related:
  - services/image-host/imgbb
  - services/image-host/imgur
  - services/image-host/github-user-content
  - services/image-cdn/cloudflare-images
  - decisions/architecture/image-host-four-tier
  - decisions/architecture/cms-markdown-in-repo-only
  - decisions/infrastructure/cloudflare-pages-for-all-sites
  - rules/no-card-on-file
---

# Repo-hosted images on Cloudflare Pages

## Role

**Tier 1 origin** in the family's [4-tier image-host chain](../../decisions/architecture/image-host-four-tier.md).
The default image storage for everything that fits naturally in the
repo — blog-post screenshots, hero images, og:image source files,
diagrams, icons. The image lives next to the `.mdx` file that
embeds it; deploy of the site is deploy of the image.

This is the natural pair for the
[markdown-in-repo-only CMS lock](../../decisions/architecture/cms-markdown-in-repo-only.md).

## Free tier

- Cloudflare Pages free plan ships **unlimited bandwidth** on static
  assets — image bytes count against the same envelope as the HTML
  they ship with, no separate billing surface
- 500 builds / month per project (well clear of family scale)
- 25 MB hard limit per asset (the rare > 25 MB asset falls to
  [Tier 4 GitHub user-content](./github-user-content.md))
- Files served from the same edge as the rest of the site — no
  cross-origin DNS hop, no CORS dance

## Card / subscription required?

**NO.** This rides the existing Pages free plan; no extra signup, no
card.

## How it works

1. Author drops `hero.png` into `oriz-blog-site/posts/2026-06-20/` next to `post.mdx`.
2. MDX embeds it: `<Image src="./hero.png" alt="..." />`.
3. Build emits `/posts/2026-06-20/hero.png` at the deploy.
4. Cloudflare Pages serves it from its edge, alongside the HTML.
5. The [3-tier image-CDN chain](../image-cdn/index.md) wraps the origin URL with transforms (`/cdn-cgi/image/...`) for resize / format conversion.

## Card / subscription required?

**NO.** Free.

## Alternatives

- [ImgBB](./imgbb.md) — Tier 2 fallback, used when the image shouldn't bloat the repo
- [Imgur](./imgur.md) — Tier 3 mirror
- [GitHub user-content](./github-user-content.md) — Tier 4, > 25 MB assets

## Swap cost

Low — the `<Image>` component in `@chirag127/oriz-kit` owns origin
resolution. Swap = change one default in the chain config. Existing
images would still resolve from their committed paths.

## Why this is our pick

- Co-located with the content that embeds it; one git history covers both
- Same edge as the page that uses it (lowest latency)
- No upload flow, no API key, no rate limit
- Markdown-friendly: relative paths just work

## Cross-refs

- [4-tier image-host decision](../../decisions/architecture/image-host-four-tier.md)
- [Markdown-in-repo only CMS decision](../../decisions/architecture/cms-markdown-in-repo-only.md)
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- [Image CDN — primary (CF Images)](../image-cdn/cloudflare-images.md)
- [oriz-kit glossary](../../glossary/o-r/oriz-kit.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
