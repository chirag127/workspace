---
type: rule
title: "Small composable skills, not mega-skills"
description: "One skill does one thing well. Chain 4-6 small skills > one 500-line mega-skill. Enables auto-invocation per sub-task + composition across workflows."
tags: [agent, skills, composition, modularity]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/iterate-before-skill
  - rules/agent/delegate-to-subagents-by-default
---

# Small composable skills

## The rule

Each skill does ONE thing. Not "write my whole YouTube video" — instead: `script-critique`, `intro-writer`, `title-generator`, `description-writer`. Four skills, each focused, all invokable independently.

## Why

**Auto-invocation**: Claude auto-loads the right skill based on the user's phrasing. `write me a title` → title-generator. `critique this script` → script-critique. A mega-skill sits idle until explicitly named; small skills fire when they match.

**Reusability**: `title-generator` works for videos AND blog posts AND emails. A `full-youtube-workflow` skill only works for YouTube.

**Debuggability**: When a skill produces wrong output, you know exactly which of the 6 skills to fix. In a mega-skill, the failure mode is opaque.

**Composition**: Real workflows chain skills. Nate Herk 2026-07-02: script → critique → intro → title → description = 4 skills in one project. Not one skill doing all 4.

## The shape

| Good skill | Bad mega-skill |
|---|---|
| `script-critique.md` — 60 lines | `youtube-full-workflow.md` — 400 lines |
| `intro-writer.md` — 40 lines | |
| `title-generator.md` — 30 lines | |
| `description-writer.md` — 30 lines | |

Total: 160 lines across 4 skills > 400 lines in one.

## Size heuristic

If a `SKILL.md` gets past ~150 lines, ask: can this split into 2 skills? If yes, split.

Exceptions:
- Reference/lookup skills (e.g. `github-actions-docs`) — inherently long because they encode documentation
- Deep-domain skills (e.g. `webapp-testing`) — the domain is genuinely broad; split by sub-domain if possible but don't force it

## What "one thing" means

- ✅ `code-review` — reviews code for defects
- ✅ `security-review` — reviews code for OWASP-style vulns
- ❌ `code-and-security-review` — do both

Related-but-separate concerns get separate skills. The user can invoke both in sequence.

## When to combine

**When to actually merge** two skills into one:
- Both skills share ≥80% of their prompt content
- Neither skill is useful alone (one always fires with the other)
- Combined skill is still <150 lines

Otherwise, keep separate.

## Cross-refs

- [`ponytail`](./ponytail.md) §ULTRA — "one implementation = no interface. one product = no factory"
- [`iterate-before-skill`](./iterate-before-skill.md) — iteration reveals the natural boundaries between skills
- [`delegate-to-subagents-by-default`](./delegate-to-subagents-by-default.md) — a mega-skill vs many small skills is the same anti-pattern as monolithic agent vs subagent orchestration
- Source: Nate Herk YouTube 2026-07-02 — his 4-skill YouTube workflow demonstrates composition
