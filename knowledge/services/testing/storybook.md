---
type: service
title: "Storybook"
description: "Isolated component sandbox + interactive docs. Source of the visual-regression snapshots Chromatic diffs."
tags: [testing, component, storybook, ci, primary]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
role: test-component
provider: storybook
free_tier: "Unlimited — MIT OSS, hosted previews via Chromatic free tier"
swap_cost: medium
related:
  - services/testing/chromatic
  - services/testing/vitest
  - services/testing/playwright
  - decisions/architecture/testing-three-layer
  - decisions/architecture/oriz-ui-split-into-5-packages
---

# Storybook

## Role

Component sandbox for every export of `@chirag127/oriz-kit` and
the other [5 oriz-ui packages](../../decisions/architecture/oriz-ui-split-into-5-packages.md).
Each component ships a `*.stories.tsx` file declaring its canonical
states (default, loading, error, empty). Storybook serves three
purposes:

1. **Local dev** — render a component in isolation while iterating.
2. **Visual regression source** — the deployed Storybook is what
   [Chromatic](./chromatic.md) snapshots and diffs.
3. **Living component docs** — `autodocs` generates an MDX page
   per component for reviewers + future contributors.

## Free tier

- Unlimited — MIT OSS via `storybook`
- No account required for local / CI use
- Static build deployable anywhere (GitHub Pages, Cloudflare Pages,
  Chromatic's CDN)

## Card / subscription required?

**NO.** OSS. Hosted previews via Chromatic's free tier (5K
snapshots/mo) — see [chromatic.md](./chromatic.md).

## How CI consumes it

```yaml
- name: Build Storybook
  run: pnpm storybook build --output-dir storybook-static
- name: Visual regression (Chromatic)
  uses: chromaui/action@v11
  with:
    projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
    storybookBuildDir: storybook-static
    exitOnceUploaded: false
```

`CHROMATIC_PROJECT_TOKEN` lives in [Doppler](../secrets/doppler.md)
and syncs to GitHub Actions.

## What it catches

- Components rendered with unintended layout (margin / padding
  regressions)
- States not represented in stories (caught at story-write time)
- Theme + dark-mode regressions across the
  [v2 design system](../../design/index.md)
- Story-driven `play()` interaction tests via `@storybook/test`

## Alternatives

- Histoire — Vite-native, smaller community, narrower add-on
  ecosystem.
- Ladle — minimal alternative; same caveats.
- Plain `pnpm dev` — no isolation, no canonical state catalog.

## Swap cost

Medium — `*.stories.tsx` files are mostly portable to Histoire /
Ladle (same component-as-story shape) but the add-on configuration
(`autodocs`, `play()`, controls) re-implements per tool.

## Why this is our pick

The de-facto standard, biggest add-on ecosystem, and the only one
Chromatic ships first-class integration for. Free, OSS, deployable
anywhere. Pairs with Chromatic for visual regression — together
they form layer 3 of the
[three-layer testing stack](../../decisions/architecture/testing-three-layer.md).

## Cross-refs

- [testing services index](./index.md)
- [Chromatic — diffs Storybook snapshots](./chromatic.md)
- [Vitest — unit sibling](./vitest.md)
- [Playwright — E2E sibling](./playwright.md)
- [Testing three-layer decision](../../decisions/architecture/testing-three-layer.md)
- [oriz-ui split into 5 packages](../../decisions/architecture/oriz-ui-split-into-5-packages.md)
- [Doppler — secrets source-of-truth](../secrets/doppler.md)
- [No card-on-file rule](../../rules/no-card-on-file.md)
