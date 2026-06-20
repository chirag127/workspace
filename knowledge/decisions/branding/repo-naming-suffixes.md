---
type: decision
title: "Repo naming suffixes locked: -site / -ext / -vsc-ext / -cli / -worker / -fn"
description: "Every chirag127/oriz* repo gets a role-typed suffix. Sites end -site, browser extensions -ext, VS Code extensions -vsc-ext, CLIs -cli, Workers -worker, Cloud Functions -fn. NPM packages stay clean (no suffix)."
tags: [naming, repo, packages, suffix, family, branding]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/branding/keep-oriz-add-site-suffix
  - decisions/branding/oriz-me-added-to-family
  - decisions/branding/oriz-kit-package-name
  - decisions/infrastructure/chrome-extensions-as-submodules
  - rules/repo-naming
  - runbooks/rename-repo
  - glossary/o-r/oriz-kit
---

# Repo naming suffixes locked: -site / -ext / -vsc-ext / -cli / -worker / -fn

## Decision

Every repo in the `chirag127/oriz*` family carries a suffix that names
its role unambiguously at the GitHub-org-listing level. NPM packages
are the only exception — they stay clean because the `@chirag127/`
scope already disambiguates them.

| Role | Suffix | Examples |
|---|---|---|
| Static or dynamic website | `-site` | `oriz-blog-site`, `oriz-finance-site`, `oriz-me-site` |
| Browser extension (Chrome / Firefox / Edge / Safari) | `-ext` | `oriz-bookmarks-ext`, `oriz-tab-saver-ext` |
| VS Code extension | `-vsc-ext` | `oriz-snippets-vsc-ext` |
| Command-line tool | `-cli` | `oriz-cli`, `oriz-deploy-cli` |
| Cloudflare Worker (incl. Hono RPC umbrella) | `-worker` | `oriz-api-worker` |
| Firebase Cloud Function | `-fn` | `oriz-ingest-fn` |
| Data repo (canonical store, JSONL, etc.) | `-data` | `oriz-me-data` (already in place) |
| NPM package (scoped) | _(none)_ | `@chirag127/oriz-kit`, `@chirag127/firebase-init`, `oriz-firestream` |

`-ext` is treated as the acronym for **ext**ension; `-vsc-ext` adds
the `vsc-` qualifier so VS Code extensions don't collide with browser
extensions in the org listing or the master repo's submodule tree.

## Why

The earlier `-site` / `-ext` decision (see
[keep-oriz-add-site-suffix](./keep-oriz-add-site-suffix.md)) covered
two roles. As the family grew (CLIs, Workers, VS Code extensions on
the roadmap, Cloud Functions migrating off Firebase Spark) two-suffix
coverage became insufficient. Locking the full suffix matrix now
prevents ad-hoc names from leaking into the org listing as new repo
types appear, and it gives the parallel-by-default agent a single
table to consult before any `gh repo create`.

## Implications

- Every existing site repo migrates to its new `-site` form. Migration
  list (current → target):

  | Current | Target |
  |---|---|
  | `chirag127/oriz-home` | `chirag127/oriz-home-site` |
  | `chirag127/oriz-blog` | `chirag127/oriz-blog-site` |
  | `chirag127/oriz-books` | `chirag127/oriz-books-site` |
  | `chirag127/oriz-book-lore` | `chirag127/oriz-book-lore-site` |
  | `chirag127/oriz-cards` | `chirag127/oriz-cards-site` |
  | `chirag127/oriz-finance` | `chirag127/oriz-finance-site` |
  | `chirag127/oriz-journal` | `chirag127/oriz-journal-site` |
  | `chirag127/oriz-urls-to-md` | `chirag127/oriz-urls-to-md-site` |
  | `chirag127/oriz-image-tools` | `chirag127/oriz-image-tools-site` |
  | `chirag127/oriz-pdf-tools` | `chirag127/oriz-pdf-tools-site` |
  | `chirag127/oriz-me` | `chirag127/oriz-me-site` |

  Submodule **paths** stay `sites/oriz-<name>` for ergonomics — only
  the remote URL flips. Run renames per
  [`runbooks/rename-repo.md`](../../runbooks/rename-repo.md).

- New extensions get `oriz-<slug>-ext` from day one; new VS Code
  extensions get `oriz-<slug>-vsc-ext`.
- Workers (e.g. the Hono umbrella at `api.oriz.in`) carry `-worker`
  suffix when migrated off whatever ad-hoc name they currently use.
- NPM package repos stay clean: `@chirag127/oriz-kit`, `oriz-firestream`,
  `@chirag127/firebase-init`, etc. The `@chirag127/` scope (or, for
  unscoped, the absence of a suffix table entry) is the disambiguator.
- Data repos already use `-data` — that suffix is now formalised in
  the table above.
- GitHub repo redirects on rename keep old clones working — all
  rename steps go through [`runbooks/rename-repo.md`](../../runbooks/rename-repo.md)
  which sets them up automatically.
- Audit gate: every `git push` to a *new* repo URL must verify the
  slug ends in one of the seven suffixes (or is a clean npm-package
  name) — see [`rules/repo-naming.md`](../../rules/repo-naming.md).

## Cross-refs

- [keep-oriz-add-site-suffix](./keep-oriz-add-site-suffix.md) — the
  earlier two-suffix decision this one supersedes-by-extension
- [oriz-me added to the family](./oriz-me-added-to-family.md)
- [@chirag127/oriz-kit package name](./oriz-kit-package-name.md)
- [Chrome extensions as submodules](../infrastructure/chrome-extensions-as-submodules.md)
- [`rules/repo-naming.md`](../../rules/repo-naming.md) — the audit-before-publish rule
- [`runbooks/rename-repo.md`](../../runbooks/rename-repo.md) — the rename procedure
- [oriz-kit glossary entry](../../glossary/o-r/oriz-kit.md)
- [AGENTS.md](../../../AGENTS.md)
