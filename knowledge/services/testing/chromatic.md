---
type: service
title: "Chromatic"
description: "Visual regression diff against Storybook snapshots. Free 5K snapshots/month, no card."
tags: [testing, visual-regression, chromatic, storybook, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-visual-regression
provider: chromatic
free_tier: "5,000 snapshots/month, unlimited components, unlimited collaborators, no card"
swap_cost: medium
related:
  - services/testing/storybook
  - services/testing/vitest
  - services/testing/playwright
  - decisions/architecture/testing-three-layer
---

# Chromatic

## Role

**Visual regression** for every component story in the family's
[Storybook](./storybook.md). On every PR, Chromatic uploads the
built Storybook, captures one snapshot per story per supported
viewport, and diffs each frame against the baseline branch. The PR
shows a "Visual changes" check that requires explicit acceptance
of any pixel-level diff.

Chromatic is the only layer of the
[three-layer testing stack](../../decisions/architecture/testing-three-layer.md)
that catches "this CSS change broke an unrelated component" — a
class of regression no functional test reaches.

## Free tier

- 5,000 snapshots / month — well above the family's 11+ sites + 5
  oriz-ui packages at current story counts
- Unlimited components, unlimited collaborators
- TurboSnap (only re-snapshot stories whose dependencies changed) on
  the free tier — reduces snapshot burn
- No card required at sign-up

## Card / subscription required?

**NO.** Free-tier sign-up is GitHub-OAuth-only. No payment method
requested.

## How CI consumes it

```yaml
- name: Build Storybook
  run: pnpm storybook build --output-dir storybook-static
- name: Visual regression (Chromatic)
  uses: chromaui/action@v11
  with:
    projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
    storybookBuildDir: storybook-static
    onlyChanged: true       # TurboSnap
    exitZeroOnChanges: false # PR fails on undeclared diff
```

`CHROMATIC_PROJECT_TOKEN` lives in [Doppler](../secrets/doppler.md).
The check posts back to the PR with a link to accept / reject each
diff in Chromatic's UI.

## Snapshot budget

At ~50 stories per package × 1 viewport × 17 PRs/month avg, the
family burns roughly 850 snapshots/mo without TurboSnap; with
TurboSnap on, typically <300/mo. The 5K cap is a 5-10x buffer —
well within the
[never-hit-quotas](../../rules/interaction/never-hit-quotas.md) posture.

## Alternatives

- Percy (BrowserStack) — paid past 5K screenshots/mo with a
  card-on-file requirement.
- Lost Pixel — OSS, self-hostable, requires CI plumbing for the
  baseline storage; documented as an escape-hatch swap.
- Argos CI — comparable free tier, smaller community.

## Swap cost

Medium — Storybook stays the same; only the Chromatic-specific
GitHub Action + project token are removed. Lost Pixel is the
documented self-hosted swap target if the 5K/mo cap ever tightens.

## Why this is our pick

Tightest Storybook integration, free 5K snapshots/mo (well above
family scale), TurboSnap halves snapshot burn for free, no card.
Pairs with Storybook + Vitest + Playwright as the family's
[three-layer testing stack](../../decisions/architecture/testing-three-layer.md).

## Cross-refs

- [testing services index](./index.md)
- [Storybook — snapshot source](./storybook.md)
- [Vitest — unit sibling](./vitest.md)
- [Playwright — E2E sibling](./playwright.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [Doppler — secrets source-of-truth](../secrets/doppler.md)
- [Never hit quotas rule](../../rules/interaction/never-hit-quotas.md)
- [No card-on-file rule](../../rules/interaction/no-card-on-file.md)
