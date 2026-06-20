---
type: rule
title: "Self-update on every decision"
description: "Every architectural / naming / stack decision the user makes in chat MUST be reflected in knowledge/ before the conversation ends."
tags: [rules, agent, knowledge, process]
timestamp: 2026-06-20
format_version: okf-v0.1
status: active
related:
  - rules/future-overrides-past
  - _okf
---

# Self-update on every decision

Every architectural / naming / stack decision the user makes in chat
MUST be reflected in `knowledge/` (or `AGENTS.md` if family-wide
foundational) **in the same conversation**, before the agent's final
response.

## Why

The bundle is a living wiki. If a decision lands in chat but never
makes it to a file, the next agent (or the next chat) doesn't know it
exists, and we re-litigate decisions weekly. That wastes the user's
time and produces inconsistent code.

The agent that took the decision is the one with full context for it.
Capturing it later is strictly worse: details get lost, the wording
drifts, the rationale evaporates.

## The protocol

1. Identify the decision in the user's message.
2. Pick the right home: `rules/`, `decisions/`, `services/`,
   `architecture/`, etc. Per [`_okf.md`](../_okf.md) taxonomy.
3. Pick a `kebab-case.md` filename that names the concept clearly.
4. Write the file with full OKF frontmatter.
5. Append a one-line entry to `knowledge/log.md` with the date + path.
6. If it supersedes an older concept, set `superseded_by` on the old
   one and `supersedes` on the new one. Don't delete the old file.
7. Commit with `docs(knowledge): <one-line summary>` (don't push —
   see [`no-push-without-say-so.md`](./no-push-without-say-so.md)).

## Exceptions

None. If the agent doesn't update the bundle, the agent has failed.

## See also

- [`future-overrides-past.md`](./future-overrides-past.md) — paired rule
- [`_okf.md`](../_okf.md) §"Update protocol"
- AGENTS.md "Self-update rule"
