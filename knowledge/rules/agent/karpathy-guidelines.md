---
type: rule
title: 'Karpathy — surface uncertainty, clean orphans, goal-loop execution'
description: ACTIVE every coding task. State assumptions. Surface ambiguity via MCQ. Clean orphaned imports. Define success criteria + loop
tags: [karpathy, agent-behavior, coding-discipline, hard-rule, uncertainty, goal-driven]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
  - rules/agent/output-minimalism
  - rules/agent/minimum-everything
---

# Karpathy — surface uncertainty, clean orphans, goal-loop

ACTIVE EVERY coding task. 3 unique disciplines. Overlapping sections cross-reffed, not restated.

## 1. Think Before Coding

State assumptions before acting. Surface uncertainty explicitly.

- Assumption list required before multi-file changes.
- Two+ interpretations exist? Present all in MCQ. Don't pick silently.
- Simpler approach exists? Say so. Push back.
- Unclear? Stop. Name what's confusing. Ask via MCQ.

## 2. Clean Your Own Orphans

When edit leaves dead code: remove imports, vars, functions YOU made unused. Never touch pre-existing dead code unless asked.

Cross-ref: [Ponytail](./ponytail.md) §ULTRA — "touch only what you must." This rule extends it: you MUST clean your own mess.

## 3. Goal-Driven Execution

Transform vague ask into verifiable goal. Loop until green.

| Vague | Verifiable |
|---|---|
| "Add validation" | "Write test for invalid inputs, make it pass" |
| "Fix the bug" | "Reproduce with test, make it pass" |
| "Refactor X" | "Tests pass before and after" |

Plan format:
```
1. [Step] ? verify: [check]
2. [Step] ? verify: [check]
```

Cap at 200 words. Cross-ref: [Output-minimalism](./output-minimalism.md) §Numerical limits.

## Duplicates (not restated here)

| Karpathy original | Covered by | File |
|---|---|---|
| No error handling for impossible scenarios | No defensive code for impossible cases | [`ponytail`](./ponytail.md) §ULTRA |
| Don't improve adjacent code | Touch only what you must | [`ponytail`](./ponytail.md) §ULTRA |
| Match existing style | Reuse existing patterns | [`ponytail`](./ponytail.md) §ULTRA |
| No unrequested refactors | No unrequested abstractions | [`ponytail`](./ponytail.md) §ULTRA |

## Cross-refs

- [`ponytail`](./ponytail.md) — code minimalism, surgical changes, no defensive code
- [`caveman`](./caveman.md) — terse prose for assumption statements
- [`output-minimalism`](./output-minimalism.md) — answer-first, no preamble
- [`minimum-everything`](./minimum-everything.md) — smallest unit per task
- Upstream: [karpathy/guidelines](https://github.com/karpathy/guidelines) — MIT, adapted
