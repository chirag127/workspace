---
type: service
title: "Pagefind"
description: "Static-site search — runs at build, ships a tiny client, zero infra."
tags: [search, static, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: in-page-search
provider: pagefind
free_tier: "Open-source — no cost, no quota, no service to run"
swap_cost: low
---

# Pagefind

## Role

Powers the search box on `oriz-blog`, `oriz-books`, `oriz-me`. Indexes
generated `dist/` HTML at build time, ships a small JS client.

## Free tier

- Open source, no quota, no account
- Just an npm package and a build step

## Card / subscription required?

**NO.** It's a CLI tool you run during build. There is no service.

## Alternatives

- Algolia free (1M docs / 10K searches)
- MiniSearch (client-side, also no service)

## Swap cost

Low — Pagefind is a build step. Removing it removes a build step.

## Why this is our pick

Zero infra. Indexes the same `dist/` we deploy. No service to
re-authenticate, no quota to track.

## Cross-refs

- [Cloudflare Pages](./cloudflare-pages.md) — hosts the indexed dist
