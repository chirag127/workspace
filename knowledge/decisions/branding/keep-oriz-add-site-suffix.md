---
type: decision
title: "Repos become oriz-<name>-site / oriz-<name>-ext; packages stay scoped"
description: "Family naming: GitHub repos for sites and extensions add a -site / -ext suffix. NPM packages keep the @chirag127/oriz-* scoped form unchanged."
tags: [naming, repo, packages, family]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/branding/oriz-kit-package-name
  - decisions/infrastructure/chrome-extensions-as-submodules
  - decisions/content/per-extension-subdomain
---

# Repos become oriz-<name>-site / oriz-<name>-ext; packages stay scoped

## Decision

Public-website repos rename from `chirag127/oriz-<name>` to
`chirag127/oriz-<name>-site`. Chrome-extension repos rename to
`chirag127/oriz-<name>-ext`. NPM packages keep their existing
`@chirag127/oriz-*` scoped names — they do NOT take a `-pkg` suffix.

## Why

Earlier discussion considered stripping the `oriz-` prefix entirely;
that idea is reversed. Keeping the prefix on repos preserves brand
discoverability across the GitHub account index, while the suffix
makes a repo's role unambiguous at the org-listing level
(distinguishing site repos from extension repos from data repos
from package repos). Packages already disambiguate via their
`@chirag127/` scope, so they don't need a redundant suffix.

## Implications

- All 11 site submodules under `sites/` rename their underlying GitHub repos to `oriz-<name>-site`. Submodule `path` stays `sites/oriz-<name>` for ergonomics; only the remote URL changes.
- New extensions get repo names like `chirag127/oriz-<slug>-ext` from day one.
- Data repos use `-data` suffix (already in place: `chirag127/oriz-me-data`).
- Package paths inside the master repo stay as `packages/<name>/` — no `oriz-` prefix on the directory because `packages/` itself disambiguates.
- Submodule URL changes ripple into `.gitmodules`; update in one commit family-wide.
- Don't break clones — set up GitHub repo redirects on rename so old URLs still resolve.

## Cross-refs

- [@chirag127/oriz-kit package name](./oriz-kit-package-name.md)
- [Chrome extensions as submodules](../infrastructure/chrome-extensions-as-submodules.md)
- [Per-extension subdomain](../content/per-extension-subdomain.md)
- [AGENTS.md repository structure](../../../AGENTS.md)
