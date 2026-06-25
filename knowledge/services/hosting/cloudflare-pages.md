---
type: service
title: "Cloudflare Pages"
description: "Primary static host for every oriz site — unlimited bandwidth, free forever."
tags: [hosting, cloudflare, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: static-hosting-primary
provider: cloudflare
free_tier: "Unlimited bandwidth, 500 builds/month, 100 custom domains, 25 MiB asset size"
swap_cost: low
---

# Cloudflare Pages

## Role

Primary static host for every site in the oriz family. Each site
deploys its `dist/` folder via `wrangler pages deploy`.

## Free tier

- Unlimited bandwidth (the killer feature)
- 500 builds per month per account
- 100 custom domains per project
- 25 MiB max asset size, 20K files per deploy

## Card / subscription required?

**NO.** Cloudflare Pages free tier requires only an email-verified
Cloudflare account. No payment method on file.

## Alternatives

- [GitHub Pages](./github-pages.md) — survival fallback
- [Vercel](./vercel.md) — fallback hobby tier
- [Netlify](./netlify.md) — fallback
- Render, Surge — also viable

## Swap cost

Low — `dist/` folder uploads to any of the alternatives unchanged. CI
deploy step swaps the wrangler call for the equivalent CLI.

## Why this is our pick

Unlimited bandwidth means no surprise bills if a post goes viral, and
Wrangler integrates cleanly with the Cloudflare Workers / R2 / DNS we
already use. One vendor, one dashboard, one auth.

## Cross-refs

- [Layer 1 — static hosting](../../decisions/architecture/frontend/layer-1-static-hosting.md)
- [Cloudflare Workers](../compute/cloudflare-workers.md)
- [Cloudflare DNS](../domain/cloudflare-dns.md)
