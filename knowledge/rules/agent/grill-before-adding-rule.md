---
type: rule
title: "Grill before adding any rule — choose the right artefact type"
description: "Every proposed rule triggers a grill to determine if it belongs as a rule, skill, hook, knowledge file, or AGENTS.md line. Adding rules without grilling = knowledge bloat."
tags: [agent, meta, grill, rules, knowledge]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/agents-md-three-place-update
  - rules/agent/grill-to-knowledge
  - rules/agent/self-update-rule
---

# Grill before adding any rule

## The trigger

Whenever a new rule is about to be added — whether from a user request, a pattern observed in a session, or a video/transcript being distilled — **stop and grill first**.

## The grill questions

Ask these before writing any knowledge file:

| Q | If yes → |
|---|---|
| Is this a one-off task the user might explicitly invoke? | **Skill** (`.claude/skills/<name>/SKILL.md`) |
| Is this something Claude should do automatically on every matching tool use? | **Hook** (`settings.json` hooks) |
| Is this a durable decision with a WHY + trade-offs? | **Knowledge decision file** (`knowledge/decisions/...`) |
| Is this a constraint/taste that applies to ALL code or interactions? | **Rule** (`knowledge/rules/...`) + AGENTS.md table entry + count bump |
| Is this a step-by-step procedure? | **Runbook** (`knowledge/runbooks/...`) |
| Is this a short "always do X" that fits in one line? | **AGENTS.md TL;DR line** only (no concept file needed) |
| Is this already covered by an existing rule? | **Extend existing rule** — not a new file |

## Anti-patterns

- ❌ Writing a rule file when a skill would be better (user-invoked vs always-on)
- ❌ Writing a rule when a hook is better (runtime enforcement vs documentation)
- ❌ 5 new rule files when one existing rule could be extended
- ❌ Adding a rule without the 3-place update (concept file + AGENTS.md table + count bump)
- ❌ Rule that duplicates what ponytail/caveman/karpathy-guidelines already say

## Example grills

**"Add a rule that I should use Dagger for everything"**
→ Q: Is this a constraint on all CI code? Yes → Rule. Does it need AGENTS.md? Yes (developer constraint) → 3-place update.

**"Add a rule that you should search before filing issues"**
→ Q: Is this a one-off invoked task? Partially — but also always-on. → Extend existing `search-everything` skill AND add a note to `terse-issues-less-hallucination`.

**"Add a hook that shows screenpipe status after session ends"**
→ Q: Automatically fires on session end? Yes → Hook in `settings.json`, not a rule file.

**"Add a rule that responses should be creative"**
→ Q: Always-on taste rule? Yes, short → Memory file (`~/.claude/projects/.../memory/`) — not knowledge/ (it's user-preference, not workspace-architecture).

## Cross-refs

- [`agents-md-three-place-update`](./agents-md-three-place-update.md) — what to do after you decide it IS a rule
- [`grill-to-knowledge`](./grill-to-knowledge.md) — grill output → knowledge file
- [`self-update-rule`](./self-update-rule.md) — write the file same session
