---
type: decision
title: "One-branch-only rule: main branch only"
description: 'All repos: main branch only. No feature/fix/chore branches'
tags: [git, branches, workflow, rule]
timestamp: 2026-06-19
format_version: okf-v0.1
status: active
related:
  - rules/one-branch-only
  - decisions/process/per-repo-ci-workflows
  - rules/no-push-without-say-so
---

# One-branch-only rule: main branch only

## Decision

Every repo in the chirag127/oriz family — the master `oriz` repo,
every site under `sites/`, every package under `packages/`, every
extension under `extensions/` — commits straight on `main`. There
are no `feat/*`, `fix/*`, `chore/*`, `release/*`, or any other
branches. Single contributor, single branch, everywhere.

## Why

A solo dev with no PR-review pipeline gains nothing from feature
branches — they only add ceremony (branch / PR / merge) without
catching bugs that aren't already caught by per-repo CI. Removing
branches simplifies every git operation across 13+ repos: no
"which branch did I commit to in oriz-blog?" lookups, no merge
conflicts, no stale-branch cleanup. CI gates run on main pushes
directly and catch breakage at the same point a PR would.

## Implications

- Per-repo CI (`.github/workflows/ci.yml`) runs on push to main, not on PR — same lint+typecheck+build steps.
- Master matrix deploys trigger on master pointer-bump commits to main.
- No branch protection rules needed (which would require Pro plan in some private-repo cases anyway).
- New decisions / refactors land via direct commit + push (when user approves push); never via PR.
- Force-pushes to main remain forbidden per AGENTS.md ("Never force-push to main without explicit instruction").
- Subagents working in parallel must coordinate by commit ordering — when N subagents touch the same repo, they serialise commits via the user's instruction or via a single agent collecting the diffs.

## Cross-refs

- [One-branch-only rule (rules dir)](../../rules/development/one-branch-only.md)
- [Per-repo CI workflows](./per-repo-ci-workflows.md)
- <!-- TODO: broken link, was [No push without say-so rule](../../rules/no-push-without-say-so.md) -->
- [AGENTS.md git section](../../../AGENTS.md)
