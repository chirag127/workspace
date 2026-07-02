---
type: decision
title: "Brand-independent repo naming — drop oriz- prefix 2026-07-02"
description: "All chirag127/* repos use descriptive names without brand prefix. Enables future brand/domain migration without repo renames. Only npm package scope will migrate separately (deferred)."
tags: [naming, branding, repos, migration]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
supersedes:
  - branding/repo-naming-drop-oriz-prefix-2026-06-25
related:
  - branding/chirag127-owns-everything-2026-07-02
  - rules/development/repo-naming
---

# Brand-independent repo naming

## Decision

Repo names describe FUNCTION, not brand. Zero `oriz-` prefix on GitHub repo names. If the `oriz` brand changes tomorrow to any other name, only:
- `oriz.in` domain (registrar-side)
- `@oriz/*` npm scope (npm-side)
- Marketing copy in READMEs

need to change. Repo names stay stable forever.

## Rename mapping (executed 2026-07-02)

| Old | New | Function |
|---|---|---|
| `oriz-workflows` | `workflows` | Reusable GH Actions workflows |
| `oriz-mmi-tickertape-mmi-api` | `market-mood-index-api` | Tickertape MMI scraper API |
| `oriz-ncert-app` | `ncert-textbooks-app` | NCERT textbook access PWA |
| `oriz-janaushdhi-app` | `janaushdhi-medicine-finder-app` | Jan Aushadhi affordable-medicine locator |
| `oriz-lore-app` | `lore-app` | Lore/story app |
| `oriz-me-book` | `100-year-strategy-book` | 100-year personal strategy mdBook |
| `oriz-janaushdhi-book` | `janaushdhi-book` | Jan Aushadhi documentation book |

## Naming rules

1. **No brand prefix.** No `oriz-`, no `chirag-`. GitHub owner already shows `chirag127`.
2. **Function-first.** `market-mood-index-api` not `oriz-mmi-api`.
3. **Type suffixes kept** as useful markers: `-api`, `-app`, `-book`, `-npm-pkg`, `-vsc-ext`, `-bs-ext`, `-mcp-server`.
4. **kebab-case only.** Lowercase.
5. **Full words over abbreviations.** `history-lore-app` > `hist-lore` unless the abbreviation is universally known (`api`, `pwa`, `sdk`, `cli`).
6. **English descriptive.** For India-specific content (NCERT, Jan Aushadhi, RTO), keep the term but add context: `janaushdhi-medicine-finder-app` not just `janaushdhi-app`.

## What stays (for now)

- **`@oriz/*` npm scope**: kept as-is 2026-07-02, deferred migration to `@chirag127/*`. Reason: less painful to change JSON strings in downstream package.json files than to rename 20 repos twice.
- **`oriz.in` domain**: kept — this IS the brand. If brand changes, domain changes.

## Anti-patterns

- ❌ `oriz-<function>` — brand prefix
- ❌ `chirag-<function>` — owner prefix (redundant with GitHub URL)
- ❌ `co-<function>` — old org prefix
- ❌ Marketing names — `oriz-brilliant-idea-app`. Stick to what it does.

## Migration mechanics

- GitHub `PATCH /repos/{owner}/{repo}` with `name` field renames + auto-redirects old URLs for 1 year.
- Old submodule pointers auto-follow the redirect.
- npm publish continues on `@oriz/*` — separate migration.

## Cross-refs

- [`chirag127-owns-everything-2026-07-02`](./chirag127-owns-everything-2026-07-02.md)
- Supersedes: `branding/repo-naming-drop-oriz-prefix-2026-06-25.md` (older decision, less specific)
