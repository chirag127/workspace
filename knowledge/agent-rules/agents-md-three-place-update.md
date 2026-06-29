---
type: rule
title: 'Rule additions land in 3 places: concept file + AGENTS.md table + count'
description: Add rule: write to knowledge/rules/ + AGENTS.md entry + bump section count. All three same commit
tags: [agents-md, self-update, knowledge-discipline, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - agent-rules/self-update-rule
  - agent-rules/keep-knowledge-fresh
  - agent-rules/agents-md-2025-discipline
---

# Three-place update when a rule is added

## Rule

When user says "add this rule" or a locked grill answer becomes a rule:

| Place | Action |
|---|---|
| 1. Concept file | Write `knowledge/rules/<area>/<kebab-name>.md` with OKF frontmatter and body |
| 2. AGENTS.md table | Add a one-line entry under the relevant subsection (e.g. `### Agent behaviour (N) — knowledge/agent-rules/`) |
| 3. Count header | Bump `### <Category> (N) — ...` count to `N+1` AND the top-of-file `## Rules (TOTAL) — non-negotiable` total |

All three in the **same commit**. Conventional commit: `docs(knowledge): add <slug> rule (3-place update)`.

## Why all three

- **Concept file alone** = rule exists but isn't discoverable from the AGENTS.md TL;DR table.
- **AGENTS.md alone** = no enforceable file, no detail, no frontmatter for [`knowledge/index.md`](../../index.md) generation.
- **Skipping count bump** = section headers drift; loses the at-a-glance "how many rules in this category" signal.

## When this rule fires

- Explicit user instruction: "add a rule that …"
- Locked grill answer that codifies a taste or behavior (per [`grill-to-knowledge`](./grill-to-knowledge.md))
- An override-mined pattern (user picks 2nd choice repeatedly ? candidate rule)

## When this rule does NOT fire

- Decision file (`knowledge/decisions/…`) — those don't go in AGENTS.md's rules table; they go in the decisions section
- Runbook, service, glossary — same; their own sections
- A rule modification (not addition) — just edit the concept file; count stays

## Anti-patterns

- ? Writing the rule file but forgetting AGENTS.md entry ? discovery rot.
- ? Adding the AGENTS.md line but forgetting the count bump ? drift.
- ? Committing the rule file and the AGENTS.md update in separate commits ? `git log` can't tell they're one decision.
- ? Writing a long description in the AGENTS.md table line. **One line, terse.** Detail lives in the concept file.

## Cross-refs

- [`self-update-rule`](./self-update-rule.md) — broader self-update protocol
- [`agents-md-2025-discipline`](./agents-md-2025-discipline.md) — keeps AGENTS.md short
- [`keep-knowledge-fresh`](./keep-knowledge-fresh.md) — read-before-act
