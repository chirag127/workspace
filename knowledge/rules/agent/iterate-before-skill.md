---
type: rule
title: "Iterate before creating a skill"
description: "Never invoke skill-creator on the first attempt. Iterate manually 3-5 times, tag responses as good/bad with reasoning, THEN distill into a skill. Prevents overfit-on-one-example."
tags: [agent, skills, iteration, taste]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/karpathy-guidelines
  - rules/agent/ponytail
---

# Iterate before creating a skill

## The rule

Before invoking `skill-creator` (or manually writing a `SKILL.md`), iterate on the target task **3-5 times minimum**. On each attempt:

1. Prompt for the output.
2. Say what's good + what's bad + WHY specifically.
3. Try again with corrections.

Once the 3rd-5th attempt is close to right — THEN codify. Never skill-ify from a single response.

## Why

Skills are compressed instructions. If you distill from one example, the skill overfits: it captures accidents of that example (word choice, exact structure, edge case handling) as if they were rules. The skill will produce that exact shape forever.

Iterating exposes:
- **Taste patterns** — which stylistic choices matter, which don't
- **Failure modes** — hedging language, banned words, structures that consistently break
- **True rules vs accidents** — you only find these by seeing multiple attempts

## Anti-pattern

Nate Herk video 2026-07-02, "Claude features" walkthrough:
> "Write me 5 hooks... [gets response] ... this one's good, this one's bad" → repeat → "Now create a skill that would have gotten me the good response on the first try."

That's the shape. First attempt = data point. 5th attempt = data set.

## When to skip

- **Trivial mechanical skills** (rename files by pattern, apply lint rule) — one iteration is fine, no taste involved
- **Reproduction of documented spec** (e.g. "always use conventional commits") — spec IS the skill
- **Emergency codification** (need to lock this pattern before I forget it) — write minimal skill now, iterate later

## When NOT to skip

Any skill involving:
- Writing style / voice / tone
- Design taste (UI, prose, code style beyond formatter rules)
- Content selection / filtering / prioritization
- Anything where "the right answer" is contextual

## Reference-material addition

After iteration, if you have a corpus of good/bad examples (e.g. hook templates DB, screenshot gallery), UPLOAD it to the skill as reference material. The skill can then draw from real examples at invocation time, not just the abstracted rules.

## Cross-refs

- [`karpathy-guidelines`](./karpathy-guidelines.md) §Think Before Coding — same shape: assumptions before act
- [`ponytail`](./ponytail.md) — but note: this rule INVERTS the "act fast" default for skill creation specifically
- Source: Nate Herk YouTube 2026-07-02
