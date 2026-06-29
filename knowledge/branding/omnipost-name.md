---
type: decision
title: "Cross-post engine package is named oriz-omnipost"
description: RSS cross-poster named @chirag127/oriz-omnipost
tags: [decisions, branding, packages, naming, omnipost, cross-post]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/cross-post-engine
  - branding/repo-naming-suffixes
  - glossary/o-r/omnipost
---

# Cross-post engine package is named oriz-omnipost

## Decision

The family's RSS-driven cross-posting engine is published as
`@chirag127/oriz-omnipost`. The npm package lives at
`packages/oriz-omnipost/` inside the master `chirag127/oriz` repo.
Repo slug: `oriz-omnipost` (no `-site` / `-worker` suffix — npm
packages stay clean per
[repo-naming-suffixes](./repo-naming-suffixes.md)).

## Why

User direction (verbatim 2026-06-20): *"write the name of omnipotent."*
The package is omnipotent over distribution — one trigger fans an
oriz-blog-site post out to every blogging platform that has an API.
"Omnipost" reads as **omni-** (every) + **post** (publish), keeps the
two-syllable family cadence (`oriz-kit`, `oriz-home`, `oriz-omnipost`),
and avoids the awkward literal "omnipotent" while preserving the
intent.

## Implications

- npm name: `@chirag127/oriz-omnipost`. No suffix on the slug — npm packages stay clean.
- Repo: `chirag127/oriz-omnipost` (when split out of the master repo).
- Directory inside master: `packages/oriz-omnipost/` — matches the published name.
- Glossary entry: [`glossary/o-r/omnipost.md`](../../glossary/o-r/omnipost.md).
- The architectural detail (RSS in, adapters out, idempotent, short-link fallback) is documented in [`decisions/architecture/cross-post-engine.md`](../architecture/cross-post-engine.md) — this file only locks the name.

## Cross-refs

- [Cross-post engine architecture](../architecture/cross-post-engine.md)
- [Repo naming suffix matrix](./repo-naming-suffixes.md)
- [omnipost glossary](../../glossary/o-r/omnipost.md)
