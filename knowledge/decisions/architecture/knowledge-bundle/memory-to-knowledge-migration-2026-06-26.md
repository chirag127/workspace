---
type: decision
title: "Memory -> knowledge migration plan"
description: "All existing MEMORY.md entries that encode durable preferences/decisions are migrated into knowledge/ as proper OKF files. Memory store retains only ephemeral state + pointers. Migration is one-shot, not incremental."
tags: [decision, knowledge-bundle, memory, migration]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/knowledge-only-no-memory-dual-write
  - rules/agent/memory-mapping-by-type-field
  - decisions/architecture/knowledge-bundle/hierarchy-add-log-concepts-playbooks-2026-06-26
---

# Memory -> knowledge migration

## Decision

Migrate every durable entry in `C:\Users\C5420321\.claude\projects\C--d-oriz\memory\MEMORY.md` (and per-topic memory files) into proper OKF knowledge files under `knowledge/`. After migration, MEMORY.md retains only:

- ephemeral session state (current task, scratch notes),
- pointers to knowledge files (one-liners with links, not duplicated content).

## Why

User locked this on 2026-06-26 (Q17). MEMORY.md had grown into a parallel database of decisions — exactly the dual-write antipattern that [`knowledge-only-no-memory-dual-write`](../../../rules/agent/knowledge-only-no-memory-dual-write.md) forbids going forward. One-shot migration is cleaner than gradual.

## How to apply

- Sibling agent owns execution (task #48 in TaskList).
- For each MEMORY.md bullet: determine `type` field (rule / decision / service / glossary / etc.), route to correct `knowledge/<type>/<slug>.md` per [`memory-mapping-by-type-field`](../../../rules/agent/memory-mapping-by-type-field.md).
- Preserve supersession chains — if memory bullet says "SUPERSEDED 2026-06-25 by X", the new knowledge file gets `superseded_by:` and the superseding file gets `supersedes:`.
- After migration, MEMORY.md is rewritten to pointer-only form.
- One commit for the migration: `docs(knowledge): migrate MEMORY.md -> knowledge/ (N files)`.

## Captured

2026-06-26 session, Q17 of 24-question grill.

## Related

- [`knowledge-only-no-memory-dual-write`](../../../rules/agent/knowledge-only-no-memory-dual-write.md)
- [`memory-mapping-by-type-field`](../../../rules/agent/memory-mapping-by-type-field.md)
- [`hierarchy-add-log-concepts-playbooks-2026-06-26`](./hierarchy-add-log-concepts-playbooks-2026-06-26.md)
