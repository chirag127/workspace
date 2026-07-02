---
type: rule
title: "Distill the winning prompt — save the retrospective one-shot"
description: "After long back-and-forth to reach a working answer, ask Claude to write the prompt that would have gotten there first-try. Save that prompt. Skip the iteration next time."
tags: [prompting, agent, iteration, skills, retrospective]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/icc-prompt-formula
  - rules/agent/iterate-before-skill
  - rules/agent/context-interview
---

# Distill the winning prompt

## The rule

After a long back-and-forth in Claude that reaches a working answer, do NOT just move on. Ask Claude:

> "Write the prompt that would have gotten me to this answer on the first try. Include all the context and constraints you inferred from our back-and-forth."

Then SAVE that prompt. Next time you have a similar task, start with the saved prompt.

## Why

- Iteration cost is real — 30 min of back-and-forth per task = 30 min × N future occurrences
- Claude knows what actually worked (has the full trace) — better than you at reconstructing
- Retrospective prompts capture context you didn't realize you provided (STT clarifications, follow-up corrections)

## Where to save

Depends on frequency + shape:

| Frequency | Save location |
|---|---|
| Once — probably won't repeat | Skip, don't save |
| Occasional (few times/year) | `knowledge/reference/prompts/<slug>.md` |
| Regular (weekly+) | Turn into a skill via [`iterate-before-skill`](./iterate-before-skill.md) |
| Team-wide reusable | New skill in `repos/own/infra/agent-skills/` |

## Difference from iterate-before-skill

- **iterate-before-skill**: intentionally iterate 3-5x on a fresh task to identify what works, THEN skill-ify
- **distill-winning-prompt**: after an UNPLANNED long back-and-forth, capture the winning shape before you forget it

Both feed the skills library. This rule catches the accidental iterations.

## Anti-patterns

- ❌ "That worked, moving on" — retrospective prompt not captured, iterate next time again
- ❌ Save the prompt in the wrong place — buried in a random note, unfindable
- ❌ Save every winning prompt — noise; save only if likely to recur
- ❌ Save without ICC structure — no context section, no future replay

## Format for saved prompts

Match [`icc-prompt-formula`](./icc-prompt-formula.md):

```markdown
# <task-name>

## Instructions
<verb-first task description>

## Context
<role, scope, background — what Claude needs>

## Constraints
<format, length, tone, banned patterns>

## Example output (optional)
<one-shot example>
```

## Cross-refs

- [`icc-prompt-formula`](./icc-prompt-formula.md) — the shape of the distilled prompt
- [`iterate-before-skill`](./iterate-before-skill.md) — the planned version of this pattern
- [`context-interview`](./context-interview.md) — often the missing C in the winning prompt is what got interviewed
- Source: Nate Herk YouTube 2026-07 "seven levels of AI use"
