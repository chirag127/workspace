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

# Repo naming — universal suffix policy (every repo carries a role suffix)

## Decision (revised 2026-06-20 evening, second pass)

Every chirag127 repo carries a suffix that names its runtime category.
Sites get `-site`, npm packages stay bare scoped (`@chirag127/<name>`),
extensions get `-ext` / `-vsc-ext`, CLIs get `-cli`, MCP servers get
`-mcp`, Cloudflare Workers get `-worker`, Cloudflare/Firebase Functions
get `-fn`, static-data repos get `-data`, agent skills get `-skill`,
agent rule bundles get `-rules`. **No exceptions for sites this time** —
the prior hybrid carve-out (sites bare) is dropped.

| Role | Suffix | Examples |
|---|---|---|
| Static site | `-site` | `pages-site`, `lore-site`, `pdf-tools-site` |
| Astro / JS / TS npm package | _(none — scoped only)_ | `@chirag127/astro-shell`, `@chirag127/astro-chrome` |
| Browser extension | `-ext` | `kagi-summarizer-ext`, `bookmarks-ext` |
| VS Code extension | `-vsc-ext` | `snippets-vsc-ext` |
| CLI tool | `-cli` | `deploy-cli`, `echo-cli` |
| Cloudflare Worker | `-worker` | `api-worker` |
| Cloudflare / Firebase Function | `-fn` | `og-image-fn` |
| Model Context Protocol server | `-mcp` | `knowledge-mcp` |
| Static data repo | `-data` | `redirects-data` |
| Agent skill (Claude Code, etc.) | `-skill` | `grill-me-skill`, `agents-md-sync-skill` |
| Agent rule bundle | `-rules` | `family-rules` |

**No brand prefix.** The `chirag127/` org slug is already the prefix.
**Same name across GitHub repo and npm package** when both exist
(modulo `@chirag127/` scope on npm).
**Subdomains stay descriptive and shortest** (`pdf.oriz.in` not
`pdf-tools-site.oriz.in`). The suffix is a repo-only identifier.

## Why universal suffix (this pass)

- **Recruiter scanning**: every repo at-a-glance reveals its runtime
  category from the slug alone. No need to open the repo to learn what
  it is.
- **Organization listing readability**: repos sort + group by suffix in
  `gh repo list` output and on the GitHub user page.
- **Stamp wordmark**: the family-wide rubber-stamp signature on every
  site reads `ORIZ · pages-site` / `ORIZ · pdf-tools-site` — the suffix
  becomes part of the visible brand (per user MCQ this session).
- **Skill discovery**: `chirag127/*-skill` is grep-able for the agent
  skills CLI; `chirag127/skill-*` was the old npm-skills convention but
  inconsistent with the rest of the family.

## Skill repo prefix flip (added 2026-06-20 evening)

Old: `chirag127/skill-<name>` (npm skills CLI install target).
New: `chirag127/<name>-skill` (consistent with universal suffix).

Renamed this session:
- `skill-agents-md-sync` → `agents-md-sync-skill`
- `skill-claude-code-mcq-notes` → `claude-code-mcq-notes-skill`

GitHub auto-redirects keep old `npx skills add chirag127/skill-<name>`
URLs working until the next `gh repo rename` round.

## Site rename (this session, third pass)

The earlier brand-only push (`pages`, `lore`, `tabs`, etc.) was reverted.
All 9 sites carry `-site` suffix now:

| Brand | Repo | Subdomain |
|---|---|---|
| pages | `chirag127/pages-site` | blog.oriz.in |
| lore | `chirag127/lore-site` | (TBD) |
| ncert | `chirag127/ncert-site` | ncert.oriz.in |
| tabs | `chirag127/tabs-site` | cards.oriz.in |
| home | `chirag127/home-site` | oriz.in |
| roam | `chirag127/roam-site` | journal.oriz.in |
| me | `chirag127/me-site` | me.oriz.in |
| echo | `chirag127/echo-site` | post.oriz.in (planned) |
| janaushdhi | `chirag127/janaushdhi-site` | (TBD) |

## Rejected this session

- Brand-only sites (`pages`, `lore`, `tabs`) — third-pass reversal.
- Hybrid (sites bare + others suffixed) — replaced by universal suffix
  for consistency.
- `chirag127/skill-*` prefix convention — inconsistent with the rest of
  the family slug pattern.

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
  | `chirag127/home` | `chirag127/home` |
  | `chirag127/pages` | `chirag127/pages` |
  | `chirag127/ncert` | `chirag127/ncert` |
  | `chirag127/lore` | `chirag127/lore` |
  | `chirag127/tabs` | `chirag127/tabs` |
  | `chirag127/oriz-finance` | `chirag127/finance-tools-site` |
  | `chirag127/roam` | `chirag127/roam` |
  | `chirag127/oriz-urls-to-md` | `chirag127/dev-tools-site` |
  | `chirag127/oriz-image-tools` | `chirag127/image-tools-site` |
  | `chirag127/oriz-pdf-tools` | `chirag127/pdf-tools-site` |
  | `chirag127/oriz-me` | `chirag127/me` |

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
