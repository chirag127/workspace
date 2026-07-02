---
type: rule
title: "Atomic packages — extract lazily on second use"
description: 2+ apps need same logic ? extract to @oriz/* or oriz-* package. Concern-atomic (3-5 exports, 100-300 LOC). Build only when forced
tags: [feedback, packaging, agent-preferences]
timestamp: 2026-06-25
format_version: okf-v0.1
status: active
---

When the same logic is needed in 2 or more apps, extract it to an atomic package.

**Rules:**
- **Trigger:** =2 apps need the same logic AND no community equivalent exists at the size/shape we need.
- **Atomicity:** One concern per package. 3-5 exports max. ~100-300 LOC. NOT a one-function-per-package extreme; NOT a domain SDK either.
- **Namespaces:**
  - npm: `@oriz/<concern>` (e.g. `@oriz/analytics`, `@oriz/donations`, `@oriz/india-currency`)
  - PyPI: `oriz-<concern>` (e.g. `oriz-llm-providers`, `oriz-india-data-fetchers`)
- **Scope:** Astro/React components, vanilla TS utilities, India-data formatters, scraper helpers for APIs. NOT auth (that's a separate project per `no-auth-in-apps-or-apis`), NOT analytics WRAPPER (analytics stay inline in `BaseLayout.astro` until 2+ apps need the same custom event shape).
- **Repo home:** Each package lives in its own repo at `chirag127/<slug>-npm-pkg` or `chirag127/<slug>-py-pkg`. Submodule at `repos/own/<slug>-<npm|py>-pkg/`.

**Does NOT reverse:**
- The 23 archived packages stay archived. They were speculative / SDK-shaped; the new rule is the opposite.
- Analytics stays inline in apps unless we need a custom event-tracking helper across 2+ apps.
- Auth stays out of apps. A future `@oriz/login-redirect` thin client could exist when the separate login project ships.

**Reverses:**
- The earlier strict "zero in-house packages" blanket ban. Analytics stays inline; everything else is build-on-2nd-use.

**How to apply when 2nd app demands the same logic:**
1. Verify no community package exists at the right size/shape.
2. Create the repo: `gh repo create chirag127/<slug>-npm-pkg --public --description "<one-liner>"`.
3. Add as submodule: `git submodule add ... repos/own/<slug>-npm-pkg`.
4. Publish to npm with provenance enabled.
5. Document the package in `knowledge/services/<area>/<slug>.md` with OKF frontmatter.
6. Both apps adopt it on next touch; no big-bang migration.

**Documentation:**
- Every atomic package gets a `knowledge/services/<area>/<slug>.md` OKF entry.
- AGENTS.md auto-rebuild picks up new packages on next sync.

**Related:**
- [`lean-by-need-not-count`](./lean-by-need-not-count.md) — build-gate applies to packages.
- [`scope-cut-2026-06-25`](../../../decisions/fleet/scope-cut-2026-06-25.md) — only build packages used today.
- [`github-repo-names-are-brand-identity`](./github-repo-names-are-brand-identity.md) — package repo names are brand identity, picked carefully.
