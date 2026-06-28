---
type: decision
title: "Knowledge hierarchy: add log/, concepts/, playbooks/ as top-level dirs"
description: "Extend the OKF bundle with three new top-level dirs alongside rules/, decisions/, runbooks/, services/, glossary/: log/ for chronological history, concepts/ for cross-cutting explainers, playbooks/ for reusable multi-step procedures (distinct from runbooks)."
tags: [decision, knowledge-bundle, okf, hierarchy, structure]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/knowledge-bundle/depth-5-level-hierarchy
  - rules/agent/per-batch-grill-log
  - rules/agent/keep-knowledge-fresh
  - _okf
---

# Hierarchy: add log/, concepts/, playbooks/

## Decision

Add three new top-level directories to `knowledge/`, joining the existing `rules/`, `decisions/`, `runbooks/`, `services/`, `glossary/`:

- `knowledge/log/` — chronological history. Sub-dirs: `log/grills/` (per-batch grill summaries), `log/sessions/` (per-session execution summaries when notable).
- `knowledge/concepts/` — cross-cutting explainers that aren't rules or decisions (e.g. "what is the lifestream", "how OKF graph traversal works"). For OKF spec compliance, `type: concept` files live here.
- `knowledge/playbooks/` — reusable multi-step procedures that are NOT human-actionable runbooks but agent-orchestration playbooks (e.g. "ship a new app to the fleet" — sequencing of decisions + tools, not raw commands).

## Why

User locked this on 2026-06-26 (Q14). Grill logs need a home. Concepts need a home distinct from rules. Playbooks need a home distinct from runbooks. Hierarchy stayed at OKF's recommended <=6 levels.

## How to apply

- New file with `type: log` -> `knowledge/log/<grills|sessions>/<slug>.md`.
- New cross-cutting explainer -> `knowledge/concepts/<slug>.md`.
- New agent-orchestration procedure -> `knowledge/playbooks/<slug>.md`.
- Index gets a new section per top-level dir (update [`knowledge/index.md`](../../../index.md)).
- Runbooks remain command-sequence focused (human runs them); playbooks are higher-level orchestration.

## Captured

2026-06-26 session, Q14 of 24-question grill.

## Related

- [`depth-5-level-hierarchy`](./depth-5-level-hierarchy.md)
- [`per-batch-grill-log`](../../../rules/agent/per-batch-grill-log.md)
- [`keep-knowledge-fresh`](../../../rules/agent/keep-knowledge-fresh.md) (§4 'current truth only — no historical logs' subsumes the prior log-decisions-only rule)
- [`_okf`](../../../_okf.md)
