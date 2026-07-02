---
type: decision
title: Kiso as OKF build engine
description: Community OKF-bundle-to-static-site engine adopted for knowledge.oriz.in + skills.oriz.in; replaces custom Astro build.
tags: [okf, kiso, static-site, build]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: medium
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - rules/development/no-rebuilding-free-software
  - rules/development/community-packages-first
---

# Kiso — OKF static-site engine

## Decision

Adopt [Kiso](https://headlinesbriefing.com/dev/hacker-news/kiso-open-source-engine-transforms-knowledge-bundles-into-static-sites-a6f251ae) (announced 2026-06-27) as build engine for both public sites:

- `knowledge.oriz.in`
- `skills.oriz.in`

## Why Kiso (not Astro custom, not 11ty)

- **Purpose-built** — designed for exactly OKF-bundle-to-static-site.
- **`llms.txt` + `sitemap.xml`** — ships defaults per emerging OKF convention.
- **Community-first** per `no-rebuilding-free-software` — reject the custom Astro path.
- **Faster to ship** — no template design work.

## Confidence: medium

- Kiso is **≤2 weeks old** — no v1.0, small user base, maintainer track record unproven.
- If Kiso breaks or stalls: fallback = custom Astro build per prior `framework-astro-react-tailwind-shadcn-2026-06-25`.
- Watch for: dead commits >30 days, unresponsive issues, breaking releases.

## Wiring

- Install via pnpm workspace dep (not submodule — Kiso is a tool, not source to modify).
- `.github/workflows/publish-knowledge.yml` step:
  ```yml
  - run: pnpm dlx kiso build ./knowledge --out ./dist
  ```
- Then witscode validation, RSS gen, CF Pages deploy.

## Fallback trigger

If Kiso breaks: fork under `chirag127/kiso` per `fork-thin-upstream-tracking`. File issues per `terse-issues-less-hallucination`.

## Anti-patterns

- ❌ Fork Kiso pre-emptively — no reason yet.
- ❌ Depend on Kiso for critical private data — public bundles only.
- ❌ Skip fallback plan — 2-week-old tool needs escape hatch.

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](./cloud-publish-knowledge-2026-07-03.md)
- [`no-rebuilding-free-software`](../../rules/development/no-rebuilding-free-software.md)
- [`community-packages-first`](../../rules/development/community-packages-first.md)
