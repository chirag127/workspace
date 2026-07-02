---
type: decision
title: 'Workspace canonical; globals derived by script (2026-06-29)'
description: Workspace files canonical. Global configs derived via sync-globals.mjs. Drift triggers grill-me
tags: [global, workspace, mcp, agent-tooling, grill-decision, sync-script]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/globals-derived-from-workspace
  - rules/agent/agent-fleet-parity
  - rules/agent/mcp-config-single-source-of-truth
  - decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29
---

# Workspace canonical; globals derived by script

## Decision

`chirag127/workspace` is canonical. Global agent files are **derived caches**, written by `scripts/sync-globals.mjs`. The script grill-mes on drift or new-item detection; runs silent when workspace and globals match.

## Grilled flow (2026-06-29)

Three iterations same turn:

1. **First pass** — locked "workspace-only" (move everything global ? workspace).
2. **Reality check** — OpenCode's schema differs from Claude Code's; my sync emitted `chirag127: {command:[null]}` and OpenCode rejected the config. User pasted the error.
3. **Reversal** — user reframed: workspace canonical, globals derived by auto-grill script. "Nothing will be workspace only because the repository should be clean and minimum root folders."

The reversal is captured here; the original workspace-only rule has been deleted per [`knowledge-deletion-not-supersession`](../../../rules/agent/knowledge-deletion-not-supersession.md). Git history is the audit trail (commit `66f05f7` added it; commit on this trio of changes removes it).

## What the script does

| Step | Behavior |
|---|---|
| Trigger | **Manual only.** User invokes `node scripts/sync-globals.mjs` when ready. No auto-trigger (session-start, cron, hook). |
| Read | Workspace anchors (`.mcp.json`, `.agents/claude/settings.template.json`, agent-skills junction) |
| Diff | Compare against globals (`~/.claude.json`, `~/.opencode/config.json`, `~/.kilocode/`, etc.) |
| Silent | If workspace and globals match ? exit 0, no output |
| Grill | If new item OR drift ? fire grill-me MCQ (migrate / keep both / delete from workspace) |
| Write | Apply user's grill answer back to globals + registry |

Note: per-agent propagation (`scripts/sync-mcp-configs.mjs`) is also a separate manual step — `sync-globals.mjs` no longer auto-invokes it.

## Per-agent schema transform

The script holds adapters per agent (today: Claude Code, OpenCode, Kilo Code, Antigravity). Each adapter knows the agent's JSON shape and transforms the canonical `.mcp.json` entries into the target shape. Adding a new agent = add an adapter.

## What got fixed at the same time (OpenCode break)

`sync-mcp-configs.mjs` line that converted `chirag127` remote MCP was broken — emitted `{type:remote, command:[null]}` instead of `{type:remote, url, enabled:true}`. Fixed in the same turn as this decision. Confirmed by `opencode mcp list` showing 7/8 servers connected (`chirag127` itself shows "needs authentication" — that's a Smithery OAuth issue, not a config-schema issue).

## Override learnings (candidate rules; cumulative across the turn)

1. **`<name>-mcp` suffix** over `mcp-<name>` prefix ? `mcp-repo-naming-suffix`
2. **Cline drop**, fleet = 4 agents ? `fleet-cut-to-4-agents-2026-06-29`
3. **Workspace-canonical, globals-derived** beats workspace-only ? this file
4. **Live web search > Haiku-pinned researcher** for landscape questions (researcher claimed Aider has MCP; live search refuted)
5. **Pre-flight smoke test of OpenCode/Kilo schemas before sync** — silent drift caught the user's terminal, not me. Adding `scripts/test-mcp-servers.mjs` this turn.
