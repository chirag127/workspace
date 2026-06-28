---
type: rule
title: Self-update on every decision (durable info only)
description: Every durable architectural / naming / stack / external-fact decision the user makes in chat MUST be reflected in knowledge/ before the conversation ends. Skip count bumps, migration timestamps, step logs, restatements of the diff.
tags: [rules, agent, knowledge, process]
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
related:
  - rules/interaction/future-overrides-past
  - _okf
---

# Self-update on every decision

Durable decisions land in `knowledge/` (or `AGENTS.md` if family-wide) **in the same conversation**, before final response.

## What COUNTS (capture)

- Choice between distinct options + reason ("Razorpay not Stripe — INR rail")
- Stated constraint / taste rule ("no card on file", "free for users")
- External fact future-you can't easily re-derive (GPL-3.0 obligations for fork shipping)

## What does NOT count (skip)

- **Count bumps.** "72 → 73 submodules" is recoverable from git.
- **Migration timestamps + step logs.** Git history records what + when.
- **Diff restatements.** Commit already says "added DeArrow."
- **Status updates.** "Task complete" belongs in commit messages.

## Protocol

1. Durable info in user message? (per COUNTS list above)
2. Pick home per [`_okf.md`](../../_okf.md) taxonomy
3. `kebab-case.md` + concise OKF frontmatter + body
4. Supersedes older concept → set `superseded_by` + `supersedes`, don't delete
5. Commit `docs(knowledge): <one-liner>` (no push without say-so)

## See also

- [`future-overrides-past.md`](../interaction/future-overrides-past.md)
- [`_okf.md`](../../_okf.md) §"Update protocol"
