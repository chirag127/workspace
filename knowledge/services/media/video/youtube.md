---
type: service
title: "YouTube"
description: "Primary video host + embed — unlimited storage, public-content only"
tags: [video, hosting, embed, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: video-hosting-primary
provider: youtube
free_tier: "Unlimited storage, unlimited bandwidth, unlimited embeds, unlimited views"
swap_cost: low
---

# YouTube

## Role

Hosts and serves every public-facing video in the family —
extension-tutorial walkthroughs on per-extension sites, blog-post
embedded video, public lifestream clips on me.oriz.in. The free tier
is genuinely unlimited; the trade-off (YouTube's tracking pixel sets
cookies on every embedded view) is acceptable for content that's
already public.

## Free tier

- Unlimited video storage
- Unlimited bandwidth
- Unlimited embeds and views
- Auto-generated captions, chapters, end screens
- Studio analytics

## Card / subscription required?

**NO.** Google account only.

## Trade-off — viewer tracking

YouTube embeds set tracking cookies on every visit. Privacy-sensitive
content (drafts, oriz-me intimate-scope lifestream entries, anything
under the [public-private line](../../policy/public-private-line.md)
private side) MUST go to [gumlet](./gumlet.md) instead. The
[per-extension privacy policy](../../policy/privacy-policy-per-extension.md)
requires every extension site's `/privacy` page to disclose the
embedded YouTube cookie set when video is embedded.

## Alternatives

- [gumlet](./gumlet.md) — privacy-sensitive primary
- Vimeo (capped uploads + paid for embed customisation — rejected)
- Cloudflare Stream (paid)
- PeerTube self-host (rejected — no-selfhost rule)

## Swap cost

Low — videos export, but viewer-side embeds are a single iframe URL
swap. Comments and view counts do NOT migrate; treat them as
disposable engagement signals, not durable data.

## Why this is our pick

Unlimited free, search-discoverable, ubiquitous embed support. For
public content the discoverability bonus is a feature, not a bug.

## Cross-refs

- [gumlet](./gumlet.md) — privacy-sensitive video fallback
- [Per-extension privacy policy](../../policy/privacy-policy-per-extension.md) — must disclose YouTube cookie set
- [Public/private line](../../policy/public-private-line.md)
