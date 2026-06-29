---
type: glossary
title: "cache rebuild"
description: GitHub Actions job reads JSONL canonical, re-populates Turso warm cache
tags: [glossary, ci, lifestream, turso]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# cache rebuild

## Definition

The cache rebuild is the GitHub Actions cron job that reads the JSONL
canonical store from the data repo and re-populates the Turso libSQL
warm cache used by the live `me.oriz.in` home feed.

## Expanded

Why a cache: Turso reads serve the last 24h of lifestream events to
the home feed at edge latency, with a browser-safe read-only token.
Why a rebuild (not incremental writes): the JSONL in git is the
contract — if the cache and the canonical disagree, the canonical
wins, and the simplest way to enforce that is to throw the cache away
and regenerate it.

The job runs daily and on every push to `oriz-me-data`. If Turso ever
dies, the next deploy rebuilds it. If GitHub dies, the canonical is
git-clonable to any new host.

## See also

- [data-repo](../d-h/data-repo.md)
- [lifestream](../i-n/lifestream.md)
- [survival-fallback](../s-z/survival-fallback.md)
