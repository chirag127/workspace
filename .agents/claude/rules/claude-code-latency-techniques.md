---
type: rule
title: 'Claude Code latency: keep cache hot, route through Hr, balance speed/accuracy/cost'
description: Per Anthropic's prompt-caching docs, April 2026 incident postmortem, and 2026-06-29 grill-me settings rebalance. Pick model + effort at session start, don't change mid-task. Route through Headroom. Use skill triggers (slash commands) over prose discussion.
tags: [latency, speed, claude-code, prompt-caching, headroom, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
  - rules/agent/preferences/cc-settings-balance
---

# Claude Code latency optimization

Goal: balance turn-time, output quality, and cost. Per [Anthropic prompt-caching docs](https://code.claude.com/docs/en/prompt-caching), the [April 2026 postmortem](https://www.aakashx.com/blog/claude-code-slow-causes-fixes/), and the [2026-06-29 settings-balance grill-me session](../../../knowledge/rules/agent/preferences/cc-settings-balance.md).

## The cache model (must understand to optimize)

Each turn the API caches the request **prefix**. New content goes at the end; cache reuses everything before the latest exchange. **Any change in the prefix invalidates everything after it.**

Three layers, ordered from stable to volatile:

| Layer | Content | When it changes |
|---|---|---|
| System prompt | Core instructions, tool definitions, output style | Tool definitions change, Claude Code upgrade |
| Project context | CLAUDE.md, AGENTS.md, auto memory, rules | Session starts, `/clear`, `/compact` |
| Conversation | User messages, Claude responses, tool results | Every turn |

The cache key ALSO includes:
- **Model** — each model has its own cache. `/model opus` → entire history recomputed.
- **Effort level** — each effort has its own cache. `/effort high` → entire history recomputed.
- **Fast mode flag** — turning it on adds a cache-key header → entire history recomputed (once per conversation).

## Actions that destroy the cache mid-session

DON'T do these mid-task unless absolutely necessary:

- `/model <other>` — full rebuild
- `/effort <level>` — full rebuild
- `/fast` toggle — full rebuild (first time only; subsequent toggles cached)
- Connect/disconnect MCP server (when tools aren't deferred via tool search)
- Enable/disable a plugin
- Deny an entire tool
- `/compact`
- Upgrade Claude Code

Reserve `/compact` for natural breaks between tasks, not mid-task.

## Settings.json — current pin (2026-06-29 rebalance)

`~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:8787",
    "ANTHROPIC_MODEL": "claude-opus-latest",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-latest",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-latest",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-latest",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "85",
    "DISABLE_ERROR_REPORTING": "1",
    "DISABLE_TELEMETRY": "1",
    "ENABLE_TOOL_SEARCH": "auto"
  },
  "model": "claude-opus-latest",
  "effortLevel": "high",
  "alwaysThinkingEnabled": true,
  "showThinkingSummaries": true,
  "autoMemoryEnabled": true,
  "switchModelsOnFlag": true
}
```

Auth token lives in `~/.claude/settings.local.json` (gitignored).

Why each line matters:
- `ANTHROPIC_BASE_URL=http://127.0.0.1:8787` — routes through Headroom which compresses chat/file context. Less input = faster TTFT.
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` — skips background analytics HTTP. Faster TTFT.
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` — auto-fanout 2-3 subagents on architecture/research tasks. Costs 2-3× tokens for wall-clock win.
- `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=85` — compact context at 85% (default-ish). Trades rare cache rebuilds for fewer summarization passes.
- `ENABLE_TOOL_SEARCH=auto` — defers MCP tool definitions out of the cache prefix. Connecting/disconnecting MCP servers no longer invalidates cache.
- `effortLevel=high` — Anthropic's pre-March-2026 default. Strong reasoning without xhigh's cost. `/effort xhigh` per-task when needed.
- `alwaysThinkingEnabled=true` — forces non-zero think tokens every turn. Prevents the Feb-2026 zero-think-tokens bug (AMD's 6852-session analysis, Boris Cherny HN confirmation).
- **Adaptive thinking is left ENABLED** (default). Combined with `alwaysThinkingEnabled=true`, this gives: floor>0 always, depth auto-tuned per turn. Cheaper than always-xhigh, safer than adaptive-alone. The balanced position.
- `showThinkingSummaries=true` — reasoning visible in terminal. Catches bad paths early.
- `model=claude-opus-latest` — daily driver. Opus through Hr (corp Bedrock) means cost is downstream concern. `/fast` switches to Sonnet on mechanical work.
- `switchModelsOnFlag=true` — makes `/fast` actually switch models.

## Skill triggers > free-form prose

User says trigger phrase → invoke a skill (focused prompt + tool budget). Skills run in ~30% less wall-clock than ad-hoc prose discussion of the same topic.

| Phrase | Skill |
|---|---|
| "grill me", "stress-test" | `grill-me` |
| "review the diff", "code review" | `/code-review` |
| "security review", "audit" | `/security-review` |
| "verify it works" | `/verify` |
| "simplify" | `/simplify` |
| "deep research" | `/deep-research` |

Same table is in `CLAUDE.md`. This rule locks the behavior: when user uses a trigger phrase, prefer the skill invocation over discussing it.

## Headroom (Hr) — input compressor in the chain

Hr listens on `localhost:8787`. Compresses file reads + chat history before sending upstream. Chain: Claude Code → Hr `:8787` → hai `:6655` → Bedrock. Already running (verified healthy).

If Hr is down, Claude Code fails. That's intentional — single config, single chain.

## RTK — installed and active

RTK (Rust Token Killer) v0.42.4 compresses shell-tool output (`git diff`, `npm install`, `ls -R`) before agent reads it. `rtk gain` as of 2026-06-28: **48.5% savings on 329 commands, 370.9K tokens saved**.

Verify: `rtk --version` (should show ≥0.28.2), `rtk gain` (should show non-zero savings).

## Ponytail + Caveman — output-side compression

Both already inlined in `AGENTS.md`. Ponytail = "lazy senior dev" ladder (less code = less output = faster). Caveman = terse prose (drop articles/filler = less prose = faster).

## Anti-patterns

- ❌ Switching model mid-task to "save tokens" — the rebuild costs more than you save
- ❌ Toggling fast mode repeatedly — first toggle invalidates cache, subsequent don't
- ❌ Running `/compact` to "clean up" mid-task — rebuilds entire cache
- ❌ Adding MCP servers mid-session without `ENABLE_TOOL_SEARCH=auto`
- ❌ Letting `~/.claude/settings.json` regress (happened 2026-06-27 → restored)
- ❌ Routing direct to hai `:6655` instead of through Hr `:8787` — loses Hr's compression
