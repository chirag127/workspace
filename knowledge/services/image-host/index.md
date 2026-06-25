---
type: index
title: "Image host services"
description: "4-tier fallback chain for image origin storage: repo-hosted on CF Pages → ImgBB → Imgur → GitHub user-content."
tags: [services, image-host, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Image host services

The family runs a **4-tier fallback chain** for image **origin storage**
(the bytes themselves), independent of the
[3-tier image-CDN chain](../image-cdn/index.md) that handles
**delivery / transformation**. Origin = where the file lives;
CDN = where it's resized + edge-cached on the way to the browser.

The chain is documented in
[`decisions/architecture/image-host-four-tier.md`](../../decisions/architecture/image-host-four-tier.md).
The kit's `<Image>` wrapper composes this chain with the image-CDN
chain so each `src=` either resolves at Tier 1 or falls through.

| Tier | Service | Status | Role | Free tier headline |
|---|---|---|---|---|
| 1 | [repo-hosted-cf-pages.md](./repo-hosted-cf-pages.md) | active | image-host-primary | Static files in each site repo, served from CF Pages — free unlimited |
| 2 | [imgbb.md](./imgbb.md) | active | image-host-fallback-1 | Free unlimited uploads + REST API, no card |
| 3 | [imgur.md](./imgur.md) | active | image-host-fallback-2 | Free unlimited uploads + REST API, no card |
| 4 | [github-user-content.md](./github-user-content.md) | active | image-host-fallback-3 | Push to `assets` branch of any repo, link via `raw.githubusercontent.com` — free unlimited |

## Origin vs CDN — two different chains

| Concern | Chain | Subdir |
|---|---|---|
| Where does the byte live? (origin) | repo-hosted → ImgBB → Imgur → GitHub user-content | `image-host/` (this dir) |
| How is it resized + edge-cached? (CDN) | Cloudflare Images → wsrv.nl → ImageKit | [`image-cdn/`](../image-cdn/index.md) |

Both chains are wired into the same `<Image>` component in
<!-- TODO: broken link, was [`@chirag127/oriz-kit`](../../glossary/o-r/oriz-kit.md) -->. The CDN
chain wraps the origin URL with a transform + edge-cache layer — they
compose cleanly because every CDN tier accepts an absolute URL as
input.

## When to use which tier

- **Tier 1 (repo-hosted).** The default for everything that fits in
  the repo (typical site image sizes ≤ a few MB). Markdown-in-repo
  authoring puts the image next to the `.md` file; no upload step.
- **Tier 2 (ImgBB).** Used by CI for blog-post images that don't
  belong in the repo (e.g. throwaway screenshots from automated
  publishing flows, large-batch one-off uploads).
- **Tier 3 (Imgur).** Mirror / hot-link backup. Same upload payload
  pushed to ImgBB and Imgur in parallel from CI; if Tier 1 + Tier 2
  both fail at runtime the `<Image>` wrapper falls through to the
  Imgur URL.
- **Tier 4 (GitHub user-content).** Rare. For assets > 100 MB
  (GitHub's per-file ceiling) or large animated GIFs we don't want
  inflating the site repo's clone size — push to a dedicated
  `assets` branch of any family repo, reference via
  `raw.githubusercontent.com/<user>/<repo>/<branch>/<path>`.

## Cross-refs

- [4-tier image-host decision](../../decisions/architecture/image-host-four-tier.md)
- [3-tier image-CDN chain](../image-cdn/index.md) — different concern (transform/resize), composed alongside this chain
- [Markdown-in-repo only CMS decision](../../decisions/architecture/cms-markdown-in-repo-only.md) — Tier 1 is the natural fit for markdown-authored content
- <!-- TODO: broken link, was [oriz-kit glossary](../../glossary/o-r/oriz-kit.md) -->
- [Cloudflare Pages for all sites](../../decisions/infrastructure/cloudflare-pages-for-all-sites.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
- [Never-hit-quotas rule](../../rules/interaction/never-hit-quotas.md)
