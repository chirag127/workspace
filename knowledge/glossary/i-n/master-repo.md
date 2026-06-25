---
type: glossary
title: "master repo"
description: "chirag127/oriz, the umbrella repo that holds every submodule plus knowledge/ and design/."
tags: [glossary, git, structure]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# master repo

## Definition

The master repo is `chirag127/oriz` — the umbrella repository that
holds every site, extension, and package as a git submodule, plus the
inline `apps/api/`, `knowledge/`, and `design-briefs/` directories.

## Expanded

Submodule layout: `sites/oriz-<name>/` for the 11 sites,
`extensions/<name>/` for Chrome/Firefox/Edge extensions,
`packages/<name>/` for the 6 shared packages. The Hono Worker at
`apps/api/` is **not** a submodule — it lives inline so that pointer
bumps and Worker deploys ship together.

The master repo is also where `AGENTS.md`, `CLAUDE.md`, `knowledge/`,
and `design-briefs/` live as the family's single source of truth.

## See also

- [submodule-pointer](../s-z/submodule-pointer.md)
- [family](../d-h/family.md)
- [oriz](../o-r/oriz.md)
