---
type: glossary
title: "parallel fan-out"
description: "Spawning N subagents simultaneously for independent work."
tags: [glossary, agents, parallel]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# parallel fan-out

## Definition

Parallel fan-out is the act of spawning N subagents in a single
assistant turn so they execute simultaneously — the concrete
implementation of the [parallel-by-default](./parallel-by-default.md)
rule.

## Expanded

Mechanics: in a single tool-use block, issue N `Agent` calls (or N
parallel `Bash`/`Read`/`Write` calls), each scoped to one piece of
the independent work. Each subagent reports back; the parent
synthesises the results. This is fundamentally faster than
sequential, and the family's hard rule mandates it whenever the work
shape allows.

Anti-pattern: starting agent 1, waiting for it, starting agent 2, …
when none of them depends on another. Correct pattern: launch all in
the same turn.

## See also

- [parallel-by-default](./parallel-by-default.md)
