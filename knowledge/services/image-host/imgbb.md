---
type: service
title: "ImgBB"
description: "Tier 2 image origin — free unlimited image hosting + REST upload API, no card."
tags: [images, host, origin, imgbb, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-host-fallback-1
provider: imgbb
free_tier: "Unlimited uploads, unlimited bandwidth, REST API for programmatic upload, no card; free anonymous uploads + free authenticated API key"
swap_cost: low
related:
  - services/image-host/repo-hosted-cf-pages
  - services/image-host/imgur
  - services/image-host/github-user-content
  - decisions/architecture/image-host-four-tier
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# ImgBB

## Role

**Tier 2 origin** in the [4-tier image-host chain](../../decisions/architecture/image-host-four-tier.md).
Used by CI for blog-post images that don't belong in the repo —
throwaway screenshots from automated publishing flows, batch uploads
generated outside an editor session, and any image too big to commit
sensibly.

## Free tier

- Unlimited uploads
- Unlimited bandwidth on hot-link
- REST API at `https://api.imgbb.com/1/upload` (key-based)
- No file-count cap, no per-day cap documented at family scale
- 32 MB per upload ceiling
- Albums + auto-delete-after-N-days options for ephemeral content

## Card / subscription required?

**NO.** Free-tier sign-up is email-only; the API key is generated on
the dashboard. No payment method requested.

## How it's used

1. CI step uploads the image via `POST /1/upload` with `key=<IMGBB_KEY>` (sourced from [Doppler](../secrets/doppler.md)) + base64-encoded body.
2. API returns `{ data: { url, display_url, delete_url, ... } }`.
3. The URL gets committed back to the post's frontmatter as `image_tier_2:`.
4. Site build embeds the URL into the [3-tier image-CDN chain](../image-cdn/index.md) so deliveries still go through wsrv.nl / ImageKit transforms.

## Methods supported

Upload-by-URL, upload-by-base64, upload-by-multipart-form-data.
No paid plan; no auth flow beyond API key.

## Alternatives

- [repo-hosted on CF Pages](./repo-hosted-cf-pages.md) — Tier 1 default
- [Imgur](./imgur.md) — Tier 3 mirror, similar feature set
- [GitHub user-content](./github-user-content.md) — Tier 4 for > 32 MB

## Swap cost

Low — single env var (`IMGBB_KEY`) + one CI step. Existing URLs keep
resolving even after a swap because each tier's URLs are absolute and
permanent.

## Why this is our pick

- Free unlimited, no card, no quota cliff at family scale
- Permissive REST API doesn't require OAuth dance
- Mature service (around since 2014); low operational risk

## Cross-refs

- [4-tier image-host decision](../../decisions/architecture/image-host-four-tier.md)
- [repo-hosted Tier 1](./repo-hosted-cf-pages.md)
- [Imgur Tier 3](./imgur.md)
- [GitHub user-content Tier 4](./github-user-content.md)
- [3-tier image-CDN chain](../image-cdn/index.md) — the delivery layer wrapping all 4 origin tiers
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never-hit-quotas rule](../../rules/never-hit-quotas.md)
