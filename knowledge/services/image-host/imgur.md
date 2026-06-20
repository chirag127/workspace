---
type: service
title: "Imgur"
description: "Tier 3 image origin — free unlimited image hosting + REST upload API, no card. Mirror of Tier 2 ImgBB for hot-link backup."
tags: [images, host, origin, imgur, fallback, mirror]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: image-host-fallback-2
provider: imgur
free_tier: "Unlimited image uploads, unlimited bandwidth, OAuth2 + anonymous REST API; 50 uploads/hour anonymous, 12,500/day authenticated client"
swap_cost: low
related:
  - services/image-host/repo-hosted-cf-pages
  - services/image-host/imgbb
  - services/image-host/github-user-content
  - decisions/architecture/image-host-four-tier
  - rules/no-card-on-file
  - rules/never-hit-quotas
---

# Imgur

## Role

**Tier 3 origin** in the [4-tier image-host chain](../../decisions/architecture/image-host-four-tier.md).
Operates as a **mirror / hot-link backup** to [ImgBB](./imgbb.md):
the same upload payload is pushed to both services in parallel from
CI. If both Tier 1 (repo-hosted) and Tier 2 (ImgBB) fail at runtime,
the `<Image>` wrapper falls through to the Imgur URL.

## Free tier

- Unlimited image uploads + bandwidth
- 20 MB ceiling per JPEG / PNG / GIF (PNGs over 5 MB get re-encoded to JPEG); 200 MB ceiling for video
- REST API at `https://api.imgur.com/3/upload` with both anonymous and OAuth2 modes
- Anonymous rate limit: 50 uploads / hour per IP
- Authenticated client: 12,500 uploads / day, 1,250 / hour
- Free image URLs at `i.imgur.com/<id>.<ext>` with permanent stable IDs

## Card / subscription required?

**NO.** Free-tier sign-up is email; client ID for the API is issued
without payment method. No card requested anywhere in the flow.

## How it's used

1. Same CI step that uploads to [ImgBB](./imgbb.md) also POSTs to `https://api.imgur.com/3/image` with `Authorization: Client-ID <IMGUR_CLIENT_ID>` (from [Doppler](../secrets/doppler.md)) + base64 body.
2. API returns `{ data: { link, deletehash, ... } }`.
3. The URL is committed to the post's frontmatter as `image_tier_3:`.
4. The [`<Image>` chain](../../glossary/o-r/oriz-kit.md) treats it as the fallback after ImgBB.

## Methods supported

Anonymous upload (Client-ID only), OAuth2 (account-bound), URL upload,
base64, multipart form. No paid plan, no card path.

## Alternatives

- [ImgBB](./imgbb.md) — Tier 2 sibling
- [repo-hosted](./repo-hosted-cf-pages.md) — Tier 1 default
- [GitHub user-content](./github-user-content.md) — Tier 4 for files
  > 20 MB or animated content we don't want re-encoded

## Swap cost

Low — single env var (`IMGUR_CLIENT_ID`) + one CI step. Existing URLs
keep resolving from `i.imgur.com` regardless.

## Why this is our pick

- Free unlimited, no card
- Independent provider from ImgBB — Tier 2 + Tier 3 outage at the
  same time is highly unlikely; that's the redundancy point
- Mature service (around since 2009); low operational risk
- Permanent URLs by default (don't auto-delete unauthenticated uploads)

## Imgur quirks worth knowing

- PNG > 5 MB gets re-encoded to JPEG. For PNGs that must stay PNG,
  use [GitHub user-content Tier 4](./github-user-content.md) instead.
- Animated GIF support is fine; large GIFs are converted to MP4 for
  streaming — the original GIF URL still serves.

## Cross-refs

- [4-tier image-host decision](../../decisions/architecture/image-host-four-tier.md)
- [ImgBB Tier 2 sibling](./imgbb.md)
- [repo-hosted Tier 1](./repo-hosted-cf-pages.md)
- [GitHub user-content Tier 4](./github-user-content.md)
- [3-tier image-CDN chain](../image-cdn/index.md) — delivery wrapper
- [No card-on-file rule](../../rules/no-card-on-file.md)
- [Never-hit-quotas rule](../../rules/never-hit-quotas.md)
