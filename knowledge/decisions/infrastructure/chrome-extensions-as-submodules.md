---
type: decision
title: "Each Chrome extension is its own GitHub repo, added as a submodule"
description: "Every extension lives in its own chirag127/oriz-<name>-ext repo, added under extensions/ in the master oriz repo as a git submodule."
tags: [extensions, submodules, repos, structure]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - decisions/branding/keep-oriz-add-site-suffix
  - decisions/infrastructure/extensions-cross-store-publish
  - decisions/process/per-repo-ci-workflows
  - decisions/content/per-extension-subdomain
---

# Each Chrome extension is its own GitHub repo, added as a submodule

## Decision

Every extension is its own GitHub repository named
`chirag127/oriz-<slug>-ext`, added to the master `chirag127/oriz`
repo as a submodule under `extensions/<slug>/`. Extensions are not
folders inside a monorepo.

## Why

Each extension has its own release lifecycle (manifest version,
store-review cadence, Chrome/Firefox/Edge submission timing) that
shouldn't be coupled to the master repo's pointer bumps. Submodules
preserve independent commit history and let each extension's CI
publish to all 3 stores without master being involved. They also
mirror the existing pattern used for sites under `sites/`, so the
mental model stays consistent.

## Implications

- `git submodule add https://github.com/chirag127/oriz-<slug>-ext.git extensions/<slug>` to add a new extension.
- Each extension repo has its own `.github/workflows/ci.yml` (lint + typecheck + build) and a separate cross-store publish workflow.
- Master pointer bumps via `git add extensions/<slug> && git commit -m "chore(submodule): bump <slug> to <sha>"`.
- The extension's website (per [big-website-per-extension](../content/big-website-per-extension.md)) lives inside the same submodule under `site/` (or root) and deploys to `<slug>.oriz.in`.
- The one-branch-only rule applies: every extension repo commits straight on `main`.
- AGENTS.md and CLAUDE.md per-repo files extend the family rules with extension-specific overrides if needed.

## Cross-refs

- <!-- TODO: broken link, was [Repo naming: oriz-<name>-site / -ext](../branding/keep-oriz-add-site-suffix.md) -->
- [Extensions cross-store publish](./extensions-cross-store-publish.md)
- [Per-repo CI workflows](../process/per-repo-ci-workflows.md)
- [Per-extension subdomain](../content/per-extension-subdomain.md)
- [One-branch-only rule](../process/one-branch-only-rule.md)
