---
type: rule
title: 'Globals derived from workspace by script (with grill on drift)'
description: '`.mcp.json` and other workspace anchors are canonical. Globals (`~/.claude.json` mcpServers, `~/.opencode/config.json` mcp, etc.) are written by `scripts/sync-globals.mjs`. Workspace stays clean — only essential root files. Script fires grill-me when it detects a new or drifted item; runs cleanly when workspace and globals already match.'
tags: [global, workspace, mcp, sync, derived, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
supersedes:
  - rules/agent/no-global-config-without-grilling
related:
  - rules/agent/mcp-config-single-source-of-truth
  - rules/agent/agent-fleet-parity
  - rules/agent/grill-me-default
---

# Globals derived from workspace

## Rule

`oriz-org/workspace` files are **canonical** for agent configuration. Global config files (`~/.claude.json`, `~/.opencode/config.json`, `~/.kilocode/`, `~/.gemini/`, etc.) are **derived caches** written by `scripts/sync-globals.mjs`.

You never edit a global file directly. The script reads workspace → writes global → diffs → fires grill-me if drift is detected.

## What "canonical" maps to

| Concern | Workspace source | Global target (derived) |
|---|---|---|
| MCP servers | `.mcp.json` | `~/.claude.json` mcpServers; `~/.opencode/config.json` mcp; etc. |
| Claude Code settings | `.agents/claude/settings.template.json` | `~/.claude/settings.json` (merge per host) |
| Agent rules | `AGENTS.md` + `knowledge/rules/` | `~/.claude/CLAUDE.md` (pointer) |
| Skills | `repos/own/infra/agent-skills/` | `~/.claude/skills/` (junction) |

## When the script runs

**Manual only.** User invokes explicitly: `node scripts/sync-globals.mjs`. No auto-trigger from session start, no cron, no hook. Per user instruction 2026-06-29: "don't sync automatically or anyway anything for now i will do it individually."

If/when auto-sync is wanted, grill-me first to decide trigger shape (session-start hook vs cron vs file-watcher).

## How grill-me fires

Script detects diff → prints diff → calls `grill-me` (via `claude` CLI invocation, or interactive PS prompt fallback) with the question:

> "Workspace has X but global doesn't (or vice versa). Migrate / keep both / delete from workspace?"

The answer is committed back to the script's allow/deny registry so the same diff doesn't re-prompt on the next session.

## Why this rule, not "workspace-only"

Tried workspace-only (rule deleted in this commit). Real failure modes:

1. **Per-agent schema drift** — OpenCode's `mcp` shape ≠ Claude Code's; sync script must transform per agent. Workspace-only meant manually maintaining N adapters.
2. **Per-machine variation** — auth tokens, absolute binary paths (`codebase-memory.exe`), model env vars vary per laptop. Forcing them into workspace = either commits secrets or commits a per-machine config file that doesn't work elsewhere.
3. **Repo cleanliness** — workspace root should hold minimum essential files. Stuffing every agent's global content into workspace would bloat the root.

Workspace-canonical + derived-globals keeps both: clean workspace root + reproducible globals via script.

## Anti-patterns

- ❌ Editing `~/.claude.json` or `~/.opencode/config.json` directly. Script will overwrite next run.
- ❌ Letting globals drift "just for this machine" without committing the variation to workspace as a per-machine profile.
- ❌ Running the script via cron — must run when CC session starts so changes you push from one machine reflect on this one.

## First-run / new-laptop bootstrap

```cmd
cd C:\D\oriz
node scripts/sync-globals.mjs --bootstrap
```

`--bootstrap` skips the grill-me on every new item (you just cloned; everything is new) and just writes globals from workspace. After bootstrap, the next session-start run uses normal grill-on-drift.

## Cross-refs

- [`mcp-config-single-source-of-truth`](./mcp-config-single-source-of-truth.md) — the MCP-side of this rule
- [`agent-fleet-parity`](./agent-fleet-parity.md) — what derived-globals enables (4-agent uniform config)
- [`mcp-workspace-not-global`](./mcp-workspace-not-global.md) — narrower MCP-scope rule (still applies; same direction)
