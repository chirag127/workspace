---
type: glossary
title: "digital twin"
description: "The broader concept lifestream implements: a public-facing mirror of one person's consumption and activity."
tags: [glossary, digital-twin, lifestream]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# digital twin

## Definition

A digital twin is a public-facing mirror of one person's consumption
and activity, assembled from the APIs of the services they use.

## Expanded

Where a [lifestream](./lifestream.md) is the specific JSONL-backed
event store on `me.oriz.in`, the digital twin is the *category* —
the design pattern of pulling external service data (music, code,
chess, books, films, fitness, …) into one canonical home that
represents the person across the open web.

The family's digital twin is intentionally read-only and public; user
authentication on `me.oriz.in` is only for the page owner's admin
controls. Private journaling lives separately on `journal.oriz.in`.

## See also

- [lifestream](./lifestream.md)
- [data-repo](./data-repo.md)
