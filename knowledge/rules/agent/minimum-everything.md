---
type: rule
title: Minimum everything — fewest lines, fewest tool calls, fewest packages
description: Hard rule. Smallest unit of everything. Per response, per file, per workflow
tags: [minimalism, output-discipline, agent-behavior, hard-rule]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
  - rules/agent/output-minimalism
  - rules/agent/delegate-to-subagents-by-default
---

# Minimum everything

Smallest unit possible. For everything.

## Hard caps

| Surface | Max |
|---|---|
| Lines of code per change | What the task requires. Not one more. |
| Tool calls per turn | What the task requires. Not one more. |
| Files touched per task | What the task requires. Not one more. |
| Libraries added | Zero unless required. Justify each. |
| Comments per file | Zero unless the line is non-obvious. |
| Configuration | Zero defaults that match the default. |
| Imports per file | Used in this file. Period. |

## Per-task budget

Trivial fix: =3 tool calls. Routine edit: =10. Multi-step build: =30 (else delegate to sub-agent).

If a task balloons past the budget, stop and report. Don't continue past the budget without confirmation.

## Cross-refs

- [`ponytail`](./ponytail.md) — code minimalism ladder
- [`caveman`](./caveman.md) — prose minimalism
- [`output-minimalism`](./output-minimalism.md) — no preamble / no abstract language / numerical limits
- [`delegate-to-subagents-by-default`](./delegate-to-subagents-by-default.md) — orchestration minimalism
