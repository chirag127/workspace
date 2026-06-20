---
type: decision
title: "Knowledge bundle hierarchy: every leaf at 5 levels"
description: "Lock the OKF directory depth at 5. Every concept file lives at knowledge/<L1>/<L2>/<L3>/<L4>/<file>.md so an agent's read pulls the smallest possible leaf. Supersedes the 3-then-4-level rule."
tags: [architecture, knowledge, okf, agent-context]
timestamp: 2026-06-20
related: [knowledge-okf-spec]
supersedes: 4-level-hierarchy-for-big-dirs
---

# 5-level hierarchy, every leaf

## Decision

Every concept file in `knowledge/` lives at exactly 5 path levels:

```
knowledge/<L1>/<L2>/<L3>/<L4>/<file>.md
```

L1 = top-level area (`rules`, `decisions`, `services`, `runbooks`, …).
L2–L4 = progressive categorisation.
L5 = the atomic concept file.

`index.md` files exist at every level and list only their direct children.

This file is itself the demonstration:
`knowledge/decisions/architecture/knowledge-bundle/depth/5-level-hierarchy.md`.

## Why

Agent context budgets are spent on directory dumps. A glob like
`knowledge/services/**/*.md` pulls dozens of unrelated files when the
agent only needs one. Forcing depth means:

- A grep that hits one path returns one concept, not a category dump.
- An `ls` of a parent dir shows ≤15 leafs, never 40+.
- The path itself is the breadcrumb — `services/data/database/postgres/neon-postgres.md` reads as a sentence.

## Implementation rule

When a category has fewer files than the depth requires, use single-file
pass-through subdirs named after the role rather than flattening. The
depth is the contract.

When a leaf set grows past ~15 siblings, split L4 into multiple L4s.
Never go to 6 — the path stops being memorable.

## Migration

Existing files at L3 or L4 get moved as they're touched, not in one
big-bang rewrite. Touch-and-deepen. The OKF spec at `knowledge/_okf.md`
points to this file as the source of truth.
