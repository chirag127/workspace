---
name: session-handoff-prompt
description: Before starting a fresh Claude Code session on an existing project, ask the current session to summarize architecture + decisions + current state + what's left. Paste that summary + trust CLAUDE.md handles the rest.
---

# Session handoff prompt

## Why this exists

Claude Code context windows are finite. Auto-compact happens but drops nuance. Better move: fresh session at natural breakpoints, with a structured handoff.

CLAUDE.md carries the project's PERMANENT facts. Session-handoff carries the SESSION-SPECIFIC state — what got decided today, what's mid-flight, what's next.

## The prompt to end a session with

```
Summarize everything important about this project:
- Architecture decisions made this session
- Current state / mid-flight work
- What's left to do
- Any gotchas discovered

Format so I can paste it directly into a new session as context.
```

## The prompt to start the next session with

```
[Paste the summary from the previous session's end.]

Now continue from here. Trust the CLAUDE.md for permanent context;
this summary is where we left off.
```

## When to break sessions

- Context window >80% full
- Natural task-completion breakpoint (feature done, before starting next)
- Just switched from planning to building (fresh session, clean tokens)
- Just switched from building to debugging (planning context isn't needed)
- End of work day (start tomorrow with fresh model state)

## When NOT to break

- Mid-feature — carry to completion, then break
- Debugging with lots of hypothesis-testing loops — reset would lose leads
- Just started + haven't hit any real context load

## Anti-patterns

- ❌ Auto-compact everything and hope — you'll lose nuance you needed
- ❌ Break session without handoff prompt — waste 10+ min re-establishing state
- ❌ Break too often — every fresh-session tax is a real cost
- ❌ Handoff prompt as a wall of text — force structure (architecture, state, next-steps)

## Cross-refs

- [`init-claude-md`](./init-claude-md.md) — the permanent-facts complement
- [`memory-review-monthly`](../../../knowledge/rules/agent/memory-review-monthly.md) — the memory hygiene that keeps handoffs clean
- Source: Nate Herk Claude Code walkthrough 2026-07
