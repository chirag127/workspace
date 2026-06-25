---
type: service
title: "GitHub Pages"
description: "Survival fallback static host — the second-account-equivalent every oriz site mirrors to."
tags: [hosting, github, fallback]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: static-hosting-fallback
provider: github
free_tier: "100 GB/mo bandwidth per site, 1 GB site size, 10 builds/hour"
swap_cost: low
---

# GitHub Pages

## Role

Survival fallback host. Every oriz site is mirrored here so if
Cloudflare Pages disappears overnight, the family still resolves.

## Free tier

- 100 GB/month bandwidth per site (soft limit)
- 1 GB total site size
- 10 builds per hour
- Unlimited public-repo Pages sites

## Card / subscription required?

**NO.** GitHub Pages is free for public repositories with no payment
method requirement.

## Alternatives

- A second Cloudflare account
- [Vercel](./vercel.md), [Netlify](./netlify.md)

## Swap cost

Low — re-target the GitHub Action to deploy `dist/` to the `gh-pages`
branch instead of (or in addition to) Cloudflare Pages.

## Why this is our pick

It's already where the source lives. Zero new accounts, the deploy
step is `peaceiris/actions-gh-pages@v3`, and it survives Cloudflare
outages independently.

## Cross-refs

- [Layer 2 — survival fallback](../../decisions/architecture/frontend/layer-2-survival-fallback.md)
- [GitHub Actions](../compute/github-actions.md)
- [Cloudflare Pages](./cloudflare-pages.md)
