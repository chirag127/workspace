---
type: decision
title: "Code quality stack — Dependabot + biome + CodeRabbit + Sonarcloud"
description: "Layered code-quality stack across the family. Dependabot for deps, biome local + CI, CodeRabbit reviewing PRs, Sonarcloud SAST on merge. All free for OSS."
tags: [decisions, process, code-quality, ci, oss]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - services/code-quality/dependabot
  - services/code-quality/coderabbit
  - services/code-quality/sonarcloud
  - rules/match-surrounding-style
  - rules/always-latest-deps
  - rules/repos-work-independently
---

# Code quality stack — Dependabot + biome + CodeRabbit + Sonarcloud

## Decision

Adopt a 4-layer code-quality stack across every repo in the chirag127/oriz family:

1. **Dependabot** — automated dependency / security update PRs (GitHub-native).
2. **biome** — lint + format on every commit and in CI (already in place).
3. **CodeRabbit** — AI code review on every pull request (free for OSS).
4. **Sonarcloud** — deeper static analysis (SAST, code smells, complexity, duplication, coverage) on merge to `main` (free for OSS).

## Why

Each layer catches a class of issues the others miss:

- Dependabot = supply chain (CVEs)
- biome = style + obvious bugs (deterministic, fast)
- CodeRabbit = logic + design + security smells (LLM-grade review of intent)
- Sonarcloud = data-flow + cyclomatic complexity + duplication (whole-codebase static analysis)

All four are free forever for the family's public OSS repos, fitting the [no-paid-tier](../../policy/no-paid-tier.md) rule.

## Implications

- Each repo's `.github/dependabot.yml` enables weekly version updates for `npm` (security updates are on by default GitHub-wide).
- Each repo's `.github/workflows/ci.yml` continues to run biome locally; this rule keeps repos working independently per [repos-work-independently](../../rules/repos-work-independently.md).
- The CodeRabbit GitHub App is installed at the org level, no per-repo setup needed.
- Sonarcloud is wired through a `.github/workflows/sonar.yml` per repo plus a Sonarcloud project per repo. Adds one more PR check.
- PR flow: open → biome runs → CodeRabbit comments → reviewer merges → Sonarcloud analyses → quality gate visible on dashboard.
- Dependabot's PRs flow through the same checks. CodeRabbit reviews dependency PRs the same way it reviews human PRs.

## Cross-refs

- [services/code-quality/index](../../services/code-quality/index.md)
- [services/code-quality/dependabot](../../services/code-quality/dependabot.md)
- [services/code-quality/coderabbit](../../services/code-quality/coderabbit.md)
- [services/code-quality/sonarcloud](../../services/code-quality/sonarcloud.md)
- [rules/match-surrounding-style](../../rules/match-surrounding-style.md)
- [rules/always-latest-deps](../../rules/always-latest-deps.md)
- [rules/repos-work-independently](../../rules/repos-work-independently.md)
- [decisions/per-repo-ci-workflows](./per-repo-ci-workflows.md)
