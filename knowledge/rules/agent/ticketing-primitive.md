---
type: rule
title: "Ticketing primitive — agent operations visible via TaskCreate"
description: "Every multi-step operation and every external-state operation goes through the task system. No hidden work in chain-of-thought."
tags: [agent, tasks, visibility, ticketing, orchestration]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/own-memory-rent-intelligence
  - rules/agent/preferences/edit-mode-prefs
  - rules/agent/subagent-transparency
---

# Ticketing primitive

## The rule

Every non-trivial agent operation lands in a **task**. Not just as a mental model — the actual `TaskCreate` / `TaskUpdate` tool must fire so the user sees what's happening.

## When ticketing is required

| Trigger | Task required? |
|---|---|
| 3+ step operation | Yes |
| Any external-state operation (per [`draft-not-send`](./draft-not-send.md)) | Yes |
| Multi-file refactor | Yes |
| Multi-repo sweep | Yes (one task per repo, or one task with subtasks) |
| Background subagent spawn | Yes (task per subagent) |
| Single-file edit with clear instruction | Skip |
| Reading a file to answer a question | Skip |
| Conversational turn | Skip |

## Task lifecycle

1. **Before starting**: `TaskCreate` with subject, description, activeForm.
2. **On start**: `TaskUpdate` → `in_progress`.
3. **On external state changes**: mid-task `TaskUpdate` if scope shifts materially.
4. **On complete**: `TaskUpdate` → `completed` — but ONLY if the work is truly done + verified. Partial credit = keep it `in_progress`.
5. **On block**: `TaskCreate` a new task describing the blocker; keep original `in_progress`.

## Anti-patterns

- ❌ Doing 10 tool calls without a task — user has no way to see progress
- ❌ Marking `completed` when tests are red / partial work
- ❌ Ticketing every trivial single-command edit (task-creation overhead exceeds the work)
- ❌ Hiding subagent work in chain-of-thought instead of a task
- ❌ Stale task list from earlier session leaking into current work — clean up first

## Why this matters

Per [`own-memory-rent-intelligence`](./own-memory-rent-intelligence.md), your memory + orchestration belong to you. Tasks ARE the orchestration record — they're what makes agent work reviewable, resumable, and portable across sessions.

Ticket = "the receipt for this action". No ticket = no accountability. Especially critical for background subagents and long-running sweeps where the main agent may look busy but you can't see individual step status.

## Cross-agent parity

All 6 fleet agents (Claude Code + ZCode + OpenCode + Kilo Code + Antigravity + MiMoCode) need a task system OR must document explicitly why they can't. Currently:

| Agent | Task tool |
|---|---|
| Claude Code | Native `TaskCreate` / `TaskUpdate` / `TaskList` |
| OpenCode | Native task tool |
| Kilo Code | VS Code extension task view |
| Antigravity | Native |
| ZCode | Unknown — verify next session |
| MiMoCode | Unknown — verify next session |

## Cross-refs

- [`edit-mode-prefs`](./preferences/edit-mode-prefs.md) — pointer to use task-list for ≥3-step tasks
- [`delegate-to-subagents-by-default`](./delegate-to-subagents-by-default.md) — subagent spawns get tasks
- [`draft-not-send`](./draft-not-send.md) — external ops get tasks so approval is visible
- Source: Nate B Jones 2026-06 — "ticketing is the primitive for agent-work visibility"
