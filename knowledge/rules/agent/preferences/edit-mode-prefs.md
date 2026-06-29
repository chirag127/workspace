---
type: rule
title: 'Edit-mode preferences — tool choice + task tracking'
description: Edit > Write, batch parallel tool calls, task-list for 3+ steps, no .md deliverables
tags: [edit-mode, tools, task-tracking, agent-behavior, feedback]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/read-before-edit
  - rules/interaction/parallel-fan-out-by-default
---

# Edit-mode preferences

- **Edit > Write.** Use `Edit` for surgical changes. Use `Write` only for new files or full replacements after a Read.
- **Read before Edit, always.** Harness enforces it; also prevents stale-match failures. See [`read-before-edit`](../read-before-edit.md).
- **Batch independent tool calls** in one turn (parallel function calls in same response). See [`parallel-fan-out-by-default`](../../interaction/parallel-fan-out-by-default.md).
- **Use the task-list tool** for any task =3 steps. Mark `in_progress` before starting, `completed` only when actually done. No partial credit.
- **No report/summary `.md` deliverables.** Return findings inline unless the user explicitly asked for a checked-in doc.
