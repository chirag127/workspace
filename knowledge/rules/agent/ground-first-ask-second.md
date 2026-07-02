---
type: rule
title: "Ground first, ask second"
description: "For tasks requiring domain knowledge or fresh context, send a research/ground prompt FIRST, then the action prompt. Two-prompt pattern. Reduces hallucination + generic answers."
tags: [prompting, agent, grounding, hallucination]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/icc-prompt-formula
  - rules/interaction/parse-mcq-other-for-context
  - rules/agent/preferences/always-search-twice-before-deciding
---

# Ground first, ask second

## The rule

When a task needs specific domain knowledge, up-to-date info, or a particular framework/style, split into TWO prompts in the same session:

1. **Ground prompt**: "Research X. Extract the important tactics/patterns/spec. Be up-to-date."
2. **Action prompt**: "Now using what you just researched, do Y."

Same chat session. Grounding lands in context; action prompt draws from it.

## Example

**Task**: "Help me launch this product."

❌ **Single-prompt**:
```
Help me launch this SaaS product. What should my pricing strategy be?
```
→ Generic pricing advice.

✅ **Ground first**:
```
Prompt 1: Research Alex Hormozi's product-launch playbook. Extract:
  value equation, Grand Slam Offer components, pricing philosophy,
  market selection rules, risk reversal tactics. Be thorough.

Prompt 2 (same chat): Now using those tactics, help me price + position
  my SaaS. Product details: [full context].
```
→ Grounded, specific advice referencing the real playbook.

## When to use

- Task references a specific methodology / framework / expert
- Task involves fresh info (recent library version, new API, current market)
- Task in a domain you're not sure Claude is current on
- Iterating on a design that references specific artistic movements / brands

## When to skip

- Simple mechanical task
- Task where Claude's baseline knowledge is definitively sufficient
- Task with all context already in `knowledge/` (just reference the file)

## Grounding methods

Ground prompt can:
- **Research on the web** (Claude's web search): "research X"
- **Draw from uploaded files**: "read this doc + summarize the key tactics"
- **Reference internal knowledge**: "load `knowledge/decisions/stack/pipeline-stack-2026-07-01.md` before answering"
- **Combine**: "read this doc AND search web AND cite both"

## Combines with ICC

Ground prompt IS an ICC prompt: instructions ("research and extract"), context ("this is grounding for a later prompt about Y"), constraints ("extract as bullet list, cite sources").

## Anti-patterns

- ❌ Ground and act in one prompt — model tries to shortcut and does both poorly
- ❌ Ground in one session, act in another — context lost, defeats the pattern
- ❌ Ground with a shallow one-liner — get shallow grounding, useless downstream
- ❌ Skip grounding on fresh-info tasks — get 2024-training-cutoff answers

## Cross-refs

- [`icc-prompt-formula`](./icc-prompt-formula.md) — the shape of both the ground and action prompts
- [`always-search-twice-before-deciding`](./preferences/always-search-twice-before-deciding.md) — "search twice" applies to grounding too
- [`context-interview`](./context-interview.md) — alternative when the gap is user-context not domain-context
- Source: Nate Herk YouTube 2026-07 "Ground first, ask second" pattern
