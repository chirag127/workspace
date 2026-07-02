---
type: rule
title: "Proactively add rules and knowledge — don't wait to be asked"
description: "Every session that surfaces a durable insight, decision, taste rule, or pattern must write it to knowledge/ or memory/ in the same turn. Don't wait for user to ask."
tags: [agent, meta, knowledge, proactive, self-update]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/self-update-rule
  - rules/agent/grill-before-adding-rule
  - rules/agent/knowledge-everything-caveman
---

# Proactively add rules and knowledge

## The rule

Every time a durable insight surfaces in a session — from a video transcript, a grill, a recurring error pattern, a user preference, a build failure lesson — **write it to knowledge/ or memory/ in the same turn**. Do not wait for the user to say "add this as a rule."

The agent is responsible for identifying what's worth keeping. Users are thinking about their problem, not about knowledge curation.

## Triggers that should fire automatic knowledge capture

| Trigger | Write to |
|---|---|
| User corrects a wrong approach I took | `memory/feedback-*.md` |
| Build fails for the same reason twice | `knowledge/rules/development/` or `knowledge/runbooks/` |
| A video/transcript contains applicable practices | `knowledge/rules/agent/` after grilling |
| A decision is made with clear reasoning | `knowledge/decisions/<area>/` |
| A service limit/pricing detail is confirmed | `knowledge/services/` |
| A recurring pattern in prompts | `knowledge/rules/agent/preferences/` |
| An integration gotcha (tool X doesn't work with Y) | `knowledge/rules/development/` or a runbook |

## What this looks like in practice

- GHA build fails with PS 5.1 `?.` syntax error → **write** "corp-vdi-build-failures-use-gha.md" to memory
- 8 retries of same blocked build → **write** lesson: suggest GHA immediately on AV block
- User adds a rule about Dagger → **grill first** (per `grill-before-adding-rule`), then write
- Video transcript arrives → **extract** concrete takeaways, grill on each, write approved ones
- User says "responses should be more creative" → **write** memory feedback, don't just apply it

## Anti-patterns

- ❌ Learning a lesson and not writing it → same mistake next session
- ❌ User has to ask "add this as a rule" explicitly for every lesson
- ❌ Writing every casual observation to knowledge/ (noise) — only write DURABLE facts
- ❌ Writing knowledge mid-task without finishing the task first — finish, then write

## "Durable" test

A fact is durable if: "Would a fresh session 3 months from now benefit from knowing this?" If yes → write it. If it's task-specific, session-only, or will change next week → skip.

## Cross-refs

- [`self-update-rule`](./self-update-rule.md) — the protocol for writing
- [`grill-before-adding-rule`](./grill-before-adding-rule.md) — which artefact type to write
- [`knowledge-everything-caveman`](./knowledge-everything-caveman.md) — style guide for the writing
