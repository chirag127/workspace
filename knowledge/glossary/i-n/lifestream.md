---
type: glossary
title: "lifestream"
description: Public daily-rebuilt event store concept powers me.oriz.in
tags: [glossary, lifestream, me-oriz-in]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# lifestream

## Definition

The lifestream is the append-only, daily-rebuilt event store that
records Chirag's public consumption and activity (Last.fm scrobbles,
GitHub commits, Lichess games, books read, films watched, …) and
powers `me.oriz.in`.

## Expanded

The concept originated for `me.oriz.in` and was formalised by post #4
in `oriz-blog`. The canonical store is JSONL files in
`chirag127/oriz-me-data` (a separate git repo); a daily GitHub Actions
cron rebuilds Turso libSQL as a warm read-only cache for the live home
feed. The site itself is statically rebuilt from the JSONL on every
push.

Lifestream is one concrete implementation of the broader
[digital-twin](../d-h/digital-twin.md) concept.

## See also

- [digital-twin](../d-h/digital-twin.md)
- [data-repo](../d-h/data-repo.md)
- [cache-rebuild](../a-c/cache-rebuild.md)
- [the-provenance-strip](../s-z/the-provenance-strip.md)
