---
type: rule
title: "Keep knowledge fresh — read first, write decisions, delete obsoletes every session"
description: "Every chat session begins with reading the relevant knowledge files. Every decision the user makes in chat must land in knowledge in the same conversation. Every superseded decision file must be marked status: superseded OR deleted same-day. Never let knowledge and conversation drift."
tags: [rules, knowledge, okf, self-update, family]
timestamp: 2026-06-21
format_version: okf-v0.1
status: active
related: [rules/self-update-rule, rules/future-overrides-past, _okf]
---

# Keep knowledge fresh

## The rule

The OKF knowledge bundle at `knowledge/` is the family's persistent
memory. Every chat session, every agent, every subagent reads from it
before acting, writes to it whenever a decision lands, and prunes it
whenever a prior decision is obsolete.

Three obligations on every session:

### 1. Read first

Before suggesting any architectural or naming change, read:
- `knowledge/index.md` (always)
- `knowledge/decisions/index.md` for any architecture / naming /
  stack question
- `knowledge/rules/index.md` for any policy question
- The specific decision file the question touches (e.g.
  `decisions/branding/naming-policy-v5.md` for repo names)

If knowledge already locks the answer, DO NOT ask the user — surface
the locked answer and proceed.

### 2. Write every chat decision

When the user makes a decision in chat (MCQ answer, free-text choice,
override), the decision lands in knowledge SAME TURN:
- New decisions → new file under `knowledge/decisions/<topic>/`
- Reaffirmations → no new file, but log in `knowledge/log.md`
- Reversals → mark prior file `status: superseded`, write new file

Per `rules/self-update-rule.md`. The chat is ephemeral; knowledge is
durable.

### 3. Delete obsoletes same-day

When a decision is superseded:
- If <24 hours old AND has no external refs → DELETE the file
- If >24 hours old OR referenced externally → mark `status: superseded`
  with banner-header pointing at the superseder

Audit trail lives in git history, not in lingering stale files. Per
`rules/user-prefers-deletion-over-archive.md`.

## How to apply per session

```
START
├── Read knowledge/index.md
├── Read knowledge/log.md (last 10 entries)
├── For each user request:
│   ├── Identify which knowledge area applies
│   ├── Read the relevant decision/rule files
│   ├── If answer is locked → use it
│   ├── If not → ask user MCQ, then write decision to knowledge
│   └── If reversal → delete obsolete + write new
├── At session end (or every 10 turns):
│   ├── Sweep for orphaned references to deleted files
│   └── Commit + push knowledge changes
END
```

## Required reading on first turn of every session

Every agent's first action in a session is:
1. `Read C:/D/oriz/knowledge/index.md`
2. `Read C:/D/oriz/knowledge/decisions/index.md`
3. `Read C:/D/oriz/knowledge/rules/index.md`
4. `Read C:/D/oriz/knowledge/log.md` (most recent 20 entries)

Without these reads, the agent cannot know what's already decided. Acting
without reading first violates this rule.

## When NOT to apply

- Trivial typo fixes (no decision content).
- One-shot bug fixes in code that don't change architecture.
- Pure code refactors that don't touch a locked decision.

Everything else triggers the read-write-prune cycle.

## What goes WHERE

| Type | Goes in | Example |
|---|---|---|
| Locked architectural / stack / naming choice | `decisions/<topic>/<slug>.md` | `decisions/branding/naming-policy-v5.md` |
| Non-negotiable family-wide constraint | `rules/<slug>.md` | `rules/no-card-on-file.md` |
| Service pick with alternatives + swap cost | `services/<category>/<service>.md` | `services/auth/firebase-spark.md` |
| Step-by-step actionable sequence | `runbooks/<slug>.md` | `runbooks/scaffold-a-new-site.md` |
| Family-specific term definition | `glossary/<letter>/<term>.md` | `glossary/o-r/oriz-kit.md` |
| Per-site scoped concept | `sites/<site>/<slug>.md` | `sites/oriz-me/lifestream-spec.md` |
| Time-stamped history | `log.md` | (append-only) |

## Cross-refs

- [rules/self-update-rule](./self-update-rule.md) — every chat
  decision lands in knowledge same turn
- [rules/future-overrides-past](./future-overrides-past.md) — chat
  wins when it contradicts knowledge
- [rules/user-prefers-deletion-over-archive](./user-prefers-deletion-over-archive.md)
  — delete superseded same-day
- [_okf.md](../_okf.md) — the OKF conventions every concept file
  follows
