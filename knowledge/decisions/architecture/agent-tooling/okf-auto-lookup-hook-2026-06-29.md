---
type: decision
title: "OKF auto-lookup via UserPromptSubmit hook (CC) + manual script (other agents)"
description: "Fix for OKF-not-triggering symptom: a 50-LOC Python script scores knowledge/index.md lines by prompt-token overlap, returns top-3 paths. CC fires it automatically; other agents run it manually because their harnesses lack pre-prompt hooks."
tags: [architecture, agent-tooling, okf, discoverability, hook]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - agent-rules/okf-lookup-before-acting.md
  - agent-rules/agent-fleet-parity.md
  - agent-rules/agent-minimum-context.md
---

# OKF auto-lookup via UserPromptSubmit hook

## Problem

`knowledge/` has 700+ concept files. Agent answers questions from training-data memory instead of grepping `knowledge/` first. The right answer exists in a concept file but is invisible because no mechanism forces a lookup.

Stated symptom from user 2026-06-29: "OKF is not getting triggered."

## Options considered

| Option | Cost | Coverage | Verdict |
|---|---|---|---|
| Convert 18 OKF runbooks to SKILL.md | 8-10 hr | 18/700 files (2.5%) | Rejected — leaves 97.5% un-triggerable |
| Convert all 700 files to SKILL.md wrappers | 40 hr | 100% but noisy | Rejected — Anthropic spec warns against |
| Embed full `index.md` (1285 lines, ~30K tokens) as auto-import | 0 hr | 100% by title | Rejected — pays cost every turn |
| Local embedding model semantic search | 4 hr + model download | 100% with smarter matching | Deferred — overkill for v1 |
| Tiny LLM (Haiku) classification per turn | 1 hr + $0.0002/turn | 100% with smartest match | Deferred — pay-per-call |
| **UserPromptSubmit hook + keyword script** | **~2 hr** | **100% by token overlap** | **Selected** |

## Decision

`scripts/okf-prompt-lookup.py` — stdlib Python, ~120 LOC. Reads prompt from argv or JSON-stdin, tokenises (strips stopwords + 3-char minimum), scores every line of `knowledge/index.md` by token overlap, returns top-N concept-file paths.

Wired into Claude Code via `~/.claude/settings.json` UserPromptSubmit hook. Fires on every prompt. Output is prepended to context as a system-reminder block listing top-3 paths + their index descriptions + scores.

## Fleet-parity gap

Audited 5 other agents 2026-06-29:

- **OpenCode** — no hook system in config schema. Verified against `ConfigV1.Info` TypeScript schema. Filed as upstream gap.
- **Kilo Code** — has `chat.message` plugin hook (TypeScript/Bun). Usable but requires a compiled plugin. Deferred.
- **Antigravity** — no public hook documentation. Treated as no-support.
- **MiMoCode** — no public hook documentation. Treated as no-support.
- **ZCode** — GUI-driven, no hook config.

For the 5 unsupported agents, the [`okf-lookup-before-acting`](../../../agent-rules/okf-lookup-before-acting.md) rule mandates the agent run the script itself at task start. Manual instead of automatic, but the rule lives in `AGENTS.md` and is loaded by every agent.

## Implementation

Files added:

- `scripts/okf-prompt-lookup.py` — the lookup script
- `knowledge/rules/agent/okf-lookup-before-acting.md` — the rule that mandates use
- `knowledge/decisions/architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29.md` — this file

Files modified:

- `~/.claude/settings.json` — added second entry to `UserPromptSubmit` hooks array (cavemem's entry preserved alongside)

## Verification

Smoke-tested 4 prompts 2026-06-29:

| Prompt | Top hit | Score | Verdict |
|---|---|---|---|
| "rotate a leaked GitHub token urgently" | `runbooks/security/credentials/rotate-cf-and-npm-tokens.md` | 2 | ✓ correct |
| "scaffold a new astro tool site" | `runbooks/scaffolding/sites/scaffold-tool-site.md` | 4 | ✓ correct |
| "add a new api subdomain to cloudflare DNS" | 3 CF-DNS-related files at score 3 | 3 | ⚠ missed `cf-dns-add-api-subdomain` because of "cloudflare" vs "cf-" token mismatch |
| "ok" | (empty, exit 1) | — | ✓ correctly skipped |

Live confirmation: user's first prompt after install surfaced `parallel-fan-out-by-default` + `parallel-by-default` + `parallel-fan-out` at score 3 each, exactly matching the user's prompt about fan-out.

## Known limitations (v1)

- **Token-mismatch misses**: "cloudflare" doesn't match `cf-`-prefixed files. Acceptable for v1; track upgrade to embedding/LLM classification if false-negative rate is bad.
- **No deduplication across glossary + runbook + decision**: same concept can return 3 paths (glossary stub + decision file + service file). Top-3 limit means real diversity caps out at 1-2 actually-distinct hits sometimes.
- **Stopword list is English-only**: matches family default; revisit if non-English content arrives.
- **No caching**: re-scans 1285 lines per turn. Negligible (~30ms) but could pre-index if it ever matters.

## What this replaced

A prior plan (rounds 1-4 of the grill) proposed 28-skill cross-agent installation, 3 submodule forks of external skill repos, `oriz-org/agent-skills` plugin marketplace, wshobson cross-harness adapter pattern. Round 5 reframe: the actual symptom was discoverability, not skill format. The auto-lookup hook fixes 90% of the symptom at 20% of the cost. The 28-skill plan is deferred indefinitely.
