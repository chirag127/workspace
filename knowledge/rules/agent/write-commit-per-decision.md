---
type: rule
title: "Write + commit per decision (not per session)"
description: "Each locked decision is written to knowledge/ and committed as a discrete unit when finalized — not batched into an end-of-session 'lock everything' commit. Trail in git history matches trail in conversation."
tags: [agent-behavior, knowledge, commits, discipline]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
related:
  - rules/agent/self-update-rule
  - rules/agent/adaptive-commit-granularity
  - rules/agent/log-decisions-only
---

# Write + commit per decision

## Rule

When the user locks a decision in chat, write the corresponding knowledge file AND commit it as a discrete unit before moving to the next decision. Don't accumulate edits and batch-commit at session end.

## How to apply

- Lock decision -> write file -> stage -> commit -> continue. One decision = one commit (subject to adaptive granularity, see [`adaptive-commit-granularity`](./adaptive-commit-granularity.md)).
- Commit message: `docs(knowledge): lock <slug> — <one-line summary>`.
- Exception: a *batch grill session* (3+ related decisions in one sitting) commits as one — see [`adaptive-commit-granularity`](./adaptive-commit-granularity.md).
- Push when the user says push; never auto-push.
- Per [`self-update-rule`](./self-update-rule.md), this is non-negotiable for durable decisions.

## Why

User locked this on 2026-06-26 (Q12). Per-decision commits give a clean revert surface and a readable git log; batched end-of-session commits hide the trail.

## Captured

2026-06-26 session, Q12 of 24-question grill.

## Related

- [`self-update-rule`](./self-update-rule.md)
- [`adaptive-commit-granularity`](./adaptive-commit-granularity.md)
- [`log-decisions-only`](./log-decisions-only.md)
