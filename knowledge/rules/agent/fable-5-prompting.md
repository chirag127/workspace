---
type: rule
title: "Fable 5 prompting — 6 habits + safety-route awareness"
description: "Six locked prompting habits for Claude Fable 5: give why, negative-prompt, act when enough, make it prove, don't ask for reasoning, say less. Plus safety-router awareness (Fable→Opus 4.8 on suspicious intent)."
tags: [agent, prompting, fable, claude, effort-levels, safety]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
  - rules/agent/output-minimalism
  - rules/agent/preferences/cc-settings-balance
---

# Fable 5 prompting — 6 habits

## Model context

| Fact | Value |
|---|---|
| Model ID | `claude-fable-5` |
| Cost | $10/M input, $50/M output (2× Opus 4.8) |
| Promo period end | 2026-07-07 (50% weekly quota free until then; after = usage credits) |
| Reach | Claude desktop, VS Code, Claude Code, API |
| Reach for | ~5-15% of tasks. Overkill for the rest — use Sonnet/Haiku/Opus. |

## The 6 habits

### 1. Give it the why (any model)

Fable connects task → right context when intent is stated. Guessing without intent is where it drifts.

- ❌ `write me an email to a client about the delay`
- ✅ `[context: shipping X, client Y, blocker Z]. write an email about the delay`

### 2. Negative-prompt (any model)

Say what NOT to do. Older intuition that negative prompts hurt is outdated — 2026 models parse them cleanly.

- ❌ `take a look and handle it`
- ✅ `when I describe a problem, the deliverable is your assessment. don't fix, send, edit, or delete until I say go`

### 3. Let it act once it has enough (any model)

Fable can overplan at high effort. Cap the planning phase explicitly.

- ❌ `research everything and make a full plan before you do anything`
- ✅ `when you have enough information to act, act`

### 4. Make it prove it (any model)

Force explicit verification-with-evidence before "done". No done-declarations without receipts.

```
before you tell me something is done, point to the result that proves it.
only report work you can show evidence for.
if something isn't verified, say so plainly instead of guessing.
```

Bake into skills, agents, CLAUDE.md — not per-prompt.

### 5. Don't ask for reasoning display (Fable-specific)

`explain your reasoning` in system prompt can trigger Fable's safety guard → silently routes to Opus 4.8. Fable treats "reveal your private reasoning" as jailbreak-adjacent.

Skip that phrasing on Fable. If you want thinking visible: use `showThinkingSummaries=true` in settings, not a prompt line.

### 6. Say less, not more (Fable-specific)

Fable steers off short instructions as well as spelled-out rules. Bloating the system prompt no longer helps.

- ❌ `rule 1: be concise. rule 2: do X. rule 3: don't do Y. rule 4: ...`
- ✅ `lead with the outcome. keep it simple. pause only when the work truly needs me`

Not a contradiction with #1 — "why" is context, not rule-list-bloat.

## Effort levels

| Effort | When |
|---|---|
| `low` | Routine work, mechanical edits. Fable low ≈ Opus 4.8 xhigh quality, cheaper. |
| `medium` | Default routine |
| `high` | Recommended default per Anthropic docs |
| `xhigh` | Capability-sensitive (arch, hard debug, security review) |
| `max` | Reserve for genuinely hard multi-step problems |

Match effort to task. Blanket-xhigh burns budget without matching win.

## Safety-router awareness

Fable runs a safety check per request. Silent-routes to **Opus 4.8** if it detects:

- Hacking / offensive-security patterns
- Dangerous biology / weapons
- "Reveal your private reasoning" / jailbreak-shaped prompts

Signal:
- API: response header shows the actual model that served the request
- Claude Code / Desktop: no visible signal — you may not know
- Cost: Opus 4.8 is cheaper than Fable, so router = slight refund, not surprise bill

Avoid: don't ask Fable for scratchpad reasoning; don't phrase legit-but-suspicious tasks as if they were malicious.

## Applying to workspace

- **CLAUDE.md / AGENTS.md**: no `explain your reasoning` lines
- **Skills**: bake `make it prove it` verification-with-evidence into `verify`, `code-review`, `security-review`
- **Effort per skill**: `verify` = xhigh, `simplify` = low, most default = high
- **Session default**: keep Opus 4.8 (per [`cc-settings-balance`](./preferences/cc-settings-balance.md)); `/model fable-5` per-task for the 5-15% that warrants it

## Cross-refs

- [`ponytail`](./ponytail.md) — code-side minimalism (habit #6 aligned)
- [`caveman`](./caveman.md) — prose-side terseness (habit #6 aligned)
- [`output-minimalism`](./output-minimalism.md) — answer-first, no preamble (habit #3 aligned)
- [`cc-settings-balance`](./preferences/cc-settings-balance.md) — effort-level defaults
- Source: Anthropic Fable 5 prompting docs + Nate Herk YouTube distillation 2026-07-02
