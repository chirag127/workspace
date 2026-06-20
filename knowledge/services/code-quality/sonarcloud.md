---
type: service
title: "Sonarcloud"
description: "Deeper static analysis — SAST, code smells, duplication, complexity, coverage. Free for OSS. Catches issues biome can't."
tags: [services, code-quality, sast, static-analysis]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: static-analysis
provider: sonarsource
free_tier: "Free for public repos — unlimited lines of code analysed; SAST, code smells, duplication, cyclomatic complexity, coverage tracking"
swap_cost: medium
---

# Sonarcloud

## Role

Whole-repository static analysis after each merge to `main`. Sonarcloud catches:

- **Security hotspots** (SAST) — auth bypass patterns, unsafe deserialisation, weak crypto, hardcoded secrets biome doesn't know about
- **Code smells** — long methods, large classes, deep nesting, dead code
- **Duplication** — copy-pasted blocks across files
- **Cyclomatic complexity** — functions too branchy to test
- **Coverage** — when paired with the test runner's output

Biome is fast and great at lint + format, but it's not a full SAST tool — Sonarcloud fills that gap.

## Free tier

Free forever for public repos:

- Unlimited lines of code analysed
- All language rules (TypeScript, JavaScript, CSS, JSON, YAML, etc.)
- Pull-request decoration (analysis posted as a check on every PR)
- Coverage tracking when test runner emits LCOV

## Card / subscription required?

**NO** for OSS / public repos. Paid plans for private repos start at metered LOC.

## Alternatives

- **Semgrep** — pattern-based SAST, OSS, can self-host; less full-rules-out-of-the-box than Sonar
- **CodeQL** — GitHub-native, free for public repos, deeper SAST but less code-smell coverage
- **DeepSource** — similar OSS-friendly tier, narrower rule set

## Swap cost

**Medium.** Each replacement requires a different `.github/workflows/<tool>.yml`, a different webhook, and PR-decoration UI changes. The actual code stays the same — these are all CI-side checks.

## Why this is our pick

Sonarcloud's rule library on TypeScript is the broadest of the OSS-tier options, and the dashboard's per-project quality-gate view gives the family a single pane across all 13+ repos. Critically, Sonarcloud catches issues biome can't: it understands data flow, not just syntax. A function that builds a SQL string from user input is a Sonar finding, not a biome finding.

## Cross-refs

- [services/code-quality/coderabbit](./coderabbit.md)
- [services/code-quality/dependabot](./dependabot.md)
- [rules/repos-work-independently](../../rules/repos-work-independently.md)
- [decisions/code-quality-stack](../../decisions/process/code-quality-stack.md)
