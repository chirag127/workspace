---
type: service
title: "Vercel"
description: "Fallback static host — free hobby tier."
tags: [hosting, vercel, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: fallback
role: static-hosting-fallback
provider: vercel
free_tier: "100 GB bandwidth/mo, 6,000 build minutes/mo, unlimited static deploys (hobby plan, non-commercial)"
swap_cost: low
---

# Vercel

## Role

Documented fallback static host if Cloudflare Pages and GitHub Pages
both became unavailable.

## Free tier

- 100 GB bandwidth / month (hobby)
- 6,000 build minutes / month
- Unlimited deploys
- Hobby plan: non-commercial use only

## Card / subscription required?

**NO** for the hobby plan sign-up. Vercel does not require a card on
file for hobby. Note: Vercel hobby is for non-commercial sites — if
any oriz site monetizes, we cannot use this fallback for that site.

## Alternatives

- [Netlify](./netlify.md)
- A second Cloudflare account

## Swap cost

Low — `dist/` upload, `vercel.json` is rarely needed.

## Why fallback only

Hobby bandwidth is finite (vs Cloudflare's unlimited), and the
non-commercial restriction blocks monetized sites.

## Cross-refs

- [Cloudflare Pages](./cloudflare-pages.md) — primary
- [Netlify](./netlify.md) — also fallback
