---
type: rule
title: "AGENTS.md is a living doc — update when patterns recur"
description: "AGENTS.md is not written-once. When a recurring issue surfaces during development (tool quirk, banned pattern, style rule), update AGENTS.md before moving on. Solve once, document, forget."
tags: [agent, agents-md, hygiene, living-doc, workflow]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/agents-md-three-place-update
  - rules/agent/self-update-rule
  - rules/agent/practical-vibe-coding
---

# AGENTS.md is a living doc

## The rule

AGENTS.md is not a one-time write. When a pattern recurs during development, UPDATE AGENTS.md before moving on to the next feature.

**Solve once → document → forget.** Never fight the same issue twice.

## Trigger: what counts as "recurring"

Update AGENTS.md when:

- **Same tool quirk hits 2+ times** in one session (e.g. NativeWind + safe-area-view style prop drops)
- **AI reaches for wrong library / pattern** more than once (e.g. keeps proposing lodash when stdlib works)
- **Banned pattern appears** in generated code multiple times (e.g. `any` type in TS, `console.log` left in)
- **Version-specific gotcha** surfaces (e.g. Zustand DevTools uses `import.meta` which RN doesn't support)
- **User rejects a suggestion class** more than once (e.g. "no card-on-file" for the Nth time)

## The update mechanic

1. Note the issue as it happens (in a scratch section or inline)
2. At the natural stopping point (end of feature, before next prompt), edit AGENTS.md
3. Add a one-liner under the relevant section (Style Rules / Stack Rules / Anti-Patterns)
4. Continue the next feature — the AI now reads the updated AGENTS.md and skips the issue

## Example

**Situation**: NativeWind class-name prop doesn't work on `<SafeAreaView>`. AI keeps generating class-name-only styles that silently fail.

**Update**: Add to AGENTS.md under Style Rules:

```md
### Style Rules
- Use NativeWind classes (className prop) for all styling
- EXCEPTION: SafeAreaView does not support className. Use StyleSheet for it.
```

Now: AI reads this every prompt. Issue never returns.

## Anti-patterns

- ❌ Fight the same issue 5 times without updating AGENTS.md
- ❌ Wait until "the perfect AGENTS.md" before starting — ship, update as you learn
- ❌ Bulk-update AGENTS.md quarterly — update SAME SESSION the issue appeared
- ❌ Add every one-off preference — only add things that RECUR
- ❌ Long-form additions — one-liners preferred; detail lives elsewhere

## When to also propagate to `knowledge/`

If the recurring pattern is:
- Family-wide (affects all repos, not just this one) → also add to `knowledge/rules/agent/` per [`agents-md-three-place-update`](./agents-md-three-place-update.md)
- Repo-specific → AGENTS.md only

## AGENTS.md size discipline

AGENTS.md should grow slowly. If it's ballooning past ~500 lines:
- Some rules are one-offs, not recurring → prune them
- Some rules belong in a linked concept file → link out instead of inlining

Target: AGENTS.md is skimmable in 60 seconds by a new agent.

## Cross-refs

- [`agents-md-three-place-update`](./agents-md-three-place-update.md) — when the update ALSO needs a `knowledge/rules/` entry
- [`self-update-rule`](./self-update-rule.md) — the broader same-turn write discipline
- [`practical-vibe-coding`](./practical-vibe-coding.md) — the umbrella this fits under
- Source: JavaScript Mastery YouTube 2026-07 "practical vibe coding" — the NativeWind + safe-area-view example
