---
type: service
title: "Cloudflare R2"
description: "S3-compatible object storage — no egress fees, 10 GB free"
tags: [cloudflare, storage, r2]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: object-storage
provider: cloudflare
free_tier: "10 GB storage, 1M Class-A ops/mo, 10M Class-B ops/mo, ZERO egress fees"
swap_cost: low
---

# Cloudflare R2

## Role

Object storage when something is too big for git (photos, video
exports, larger PDFs, image-tools intermediates).

## Free tier

- 10 GB stored
- 1,000,000 Class-A (write) ops / month
- 10,000,000 Class-B (read) ops / month
- **0 egress fees** (the headline feature)

## Card / subscription required?

**NO** for the Free plan, but with a footnote: Cloudflare offers R2
under the same account as Pages/Workers and the Free plan does not
require a billing method on file. (If you cross into the paid R2
add-on you'd add a card; we never do.) Audit confirms: free tier
sign-up does not require card.

## Alternatives

- Filebase
- 4EVERLAND
- Backblaze B2 — **rejected by user policy** ([backblaze-b2.md](../backblaze-b2.md))

## Swap cost

Low — S3-compatible API, swap endpoint URL + credentials.

## Why this is our pick

Zero egress is uniquely valuable for image / asset hosting. Same
dashboard as Pages and Workers.

## Cross-refs

- [Cloudflare Pages](../hosting/cloudflare-pages.md)
- [ImageKit](../tooling/imagekit.md) — used for transforms in front of R2
