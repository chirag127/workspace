---
type: rule
title: "Context interview — agent asks user first when uncertain"
description: "When unsure what context is needed for a task, agent asks the user targeted questions BEFORE attempting. 'Ask me any further questions you need to achieve the best result.'"
tags: [agent, prompting, context, interview, uncertainty]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/karpathy-guidelines
  - rules/agent/preferences/edit-mode-prefs
  - rules/interaction/communication-stt-friendly
---

# Context interview

## The rule

When the agent is uncertain what context is needed to produce a good result, ASK THE USER first. Don't guess. Don't proceed with vague framing hoping to iterate.

## The pattern

Agent detects uncertainty → sends 2-4 targeted questions → user answers → agent proceeds with grounded context.

Example prompt to the user when the AGENT is asking:

> "Before I write this, I need to understand a few things. Answer any that are relevant:
> 1. Who is the audience?
> 2. What's the desired tone?
> 3. Are there constraints (length, format, forbidden words)?
> 4. Are there examples I should model after?"

## When to fire

- Task is broad or ambiguous ("write a blog post" without topic angle)
- Task involves taste (design, prose, code style beyond formatter rules)
- Task references undocumented context ("the usual way", "like last time")
- Task has 3+ valid interpretations

## When NOT to fire

- Task is mechanical (rename files, apply lint rule, run test)
- Task has clear spec in `knowledge/` — use spec, don't interview
- Task is a follow-up in same session where context was established
- STT-friendly ambiguity (per [`communication-stt-friendly`](../interaction/communication-stt-friendly.md)) — pick most likely interpretation + state assumption inline, don't interview

## Not the same as grill-me

**Grill-me** = user invokes decision-tree interrogator to lock a choice with multiple locked-in options.
**Context interview** = agent asks small factual questions to fill in gaps before executing.

Grill-me is user-invoked, uses MCQ, ends in a knowledge write. Context interview is agent-invoked, uses open questions, ends in a well-scoped task attempt.

## Format

- **Numbered questions** — user can answer subset by number
- **≤4 questions per interview** — SDK MCQ cap + STT-friendly
- **Explicit "answer any that are relevant"** — user can skip

## Anti-patterns

- ❌ "What do you want?" — too broad, user has to redo the framing
- ❌ 10-question interview — pick 4 highest-leverage
- ❌ Interview after already producing wrong output — should have interviewed first
- ❌ Interview mid-task when agent should have asked at start
- ❌ Skipping interview + producing wrong output + saying "let me know if that's not right" — that's punting the interview onto the user

## Cross-refs

- [`karpathy-guidelines`](./karpathy-guidelines.md) §Think Before Coding — state assumptions; interview is one way to gather them
- [`edit-mode-prefs`](./preferences/edit-mode-prefs.md) — "no report/summary .md files as deliverable" applies; return context questions inline
- [`communication-stt-friendly`](../interaction/communication-stt-friendly.md) — the interview may itself be STT-friendly; ≤4 short questions
- Source: Nate Herk YouTube 2026-07-02 — "just ask Claude to ask me any further questions it needs to achieve the best result"
