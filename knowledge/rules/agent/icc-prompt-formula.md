---
type: rule
title: "ICC prompt formula — Instructions + Context + Constraints"
description: "Every non-trivial prompt must have all three: what to do (instructions), what to know (context), what shape/limits apply (constraints). Order doesn't matter, completeness does. Optional: output example."
tags: [prompting, agent, structure, quality]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/karpathy-guidelines
  - rules/agent/output-minimalism
  - rules/agent/context-interview
---

# ICC prompt formula

## The rule

Every non-trivial prompt (to Claude directly, to subagent, or in skill/agent instructions) has three parts:

- **I** — **Instructions**: the task. Verb-first. Concrete deliverable.
- **C** — **Context**: role, objective, background, constraints already known, prior state. Err toward MORE context. Full context dumps are fine.
- **C** — **Constraints**: rules, style, tone, length, format, banned patterns, deadlines. Optional but usually valuable: an output example.

Order flexible. Completeness matters.

## Bad → Good example

❌ `Recommend 5 ways to implement AI in my marketing agency.`

Generic answer. Model has no anchor.

✅
```
[I] Recommend 5 ways to implement AI in my agency.
[C] I run a 3-person marketing agency, ~10 clients, mostly SaaS.
    Biggest time drain: client reporting + slack-check-in overhead.
    Team is non-technical.
[C] Low-cost, no technical expertise required, <2 weeks to setup each.
    Format: numbered list, one-sentence justification per item.
```

## Why ICC works

Model output quality is bounded by prompt information density. Missing:
- Instructions → confused output shape
- Context → generic, non-specific advice
- Constraints → sprawling, un-actionable

## When to relax

- Follow-up prompt in same session — context is already there
- Trivial mechanical task ("format this JSON") — I alone is fine
- Conversational turn — not a task at all

## Combines with context interview

If you START with ICC but realize context is thin, invoke [`context-interview`](./context-interview.md): "ask me any further questions you need before answering." Model fills the C gap for you.

## Apply to subagent prompts

The Agent tool prompt you write MUST have ICC:
- I: what the subagent will do
- C: what state/knowledge it needs, working dir, constraints from workspace rules
- C: return format, output caps, forbidden actions

## Anti-patterns

- ❌ I only ("write me a title") — get generic
- ❌ C only ("here's my business, tell me about it") — no verb to act on
- ❌ Constraints without I ("must be under 100 words. must include emoji.") — for WHAT?
- ❌ ICC + demanding "you decide" — user has to pick one path; you're the taste

## Cross-refs

- [`context-interview`](./context-interview.md) — how to fill C when you don't know it
- [`karpathy-guidelines`](./karpathy-guidelines.md) §Think Before Coding — state assumptions
- [`output-minimalism`](./output-minimalism.md) — constraints often trim output
- Source: Nate Herk YouTube 2026-07 "Most people are using Claude wrong"
