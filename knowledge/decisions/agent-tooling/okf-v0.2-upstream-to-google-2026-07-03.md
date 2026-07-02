---
type: decision
title: OKF v0.2 additions upstreamed to Google
description: PR to GoogleCloudPlatform/knowledge-catalog proposing optional `confidence` and `durability` fields; agentmemory precedent cited.
tags: [okf, upstream, google, spec]
timestamp: 2026-07-03
format_version: okf-v0.2
status: active
confidence: high
durability: durable
related:
  - decisions/agent-tooling/cloud-publish-knowledge-2026-07-03
  - rules/agent/terse-issues-less-hallucination
  - rules/agent/thank-maintainers
---

# OKF v0.2 → upstream to Google

## Decision

Open PR/issue on [`GoogleCloudPlatform/knowledge-catalog`](https://github.com/GoogleCloudPlatform/knowledge-catalog) proposing OKF v0.2 additive fields:

- `confidence: high | medium | low` — matches [rohitg00/agentmemory](https://github.com/rohitg00/agentmemory) precedent
- `durability: durable | volatile` — novel; oriz first-mover

Both **optional**. v0.1 files stay conformant.

## Why upstream (not fork or private)

- **v0.1-only status confirmed** by deep-research 2026-07-02 — no official v0.2, no competing forks, only ~3 weeks old.
- **First-mover window open** — spec author (Google Data Cloud team) accepting community input.
- **Ecosystem alignment** — private v0.2 causes drift when Google eventually ships v0.2 of their own.
- **Real precedent** for `confidence` (agentmemory) — not speculative.

## What we ship in the PR

- Diff to `okf/SPEC.md` adding two field defs.
- Example bundle using both fields (small — 5 files).
- Rationale: hallucination reduction, durability triage for compaction/pruning.
- Cite agentmemory + oriz workspace (792 concept files) as adopters.

## Terse per rule

Body ≤150 words per `terse-issues-less-hallucination`. Thank maintainers per `thank-maintainers`. No speculation about "future v0.3" — just the 2 fields.

## Fallback

If Google rejects or ignores:
- Keep v0.2 internally.
- Rename `format_version: okf-v0.2` → `okf-v0.2-oriz` to avoid future collision.
- Continue with additive-only additions.

## Anti-patterns

- ❌ Fork spec repo aggressively — burns goodwill.
- ❌ Ship 5+ fields — dilutes proposal, higher rejection risk.
- ❌ Skip the PR — locks us out of official evolution.

## Cross-refs

- [`okf-publishing-conventions-2026-07-03`](./okf-publishing-conventions-2026-07-03.md)
- [`terse-issues-less-hallucination`](../../rules/agent/terse-issues-less-hallucination.md)
- [`thank-maintainers`](../../rules/agent/thank-maintainers.md)
