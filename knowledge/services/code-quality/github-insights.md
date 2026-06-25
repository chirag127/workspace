---
type: service
title: "GitHub Insights"
description: "Native repo insights — contributors, commits-over-time, code frequency, dependents, traffic. Free, native to every public repo, auto-tracked. Used as a code-stats source for the family /stats page."
tags: [services, code-quality, code-stats, github, native, auto-tracking]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-stats-native
provider: github
free_tier: "Free, native to every public repo on GitHub. Includes contributors graph, commit activity, code frequency, punchcard, network, forks, dependents. Public-repo traffic data is owner-only."
swap_cost: zero
related:
  - services/code-quality/tokei
  - services/code-quality/lines-of-code-badge
  - decisions/architecture/code-stats-everything
  - decisions/architecture/family-wide-stats-page
  - rules/auto-only-tracking
---

# GitHub Insights

## Role

Every public family repo gets free native code stats from GitHub:

- **Contributors graph** — per-author commits over the lifetime of
  the repo
- **Commit activity** — last-52-week heatmap
- **Code frequency** — additions/deletions per week
- **Network + forks** — fork tree
- **Dependents** — packages depending on this one (if it's a public
  package)
- **Traffic** (private to the owner) — clones + visitor counts +
  popular content + referrers, last 14 days

No setup — Insights is on by default for every public repo. The
family /stats page reads these via the REST API at build time per
[`family-wide-stats-page`](../../decisions/architecture/family-wide-stats-page.md).

## Free tier

Free, unlimited, native to every public GitHub repo. No quota.

## Card / subscription required?

**NO.** Native to every GitHub account.

## Alternatives

- [Tokei](./tokei.md) — sibling tool in this stack, complementary:
  Tokei does per-language line counts, GitHub Insights covers
  commits / contributors / activity over time. Both feed the family
  /stats page.
- [Code Climate Quality](./codeclimate.md) — overlap on
  maintainability dashboards but Insights is the canonical
  authorship + cadence source.
- Self-hosted git stats (gitstats / git-quick-stats) — same data
  recomputable locally; redundant when GitHub already exposes it
  via free API.

## Swap cost

**Zero** — GitHub Insights is a property of hosting on GitHub. If
the family ever moved off GitHub (it won't —
[GitHub Issues only](../../decisions/architecture/bug-tracker-github-issues-only.md)
+ [GitHub Projects only](../../decisions/architecture/project-mgmt-github-projects-only.md)
+ GitHub Pages mirror are all locked), equivalent stats would have to
be regenerated from `git log`.

## Why this is our pick

The 9-tool code-stats stack
([decision](../../decisions/architecture/code-stats-everything.md))
deliberately includes every metric the family can auto-track for
free. GitHub Insights is the **native** code-stats layer — already
running, already covering every repo, already free. Including it as
a documented service makes the
[family-wide /stats page](../../decisions/architecture/family-wide-stats-page.md)
an explicit consumer instead of an implicit one.

Auto-tracked end-to-end: GitHub computes every graph from `git log`
itself, no human action triggers updates. Aligns with the
[`auto-only-tracking`](../../rules/interaction/auto-only-tracking.md) rule.

## Cross-refs

- [Code quality services index](./index.md)
- [Code stats everything decision (9-tool stack)](../../decisions/architecture/code-stats-everything.md)
- [Family-wide /stats page decision](../../decisions/architecture/family-wide-stats-page.md)
- [Tokei — sibling line-counter](./tokei.md)
- [Lines of Code badge — README rendering](./lines-of-code-badge.md)
- [Auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) (forward ref — being added in parallel)
