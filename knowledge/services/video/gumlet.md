---
type: service
title: "gumlet"
description: "Privacy-sensitive video hosting + streaming — 250 GB/month free, no card, no viewer tracking."
tags: [video, hosting, streaming, privacy, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: video-hosting-privacy-sensitive
provider: gumlet
free_tier: "250 GB bandwidth/month, video + image processing, adaptive streaming, CDN, no card"
swap_cost: low
---

# gumlet

## Role

Hosts video that should NOT leak into the YouTube algorithm or set
tracking cookies on viewers — oriz-me lifestream entries on the
private side of the
[public-private line](../../policy/public-private-line.md), draft
preview videos before public publish, anything where embed-side
viewer tracking would be inappropriate. [YouTube](./youtube.md)
remains the primary for explicitly-public content.

## Free tier

- 250 GB bandwidth / month
- Video + image processing and storage
- Adaptive bitrate streaming (HLS / DASH)
- Global CDN
- Customisable player, no provider-branded overlay
- API access

## Card / subscription required?

**NO.** Free tier sign-up is email-only. No payment method requested.

## Alternatives

- [YouTube](./youtube.md) — public-content primary
- Cloudflare Stream (paid)
- Mux (paid past trial)
- Bunny.net Stream (low-cost but card-required)

## Swap cost

Low for video. gumlet also ships an image-processing product, but the
family uses [ImageKit](../tooling/imagekit.md) for images — keeping
video on gumlet and images on ImageKit avoids putting both eggs in
one provider's basket.

## Why this is our pick (as privacy-sensitive)

The most generous no-card video free tier we found that ships with
adaptive streaming and a clean embedded player. 250 GB/month easily
covers private-side video; if usage grows, the
[never-hit-quotas rule](../../rules/never-hit-quotas.md) kicks in
and we evaluate Cloudflare Stream's paid tier rather than letting
private content spill onto YouTube.

## Cross-refs

- [YouTube](./youtube.md) — public-content video primary
- [ImageKit](../tooling/imagekit.md) — images stay here, not on gumlet
- [Public/private line](../../policy/public-private-line.md)
- [Never hit quotas rule](../../rules/never-hit-quotas.md)
