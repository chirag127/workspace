---
type: rule
title: "Subagent transparency — show what they do, don't silent-pass-through"
description: "When spawning a subagent, show what it will do + return format + verification plan. Summarize subagent output back to user before acting on it."
tags: [agent, subagent, transparency, orchestration]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/delegate-to-subagents-by-default
  - rules/agent/ticketing-primitive
  - rules/agent/own-memory-rent-intelligence
---

# Subagent transparency

## The rule

When spawning a subagent, the user MUST see:

1. **What the subagent will do** — one-line goal in plain language
2. **Return format** — terse summary paragraph? structured table? file path?
3. **Verification plan** — how the main agent will check the subagent's output

And when the subagent returns:

4. **Summarized output** — main agent must summarize back to the user before acting on the subagent's return, unless the output is a single well-scoped artifact (e.g. a decision file path).

## Anti-patterns

- ❌ Silent pass-through: subagent returns 300-line dump → main agent acts on it without summarizing
- ❌ Subagent output triggers a series of tool calls the user never approved
- ❌ 5 parallel subagents fire but only 3 tasks visible in TaskList — the other 2 are hidden
- ❌ Subagent hallucinated output → main agent trusts it without verification → cascading errors (the "Lemonade insurance" pattern at agent-of-agent level)

## The transparency contract

For every `Agent` tool call:

```
Task #N: <one-line what>
Agent goal: <what success looks like>
Return: <expected shape>
Verify: <how I'll check the output>
```

Fire the `Agent` call AFTER this contract is on-screen. When the subagent completes, first-line of your response summarizes what came back before any acting-on-it happens.

## Special case: background subagents

Background subagents (`run_in_background: true`) are especially prone to silent-pass-through because the completion notification arrives mid-work-on-something-else. When a background subagent completes:

1. Announce completion + one-line what it did
2. Show the returned artifact/summary
3. WAIT for the user's next input before acting on the output — unless the user's original directive was clearly "and continue from what it returns"

## When transparency can be tighter

- Trivial subagent (single grep across N files) — skip the full contract; a one-liner is fine
- Subagent whose output is a specific file path — main agent reading the file counts as visible action
- Fan-out of ≥5 subagents in one message — a single group announcement covers all instead of per-agent contracts

## Anti-anti-pattern (when transparency hurts)

Don't over-narrate:
- ❌ "I'm now going to spawn a subagent to do X. First I'll define the goal. Then I'll write the prompt. Then I'll..."
- ✅ "Spawning: <what>. Return: <shape>. Verify: <how>. Firing now."

## Cross-refs

- [`delegate-to-subagents-by-default`](./delegate-to-subagents-by-default.md) — WHEN to delegate
- [`ticketing-primitive`](./ticketing-primitive.md) — every subagent spawn = a task
- [`draft-not-send`](./draft-not-send.md) — subagents that touch external state = user-approved before send
- [`own-memory-rent-intelligence`](./own-memory-rent-intelligence.md) — the broader principle
- Source: Nate B Jones 2026-06 agentic-loop visibility + Nikita/Lemonade insurance-story lesson
