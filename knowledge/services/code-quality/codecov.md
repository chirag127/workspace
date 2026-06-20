---
type: service
title: "Codecov"
description: "Coverage tracking for every PR — uploads LCOV from Vitest, posts coverage delta as a check, free unlimited for public repos."
tags: [services, code-quality, coverage, testing]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: coverage-tracking
provider: codecov
free_tier: "Free for public repos — unlimited uploads, unlimited reports, all languages, PR comments + status checks"
swap_cost: low
related:
  - services/code-quality/sonarcloud
  - services/code-quality/coderabbit
  - services/testing/vitest
  - decisions/architecture/code-quality-five-tools
  - decisions/architecture/testing-three-layer
  - rules/no-card-on-file
---

# Codecov

## Role

Tracks per-PR test coverage. The CI workflow runs Vitest with the
LCOV reporter, then `codecov/codecov-action@v5` uploads the report.
Codecov posts a comment on the PR showing coverage delta vs `main`
and adds a status check that fails if coverage drops below the
configured floor.

## Free tier

Free forever for public repos:

- Unlimited uploads
- Unlimited reports
- Unlimited committers / contributors
- All languages
- PR comments + status checks
- Coverage badges
- Branch + flag-based reporting

## Card / subscription required?

**NO** for public repos. Sign-in via GitHub OAuth; no payment method
requested. The family's [public-repos-only stance](../../rules/repos-work-independently.md)
keeps every repo eligible.

## Alternatives

- [Sonarcloud](./sonarcloud.md) — also tracks coverage, but the
  rendering is part of the SAST report and the dashboard is busier
  for "what's the coverage delta on this PR" specifically.
- Coveralls — similar, smaller community, slower PR comments.
- Self-hosted (Coverage Gutters in editor only) — no PR feedback.

## Swap cost

**Low.** Replace `codecov/codecov-action@v5` with the alternative's
action; LCOV format is universal. Coverage thresholds live in
`codecov.yml` at repo root.

## Why this is our pick

Five-tool code-quality stack ([decision](../../decisions/architecture/code-quality-five-tools.md))
needs vendor-redundant signals: Sonarcloud renders coverage as part
of its quality gate, Codecov renders it as **the** dedicated PR
artefact. Codecov's PR comment is the most-read signal during
reviews and the family ships it on every public repo without paying
anything.

## Cross-refs

- [Code quality services index](./index.md)
- [Five-tool code quality decision](../../decisions/architecture/code-quality-five-tools.md)
- [Vitest — emits LCOV](../testing/vitest.md)
- [Sonarcloud — also tracks coverage](./sonarcloud.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
