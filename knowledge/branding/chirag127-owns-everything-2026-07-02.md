---
type: decision
title: "chirag127 owns everything — oriz-org dissolved 2026-07-02"
description: "Every repo (own, forks, workflows, umbrella) lives under chirag127. oriz-org GitHub org is dissolved. Secrets consolidated in the umbrella (chirag127/workspace)."
tags: [org, github, branding, recruiter, migration]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
supersedes:
  - branding/oriz-org-rename-from-co
  - branding/keep-oriz-org-recruiter-via-pinning
related:
  - rules/agent/fork-thin-upstream-tracking
  - decisions/architecture/agent-tooling/workspace-owns-secrets-2026-07-02
---

# chirag127 owns everything — oriz-org dissolved

## Decision

All GitHub repos live at `chirag127/<name>`. The `oriz-org` GitHub org is dissolved after all transfers complete.

## Layout

| Repo class | Location | Example |
|---|---|---|
| Own | `chirag127/*` | `chirag127/oriz-blog`, `chirag127/constants-api` |
| Forks | `chirag127/*` | `chirag127/OmniRoute` (upstream = diegosouzapw/OmniRoute) |
| Umbrella | `chirag127/workspace` | Formerly `oriz-org/workspace`; renamed 2026-07-02 |
| Reusable workflows | `chirag127/oriz-workflows` | New — canonical GH Actions workflows for the whole fleet |
| Shared packages | `chirag127/oriz-<name>` published to npm as `@oriz/*` | e.g. `@oriz/astro-integration` |

## Why (2026-07-02)

Reversing the [`keep-oriz-org-recruiter-via-pinning`](../branding/keep-oriz-org-recruiter-via-pinning.md) strategy. New reasons override:

1. **Consistency after fork migration.** Forks moved to chirag127 on 2026-07-01 (see [`fork-thin-upstream-tracking`](../rules/agent/fork-thin-upstream-tracking.md)) because org-owned forks broke `maintainer_can_modify` on upstream PRs. Split ownership creates ongoing confusion.
2. **Recruiter view unchanged.** GitHub renders cross-org contributions on `chirag127` profile via the contribution graph. Pinning worked; direct ownership works better — repo count + star count appear on-profile.
3. **PR authorship.** External PRs to `chirag127/repo` present as personal-project contributions. `oriz-org/repo` PRs read as semi-corporate; some maintainers treat them differently.
4. **Simpler mental model.** One namespace, one place for issues, one profile URL to share.
5. **Secrets consolidation.** Org-level secrets replaced by umbrella-owned secrets model — see [`workspace-owns-secrets-2026-07-02`](../architecture/agent-tooling/workspace-owns-secrets-2026-07-02.md).

## What "oriz" as brand becomes

- **Domain**: `oriz.in` (owned via Spaceship registrar). Persists.
- **Repo prefix**: `chirag127/oriz-<name>` for family repos. `oriz-` prefix carries the brand.
- **npm scope**: `@oriz/*` scope is Chirag-owned. Persists.
- **PyPI/GitHub Packages**: same — brand is per-package, not per-org.
- **GitHub org**: **DELETED**.

## Migration mechanics

Use `gh repo transfer <src> <dst-owner>`:
- Preserves stars, issues, PRs, wikis, releases.
- URL redirects work for 1 year for git operations and web navigation.
- Submodule pointers must be updated manually in umbrella after transfer.

## Cross-refs

- [`workspace-owns-secrets-2026-07-02`](../architecture/agent-tooling/workspace-owns-secrets-2026-07-02.md)
- [`fork-thin-upstream-tracking`](../rules/agent/fork-thin-upstream-tracking.md)
- Supersedes: `branding/oriz-org-rename-from-co.md`, `branding/keep-oriz-org-recruiter-via-pinning.md` (DELETED same commit)
