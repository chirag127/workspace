---
type: glossary
title: "survival fallback"
description: "The §16 layer that survives if every primary service dies (GitHub Pages mirrors + git-canonical data repo)."
tags: [glossary, survival, hosting, 100-year-strategy]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# survival fallback

## Definition

The survival fallback is the layer of the stack — section 16 of the
100-year strategy — that keeps every site reachable if the primary
host (Cloudflare Pages) and every cloud cache (Firestore, Turso) dies
at the same time.

## Expanded

Two pieces. **GitHub Pages mirrors**: every site builds a static copy
to `chirag127.github.io/<site-name>` on every push to main, so the
site's `/work`, `/me`, and `/legal` routes continue to serve even if
Cloudflare disappears. **Git-canonical data**: every append-only
dataset (lifestream events, blog MDX, books JSON, cards JSON) lives
in a `chirag127/*-data` GitHub repo as JSON/JSONL/MDX, which means
recovery is `git clone` to a new host.

Cloud DBs are never authoritative. They are caches rebuilt from git
on every deploy.

## See also

- [data-repo](./data-repo.md)
- [cache-rebuild](./cache-rebuild.md)
