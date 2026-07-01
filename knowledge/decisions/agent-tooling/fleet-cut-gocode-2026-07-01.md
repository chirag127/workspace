---
type: decision
title: "Fleet cut 2026-07-01 — drop gocode, Codeep, Claurst, Coddy"
description: "Reduce coding-agent fleet from 10 → 6. Remove marginal agents (gocode, Codeep, Claurst, Coddy) after audit found no differentiating usage patterns."
tags: [fleet, agents, cut, gocode, codeep, claurst, coddy]
timestamp: 2026-07-01
format_version: okf-v0.1
status: active
supersedes:
  - decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29
related:
  - rules/agent/agent-fleet-parity
  - rules/agent/mcp-config-single-source-of-truth
  - decisions/agent-tooling/oss-audit-2026-07-01
---

# Fleet cut 2026-07-01

## Decision

Fleet drops from 10 → 6 supported coding agents. Removed:

| Agent | Repo | Reason |
|---|---|---|
| **gocode** | AlleyBo55/gocode (36⭐) | Small ecosystem, low active usage, redundant with Codex/qwen-code |
| **Codeep** | VladoIvankovic/Codeep | Single maintainer, small ecosystem, keytar+prebuild-install deprecation chain (see closed #6) |
| **Claurst** | Kuberwastaken/claurst (9.8K⭐) | ACP-first model diverges from MCP fleet parity; not worth the sync effort for one agent |
| **Coddy** | coddy-project/coddy-agent (66⭐) | Similar profile to gocode; recently added but never became daily-driver |

Fleet after cut:

| Agent | Type | Role |
|---|---|---|
| Claude Code | CLI (primary) | corp laptop, Bedrock-routed |
| ZCode | GUI IDE | secondary GUI |
| OpenCode | CLI | personal-laptop primary CLI |
| Kilo Code | VS Code ext | in-editor agent |
| Antigravity | Standalone IDE | secondary IDE |
| MiMoCode | CLI | Xiaomi ecosystem CLI |

## Why

Each agent added to the fleet costs:

1. **Sync tax** — MCP config, AGENTS.md pointer, skills junctions, PATH management
2. **Cognitive tax** — remembering which agent uses which config path
3. **Maintenance tax** — every `.mcp.json` change requires re-running `scripts/sync-mcp-configs.mjs`
4. **Failure-mode tax** — every added agent expands the surface where "why doesn't this work" investigations start

The 4 removed agents individually cost more than they saved. Audit at 2026-07-01 (see [`oss-audit-2026-07-01`](./oss-audit-2026-07-01.md)) found:

- **gocode**: MCP was undocumented in AGENTS.md but present in the tool; skills format required a bespoke `SKILL.md` variant. Two issues filed (#31 README, #32 SKILL.md interop) closed on removal.
- **Codeep**: 4 issues filed (#3 AGENTS.md discovery, #4 Windows hooks, #5 `.mcp.json` auto-discover, #6 keytar/prebuild-install deprecation chain). Closed on removal.
- **Claurst**: ACP protocol, docs unclear on MCP support. 2 issues filed (#201 MCP docs, #202 AGENTS.md), closed on removal.
- **Coddy**: 3 issues filed (#41 AGENTS.md, #42 Windows PATH docs, #43 YAML schema), closed on removal.

All 11 closed with a neutral "we're consolidating, not something wrong with the tool" note.

## Executed cleanup

- `npm uninstall -g codeep claurst` — done
- Deleted `~/bin/gocode.exe`, `~/bin/coddy.exe` — done
- Removed `.agents/{gocode,coddy,codeep,claurst}/` from workspace — done
- Filed 11 upstream issues STAY OPEN. Initial close on removal was reversed 2026-07-01 — the issues describe real gaps in each tool and are useful signal to maintainers regardless of our own usage decisions.
- Updated `AGENTS.md` fleet table + counts — done in this commit

## Why this supersedes fleet-cut-to-4-agents-2026-06-29

The 2026-06-29 decision cut Cline and locked at 4 agents (Claude Code, OpenCode, Kilo, Antigravity). Between then and 2026-07-01:

- MiMoCode was added (Xiaomi ecosystem, personal machine)
- ZCode was added (GUI IDE, dual-machine)
- gocode + Coddy were added (from binary releases)
- Codeep + Claurst were added (from npm)

The 2026-06-29 file's "fleet = 4" claim became stale within 48h. This decision replaces it and locks the new count at 6 explicitly — but with the caveat that any future fleet addition MUST come with a grill-me session per [`agent-fleet-parity`](../../rules/agent/agent-fleet-parity.md).

## What we still track upstream

The removals do NOT mean we stop caring about these projects. They just leave our default fleet. If a specific engagement needs one (e.g. Claurst's ACP for a particular integration), it can be spun up ad-hoc without adding to the standing fleet.

## Cross-refs

- [`oss-audit-2026-07-01`](./oss-audit-2026-07-01.md) — the audit that surfaced the case for cutting
- [`no-fork-divergence`](../../rules/agent/no-fork-divergence.md) — pairs with this: don't add complexity we can't upstream
- [`agent-fleet-parity`](../../rules/agent/agent-fleet-parity.md) — every fleet member needs identical sync
