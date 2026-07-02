---
name: plan-mode-iterate
description: For any Claude Code initial build, always use plan mode first. Then after building, iterate one-change-at-a-time. Prevents scope drift + makes debugging easier.
---

# Plan mode + one-change-at-a-time iteration

## Two-phase rule

**Phase 1: Plan mode for initial build.** Every new project or major-feature build. Claude produces a full plan (tech stack, file layout, features, gotchas). Review + tweak + approve before code lands.

**Phase 2: One change per iteration.** After initial build, follow-up prompts are single-focus. Not "add feature A, fix bug B, refactor C in one prompt."

## Why plan mode

- Catches misinterpretation before code exists (cheap to fix)
- Surfaces clarifying questions before wasted work
- User can add "actually, I want X different" as annotations on the plan
- Locks scope

## Why one-change-at-a-time

- Failures are attributable (change X broke thing Y → clear)
- Changes can interact unexpectedly — batching multiplies failure modes
- Verify green after each change, don't stack broken states

## Toggle mechanics

- Plan mode: activate before initial prompt
- Accept & build: exits plan mode, code starts landing
- After first build lands: switch OFF plan mode for follow-ups (accept edits mode)
- Re-enter plan mode ONLY for big architectural changes / new features

## Anti-patterns

- ❌ Skip plan mode on initial build → get half-right output, fix cascading downstream
- ❌ Stay in plan mode forever → never actually build
- ❌ Batch 5 changes into one prompt → one breaks all
- ❌ "Fix everything I described earlier" without listing → agent forgets half

## What "one change" means

- Single feature addition
- Single bug fix
- Single style/UX tweak
- Single dependency swap

Two changes = two prompts. Even trivial ones — the muscle memory matters.

## Cross-refs

- [`karpathy-guidelines`](../../../knowledge/rules/agent/karpathy-guidelines.md) §Goal-Driven Execution — verify after each step
- [`ponytail`](../../../knowledge/rules/agent/ponytail.md) — minimal edit per turn
- Source: Nate Herk Claude Code walkthrough 2026-07
