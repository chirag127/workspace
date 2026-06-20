---
type: index
title: "Code quality + code stats services"
description: "The 9-tool stack that keeps every oriz repo's code healthy AND auto-tracks every available metric. All free for OSS / public repos."
tags: [services, code-quality, code-stats, index]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# Code quality + code stats services

A **9-tool layered stack** on every public family repo — each tool catches or surfaces a different signal, and all are free for OSS / public repos. The earlier 4-tool and 5-tool stacks stay; **GitHub Insights + Tokei + Lines of Code badge added 2026-06-20** alongside the 5 quality tools and biome. Locked at [`decisions/architecture/code-stats-everything.md`](../../decisions/architecture/code-stats-everything.md), extending [`code-quality-five-tools.md`](../../decisions/architecture/code-quality-five-tools.md).

| # | Tool | What it owns | Where it runs |
|---|---|---|---|
| 1 | [Sonarcloud](./sonarcloud.md) | SAST, code smells, duplication, complexity, coverage | CI on merge to `main` |
| 2 | [CodeRabbit](./coderabbit.md) | LLM-grade PR review (intent + design) | Comments on every PR |
| 3 | [Codecov](./codecov.md) | Per-PR coverage delta vs `main` | PR comment + status check |
| 4 | [Code Climate](./codeclimate.md) | A — F maintainability grade per file | Dashboard + status check |
| 5 | [DeepSource](./deepsource.md) | Static analysis with **autofix PRs** | Issue list + auto-PR |
| 6 | **biome** (in-repo, not a SaaS) | Lint + format — style violations, simple bugs, unused imports | Local + CI (`pnpm biome check`); see [rules/match-surrounding-style](../../rules/match-surrounding-style.md) |
| 7 | [Dependabot](./dependabot.md) | Vulnerable dependencies; out-of-date packages | GitHub-native, opens PRs automatically |
| 8 | [GitHub Insights](./github-insights.md) | Native contributors / commits / code-frequency / dependents | Repo `/pulse` + `/graphs/*` |
| 9 | [Tokei](./tokei.md) | Per-language line / file / blank / comment counts | CI artefact + family `/stats` |
| + | [Lines of Code badge](./lines-of-code-badge.md) | Single LoC number rendered as README badge | Auto-committed SVG in every repo |

(That is intentionally 9 tools + a badge renderer that consumes Tokei output. The user direction was *"ADD EVERYTHING — GitHub Insights + Tokei + CodeClimate + LinesOfCode badges."*)

The order is intentional: Dependabot opens dependency PRs → CodeRabbit reviews them → biome runs on the merge → Sonarcloud + Code Climate + DeepSource do deeper analysis after merge → Codecov tracks coverage delta on every PR → GitHub Insights + Tokei + LoC badge surface code-stats metrics for the family `/stats` page.

## Why all nine

Each layer catches a different failure mode and renders on a different surface:

- **Dependabot** = supply chain (CVEs, abandoned packages)
- **biome** = style + obvious mechanical bugs (fast, deterministic)
- **CodeRabbit** = LLM-grade review of intent and design (catches things rules can't encode)
- **Sonarcloud** = whole-codebase SAST (cyclomatic complexity, dup blocks, security hotspots biome misses)
- **Codecov** = coverage delta — most-read PR signal during reviews
- **Code Climate** = A — F per-file grade — cheapest "is this file getting worse?" glance
- **DeepSource** = autofix PRs — cheapest path from "issue reported" to "issue fixed"
- **GitHub Insights** = native commit cadence + contributor + code-frequency stats; auto-tracked, surfaces straight from `git log`
- **Tokei** = canonical per-language line counts; JSON output for the family `/stats` page builder
- **LoC badge** = the cheapest at-a-glance line-count signal in every README

All free for public repos under the family's
[everything-is-public-OSS posture](../../rules/repos-work-independently.md). Auto-tracked end-to-end per [`auto-only-tracking`](../../rules/auto-only-tracking.md).

## Cross-refs

- [9-tool code-stats decision (2026-06-20)](../../decisions/architecture/code-stats-everything.md)
- [5-tool code-quality decision (extended above)](../../decisions/architecture/code-quality-five-tools.md)
- [Earlier 4-tool stack decision (Batch 4, 2026-06-20)](../../decisions/process/code-quality-stack.md)
- [Family-wide /stats page decision](../../decisions/architecture/family-wide-stats-page.md)
- [rules/always-latest-deps](../../rules/always-latest-deps.md)
- [rules/match-surrounding-style](../../rules/match-surrounding-style.md)
- [rules/repos-work-independently](../../rules/repos-work-independently.md)
- [Auto-only-tracking rule](../../rules/auto-only-tracking.md) (forward ref — being added in parallel)
