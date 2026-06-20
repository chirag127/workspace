---
type: service
title: "Firebase Hosting"
description: "REJECTED — Spark daily bandwidth cap shifted to 360 MB/day shared, too tight."
tags: [hosting, firebase, rejected]
timestamp: 2026-06-20
format_version: okf-v0.1
status: rejected
role: static-hosting
provider: google-firebase
free_tier: "Was 10 GB/mo + 360 MB/day; the daily cap is now shared across all sites on the project — too tight for the family"
swap_cost: n/a
rejection_reason: "Spark daily bandwidth cap (360 MB/day, shared across the project) is too tight for a multi-site family. A single popular post on one site would starve the others. Cloudflare Pages offers unlimited bandwidth instead."
---

# Firebase Hosting

## Status

**REJECTED.** Was previously used for `oriz-journal`; that decision
was reversed and journal moved to Cloudflare Pages.

## Why rejected

The Spark daily bandwidth cap is 360 MB/day, **shared** across every
site on the Firebase project. With 11+ sites in the family, a single
popular post starves the rest. Cloudflare Pages offers unlimited
bandwidth on the same free tier, with no daily cap.

## Card / subscription required?

**NO** for the Spark plan, but irrelevant — the bandwidth cap kills
this option before card requirements come up.

## Replacement

[Cloudflare Pages](./cloudflare-pages.md) for primary, [GitHub Pages](./github-pages.md)
for survival fallback.

## Cross-refs

- [Cloudflare Pages](./cloudflare-pages.md) — replacement
- [Hosting](../../../AGENTS.md#hosting-per-site) — AGENTS.md hosting section
