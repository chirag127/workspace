---
type: service
title: "Lines of Code badge (GitHub Action)"
description: "Auto-generated `<!-- TODO: broken link, was [![Lines of Code](badge.svg) -->]` badge in every family repo's README. GitHub Action runs on push, recomputes line count, commits the badge SVG. Free, OSS, auto-tracked."
tags: [services, code-quality, code-stats, badge, readme, github-actions, auto-tracking]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: code-stats-badge
provider: shadowmoose/GHA-LoC-Badge (or equivalent)
free_tier: "Free OSS GitHub Action; runs on the family's existing GitHub Actions free public-repo minutes (unlimited per repos-work-independently posture)."
swap_cost: low
related:
  - services/code-quality/tokei
  - services/code-quality/github-insights
  - decisions/architecture/code-stats-everything
  - decisions/architecture/family-wide-stats-page
  - rules/auto-only-tracking
---

# Lines of Code badge (GitHub Action)

## Role

A GitHub Action runs on every push to `main`, recomputes the repo's
total line count, regenerates an SVG badge, and commits the badge
back to the repo. The badge is referenced from each README's
heading block alongside the existing quality / coverage badges:

```markdown
<!-- TODO: broken link, was [![Lines of Code](.github/badges/lines-of-code.svg) -->](#)
```

Every repo's README ships the badge by default via
`templates/per-site-ci/`; new family repos pick it up automatically.

## Free tier

Free OSS Action, runs on the family's existing GitHub Actions free
public-repo minutes — unlimited under the
[public-everywhere posture](../../rules/development/repos-work-independently.md).

## Card / subscription required?

**NO.** GitHub Action; consumes Actions free minutes.

## Alternatives

- shields.io dynamic badge driven by the
  [Tokei](./tokei.md) JSON artefact URL — works but ties the badge
  to a remote service that has to fetch the artefact each render
  (rate-limited).
- Self-rendered SVG generated in-repo by a Python or Node script —
  same approach, more code to maintain.
- Skip the badge and link directly to the family /stats page —
  rejected because the README badge is the cheapest at-a-glance
  signal.

## Swap cost

**Low.** Replace the Action workflow YAML; the badge consumer
(README markdown) doesn't change.

## Why this is our pick

The 9-tool code-stats stack
([decision](../../decisions/architecture/code-stats-everything.md))
asks for a visible line-count signal in every repo's README — a
self-committing GitHub Action gives that for free, without depending
on a remote SVG host or a third-party badge service.

Composes with [Tokei](./tokei.md) for the canonical line count + the
[family-wide /stats page](../../decisions/architecture/family-wide-stats-page.md)
for the cross-repo aggregate view. The badge is the per-repo glance;
/stats is the family-wide dashboard.

Auto-tracked end-to-end: badge regenerates on every push without
human action, in line with the
[`auto-only-tracking`](../../rules/interaction/auto-only-tracking.md) rule.

## Cross-refs

- [Code quality services index](./index.md)
- [Code stats everything decision (9-tool stack)](../../decisions/architecture/code-stats-everything.md)
- [Family-wide /stats page decision](../../decisions/architecture/family-wide-stats-page.md)
- [Tokei — canonical line counter](./tokei.md)
- [GitHub Insights — sibling native stats](./github-insights.md)
- [Auto-only-tracking rule](../../rules/interaction/auto-only-tracking.md) (forward ref — being added in parallel)
