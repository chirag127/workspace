---
type: glossary
title: "the seal"
description: "oriz-journal's signature animation (the only motion in the app), the encryption metaphor."
tags: [glossary, design, oriz-journal]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# the seal

## Definition

The Seal is `oriz-journal`'s signature animation — the only motion in
the app — that visualises an entry being encrypted and committed to
storage, treating the act of sealing the journal as a physical
metaphor for the encryption.

## Expanded

`oriz-journal` is the private journaling PWA at `journal.oriz.in`.
Its v2 design budget allows exactly one motion element; The Seal is
it. When the user finishes an entry and saves, The Seal animates
closed, signaling that the entry has been encrypted (per the journal's
local-first encryption model) and is now at rest.

Everywhere else in the journal is intentionally still — the absence
of motion is the design.

## See also

- [family-anchor-site](../d-h/family-anchor-site.md)
