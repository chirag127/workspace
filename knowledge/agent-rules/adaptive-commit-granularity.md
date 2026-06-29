---
type: rule
title: "Adaptive commit granularity"
description: Commits sized to work unit: single decision = 1 commit; batch grill = 1; refactor = 1 per unit
tags: [agent-behavior, commits, git, granularity]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - agent-rules/write-commit-per-decision
  - agent-rules/self-update-rule
---

# Adaptive commit granularity

## Rule

Commit size adapts to work unit. Three shapes:

1. **One locked decision** (ad-hoc during a session) = one commit, message `docs(knowledge): lock <slug> — <summary>`.
2. **Batch grill session** (3+ related decisions answered in one sitting) = one commit covering the batch, message `docs(knowledge): lock N rules from <date> grill session`.
3. **Multi-file refactor / migration** = one commit per logical refactor unit (not per file, not per session).

## How to apply

- Default to per-decision when decisions come in trickle.
- Switch to per-batch when 3+ decisions land in a coherent sitting.
- A migration that touches dozens of files is one commit if it's one logical change ("migrate MEMORY.md -> knowledge/"); split only if subsystems are independent.
- Conventional Commits: `docs(knowledge): ...`, `feat(<scope>): ...`, `refactor(<scope>): ...`.
- Never push without explicit say-so (per [`~/AGENTS.md`](file://~/AGENTS.md)).

## Why

User locked this on 2026-06-26 (Q18). Per-decision-always is too noisy when 24 decisions land in one session; per-session-always loses the granular revert surface. Adaptive matches actual work shape.

## Captured

2026-06-26 session, Q18 of 24-question grill.

## Related

- [`write-commit-per-decision`](./write-commit-per-decision.md)
- [`self-update-rule`](./self-update-rule.md)
