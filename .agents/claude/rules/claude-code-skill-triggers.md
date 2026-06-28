---
type: rule
title: 'Claude Code skill triggers — phrase → skill reflex map'
description: When the user types these phrases, fire the matching skill automatically without confirmation.
tags: [claude-code, skills, reflex, agent-behavior, feedback]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/edit-mode-prefs
---

# Claude Code skill triggers

When user types these phrases, fire the matching skill without asking.

| User phrase | Skill |
|---|---|
| "grill me", "stress-test", "interview me" | `grill-me` — walks decision tree branch-by-branch via MCQ |
| "review the diff", "code review" | `/code-review` — reviews current diff for bugs |
| "security review", "audit" | `/security-review` — OWASP-style audit of working tree |
| "verify it works", "run the app" | `/verify` — runs app, observes behavior |
| "simplify", "reduce" | `/simplify` — cuts duplication/complexity |
| "deep research" | `/deep-research` — multi-source fact-checked report |

Plus Claude Code's standard CLI: `/model`, `/effort`, `/fast`, `/skill`.

Skills only — not knowledge rule names. If the user's phrase matches a skill trigger, invoke the skill. Don't paraphrase its description back; just run it.
