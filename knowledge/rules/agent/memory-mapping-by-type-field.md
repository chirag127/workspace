---
type: rule
title: "Memory file mapping by `type` field"
description: Migrating MEMORY.md to knowledge/: type field determines directory (rule?rules/, decision?decisions/, etc.)
tags: [agent-behavior, knowledge, migration, type-field, routing]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/knowledge-only-no-memory-dual-write
  - decisions/knowledge-bundle/memory-to-knowledge-migration-2026-06-26
  - _okf
---

# Memory file mapping by `type` field

## Rule

The OKF `type` frontmatter field determines the destination directory for every knowledge file. Routing table:

| `type:` | Goes to |
|---|---|
| `rule` | `knowledge/rules/<area>/` |
| `decision` | `knowledge/decisions/<area>/` |
| `service` | `knowledge/services/` |
| `runbook` | `knowledge/runbooks/` |
| `glossary` | `knowledge/glossary/` |
| `concept` | `knowledge/core-concepts/` |
| `playbook` | `knowledge/runbooks/` |
| `log` | `knowledge/log/<grills\|sessions>/` |
| `convention` | top-level `knowledge/` (e.g. `_okf.md`) |
| `policy` | `knowledge/policy/` |
| `architecture` | `knowledge/decisions/architecture/` |
| `design-brief` | `knowledge/design/` |

## How to apply

- Before writing a new knowledge file: pick `type` first, then path falls out.
- When migrating a memory bullet: determine the `type` it should have, then route per table.
- Sub-areas under `rules/` and `decisions/` are free-form (e.g. `rules/agent/`, `rules/agent/preferences/`, `decisions/agent-tooling/`).
- New `type` values require updating [`_okf.md`](../../_okf.md) in the same commit per [`okf-graph-discipline`](./okf-graph-discipline.md).

## Why

User locked this on 2026-06-26 (Q22). Routing-by-type is mechanical, deterministic, and prevents "where does this go?" hesitation during migrations.

## Captured

2026-06-26 session, Q22 of 24-question grill.

## Related

- [`knowledge-only-no-memory-dual-write`](./knowledge-only-no-memory-dual-write.md)
- [`memory-to-knowledge-migration-2026-06-26`](../../decisions/knowledge-bundle/memory-to-knowledge-migration-2026-06-26.md)
- [`_okf`](../../_okf.md)
