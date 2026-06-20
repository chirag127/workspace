---
type: decision
title: "Every site builds a static GitHub Pages mirror per §16"
description: "Each site's CI builds a static fallback to chirag127.github.io/<site> on every push to main, so /work + /me + /legal stay live if the primary host dies."
tags: [hosting, fallback, github-pages, durability]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/content/100-year-strategy-locked
  - decisions/infrastructure/cloudflare-pages-for-all-sites
  - services/hosting/github-pages
  - architecture/layer-2-survival-fallback
---

# Every site builds a static GitHub Pages mirror per §16

## Decision

Every site in the family builds a static fallback to
`chirag127.github.io/<site-name>` on every push to main. If
Cloudflare Pages dies, gets repriced, or rate-limits the family,
recruiters and users can still hit the GitHub Pages mirror and find
the core content (`/work`, `/me`, `/legal`, etc.).

## Why

Per the 100-year strategy §16, "minimum-survival layer": if
everything dies, what still works? Static `/work` + `/me` rendered
to GitHub Pages, and raw JSONL on GitHub. These two layers must be
independent of every other piece of infrastructure. GitHub Pages
free (100 GB/mo bandwidth/site, 1 GB site cap, free forever as long
as the GitHub account exists) is the single most-durable free host
available — the cheapest insurance against Cloudflare risk.

## Implications

- Each site's CI runs the static-only build with relative URLs and pushes the artifact to a `gh-pages` branch (or to a dedicated mirror repo).
- Mirror is content-only: no APIs, no Firebase Auth, no client-side SDK calls that hit `auth.oriz.in` (those degrade gracefully with a "running in survival mode" notice).
- One custom domain per repo means each site can also have its own GitHub Pages subdomain if we choose, though primary URL stays `*.oriz.in`.
- Annual fire-drill (per the 100-year strategy review checklist): clone each `chirag127.github.io/<site>` URL on a fresh machine and confirm `/work` still loads.
- Commercial intent rule: GitHub Pages allows AdSense + content + utility + portfolio — fine for our sites; never host an e-commerce flow on the mirror.

## Cross-refs

- [100-year strategy locked](../content/100-year-strategy-locked.md)
- [Cloudflare Pages for all sites](./cloudflare-pages-for-all-sites.md)
- [GitHub Pages mirror service entry](../../services/hosting/github-pages.md)
- [Layer 2 — Survival fallback architecture](../../architecture/layer-2-survival-fallback.md)
