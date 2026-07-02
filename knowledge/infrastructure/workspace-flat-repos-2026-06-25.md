---
type: decision
title: Workspace layout — flat repos/<slug>/ with type-suffix sort
description: Flat repos/<slug>/ dir, type in suffix, forks via .is-fork file
tags:
- decision
- layout
- monorepo
- submodules
- workspace
- flat-layout
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
related:
- decisions/architecture/general/projects-owner-own-forks-layout
- infrastructure/umbrella-as-clone-entrypoint-2026-06-25
- branding/repo-naming-drop-oriz-prefix-2026-06-25
supersedes: decisions/architecture/general/projects-owner-own-forks-layout
---

# Workspace layout — flat repos/<slug>/

## Decision

Every submodule sits at `repos/<slug>/`, period. No `owner/`, no `own/` vs `frk/`, no `prod/svc/lib/content/` buckets, no `<category>/` subfolders. The slug suffix (`-api`, `-npm-pkg`, `-bs-ext`, `-ide-ext`, `-cli`, `-mcp-server`, `-app`) carries the type information and groups repos under `ls`-alphabetical sort. Forks are marked by a single `.is-fork` file at the root of the repo, not by a path segment.

## Why

- **Path stability** — five-level paths (`repos/oriz/own/prod/apps/personal/<slug>`) broke 243 hardcoded references on every rename. Flat paths only break on slug change.
- **Type suffix already sorts** — `ls repos/` clusters `*-api`, `*-npm-pkg`, `*-bs-ext` together for free; no folder hierarchy needed.
- **Forks-by-path was structural overhead** — `.is-fork` is one file, greppable, doesn't move when a fork promotes to a divergent product.
- **Drops two-owner partition** — `chirag127/` vs `chirag127/` was useful when ownership leaked into branding; with the rename to `chirag127` org as canonical, the owner is unambiguous from the GitHub remote URL.
- **Cleaner umbrella** — `oriz` umbrella `.gitmodules` lists every submodule at `path = repos/<slug>` with no embedded structure to maintain.
- **Easier glob in CI** — `repos/*-app/` is a one-segment glob; the old layout needed `repos/*/own/prod/apps/*/`.

## Implications

- Every `.gitmodules` `path =` entry rewrites to `repos/<slug>`.
- Cross-knowledge links to `repos/<old-five-segments>/` need a sed migration pass.
- Recruiter-strategy posture (chirag127 stays populated) shifts: personal repos still live on the chirag127 GH account, but they sit at the flat `repos/<slug>/` level locally — owner is read from the remote URL when needed.
- Fork discipline rule unchanged — minimum-diff still applies; `.is-fork` is added by the fork bootstrap script.
- VS Code multi-root workspace files refresh once; Windows file watchers re-index once at migration time.
- Per-app knowledge bundles inside submodules use shorter relative paths back to master `knowledge/` (4 levels instead of 6).
