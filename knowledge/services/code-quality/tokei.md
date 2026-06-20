---
type: service
title: "Tokei"
description: "Rust CLI that counts lines of code by language — files, lines, blanks, comments, code. Run in CI; output JSON → publish to family /stats page. OSS, no card."
tags: [services, code-quality, code-stats, line-count, rust, oss, auto-tracking]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-line-counter
provider: tokei (XAMPPRocky/tokei, OSS)
free_tier: "OSS — Apache-2.0 / MIT dual-licensed. Single static Rust binary, runs anywhere, no service backend, no quota."
swap_cost: low
related:
  - services/code-quality/github-insights
  - services/code-quality/lines-of-code-badge
  - decisions/architecture/code-stats-everything
  - decisions/architecture/family-wide-stats-page
  - rules/auto-only-tracking
---

# Tokei

## Role

[Tokei](https://github.com/XAMPPRocky/tokei) is a Rust CLI that
counts files, blanks, comments, code, and total lines, broken down
per programming language. Run in every public family repo's CI as a
single step; emits JSON; uploaded as a workflow artefact and
consumed at build time by the
[family-wide /stats page](../../decisions/architecture/family-wide-stats-page.md).

CI step shape (lands in `templates/per-site-ci/.github/workflows/ci.yml`):

```yaml
- name: Count lines of code
  run: |
    cargo install tokei --quiet || curl -sSL https://github.com/XAMPPRocky/tokei/releases/latest/download/tokei-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /usr/local/bin
    tokei --output json . > tokei.json
- uses: actions/upload-artifact@v4
  with:
    name: tokei-stats
    path: tokei.json
```

The family /stats page build consumes the JSON via the GitHub REST
API (`/repos/{owner}/{repo}/actions/artifacts`) and renders the
per-language breakdown across all family repos.

## Free tier

OSS, Apache-2.0 / MIT dual-licensed. No SaaS backend — runs locally
or in CI. Zero quota.

## Card / subscription required?

**NO.** Static binary, no signup.

## Alternatives

- [`cloc`](https://github.com/AlDanial/cloc) — Perl-based equivalent;
  slower on large repos, similar feature set.
- [`scc`](https://github.com/boyter/scc) — Go-based, comparable
  speed, includes complexity estimation. Reasonable swap target if
  Tokei development stalls.
- GitHub's own language detection (Linguist) — surfaces percentages
  in the repo header but emits no detailed line counts.

## Swap cost

**Low.** Replace one CI step + one downstream consumer in the stats
page builder. Output JSON shape is similar across `cloc` / `scc`.

## Why this is our pick

Fastest of the OSS line counters at family scale (sub-second on
typical repos), single static binary with no runtime dependencies,
JSON output that the family /stats page consumes directly without a
parser. Used inside the
[9-tool code-stats stack](../../decisions/architecture/code-stats-everything.md)
as the canonical "lines of code" source — its JSON output also
backs the
[Lines of Code badge](./lines-of-code-badge.md) rendered in every
repo's README.

Auto-tracked end-to-end: Tokei runs on every CI invocation without
human action, in line with the
[`auto-only-tracking`](../../rules/auto-only-tracking.md) rule.

## Cross-refs

- [Code quality services index](./index.md)
- [Code stats everything decision (9-tool stack)](../../decisions/architecture/code-stats-everything.md)
- [Family-wide /stats page decision](../../decisions/architecture/family-wide-stats-page.md)
- [GitHub Insights — sibling native stats](./github-insights.md)
- [Lines of Code badge — consumes Tokei output](./lines-of-code-badge.md)
- [Auto-only-tracking rule](../../rules/auto-only-tracking.md) (forward ref — being added in parallel)
