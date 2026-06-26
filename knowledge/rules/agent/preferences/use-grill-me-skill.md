---
type: rule
title: "Always invoke grill-me skill"
description: "When a session needs structured questioning, invoke the grill-me skill rather than rolling inline AskUserQuestion calls. Skill carries the ranked-options + recommendation discipline and stays consistent across sessions."
tags: [agent-behavior, preferences, grill, skills]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/max-proactive-grill-always
  - rules/agent/preferences/grill-every-ambiguity
  - rules/agent/auto-grill-on-architectural-decisions
---

# Always invoke grill-me skill

## Rule

When a session calls for structured questioning (any non-trivial fork, any architectural decision, any "stress-test my plan" request), invoke the `grill-me` skill via the Skill tool rather than rolling AskUserQuestion calls inline.

## How to apply

- Trigger: user says "grill me", "stress-test this", "interview me on X", or the agent is about to make an architectural call.
- Call: `Skill(skill="grill-me", args="<topic>")`.
- The skill encapsulates the 4-options-ranked-with-Recommended pattern; don't re-implement it inline.
- Inline AskUserQuestion is still valid for one-off forks during normal work — the skill is for *sustained* questioning.
- After the grill ends, write the locked decisions per [`self-update-rule`](../self-update-rule.md).

## Why

User locked this on 2026-06-26 (Q10) — chose to lean on the skill rather than inline ad-hoc questioning. Keeps grill quality consistent across sessions.

## Captured

2026-06-26 session, Q10 of 24-question grill.

## Related

- [`max-proactive-grill-always`](./max-proactive-grill-always.md)
- [`grill-every-ambiguity`](./grill-every-ambiguity.md)
- [`auto-grill-on-architectural-decisions`](../auto-grill-on-architectural-decisions.md)
