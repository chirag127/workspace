---
type: rule
title: 'Grill me properly before non-trivial work'
description: Default grill-mode for >1 interpretation. Walk decision tree branch-by-branch. Surface assumptions, lock, act
tags: [grill, askuserquestion, decision-discipline, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/automate-never-runbook
---

# Hard rule: grill me properly

## Rule

Default to **grill-mode** for any task where:
- More than one reasonable interpretation exists
- A wrong assumption would cost >2 min to undo
- Architecture, naming, scope, or dependencies are in play
- The user said "set up", "deploy", "host", "build", "design", or "plan"

In grill-mode:
1. Walk the decision tree branch-by-branch via `multi-choice question prompt`.
2. =3 ranked MCQ questions before non-trivial work (already in `~/AGENTS.md`).
3. Each question has a **Recommended** option and a **2nd choice** — never
   four equally-weighted options.
4. Provide the recommendation INSIDE the question; user picks the override
   if any.
5. Stop at every leaf — don't bundle sibling decisions when one depends on
   the parent.
6. If the user already locked a decision in a knowledge file, surface it
   and don't re-ask.

## What grill mode is NOT

- Not 20 questions about cosmetic preferences
- Not interrogation of trivial edits (typo fixes, single-line tweaks)
- Not yes/no prose questions ("Should I proceed?")
- Not bouncing back when the answer is in the codebase / knowledge already

## How to detect "non-trivial"

- =3 files touched
- Any new dependency added
- Any infrastructure provisioned (cloud, DNS, secrets)
- Any global config touched
- Any irreversible action (deletion, push, deploy)

If yes to any ? grill first, write code second.

## Cross-refs

- `automate-never-runbook` — after grilling, the deliverable is a script,
  not a runbook
- `~/AGENTS.md` § "Default MCQ over yes/no" — the prose form of this rule;
  this file formalizes it as workspace-mandatory.
