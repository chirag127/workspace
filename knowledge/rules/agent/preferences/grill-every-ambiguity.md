---
type: rule
title: "Grill every ambiguity"
description: "Every ambiguous branch in a plan triggers an MCQ — not just architectural ones. Naming, granularity, scope, ordering, location-on-disk all qualify. The bar is 'is there a real fork?' not 'is this load-bearing?'"
tags: [agent-behavior, preferences, grill, ambiguity]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/max-proactive-grill-always
  - rules/agent/auto-grill-on-architectural-decisions
  - rules/agent/grill-to-knowledge
---

# Grill every ambiguity

## Rule

Every ambiguous branch is grill-worthy. The trigger is "are there 2+ defensible shapes here?", not "is this an architectural decision?". Naming, file location, granularity, ordering, batch size all count.

## How to apply

- Detect forks: filename slugs, directory placement, commit granularity, what-to-include, what-to-skip, batch sizes.
- For each fork: 1 MCQ with 4 ranked options (Recommended / 2nd / two more shapes).
- Bundle related forks into a single MCQ call (max 4 questions per call, SDK limit).
- Do NOT pre-decide and report — pre-decide and *ask*, then execute on the answer.
- If the answer is "you pick", lock the Recommended option and write a note in the relevant knowledge file capturing that the user delegated.

## Why

User locked this on 2026-06-26 (Q4) — chose "grill every ambiguity" over "grill only architectural."

## Captured

2026-06-26 session, Q4 of 24-question grill.

## Related

- [`max-proactive-grill-always`](./max-proactive-grill-always.md)
- [`auto-grill-on-architectural-decisions`](../auto-grill-on-architectural-decisions.md)
- [`grill-to-knowledge`](../grill-to-knowledge.md)
