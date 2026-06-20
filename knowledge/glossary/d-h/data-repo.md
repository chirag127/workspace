---
type: glossary
title: "data repo"
description: "chirag127/oriz-me-data, the authoritative JSONL store for the me.oriz.in lifestream."
tags: [glossary, data, lifestream]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# data repo

## Definition

The data repo is `chirag127/oriz-me-data` — the authoritative JSONL
store for the `me.oriz.in` lifestream. It is the canonical source;
every cloud DB downstream is a cache rebuilt from it.

## Expanded

JSONL files in this repo are append-only and version-controlled, so
the full event history is recoverable by `git clone` from any host
GitHub still serves. The cache-rebuild GitHub Action reads these files
and re-populates Turso libSQL on every deploy. If Turso disappears,
the next deploy rebuilds it; if Cloudflare disappears, the GitHub
Pages mirror still serves the static site rendered from the same data.

The pattern generalises: each appendable dataset in the family
(blog MDX, books JSON, cards JSON) has its own `*-data` companion repo
under the same convention.

## See also

- [lifestream](./lifestream.md)
- [cache-rebuild](./cache-rebuild.md)
- [survival-fallback](./survival-fallback.md)
