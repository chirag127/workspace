---
type: rule
title: "Knowledge-only, no memory dual-write"
description: "Durable user preferences and locked decisions are written to knowledge/ ONLY — not also mirrored into the agent MEMORY.md auto-memory store. Single source of truth; memory store becomes a cache, not a parallel database."
tags: [agent-behavior, knowledge, memory, single-source-of-truth]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/knowledge-bundle/memory-to-knowledge-migration-2026-06-26
  - rules/agent/memory-mapping-by-type-field
  - rules/agent/self-update-rule
---

# Knowledge-only, no memory dual-write

## Rule

When locking a durable preference, rule, or decision, write it to `knowledge/` only. Do NOT also write it into the agent MEMORY.md auto-memory store. Single source of truth = `knowledge/`. The memory store may *reference* knowledge files but does not duplicate their content.

## How to apply

- Lock a decision -> write `knowledge/<dir>/<slug>.md`. Done.
- Do NOT call any memory-write tool that would create a parallel record.
- If the harness offers to auto-memorize, decline / let the auto-memory link to the knowledge file rather than duplicate.
- Existing memory entries that duplicate knowledge are migrated to knowledge-only per [`memory-to-knowledge-migration-2026-06-26`](../decisions/architecture/knowledge-bundle/memory-to-knowledge-migration-2026-06-26.md).
- Memory store reduces to: ephemeral session state + pointers to knowledge files (see [`memory-mapping-by-type-field`](./memory-mapping-by-type-field.md)).

## Why

User locked this on 2026-06-26 (Q16). Dual-write creates drift — the moment the two diverge, the agent must guess which is authoritative. One store, one truth.

## Captured

2026-06-26 session, Q16 of 24-question grill.

## Related

- [`memory-to-knowledge-migration-2026-06-26`](../../decisions/architecture/knowledge-bundle/memory-to-knowledge-migration-2026-06-26.md)
- [`memory-mapping-by-type-field`](./memory-mapping-by-type-field.md)
- [`self-update-rule`](./self-update-rule.md)
