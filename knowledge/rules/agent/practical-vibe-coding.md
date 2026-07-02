---
type: rule
title: "Practical vibe coding — the middle way"
description: "Neither over-plan nor yolo. Iterate feature-by-feature with an anchoring AGENTS.md, focused ICC prompts, behavior-constraints, and verify each before starting next. The umbrella framework."
tags: [agent, philosophy, prompting, workflow, practical-vibe-coding]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/icc-prompt-formula
  - rules/agent/ground-first-ask-second
  - rules/agent/iterate-before-skill
  - rules/agent/small-composable-skills
  - rules/agent/session-hygiene
  - rules/agent/context-interview
  - rules/agent/karpathy-guidelines
---

# Practical vibe coding

## The middle way

Two failure modes at the extremes:

- **Pure vibe coding** — yolo the prompts, don't read the code. Features 1-3 fly; feature 5 breaks something and you can't tell what. Speed without direction.
- **Over-engineering** — 2 days of planning, folder conventions, and architecture docs before a single screen exists. Feels productive; ships nothing.

**Practical vibe coding sits in the middle.** Keep the speed of AI, add just enough structure so:
1. AI knows what it's working on (AGENTS.md at repo root, always read first).
2. You don't lose track (feature-by-feature, verify each).
3. Failures are localized (one change per prompt).

## The four anchors

### 1. AGENTS.md at repo root (living doc)

Written once, updated as recurring issues surface. Every prompt starts with "read AGENTS.md first and follow it strictly."

See [`agents-md-living-doc`](./agents-md-living-doc.md) for the update discipline.

### 2. 4-part prompt structure

Every non-trivial prompt has these four parts, in this order:

1. **Read AGENTS.md** — "Read the AGENTS.md first and follow it strictly."
2. **One task** — exactly one feature, one screen, one integration. Not three merged.
3. **Constraints that protect what works** — behavior constraints, not code prescriptions. See [`icc-prompt-formula`](./icc-prompt-formula.md) §"Constraints describe behavior."
4. **Design references** — screenshots, images, docs pasted inline. AI reads layouts better than descriptions of layouts.

### 3. Feature isolation

One prompt = one feature. Never merge tasks like "set up NativeWind AND build onboarding AND add auth." If something breaks across 3 tasks, you can't tell which caused it.

### 4. Verify-then-move-on

After each feature: test on real device/simulator, review the diff, then move on. Don't stack unfinished features.

See [`session-hygiene`](./session-hygiene.md) for when to reset chat between features.

## When to escalate to over-planning

Reach for full architecture docs ONLY when:
- ≥5-file cross-cutting refactor
- Security/auth boundary redesign
- Cost-sensitive infra decision (paid API, hosting migration)

Everything else = practical vibe coding.

## When to escalate to pure yolo

Never. Even a 5-line change gets an AGENTS.md read.

## Anti-patterns

- ❌ "Let me plan the whole app first" → 2 days spent, nothing built
- ❌ "Just ship it" → 5 features later, spaghetti code you can't explain
- ❌ Merging 3 features into one prompt to "save time" → save 2 min, lose 30 min on debugging
- ❌ Skipping the AGENTS.md read at prompt start → stale conventions leak through
- ❌ Perfectionist AGENTS.md upfront → block on writing; ship, update as you learn

## Composition with existing rules

| Element | Rule |
|---|---|
| Prompt structure | [`icc-prompt-formula`](./icc-prompt-formula.md) |
| Grounding before task | [`ground-first-ask-second`](./ground-first-ask-second.md) |
| Skill capture from iterations | [`iterate-before-skill`](./iterate-before-skill.md) |
| Skill composition | [`small-composable-skills`](./small-composable-skills.md) |
| AGENTS.md updates | [`agents-md-living-doc`](./agents-md-living-doc.md) |
| Session breaks | [`session-hygiene`](./session-hygiene.md) |
| Context gaps | [`context-interview`](./context-interview.md) |
| Assumptions first | [`karpathy-guidelines`](./karpathy-guidelines.md) |

## Cross-refs

- Source: JavaScript Mastery YouTube "Practical Vibe Coding" walkthrough 2026-07
- Andrej Karpathy 2026-01 "vibe coding" tweet — the term this rule refines
