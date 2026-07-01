---
type: decision
title: "freellmapi: run from source, auto-pull on boot, free-tier aggregator"
description: "Run `tashfeenahmed/freellmapi` (14K-star OpenAI-compat proxy stacking 16 free LLM provider tiers) from the local fork's dev server. Auto-start on Windows login on ports :3001 (server) + :5173 (Vite client)."
tags: [freellmapi, dev-server, ai-gateway, free-tier, auto-start, windows]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30
  - rules/development/fork-discipline
  - rules/development/windows-shortcut-absolute-binary-paths
  - runbooks/operations/start-dev-server-from-source
---

# freellmapi: dev server from source, auto-pull on boot

## What freellmapi is

`tashfeenahmed/freellmapi` is a 14,201-star OpenAI-compatible proxy that **stacks the free tiers of 16 LLM providers** behind one `/v1` endpoint, totaling **~1.7B free tokens/month**. Pure forward (not reverse-engineered), encrypted keys, smart routing with auto-failover.

Repo description: "OpenAI-compatible proxy that stacks the free tiers of 16 LLM providers (~1.7B tokens/month) behind one /v1 endpoint — plus any custom OpenAI-compatible endpoint. Smart routing, automatic failover, encrypted keys. Personal experimentation only."

Conceptually parallel to OmniRoute but with a tighter focus on the stacked-free-tier use case.

## Decision

Same pattern as [`omniroute-dev-server-from-source-2026-06-30`](./omniroute-dev-server-from-source-2026-06-30.md):

1. Fork `tashfeenahmed/freellmapi` to `chirag127/freellmapi` (canonical fork — duplicate `freellmapi-1` deleted)
2. Clone to `C:\D\oriz\repos\frk\freellmapi` with upstream tracked
3. Startup script `C:\D\oriz\scripts\start-freellmapi-dev.ps1`:
   - Fast-forward merges `upstream/main`
   - `npm install` only when `package-lock.json` or `package.json` changed
   - Launches `npm run dev` in a Windows Terminal tab titled "freellmapi Dev"
   - Idempotent: skips if `:3001` already in use
4. Auto-runs on Windows login via `shell:startup` shortcut
5. Manual trigger via desktop shortcut `freellmapi Dev.lnk`

## Ports

- **Server**: `http://localhost:3001` (Hono backend per repo's `.env.example` default)
- **Client**: `http://localhost:5173` (Vite default; ships as part of `npm run dev` via `concurrently`)

The server is the OpenAI-compat endpoint (point AI tools at `http://localhost:3001/v1`). The client is the web dashboard.

No collision with OmniRoute (`:20128`) — both can run side by side.

## Why this complements OmniRoute (not replaces it)

| Capability | OmniRoute | freellmapi |
|------------|-----------|------------|
| Free providers stacked | 50+ | 16 (curated) |
| Monthly free budget | varies | ~1.7B tokens aggregated |
| Routing strategies | 17 | smart routing + failover |
| OpenAI-compat endpoint | yes | yes |
| Open source | partially | yes (14K stars) |
| Dashboard | full multi-panel | minimal |
| Compression | 9-engine pipeline | none |
| Compatible with MCP/A2A | yes | no |

Strategic role:
- **OmniRoute** = primary daily-driver gateway with rich routing + compression + MCP
- **freellmapi** = fallback when OmniRoute providers exhaust quota OR when a specific user wants a smaller, simpler gateway

Both pointing at the same downstream free tiers means cross-redundancy: if OmniRoute throttles, freellmapi may still have capacity on the same upstream provider via its independent routing.

## Why not BYOK-only or paid

freellmapi explicitly stacks **free tiers** — passes the [`free-tier-with-cost-controls`](../../rules/infrastructure/free-tier-with-cost-controls.md) bar. No card-on-file required.

## Caveats

- freellmapi's own README says "Personal experimentation only" — apply normal don't-overload-free-tiers hygiene
- Some of the 16 upstream providers freellmapi targets will rate-limit or shut down their free tiers over time; pair with periodic upstream review
- License is permissive but the README cautions against commercial use; respect the upstream stance

## Path note

Same as OmniRoute: the launcher uses **absolute path to `npm.cmd`** (`C:\Program Files\nodejs\npm.cmd`) because `wt`-spawned shells don't reliably inherit the User PATH. See [`rules/development/windows-shortcut-absolute-binary-paths`](../../rules/development/windows-shortcut-absolute-binary-paths.md).

## See also

- [`omniroute-dev-server-from-source-2026-06-30`](./omniroute-dev-server-from-source-2026-06-30.md) — sibling decision; this one mirrors that pattern
- [`runbooks/operations/start-dev-server-from-source`](../../runbooks/operations/start-dev-server-from-source.md) — the migration runbook covers both
- OmniRoute issue [#5687](https://github.com/diegosouzapw/OmniRoute/issues/5687) — filed asking OmniRoute to route through freellmapi as a no-key fallback tier
