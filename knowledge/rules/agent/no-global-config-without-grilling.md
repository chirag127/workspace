---
type: rule
title: 'No global config without grilling'
description: Anything currently in `~/.claude/`, `~/.claude.json`, or any other global agent config gets migrated to the workspace after a grill-me session. Workspace-only is default. Exceptions are individually grilled and documented.
tags: [global, workspace, mcp, settings, grill-me, hard-rule]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/mcp-workspace-not-global
  - rules/agent/mcp-config-single-source-of-truth
  - rules/agent/agent-fleet-parity
  - rules/agent/grill-me-default
---

# No global config without grilling

## Rule

**Default:** every piece of agent configuration lives in this workspace, committed to `oriz-org/workspace`. Global config (`~/.claude/`, `~/.claude.json`, `~/.opencode/`, etc.) is an exception that needs an explicit grill-me session per item to keep.

## What "global" means

| File | Default verdict |
|---|---|
| `~/.claude/CLAUDE.md` | Migrate content to `.agents/claude/CLAUDE.md` |
| `~/.claude/settings.json` (model, effort, env vars) | **Keep global** — per-machine, not per-project. Documented exception. |
| `~/.claude/settings.local.json` (auth token) | **Keep local** — secrets must not commit. Documented exception. |
| `~/.claude.json` `mcpServers` (top-level) | Migrate to `.mcp.json`. No exceptions without grilling. |
| `~/.claude.json` `projects[<cwd>].mcpServers` | Same as above. |
| `~/.claude/skills/<skill>/` | Already workspace-owned via junction to `repos/own/infra/agent-skills`. ✓ |

## How to migrate

1. Inventory: list every global config item.
2. Per item, run grill-me: keep / migrate / delete.
3. Migrate-to-workspace = move content + `git add` + commit + delete from global.
4. Keep-global = write an exception note in the relevant rule with the why.
5. Delete = `git rm` from global (or just `delete` if not tracked).

## Why

- **Reproducibility**: clone the repo on a new machine, behavior matches.
- **Single source of truth**: agent fleet parity rule (`agent-fleet-parity`) requires workspace anchor.
- **Audit trail**: git history records every config change. Global config has none.
- **Disaster recovery**: machine wipe = `git clone` recovers everything.

## Exceptions (current, individually grilled)

| Item | Reason kept global |
|---|---|
| `~/.claude/settings.json` model/effort/env | Per-machine choice; varies by hardware + corp routing |
| `~/.claude/settings.local.json` auth token | Secrets must never commit |
| `~/.claude/skills/<skill>/` | Junctioned to `repos/own/infra/agent-skills` — workspace-owned via the junction |

Any new exception requires a grill-me session before it's added to this list.

## Cross-refs

- [`mcp-workspace-not-global`](./mcp-workspace-not-global.md) — concrete MCP-side rule
- [`agent-fleet-parity`](./agent-fleet-parity.md) — what the workspace anchor enables
- [`mcp-config-single-source-of-truth`](./mcp-config-single-source-of-truth.md) — sync flow
