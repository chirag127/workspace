---
type: glossary
title: "parallel by default"
description: "The family rule: any work that can be parallelised MUST be fanned out via subagents."
tags: [glossary, rule, agents]
timestamp: 2026-06-20
format_version: okf-v0.1
---

# parallel by default

## Definition

Parallel-by-default is the family's hard rule that any task that can
be parallelised MUST be fanned out via subagents. Sequential is the
exception, and must be justified in the commit message or task
description when used.

## Expanded

Examples: adding a feature across 5 sites = 5 parallel subagents;
researching alternatives to N services = N parallel research agents;
renaming a package across 11 consumers = 11 parallel update agents.
The exception: a 3-step pipeline where step 2 depends on step 1's
output is correctly sequential.

The rule applies even when the work is simple. A solo developer
without parallelism is the bottleneck; a solo developer with
parallelism is not.

## See also

- [parallel-fan-out](./parallel-fan-out.md)
- [self-update-rule](./self-update-rule.md)
