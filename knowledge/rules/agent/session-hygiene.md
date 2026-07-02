---
type: rule
title: "Session hygiene — break sessions between distinct features"
description: "Reset chat/session when moving between distinct features. Stale context leaks confuse the agent and waste tokens. Stay in same chat only when tied to what you just built."
tags: [agent, session, hygiene, context, tokens]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/cc-settings-balance
  - rules/agent/practical-vibe-coding
  - rules/agent/fable-5-prompting
  - .agents/claude/rules/claude-code-latency-techniques
  - .agents/claude/rules/session-handoff-prompt
---

# Session hygiene — break sessions between features

## The rule

Start a fresh chat/session when moving to a distinct feature. Stay in the same chat only when the next task is directly tied to what you just built.

## When to break

- Feature complete (verified working) → next feature = new session
- Big pivot (deploy → debug → refactor) → new session per phase
- Context window >75% full → break at next natural boundary
- After a long back-and-forth resolved a specific bug → next task = new session

## When to stay

- Currently implementing feature N; iterating on feature N → stay
- Debugging a bug in feature N → stay until fixed
- Feature N depends on state established in feature N-1 (same session context needed) → stay
- Just started a session; still in first few exchanges → stay

## Why

Two costs when you don't break:

1. **Stale context leaks confuse the agent.** Auth-implementation chatter from feature 3 bleeds into feature 7 design decisions. The agent references decisions no longer relevant.

2. **Token cost compounds.** Each turn re-reads the full history. Long chats = every prompt costs 2-5× a fresh session. Also breaks Anthropic's 5-min prompt cache TTL faster.

## Mechanic

- **Claude Code**: `/clear` or open new session
- **Cursor**: New composer / new chat
- **Web Claude**: New chat button
- **OpenCode**: `/new` command

## Complement: session-handoff prompt

When breaking mid-project (not mid-feature), use the handoff prompt from [`session-handoff-prompt`](../../.agents/claude/rules/session-handoff-prompt.md):

> "Summarize architecture + decisions + current state + what's left to do so I can paste into a new session."

Then paste into the fresh session as opening context. CLAUDE.md/AGENTS.md handles permanent facts; handoff prompt handles session state.

## Anti-patterns

- ❌ Run one massive multi-day chat that touches every feature — token bill explodes, context rots
- ❌ Break session mid-feature — lose context, redo work
- ❌ Break so often that every session is cold-start — pay the caching miss repeatedly
- ❌ Skip handoff prompt on important state transitions — next session starts blind

## Cross-refs

- [`practical-vibe-coding`](./practical-vibe-coding.md) — the workflow this supports
- [`fable-5-prompting`](./fable-5-prompting.md) §"Actions that destroy the cache" — Anthropic-side cost model
- [`session-handoff-prompt`](../../.agents/claude/rules/session-handoff-prompt.md) — the between-session handoff mechanic
- [`preferences/cc-settings-balance`](./preferences/cc-settings-balance.md) — `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=85` setting handles the auto-compact case
- Source: JavaScript Mastery YouTube 2026-07 practical-vibe-coding walkthrough
