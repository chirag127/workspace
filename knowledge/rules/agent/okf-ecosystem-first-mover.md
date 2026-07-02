---
type: rule
title: Ecosystem first-mover on emerging OKF conventions
description: When a new tool/format/convention emerges in the OKF ecosystem, adopt fast + contribute upstream — first-mover shapes the standard.
tags: [okf, ecosystem, contribution, upstream]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/okf-v0.2-upstream-to-google-2026-07-03
  - decisions/agent-tooling/boone-as-okf-search-2026-07-03
  - decisions/agent-tooling/kiso-as-okf-build-engine-2026-07-03
  - rules/development/community-packages-first
  - rules/agent/no-fork-divergence
---

# OKF ecosystem — first-mover

## Rule

When a new OKF tool, convention, or field emerges: **adopt fast + contribute upstream**. Ecosystem is <4 weeks old (2026-07-03) — every early participant shapes the standard.

## Actions

### Adopt fast

- New OKF tool released → evaluate within 7 days.
- Confidence-medium adoption OK (Kiso, boone are ≤2 weeks old but adopted).
- Ship fallbacks — new tool may break.

### Contribute upstream

- Frontmatter field addition → PR to Google `knowledge-catalog` spec.
- Convention gap (e.g. RSS/Atom for OKF bundles) → author proposal + reference implementation.
- Bug in adopted tool → PR to that tool per `no-fork-divergence`.

### Cross-reference

- Any oriz OKF field or convention = link to upstream discussion.
- Cite our workspace as adopter in ecosystem-PR bodies (bandwidth: 793 files).

## What counts as "OKF ecosystem"

- Google's `GoogleCloudPlatform/knowledge-catalog` spec repo
- OKF-consuming tools: Kiso, boone, witscode, okfgen, okf-builder
- OKF-adopting projects: agentmemory, okf-skills, others published on dev.to / HN

## Why first-mover

- **Small ecosystem** — spec + ~7 tools, ≤3 weeks old. Individual contributions have outsized impact.
- **Standards emerge from adopters, not spec authors alone** — RFC 793 pattern.
- **Signal quality** — being an adopter earns say in the spec's direction.

## Constraints

- **Contributions must be terse** per `terse-issues-less-hallucination` (≤150 words bug, ≤100 feature).
- **Thank maintainers** per `thank-maintainers`.
- **No aggressive forks** without prior soft-attempt at upstream.

## Anti-patterns

- ❌ Wait for the spec to stabilize before contributing — the spec stabilizes because you contribute
- ❌ Ship silent modifications — every custom field or convention gets an upstream PR
- ❌ Fork spec repo before filing an issue — hostile

## Cross-refs

- [`okf-v0.2-upstream-to-google-2026-07-03`](../../decisions/agent-tooling/okf-v0.2-upstream-to-google-2026-07-03.md)
- [`no-fork-divergence`](./no-fork-divergence.md)
- [`community-packages-first`](../development/community-packages-first.md)
