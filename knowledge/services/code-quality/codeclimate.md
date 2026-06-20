---
type: service
title: "Code Climate Quality"
description: "Maintainability scoring — Code Climate's 'A through F' grade per file, free for public repos. Catches technical-debt patterns biome / Sonarcloud surface differently."
tags: [services, code-quality, maintainability, technical-debt]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: maintainability-score
provider: codeclimate
free_tier: "Free for public / open-source repos — unlimited analysis, all languages, PR comments + status checks, maintainability + duplication metrics"
swap_cost: low
related:
  - services/code-quality/sonarcloud
  - services/code-quality/codecov
  - services/code-quality/deepsource
  - decisions/architecture/code-quality-five-tools
  - rules/no-card-on-file
---

# Code Climate Quality

## Role

Assigns each file in the repo a maintainability grade (A — F) based
on cyclomatic complexity, cognitive complexity, method length, file
length, argument count, and duplication. Posts the per-PR delta as a
status check; the dashboard surfaces the worst-graded files across
the whole family at a glance.

## Free tier

Free forever for OSS / public repos:

- Unlimited analysis
- All languages (JS / TS / Ruby / Python / Go / Java / etc.)
- PR comments + status checks
- Maintainability + duplication reports
- Coverage import (we point Codecov at coverage; CC reads its own
  upload via `cc-test-reporter` if we want the duplicate)
- Public dashboard (linkable from repo READMEs)

## Card / subscription required?

**NO** for public repos. GitHub OAuth signup, no payment method
requested.

## Alternatives

- [Sonarcloud](./sonarcloud.md) — broader rule set and SAST, but its
  maintainability rendering is buried inside the quality-gate UI;
  Code Climate's "A — F per file" is the most legible single
  artefact for technical-debt review.
- [DeepSource](./deepsource.md) — sibling tool in this stack,
  different rule emphasis (issues / autofix vs. graded
  maintainability).
- Better Code Hub — discontinued.

## Swap cost

**Low.** GitHub App install + a one-line `.codeclimate.yml` at repo
root. No code changes; uninstalling the GitHub App removes it
cleanly.

## Why this is our pick

The five-tool code-quality stack
([decision](../../decisions/architecture/code-quality-five-tools.md))
deliberately picks **different rendering surfaces** for overlapping
signals: Sonarcloud's quality-gate, CodeRabbit's LLM PR review,
Codecov's coverage delta, DeepSource's issue list, and Code Climate's
A — F grade. The grade is the cheapest signal to glance at during a
"is this file getting worse?" check; it complements the rest without
duplicating the dashboard.

## Cross-refs

- [Code quality services index](./index.md)
- [Five-tool code quality decision](../../decisions/architecture/code-quality-five-tools.md)
- [Sonarcloud — broader SAST](./sonarcloud.md)
- [DeepSource — sibling in this stack](./deepsource.md)
- [Codecov — coverage rendering](./codecov.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
