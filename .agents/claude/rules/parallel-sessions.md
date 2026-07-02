---
name: parallel-sessions
description: Run 2-3 Claude Code sessions in parallel on independent builds after mastering single-session basics. Yellow-dot indicators show which needs input. Only for independent projects.
---

# Parallel Claude Code sessions

## When to fire

- 2-3 INDEPENDENT builds you can run concurrently
- Long-running builds (5-15 min each) where waiting is wasted time
- Landing page + Chrome extension + link-in-bio all needed by end of day

## When NOT to

- Learning Claude Code (single session first — get the basics)
- Related builds where output of one feeds another — serialize instead
- Complex builds needing full attention on the plan/review — one at a time

## Mechanics

1. New session per project — separate folder for each
2. Watch the panel status: yellow dot = needs input
3. Cycle through sessions as they pause for input
4. Cut wait times by ~2-3× on parallelizable work

## Coordination tips

- **Different working dirs** — never share folders between parallel sessions (git-lock conflicts)
- **Different models OK** — one on Opus for hard planning, another on Sonnet for iteration
- **Don't parallelize the plan-mode step** — take plan mode seriously, one at a time; then parallelize the build phase

## Cost

- Token usage multiplies 2-3×
- 5-hour rolling window can burn faster
- Watch usage under Claude Code settings; downshift if approaching cap

## Anti-patterns

- ❌ Parallelize 5+ sessions — attention span breaks; more waste than win
- ❌ Parallel builds that share a submodule / repo → merge conflicts
- ❌ Parallelize when you haven't mastered single-session → double the confusion
- ❌ Ignoring yellow-dot indicators for 10+ min → session times out or drifts

## Cross-refs

- [`parallel-fan-out-by-default`](../../../knowledge/rules/interaction/parallel-fan-out-by-default.md) — the broader principle
- [`plan-mode-iterate`](./plan-mode-iterate.md) — parallelize the build phase, not the plan phase
- [`delegate-to-subagents-by-default`](../../../knowledge/rules/agent/delegate-to-subagents-by-default.md) — subagents inside ONE session vs parallel sessions across builds
- Source: Nate Herk Claude Code walkthrough 2026-07
