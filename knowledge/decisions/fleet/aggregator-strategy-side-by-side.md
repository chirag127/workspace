---
type: decision
title: 'Free-LLM-aggregator strategy: run freellmapi + OmniRoute side-by-side, localhost only'
description: Both kept as fork submodules. Side-by-side eval. No hosting, local SQLite
tags: [aggregator, freellmapi, omniroute, fleet, decision]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/omniroute-eval-install
  - rules/development/fork-discipline
---

# Free-LLM-aggregator: side-by-side, localhost only

## What we run

Two free-LLM-aggregator forks live in the workspace:

| Fork | Submodule path | Stars | Free providers | Hosting |
|---|---|---|---|---|
| freellmapi | `repos/frk/freellmapi` | 13,341 | 16 (1.7B tokens/mo) | localhost:3001 |
| OmniRoute | `repos/frk/omniroute` | 7,013 | 50+ (1.6B-2.1B tokens/mo) | localhost:20128 |

Both:
- Originals upstream (`tashfeenahmed/freellmapi`, `diegosouzapw/OmniRoute`).
- Forks under our oriz-org account (`oriz-org/freellmapi`, `oriz-org/omniroute`).
- MIT-licensed.
- TypeScript, Node 20+.
- Pull-upstream-regularly. File feature-gap issues upstream (filed: omniroute#5161).

## What we do NOT do

- **Do NOT build a new aggregator from scratch.** Reaching freellmapi parity is ~6 months solo. Reaching OmniRoute parity is ~12 months. Filed: omniroute#5161 covers the gaps both ways.
- **Do NOT host publicly yet.** Localhost-only until we know which one is the daily-driver.
- **Do NOT migrate storage to a hosted DB.** Both apps use local SQLite; switching to async DB drivers (Turso/Neon/Supabase) needs 43+ file rewrites + permanent merge-conflict with upstream.
- **Do NOT replace the Hr->hai->Bedrock chain** with either of these for the AI agent. That chain is SAP-mandated and verified working.

## Why both, not one

| freellmapi strength | OmniRoute strength |
|---|---|
| Embeddings, image gen, TTS | 231 providers vs 16 |
| Sticky sessions for chat | RTK+Caveman built-in compression |
| Simpler UI | 17 routing strategies |
| Easier to patch | Circuit breakers, MCP, A2A |

Run both. Decide after a week of real use.

## How to start each one

**freellmapi (localhost:3001):**
```bash
cd c:/D/oriz/repos/frk/freellmapi
npm run dev
```

**OmniRoute (localhost:20128):**
```bash
omniroute  # already on PATH from npm install -g omniroute
# OR from the fork:
cd c:/D/oriz/repos/frk/omniroute
npm start
```

## Upstream sync cadence

Per fork-discipline rule:
- `git fetch upstream && git merge upstream/main -X theirs` weekly.
- All our edits live in `deploy/`, `.github/workflows/oriz-*`, `docs/oriz/`, `scripts/oriz-*` — not inside upstream-owned files.

## Cross-refs

- `agent-rules/omniroute-eval-install` - OmniRoute is eval-only, not in the agent routing chain
- `rules/development/fork-discipline` - how to keep upstream merges clean
- Filed upstream: https://github.com/diegosouzapw/OmniRoute/issues/5161
