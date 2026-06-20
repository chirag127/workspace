---
type: decision
title: "Per-repo CI workflows; master matrix only owns deploys"
description: "REVERSES earlier master-matrix-only CI. Each site/extension/package repo has its own .github/workflows/ci.yml running lint+typecheck+build on PR."
tags: [ci, workflows, github-actions, repos]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
supersedes: master-matrix-only-ci
related:
  - decisions/infrastructure/extensions-cross-store-publish
  - rules/parallel-by-default
---

# Per-repo CI workflows; master matrix only owns deploys

## Decision

Each repo (every site under `sites/`, every extension under
`extensions/`, every package under `packages/`) owns its own
`.github/workflows/ci.yml` that runs lint + typecheck + build on
every PR. The master matrix workflow at
`chirag127/oriz/.github/workflows/deploy.yml` no longer runs CI
gating — it now ONLY owns production deploys (matrix over every
site, deploys to its Cloudflare Pages target).

## Why

The earlier "one matrix workflow runs everything" approach made PRs
inside a sub-repo unable to gate themselves — the matrix only
triggered on the master pointer bump. That pushed breakage into
master repeatedly. Per-repo CI catches breakage at PR time, in the
repo where the change actually lives, with the contributor watching
the green/red mark in their own PR. Master matrix stays useful for
"deploy everything when a pointer bumps" without doubling as a CI
gate it can't fulfil.

## Implications

- Each site/extension/package repo gets a `.github/workflows/ci.yml` with `pnpm install` + lint + typecheck + build steps.
- Each extension repo also gets a cross-store publish workflow (Chrome + Firefox + Edge stores) — separate file from `ci.yml`.
- Master `deploy.yml` is reduced: matrix over sites, runs only on master pointer-bump commits, deploys to Cloudflare Pages.
- New repos must include a CI workflow at bootstrap — adding it later means days of un-gated commits land before the first PR.
- envpact CI integration (`chirag127/envpact-action@v0`) goes in each repo's CI when the build needs secrets.

## Cross-refs

- [Extensions cross-store publish](../infrastructure/extensions-cross-store-publish.md)
- [Parallel-by-default rule](../../rules/parallel-by-default.md)
- [AGENTS.md per-repo CI section](../../../AGENTS.md)
