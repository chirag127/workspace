---
type: decision
title: OKF build engine — Astro custom (Kiso deferred)
description: Fresh verification found Kiso is HN-post-only (no npm/repo). Fallback to custom Astro via api-fleet-template pattern. Revisit Kiso when installable.
tags: [okf, astro, static-site, build]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
supersedes:
  - decisions/agent-tooling/kiso-as-okf-build-engine-2026-07-03
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - decisions/architecture/general/api-fleet-template
  - rules/development/no-rebuilding-free-software
  - rules/development/community-packages-first
---

# OKF build engine — Astro custom (Kiso deferred)

## Decision

Build `knowledge.oriz.in` + `skills.oriz.in` using **custom Astro** on top of the existing `repos/own/infra/api-fleet-template` pattern.

**Kiso deferred** — was recommended in initial grill (2026-07-02 deep-research cited HN post). Fresh verification 2026-07-03: only an aggregator blog cites it. `npm view kiso` = 225-byte name-reservation stub, unrelated year-old package. No installable software surfaces. Revisit if actual repo appears.

## Why Astro custom (fallback path)

- **api-fleet-template exists** — same Astro Integration pattern used across the 6 static-API fleet. Extend, don't rebuild.
- **Family stack lock** — `framework-astro-react-tailwind-shadcn-2026-06-25` already declares Astro as canonical.
- **Confidence: high** — Astro is stable, we own the pattern, zero external dependency risk.

## What it ships

- **OKF frontmatter parsing** — Astro content collections + Zod schema for OKF v0.2 fields.
- **Concept file → page** — 1:1 slug mapping, breadcrumb from OKF `type`/`tags`.
- **`llms.txt`** — auto-generated at build (concat all concepts, LLM-friendly headers).
- **`sitemap.xml`** — `@astrojs/sitemap` integration.
- **RSS/Atom** — `@astrojs/rss` integration.
- **Full-text search** — client-side FlexSearch (no server needed).
- **Related-graph** — `related.json` precomputed from `related:` frontmatter field.

## Package extraction

If knowledge.oriz.in + skills.oriz.in build logic converges to 3+ shared components, extract to `@chirag127/okf-site-template` per `atomic-packages-lazy`. Not yet — build both first, extract on second use.

## Kiso revisit trigger

Watch for:
- A `boone`-style GitHub repo appearing under a `Kiso` name
- npm package with real code (not name-reservation)
- Blog posts with actual `npm install kiso` commands that resolve

If those appear + Kiso proves stable for 30 days: reconsider migration path from custom Astro.

## Anti-patterns

- ❌ Adopt a tool that only exists as an HN post. Verify installability before locking.
- ❌ Skip web search. Prior-session summary cited Kiso; fresh verification proved unreliable.
- ❌ Build from scratch when api-fleet-template already handles the Astro-plus-OKF pattern.

## Cross-refs

- [`cloud-publish-knowledge-2026-07-03`](./cloud-publish-knowledge-2026-07-03.md)
- [`community-packages-first`](../../rules/development/community-packages-first.md)
- [`api-fleet-template`](../architecture/general/api-fleet-template.md)

