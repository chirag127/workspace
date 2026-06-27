---
type: rule
title: 'Claude Code latency: keep cache hot, route through Hr, no mid-session switches'
description: Per Anthropic's prompt-caching docs and April 2026 incident postmortem. Pick model + effort at session start, don't change mid-task. Route through Headroom. Use skill triggers (slash commands) over prose discussion.
tags: [latency, speed, claude-code, prompt-caching, headroom, hard-rule]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/ponytail
  - rules/agent/caveman
---

# Claude Code latency optimization

Goal: minimize turn-time (NOT cost). Per [Anthropic prompt-caching docs](https://code.claude.com/docs/en/prompt-caching) and the [April 2026 postmortem](https://www.aakashx.com/blog/claude-code-slow-causes-fixes/).

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

## Settings.json for speed

`~/.claude/settings.json` (already restored 2026-06-27):

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:8787",
    "ANTHROPIC_MODEL": "claude-opus-latest",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-latest",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-latest",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-latest",
    "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "DISABLE_ERROR_REPORTING": "1",
    "DISABLE_TELEMETRY": "1",
    "ENABLE_TOOL_SEARCH": "auto"
  },
  "alwaysThinkingEnabled": false,
  "effortLevel": "high",
  "model": "claude-opus-latest"
}
```

Why each line matters for latency:
- `ANTHROPIC_BASE_URL=http://localhost:8787` — routes through Headroom which compresses chat/file context before model sees it. Less input = faster TTFT.
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` — skips background analytics HTTP calls during a session.
- `DISABLE_TELEMETRY=1`, `DISABLE_ERROR_REPORTING=1` — same; cuts background HTTP fan-out.
- `ENABLE_TOOL_SEARCH=auto` — defers MCP tool definitions out of the cache prefix. Connecting/disconnecting MCP servers no longer invalidates cache.
- `effortLevel=high`, `model=claude-opus-latest` — pinned. No mid-session switches = no cache rebuilds.
- `alwaysThinkingEnabled=false` — saves "thinking" tokens on simple turns; high effort kicks in only when needed.

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

## RTK — installed elsewhere (NOT on this machine)

RTK (Rust Token Killer) compresses shell-tool output (`git diff`, `npm install`, `ls -R`) before Claude reads it. On this corporate machine, cargo build hits **Defender ASR** ("Access is denied. (os error 5)" on build scripts in `%TEMP%`). Same trap as `agent-browser`.

Install path: build on a non-ASR machine, copy `rtk.exe` to `~/.cargo/bin/`. Until then, accept the ~10-30% extra tokens on noisy shell commands.

## Ponytail + Caveman — output-side compression

Both already inlined in `AGENTS.md`. Ponytail = "lazy senior dev" ladder (less code = less output = faster). Caveman = terse prose (drop articles/filler = less prose = faster).

## Anti-patterns

- ❌ Switching model mid-task to "save tokens" — the rebuild costs more than you save
- ❌ Toggling fast mode repeatedly — first toggle invalidates cache, subsequent don't
- ❌ Running `/compact` to "clean up" mid-task — rebuilds entire cache
- ❌ Adding MCP servers mid-session without `ENABLE_TOOL_SEARCH=auto`
- ❌ Letting `~/.claude/settings.json` regress (happened 2026-06-27 → restored)
- ❌ Routing direct to hai `:6655` instead of through Hr `:8787` — loses Hr's compression
