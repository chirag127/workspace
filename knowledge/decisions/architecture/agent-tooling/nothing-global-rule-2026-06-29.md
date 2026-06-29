---
type: decision
title: 'Workspace-only is default; global config is exception'
description: Grilled 2026-06-29. Everything in `~/.claude/` and similar global agent dirs is moved to `oriz-org/workspace` and committed, with narrow grilled exceptions. Migration starts with the `chirag127` toolbox MCP moving from `~/.claude.json` to `.mcp.json`.
tags: [global, workspace, mcp, agent-tooling, grill-decision]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/no-global-config-without-grilling
  - rules/agent/agent-fleet-parity
  - decisions/architecture/agent-tooling/fleet-cut-to-4-agents-2026-06-29
---

# Workspace-only is default; global config is exception

## Decision

Default scope for every piece of agent configuration is the **`oriz-org/workspace` git repository**. Each existing global config item must pass a grill-me session to stay global; otherwise it migrates to the workspace.

## Grilled scope (2026-06-29)

> "Nothing global, anything global migrated after grilling" — scope option **Workspace-only** picked.

Scope = MCP servers + agent rules. Specifically excluded from migration:

- `~/.claude/settings.json` model/effort/env (per-machine; varies by corp routing)
- `~/.claude/settings.local.json` auth token (must never commit)
- `~/.claude/skills/<skill>/` (already workspace-owned via junction)

## First migration

`chirag127` toolbox MCP (HTTP, `https://mcp.smithery.run/chirag127`) moves from `~/.claude.json` top-level `mcpServers` into the workspace `.mcp.json`. After migration, the global entry is deleted.

## Future migrations

New global config items are added only after grill-me. Each becomes a row in the exceptions table in [`no-global-config-without-grilling`](../../rules/agent/no-global-config-without-grilling.md).

## Rationale

1. **Single source of truth** — `oriz-org/workspace` is already the workspace authority for code + knowledge; extending to agent config is natural.
2. **Failover** — when one machine dies, `git clone` brings agents back identical. Global config doesn't recover.
3. **Audit** — git history records every config change; global has none.
4. **Fleet parity** — needed so [`agent-fleet-parity`](../../rules/agent/agent-fleet-parity.md) can apply uniformly across CC, OpenCode, Kilo Code, Antigravity.

## Override learnings (candidate rules)

User-overrode options during grilling, captured for future rule-formalization:

1. **`<name>-mcp` suffix** over `mcp-<name>` prefix — matches existing `-bs-ext`, `-vsc-ext`, `-api`, `-app`, `-book` category-suffix convention. → [`mcp-repo-naming-suffix`](../../rules/development/mcp-repo-naming-suffix.md)
2. **Cline dropped from fleet** — primary failover via OpenCode + Kilo Code + Antigravity covers both CLI and VS Code surfaces; Cline is redundant with Kilo Code. → [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md)
3. **Live web search required** for any "best free coding agent" survey — Haiku-pinned researcher returned stale data; live search via MCP web tools corrected the failover order.
