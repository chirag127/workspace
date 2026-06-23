---
type: decision
title: "Workspace layout: projects/<owner>/<own|forks>/<bucket>/<category>/<repo>"
description: "The workspace umbrella organizes submodules in a 5-level hierarchy: GitHub owner (oriz-org or chirag127) → own/ vs forks/ → 4 artifact-type buckets (products, services, libraries, content) → category folder → repo. Shape B grouping (4 buckets) chosen over flat. Forks live under their owner. py-pkg-cli/ renamed to clis/."
tags: [layout, monorepo, submodules, workspace, hierarchy, branding]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - decisions/branding/oriz-org-rename-from-co
  - decisions/branding/repo-naming-suffixes
  - rules/fork-discipline
  - rules/profile-readme-cross-link
  - rules/recruiter-strategy
  - runbooks/migrate-to-oriz-org
---

# Workspace layout: owner → own/forks → bucket → category → repo

## Decision

The `oriz-org/workspace` umbrella organizes all 74+ submodules in a
5-level path hierarchy. Top level partitions by **GitHub owner**, so
`oriz-org/*` repos and `chirag127/*` repos sit side-by-side on disk.
Second level partitions `own/` (we authored) from `forks/` (we
forked). Third level groups by **artifact type** (Shape B, 4 buckets).
Fourth level is the existing **category folder**. Fifth is the
**repo slug** itself.

```
projects/
├── oriz-org/                              ← owner
│   ├── own/                               ← we authored
│   │   ├── products/                      ← user-facing things we ship
│   │   │   ├── apps/                      ← Astro / SvelteKit / etc. sites
│   │   │   │   ├── content/<repo>/        ← (existing sub-bucket inside apps)
│   │   │   │   ├── hub/<repo>/
│   │   │   │   ├── personal/<repo>/
│   │   │   │   └── tools/<repo>/
│   │   │   ├── browser-extensions/<repo>/
│   │   │   ├── ide-extensions/<repo>/
│   │   │   └── clis/<repo>/               ← renamed from py-pkg-cli/
│   │   ├── services/                      ← server-side runtimes
│   │   │   ├── apis/<repo>/
│   │   │   ├── workers/<repo>/
│   │   │   └── mcp-servers/<repo>/
│   │   ├── libraries/                     ← reusable code we publish
│   │   │   └── npm-packages/<repo>/
│   │   └── content/                       ← non-runnable assets
│   │       ├── books/<repo>/
│   │       ├── rules/<repo>/
│   │       ├── skills/<repo>/
│   │       └── data/<repo>/
│   └── forks/                             ← forks under oriz-org (maintained for oriz.in)
│       └── {products,services,libraries,content}/<category>/<repo>/
└── chirag127/                             ← owner: personal account
    ├── own/                               ← personal projects (cs-me-app, agents-md, etc.)
    │   └── {products,services,libraries,content}/<category>/<repo>/
    └── forks/                             ← drive-by forks (most forks land here)
        └── {products,services,libraries,content}/<category>/<repo>/
```

## Why two top-level owner folders

Every submodule's GitHub owner is either `oriz-org` or `chirag127`.
Putting that in the on-disk path makes the owner unambiguous without
opening `.gitmodules`. It also lets `git grep`, find-in-files, and CI
matrices scope by owner trivially.

The brand-owned repos cluster under `oriz-org/`. Personal experiments
and drive-by forks cluster under `chirag127/`. Recruiter strategy
(see [rules/recruiter-strategy](../../rules/recruiter-strategy.md)):
chirag127 stays populated so the personal account doesn't look dead.

## Why 4 buckets (products / services / libraries / content)

Shape B grouping chosen over Shape A (flat 12 categories). The 4
buckets are the standard industry partition:

- **products/** — anything a user opens. Apps, browser extensions,
  IDE extensions, CLIs. Stuff with a UX surface.
- **services/** — server-side runtimes. APIs, workers, MCP servers.
  No UX of their own; consumed by products.
- **libraries/** — reusable code we publish. npm packages.
- **content/** — non-runnable assets. Books, rules, skills, data.

If a new category arrives (e.g. mobile apps), it slots into one of
these 4 buckets without rethinking the hierarchy.

## Why fork hierarchy mirrors own hierarchy

Forks get the same `{products,services,libraries,content}/<category>/`
sub-structure as `own/` so the layout is symmetric and a fork's
on-disk path matches its `own/` sibling's pattern. A fork of an Astro
app sits at `forks/products/apps/<bucket>/<repo>/`, never at the root
of `forks/`.

## Renames in this migration

- `projects/py-pkg-cli/` → `projects/oriz-org/own/products/clis/`
  (`py-pkg-cli/` was empty; the name conflated language + format +
  role; pluralised to match other category folders)
- `projects/forks/` → `projects/oriz-org/forks/` (existing forks
  under oriz-org) and `projects/chirag127/forks/` (drive-bys go here
  going forward)

## What this replaces

- The single-level `projects/<category>/` layout from before
  2026-06-24
- The implicit "everything is mine, except forks/" assumption
- The empty `projects/own/` directory created accidentally on
  2026-06-23 (cleaned up)

## What this does NOT change

- Repo slug naming — still follows [`repo-naming-suffixes`](../branding/repo-naming-suffixes.md)
- Submodule discipline — still 74 submodules pinned to commits in
  the umbrella; no switch to subtree or manifest
- Fork discipline — still minimum-diff, see [`rules/fork-discipline`](../../rules/fork-discipline.md)

## Migration cost

- ~74 `.gitmodules` `path =` entries rewritten
- `git submodule sync` to propagate new paths to `.git/config`
- ~243 hardcoded `projects/<cat>/` refs in `scripts/`, `knowledge/`,
  root `*.md` files — sed-rewritten in one pass
- Windows file locks on `apis/`, `apps/`, `npm-packages/` from VS
  Code watchers and dev servers — close watchers before migration
