---
name: init-claude-md
description: Use `/init` slash command in Claude Code CLI to auto-generate a CLAUDE.md at project root. Documents the project so future sessions start with full context.
---

# `/init` — auto-generate CLAUDE.md

## When to fire

- New Claude Code project without a CLAUDE.md
- After significant architecture change ("update CLAUDE.md")
- Before starting a fresh session on an existing project

## What it does

Types `/init` in the Claude Code prompt. Claude reads the project folder, generates a CLAUDE.md at the root containing:

- Tech stack + versions
- File layout + architecture
- Rules / constraints / conventions
- API references if applicable
- Testing / build / deploy commands
- Anything else Claude would need to onboard cold

## Why not skip

Every new session starts with an empty context window. If CLAUDE.md exists, Claude reads it automatically at session start — instant onboarding. Without it, you re-explain the project every session.

## Anti-patterns

- ❌ Hand-writing CLAUDE.md from scratch (Claude does it better + faster)
- ❌ Letting CLAUDE.md drift months out of date — re-run `/init` after big changes
- ❌ Putting secrets or ephemeral state in CLAUDE.md — it's persistent context, not a scratchpad

## Cross-refs

- [`session-handoff-prompt`](./session-handoff-prompt.md) — CLAUDE.md handles WHAT the project is; session-handoff prompt handles WHERE you left off
- [`plan-mode-iterate`](./plan-mode-iterate.md) — after `/init`, use plan mode for new features
- Source: Nate Herk Claude Code walkthrough 2026-07
