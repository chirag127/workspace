---
type: rule
title: "Delegate to sub-agents by default — researcher for reads, Haiku for batch"
description: ACTIVE every response. Reach for the researcher / Explore / general-purpose sub-agent before reading 3+ files in the main thread. Sub-agent context is isolated; only the summary returns. Cuts main-thread tokens 40-70% on read-heavy work.
tags: [sub-agents, token-reduction, delegation, agent-behavior, hard-rule]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
  - rules/agent/output-minimalism
---

# Delegate to sub-agents by default

ACTIVE EVERY RESPONSE. Token-reduction discipline at the orchestration layer.

## The rule

For any of these patterns, dispatch a sub-agent instead of doing it in the main thread:

| Pattern | Sub-agent | Why |
|---|---|---|
| Reading 3+ files to answer a question | `researcher` | Pinned to Haiku — 5× cheaper. Returns paragraph summary. |
| `grep` / `Glob` across the repo for a symbol | `researcher` | Same |
| "Where is X defined?" / "What calls Y?" | `researcher` or `Explore` | Read-only, fast |
| Multi-step build (scaffold + commit + deploy) | `general-purpose` | Tool calls don't bloat main context |
| Architecture planning across 5+ files | `Plan` | Returns plan only, not file dumps |
| Claude Code / Anthropic API Q&A | `claude-code-guide` | Has WebFetch + docs access |

## When to skip sub-agents (stay in main thread)

- **Single-file edit** with a known path → just Edit
- **Trivial answer** from already-loaded context → answer directly
- **Single fact lookup** where path is known → Read directly
- **Tool call you already started** — don't fork mid-task

## Output discipline

When delegating, the sub-agent prompt MUST specify:

1. **What success looks like** (one-line goal)
2. **Return format** (terse summary, paragraph not raw dump)
3. **Working dir** (absolute path, never `/tmp` on Windows Git Bash — use `C:/D/oriz/.staging/<task>/`)
4. **Hard constraints** (no branches, no emoji, ponytail/caveman active)

## Anti-patterns

- ❌ Reading 5 files in the main thread to summarize them
- ❌ Running `grep -r` then reading every hit in main context
- ❌ Sub-agent doing a 5-line trivial task (orchestration overhead exceeds the work)
- ❌ Sub-agent that returns verbose paragraphs — its prompt should mandate terse summary
- ❌ Forgetting to give the sub-agent a working dir, leading to `/tmp` mishandling on Windows

## The cost math

Reading 10 files of 200 lines each in main thread: ~20K input tokens consumed.

Delegating to `researcher`: ~500 tokens out (the prompt) + ~300 tokens back (the summary). **~95% savings** on that operation, plus the sub-agent runs on Haiku at 1/5 the price.

## Cross-refs

- [`ponytail`](./ponytail.md) — code minimalism (lazy by code rung)
- [`caveman`](./caveman.md) — terse prose
- [`output-minimalism`](./output-minimalism.md) — banned anti-patterns
- This rule = lazy by orchestration (don't do work the main thread shouldn't carry)
