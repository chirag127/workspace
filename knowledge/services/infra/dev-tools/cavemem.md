---
type: service
title: 'cavemem — cross-agent persistent memory daemon'
description: SQLite-backed memory daemon with FTS + local-embedding semantic search. Wired into Claude Code via SessionStart/UserPromptSubmit/PostToolUse/Stop/SessionEnd hooks.
tags: [memory, cavemem, claude-code, daemon, hooks, agent-tooling]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - runbooks/workflow/maintain/cavemem-hook-sh-not-found-fix
  - rules/agent/caveman
---

# cavemem

Local-only persistent memory daemon for agent sessions. NOT the same as `caveman` (terse-prose rule) despite the name confusion.

## What it is

- npm package: `cavemem` (installed globally; latest verified 0.2.1 / 2026-06-29)
- Install path on this machine: `C:\Users\C5420321\AppData\Roaming\npm\node_modules\cavemem`
- Data dir: `C:\Users\C5420321\.cavemem`
- Worker daemon: long-lived Node process, HTTP on `127.0.0.1:37777`, PID in `worker.pid`
- DB: SQLite at `~/.cavemem/data.db` with FTS5 + local embeddings (Xenova/all-MiniLM-L6-v2)
- Wired IDEs: claude-code (installed via `cavemem install --ide claude-code`)

## What it stores

Every tool call observation: tool name + input + truncated output + session ID + timestamp. State at 2026-06-29: 3816 observations, 15 sessions, 24h worker uptime.

## How Claude Code uses it

`~/.claude/settings.json` `hooks` block registers cavemem on five lifecycle events:

| Event | What cavemem does |
|---|---|
| `SessionStart` | Loads recent session memories into prompt context |
| `UserPromptSubmit` | Snapshots the prompt for future recall |
| `PostToolUse` | Records the tool call observation |
| `Stop` | Flushes pending observations to db |
| `SessionEnd` | Marks session closed |

Plus an MCP server (`cavemem mcp`) the agent can call for explicit `memory_save` / `memory_search` / `memory_update` / `memory_delete` / `memory_list`. That's where the memory tools listed in the Claude Code system prompt come from.

## Why this exists (and why we kept it after the speed-stack rule "skipped" Caveman)

Speed-stack rule's "Caveman skipped — no install path" referred to the **prose-compression** Caveman from JuliusBrussee, which we did adopt as a written rule (`rules/agent/caveman.md`) without a CLI. `cavemem` is a different thing entirely — a memory daemon, no prose work. It IS installed and active, has been since pre-2026-06-29 sometime, and survives `/clear` / session restart unlike Claude's built-in memory.

## Required peer dep

`@xenova/transformers` (~80 packages, ~100MB). Without it, FTS search still works but semantic search is dead with `Cannot find package '@xenova/transformers'`. Install:
```
npm install -g @xenova/transformers
```

## Daily commands

```bash
cavemem status                       # show wiring, db size, worker state
cavemem doctor                       # health checks
cavemem search "query"               # CLI search (FTS + semantic)
cavemem search "query" --limit 5
cavemem viewer                       # browser UI at http://127.0.0.1:37777
cavemem worker start/stop/restart    # manage the daemon
cavemem export memories.jsonl        # backup
cavemem reindex                      # rebuild FTS if corrupted
```

## Known pitfalls

- **`sh` not found in PATH** breaks every hook silently. See [runbooks/workflow/maintain/cavemem-hook-sh-not-found-fix](../../../runbooks/workflow/maintain/cavemem-hook-sh-not-found-fix.md).
- **Embedding model first-load** = ~2 seconds. Cached after first call per process.
- **No card-on-file impact** — fully local, no network calls outside `127.0.0.1`.
- **Not in fleet parity matrix yet** — only wired into Claude Code, not OpenCode/Kilo/Antigravity. Per `agent-fleet-parity` rule, either wire it everywhere or remove. Decision deferred — cavemem's `install --ide` only supports claude-code as of 0.2.1.

## Cross-refs

- [`runbooks/workflow/maintain/cavemem-hook-sh-not-found-fix`](../../../runbooks/workflow/maintain/cavemem-hook-sh-not-found-fix.md) — the gotcha that triggered this file
- [`rules/agent/caveman`](../../../rules/agent/caveman.md) — different thing, terse-prose rule, no relation despite the name
