---
type: service
title: "DeepSource"
description: "Static analysis with autofix — JS/TS/Python/Go rule set, free unlimited for public repos. Catches issues with one-click PRs."
tags: [services, code-quality, static-analysis, autofix]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: static-analysis
provider: deepsource
free_tier: "Free unlimited for public / open-source repos — unlimited analyses, all supported languages, autofix PRs, security + bug-risk + anti-pattern + performance categories"
swap_cost: low
related:
  - services/code-quality/sonarcloud
  - services/code-quality/codeclimate
  - services/code-quality/coderabbit
  - decisions/architecture/code-quality-five-tools
  - rules/no-card-on-file
---

# DeepSource

## Role

Continuous static-analysis pass on every PR. DeepSource emphasises
**autofix** — rather than only reporting issues, the dashboard
offers "fix this with one click" PRs that the developer can accept
or close. The rule set covers TypeScript, JavaScript, Python, Go,
Ruby, Java, Rust, Shell, Docker, and SQL.

## Free tier

Free unlimited for public / OSS repos:

- Unlimited analyses
- All supported languages
- Autofix PRs (one-click)
- Issue categories: security, bug risk, anti-pattern, performance,
  documentation, style
- Transformers (formatters / lint-fixers run as a CI step)
- PR status checks + comments
- Trend dashboard across the family's public repos

## Card / subscription required?

**NO** for public repos. GitHub App install, OAuth sign-in.

## Alternatives

- [Sonarcloud](./sonarcloud.md) — broader rule library, deeper SAST,
  but no autofix PRs.
- [Code Climate](./codeclimate.md) — sibling in this stack, different
  rendering (A — F grade vs. issue list).
- CodeQL — GitHub-native, free for public repos, security-focused
  (already in `templates/per-site-ci/.github/workflows/codeql.yml`).
- Semgrep — pattern-based, OSS, can self-host; less out-of-the-box.

## Swap cost

**Low.** GitHub App install + `.deepsource.toml` at repo root. No
code changes. Autofix PRs are reviewable git commits; removing
DeepSource doesn't strand anything.

## Why this is our pick

DeepSource's autofix surface is unique in the five-tool stack
([decision](../../decisions/architecture/code-quality-five-tools.md)):
Sonarcloud + Code Climate report, CodeRabbit reviews, Codecov tracks
coverage — DeepSource is the one tool that **proposes the fix as a
PR**. Cheapest path from "this is a problem" to "this is fixed in
the codebase" without manual edits.

## Cross-refs

- [Code quality services index](./index.md)
- [Five-tool code quality decision](../../decisions/architecture/code-quality-five-tools.md)
- [Sonarcloud — broader SAST, no autofix](./sonarcloud.md)
- [Code Climate — A — F grade rendering](./codeclimate.md)
- [CodeRabbit — LLM PR review](./coderabbit.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
