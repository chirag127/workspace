---
type: service
title: "Ray.so"
description: "Generate pretty code-screenshot PNGs for Open Graph cards on code-heavy blog posts. Free, OSS, no card."
tags: [code-screenshot, social, og-image, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-screenshot
provider: raycast
free_tier: "Unlimited code screenshots, all themes, all languages, OSS (raycast/ray-so), self-hostable"
swap_cost: low
related:
  - services/code-embed/stackblitz
  - services/code-embed/codepen
  - services/code-embed/github-gists
  - decisions/architecture/multi-engine-search-button
  - rules/no-card-on-file
---

# Ray.so

## Role

Generates the **og:image** PNG for code-heavy blog posts on
oriz-blog-site. When a post is mostly about a code snippet, the
social card readers see when the URL is shared on X / LinkedIn /
WhatsApp is a Ray.so screenshot of that snippet (with the post
title overlaid by our build step).

We use ray.so's hosted instance at `ray.so` — no self-hosting, just
the URL-driven screenshot endpoint piped through a build-time fetch
in oriz-blog-site's image pipeline.

## Free tier

- Unlimited code screenshots
- All themes (Candy, Midnight, Sunset, Vercel, Rose Pine, etc.)
- All languages (Shiki under the hood — same grammar set as VS Code)
- Title bar + window padding + drop shadow + gradient backgrounds
- Open source — `github.com/raycast/ray-so` — self-hostable on Cloudflare Pages if hosted instance ever degrades

## Card / subscription required?

**NO.** The hosted ray.so endpoint requires no account at all. The
URL parameters encode the snippet + theme; the response is a PNG.

## Build-time integration

```ts
// oriz-blog-site/scripts/build-og-images.ts
const png = await fetch(
  `https://ray.so/api/image?code=${encodeURIComponent(snippet)}` +
  `&theme=midnight&language=typescript&padding=64&background=true`
).then(r => r.arrayBuffer());
// → write to /public/og/<slug>.png, referenced in <meta property="og:image">
```

The PNGs are committed to the repo (or generated on Cloudflare Pages
build) and served from the site's own origin — ray.so isn't a hot-
path dependency at request time.

## Alternatives

- Carbon (carbon.now.sh) — comparable, but no public API, scraping required
- Codeimg.io — paid for batch, free tier is interactive-only
- Polacode (VS Code extension) — manual, doesn't fit a build step
- Self-hosted Shiki + Satori — viable but rebuilds what ray.so already does for free

## Swap cost

Low — the screenshot URL is the only coupling. If ray.so's hosted
endpoint ever disappears, fall back to: (a) self-hosting `raycast/ray-so` on Cloudflare Pages, or (b) replacing the build step with `Shiki + Satori` running inside a GitHub Action.

## Why this is our pick

Free, no account, OSS escape hatch, and produces the best-looking
default of any code-screenshot tool tested. The URL-driven API
fits a build-step model — no human in the loop per post.

## Cross-refs

- [StackBlitz](../code-embed/stackblitz.md) — the post embeds StackBlitz; ray.so renders the social card
- [CodePen](../code-embed/codepen.md) — same pattern for CSS-heavy posts
- [GitHub Gists](../code-embed/github-gists.md) — same pattern for static-snippet posts
- [Multi-engine search button](../../decisions/architecture/multi-engine-search-button.md) — screenshots travel through the multi-search button as og:image when readers share the post URL
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
