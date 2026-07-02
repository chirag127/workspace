---
type: rule
title: "Review per-project memory monthly, prune stale entries"
description: "Auto-saved memory files (~/.claude/projects/*/memory/MEMORY.md) get stale — 'currently working on X' after X shipped. Monthly review + prune."
tags: [agent, memory, hygiene, maintenance]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/self-update-rule
  - rules/agent/knowledge-deletion-not-supersession
  - rules/agent/own-memory-rent-intelligence
---

# Memory review monthly

## The rule

Once a month, review every `~/.claude/projects/*/memory/MEMORY.md` file + any per-project memory notes. Delete stale entries. Not archive — delete, per [`knowledge-deletion-not-supersession`](./knowledge-deletion-not-supersession.md).

## Why this exists

Auto-saved memory accumulates false facts over time:
- "Currently working on X" — X shipped 3 weeks ago
- "User prefers Y" — user changed to Z last month
- "Project uses framework A" — migrated to B in the interim
- "Blocked on Z" — Z was resolved in a different session

Claude re-reads memory at session start and treats stale entries as current fact. Result: confident-wrong responses.

## Review protocol

Once a month (calendar reminder or on the first commit of the month):

1. `ls ~/.claude/projects/*/memory/` — list per-project memory dirs
2. For each `MEMORY.md`:
   - Read every one-liner pointer
   - For each pointer, ask: "Is this still true?"
   - Delete stale, keep live
3. For each memory file linked from `MEMORY.md`:
   - Open, check `metadata.type`
   - `feedback`/`project`: verify still applies. Delete if user preference changed OR project completed.
   - `user`: verify user still matches. Rarely deleted; occasionally updated.
   - `reference`: verify URL/target still exists. Delete if broken.
4. Commit: `chore(memory): prune stale entries YYYY-MM`

## What COUNTS as stale

- Timeframe: any "currently"/"in progress"/"waiting on" entry older than 6 weeks
- Superseded: entries where a newer decision file in `knowledge/` contradicts
- Duplicates: same fact stored in `knowledge/` + memory → keep knowledge, drop memory
- Wrong: entries that were factually incorrect when written (learned in a later session)

## What does NOT count as stale

- Genuine long-term preferences (user role, permanent taste rules)
- Reference URLs still live
- Feedback captured with "Why" + "How to apply" that still applies

## Anti-patterns

- ❌ Never reviewing (default) — memory becomes a fiction
- ❌ Reviewing but not deleting — accumulating "just in case"
- ❌ Moving stale memory to `knowledge/` "in case it's useful" — if it's not durable, delete
- ❌ Auto-review script that deletes anything older than N days without human eyes — misses genuine long-term facts

## Automation aids (allowed)

- Script that surfaces memory files older than 30 days for review
- Script that flags memory entries containing "currently"/"in progress"/"today"/"this week"
- Never a script that AUTO-DELETES

## Cross-refs

- [`self-update-rule`](./self-update-rule.md) — the write-side complement
- [`knowledge-deletion-not-supersession`](./knowledge-deletion-not-supersession.md) — deletion pattern
- [`own-memory-rent-intelligence`](./own-memory-rent-intelligence.md) — the reason memory hygiene matters
- Source: Nate Herk YouTube 2026-07-02 — his "kept thinking I was still working on videos I'd already posted" observation
