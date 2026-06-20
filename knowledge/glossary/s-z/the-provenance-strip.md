---
type: glossary
title: "the provenance strip"
description: "oriz-me's signature element, the live build manifest at the top of every page."
tags: [glossary, design, oriz-me, lifestream]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# the provenance strip

## Definition

The Provenance Strip is `oriz-me`'s signature element — a thin live
build manifest at the top of every page that records when the page
was built, the git SHA it was built from, and the data sources it
drew from.

## Expanded

The strip ties the visible page back to the canonical
[data-repo](./data-repo.md) and the [cache-rebuild](./cache-rebuild.md)
that produced it. Each ingester (Last.fm, GitHub, Lichess, …) reports
into the strip with its last successful sync time, so a missing
heartbeat is visible to anyone reading the site, not buried in a
private dashboard.

It is the public contract of the lifestream: this page was built at
this time from these sources, and you can verify any of it via the
links the strip exposes.

## See also

- [lifestream](./lifestream.md)
- [data-repo](./data-repo.md)
- [the-spine](./the-spine.md)
