---
type: rule
title: 'Claude Code settings balance — speed × accuracy × cost (2026-06-29 pin)'
description: All 12 settings.json picks from the 2026-06-29 grill-me session, with rationale per axis. Locks the Opus-default + always-thinking-floor + adaptive-on + 85% compact + agent-teams-on shape.
tags: [claude-code, settings, balance, speed, accuracy, cost, preference]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/claude-code-latency-techniques
  - rules/agent/preferences/edit-mode-prefs
---

# Claude Code settings balance — 2026-06-29 pin

Locked via 2026-06-29 grill-me session, 4 batches × 4 questions = 16 picks. Captures the "max-quality posture" since Bedrock-through-Hr is corp-paid.

## The 12 picks

| Setting | Value | Speed | Accuracy | Cost |
|---|---|---|---|---|
| `effortLevel` | `"high"` | 8/10 | 8/10 | 4/10 |
| `alwaysThinkingEnabled` | `true` | -1/10 | +2/10 | +1/10 |
| Adaptive thinking | enabled (default) | +1/10 | -0 (with always-thinking floor) | -1/10 |
| `MAX_THINKING_TOKENS` | DELETED | 0 | 0 | 0 |
| `model` | `"claude-opus-latest"` | 6/10 | 10/10 | 9/10 |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | `"85"` | +1/10 | 9/10 | -1/10 |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | `"1"` | +3/10 | +2/10 | +3/10 |
| `switchModelsOnFlag` | `true` | (off-axis) | (off-axis) | (off-axis) |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | DELETED (betas ON) | -1/10 | +1/10 | 0 |
| `showThinkingSummaries` | `true` | -0 | +2/10 (catches bad paths) | 0 |
| `autoMemoryEnabled` | `true` | -0 | +1/10 | 0 |
| `ANTHROPIC_AUTH_TOKEN` | → `settings.local.json` | 0 | 0 | 0 (security only) |

Cost-positive number = burns more. Speed-positive number = faster wall-clock.

## Rationale per axis

### Speed posture: medium-high

Hr proxy compresses prefix. ToolSearch defers MCP tools out of cache. 85% compact reduces rebuild frequency. PowerShell tool over Git Bash. Pinned model + pinned effort = stable cache key. Betas ON costs a few ms of HTTP fanout — acceptable for new features.

### Accuracy posture: max

Opus 4.8 daily. Always-thinking + adaptive thinking combined: floor>0, depth auto-tuned. effortLevel=high (pre-March-2026 Anthropic default; the level Boris Cherny says Claude was tuned for). Agent teams for architecture work. Thinking summaries visible.

### Cost posture: don't count

Corp Bedrock via Hr means cost is downstream concern. Pick Opus over Sonnet. Pick agent teams ON. Pick 85% compact over 70% (fewer rebuilds = more cache reuse = NET cheaper despite longer prefix).

**The exception:** `/model sonnet` and `/fast` available per-task when the work is mechanical. Don't let "cost is downstream" become "always burn Opus on file renames."

## Why these specific overrides matter

Three picks OVERRODE my initial recommendations:

1. **`model: claude-opus-latest` over Sonnet** — overrides 2026-06-27 `default-model-sonnet-4-6` memory. New memory: `default-model-opus-2026-06-29`. Captures the corp-pays insight that earlier grill missed.

2. **Adaptive thinking ENABLED over disabled** — Marco Lancini + Pasquale Pillitteri both recommend disabling adaptive. User insight: combining `alwaysThinkingEnabled=true` with adaptive gives floor>0 + auto-tune, better than either alone. **This is a novel position the cited articles don't cover.**

3. **Agent teams ENABLED** — Marco's setup; conflicts with the `delegate-to-subagents-by-default` rule. Resolution: when user invokes a slash command (`/grill-me`, `/code-review`), explicit delegation wins. Agent teams handles the "free-form prose multi-step" case where the explicit delegation rule didn't fire. They compose; no double-spawn.

## Anti-patterns this pin avoids

- ❌ Cargo-culting Marco Lancini's `xhigh` default — costs 2× without 2× benefit at the corp-Bedrock margin
- ❌ Disabling adaptive thinking globally — works for Marco (always-xhigh) but wastes tokens on trivial turns when paired with `high` effort
- ❌ 70% compact threshold — fires too early on long sessions; 85% is the Anthropic default for a reason
- ❌ Pinning `MAX_THINKING_TOKENS` — legacy `budget_tokens` API, ignored on Opus 4.7+
- ❌ Auth token in `~/.claude/settings.json` — gets committed/synced. Move to `settings.local.json` (gitignored by CC).

## When to re-grill

- Anthropic changes default `effortLevel` (next regression)
- Bedrock corp billing model changes (cost re-enters the equation)
- Agent teams graduates from experimental or gets renamed
- User stops using Hr (cost becomes personal)

## Cross-refs

- [`claude-code-latency-techniques`](../claude-code-latency-techniques.md) — settings reference + cache model
- [`default-model-opus-2026-06-29`](../../../../../.claude/projects/c--D-oriz/memory/default-model-opus-2026-06-29.md) — memory file capturing model choice
- [`minimum-claude-settings`](../../../../../.claude/projects/c--D-oriz/memory/minimum-claude-settings.md) — "keep settings.json minimal" — partially superseded; this pin has more keys
- [`grill-me-default`](../grill-me-default.md) — the discipline that produced this pin
- Upstream: Marco Lancini's 2026 setup, Pasquale Pillitteri effort guide, Boris Cherny HN comment, AMD Stella Laurenzo 6852-session analysis
