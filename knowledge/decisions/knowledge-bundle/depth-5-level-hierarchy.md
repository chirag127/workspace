---
type: decision
title: "Knowledge bundle depth scales with folder size, ceiling 5"
description: 'Folder depth adaptive: flat for tiny, 5 levels for big'
tags: [architecture, knowledge, okf, agent-context]
timestamp: 2026-06-20
related: [knowledge-okf-spec]
supersedes: 4-level-hierarchy-for-big-dirs
---

# Depth scales with folder size, ceiling 5

## Decision

Depth tracks the L1 folder's file count. Apply the deepest tier the
folder qualifies for; never exceed 5.

| L1 file count | Depth | Example |
|---|---|---|
| =15 | 2 | `knowledge/glossary/api.md` |
| 16–50 | 3 | `knowledge/rules/security/no-hardcoded-secrets.md` |
| 51–150 | 4 | `knowledge/services/business/auth/firebase/firebase-auth.md` |
| 151+ | **5** | `knowledge/decisions/knowledge-bundle/depth/5-level-hierarchy.md` |

`index.md` exists at every level and lists only direct children.

## Why

A grep / glob / read should pull one concept, not a 30-file category
dump. Minimum context = minimum tokens = sharper agent attention.

Forcing 5 levels everywhere (the rejected earlier rule) bloats tiny
folders with empty pass-through subdirs. Letting depth float with
size keeps the bottom of the tree tight in big areas and flat in
small ones. Same property — minimum leaf — without the make-work.

## Implementation

- When an L_n grows past ~15 siblings, split into multiple L_n peers.
  Don't add a deeper L_{n+1} unless the whole L1 has crossed its next
  threshold.
- Touch-and-deepen migration: when editing a file, move it to the
  depth its parent now warrants. No big-bang rewrites.
- The `_okf.md` table is the source of truth; this file explains why.
