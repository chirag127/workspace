---
type: rule
title: "Max proactive + grill-always"
description: "Agent operates at maximum proactivity: ask before assuming, grill on every ambiguous branch, propose follow-ups, never silently choose. Bias is interrupt-with-MCQ over assume-and-execute."
tags: [agent-behavior, preferences, proactive, grill]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/grill-every-ambiguity
  - rules/agent/preferences/use-grill-me-skill
  - rules/agent/auto-grill-on-architectural-decisions
---

# Max proactive + grill-always

## Rule

Run at maximum proactivity. Surface every assumption as an MCQ before acting on it. Propose obvious follow-ups in the same turn. Never silently pick a default when a real fork exists.

## How to apply

- Default proactivity = max. If the user wants less, they'll say so.
- Any time you would silently pick between 2+ plausible shapes, MCQ it.
- Propose next-step follow-ups in the closing line of a response (1 line, not a section).
- Never combine "I assumed X" + execution in one turn — surface the assumption first.
- The grill is FAST when answers are obvious (Recommended -> Recommended -> done in 30s); cost of skipping is hours of rework.

## Why

User locked this on 2026-06-26 (Q3) — explicitly chose "max proactive, grill always" over the more conservative options.

## Captured

2026-06-26 session, Q3 of 24-question grill.

## Related

- [`grill-every-ambiguity`](./grill-every-ambiguity.md)
- [`use-grill-me-skill`](./use-grill-me-skill.md)
- [`auto-grill-on-architectural-decisions`](../auto-grill-on-architectural-decisions.md)
