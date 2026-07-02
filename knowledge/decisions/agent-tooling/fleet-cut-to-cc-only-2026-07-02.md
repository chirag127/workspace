---
type: decision
title: "Fleet cut to Claude Code only (2026-07-02)"
description: "Drop ZCode, OpenCode, Kilo Code, Antigravity, MiMoCode from installed fleet. Claude Code + Bedrock chain is the sole agent."
tags: [fleet, agents, cc, drops]
timestamp: 2026-07-02
format_version: okf-v0.2
status: active
supersedes:
  - decisions/agent-tooling/fleet-cut-gocode-2026-07-01
  - decisions/agent-tooling/fleet-cut-to-4-agents-2026-06-29
---

# Fleet cut to Claude Code only

Fleet = 1. Claude Code + Bedrock chain. Everything else dropped.

## What dropped

| Agent | Drop reason |
|---|---|
| **ZCode** | GUI IDE. Manual install, GUI-only MCP config (no `.mcp.json` sync). Second surface to maintain, no CLI parity. Corp laptop already has Claude Code; personal doesn't need a heavyweight IDE. |
| **OpenCode** | Personal-only CLI. Format-transformed MCP config (`.opencode/opencode.jsonc`) = sync-script complexity. Failover-only role; never used as primary this quarter. Cost of transform > value of failover. |
| **Kilo Code** | VS Code extension. Extension surface changes per VS Code release; MCP schema drifts. Dual-machine but never picked over Claude Code on corp. |
| **Antigravity** | Standalone Google IDE. Personal-only, manual install, no headless mode. Standalone binary + separate MCP config = third surface for zero unique capability. |
| **MiMoCode (mimo)** | Xiaomi CLI. PATH caveat on Windows (Git Bash only), install script writes to `~/.bashrc`, invisible in PowerShell. Small ecosystem, unproven daily-driver. Sync/PATH tax > differentiating value (same pattern as gocode/Codeep/Claurst/Coddy drop on 2026-07-01). |

## What kept

**Claude Code + Bedrock chain.** Corp-paid Bedrock via Hr proxy (`localhost:8787` → hai `:6655` → Bedrock). Single agent, single chain, single config. Reads `.mcp.json` natively — no sync script needed.

Personal laptop consequence: no Claude Code available (no free tier + `no-card-on-file` rule blocks personal install). Personal machine is agent-less until a free-tier CLI passes the parity bar.

## AGENTS.md stays canonical family-wide

`AGENTS.md` remains the workspace source of truth. Other CLIs, human readers, and future agents still read it. Only the **fleet installation** drops — the rules, decisions, and knowledge tree are agent-agnostic.

- Per-agent stubs (`.agents/opencode/`, `.agents/kilocode/`, `.agents/antigravity/`, `.agents/mimo/`, `.agents/zcode/`) stay on disk. Zero maintenance. Reintroduction path preserved.
- `scripts/sync-mcp-configs.mjs` stays but stops running. No cron, no session hook. Dead code flagged for review at 90-day mark.

## Submodule-level configs (90-day cooldown)

Files stay but stop being synced:

- `.opencode/opencode.jsonc`
- `.kilocode/mcp.json`
- `.antigravity/mcp.json`
- `.mimo/mimocode.json` (also `.mimocode/mimocode.json` where present)

Flag for deletion after 2026-10-02 (90 days). Rationale for cooldown: preserves diff history in case a dropped agent gets reintroduced with valid rebuttal.

If reintroduction happens before cooldown expires: config already exists, sync resumes, minimal churn.

If cooldown expires with no reintroduction: `git rm` the files per `knowledge-deletion-not-supersession`. Do NOT flag with `status: deprecated` — hard-delete.

## Reintroduction bar

Reintroducing any dropped agent requires:

1. **Cite this decision** by path in the reintroduction PR body.
2. **Rebut the specific drop reason** in the table above. Generic "it's popular now" or "I want to try it" does not clear the bar.
3. **Grill-me session** per `no-global-config-without-grilling` — same rigor as any new agent.
4. **Update fleet parity rule** in the same commit (three-place update per `agents-md-three-place-update`).

## Impact on rules

Three rules need edits in the same session as this decision commits:

- **`rules/agent/agent-fleet-parity.md`** — fleet table collapses to one row (Claude Code). Failover line deleted. Sync-flow diagram deleted. Rule shrinks or dissolves (parity across N=1 is vacuous — likely delete).
- **`rules/agent/mcp-config-single-source-of-truth.md`** — sync targets enumeration deleted. Rule shrinks to "`.mcp.json` is what Claude Code reads." Sync-script mandate deleted.
- **`rules/agent/globals-derived-from-workspace.md`** — derived-target table drops OpenCode/Kilo/Antigravity/mimo/ZCode rows. Anti-pattern examples trimmed. Cross-ref to fleet-parity updated. Core rule (workspace canonical) still holds for CC.

## Impact on AGENTS.md

Sections to edit:

- **"Coding agents wired to this workspace"** — collapse fleet table to one row. Delete pending-prerequisites block (Crab Code, free-code). Delete mimo PATH caveat. Delete failover line. Delete skill-junction line for non-CC dirs.
- **Repo layout ASCII (~line 170)** — trim `.claude/.opencode/.kilocode/.gemini/skills` comment to `.claude/skills` only.
- **Rules table entry for `mcp-config-single-source-of-truth`** — trim "sync to all 5 CLI/extension agents" language.
- **Skills section** — trim junction paths to `~/.claude/skills/` only.
- **Tooling section** — `sync-mcp-configs.mjs` line deleted or marked dormant.

## Anti-patterns

- ❌ Reinstalling a dropped agent silently on personal laptop "just to try" — violates grill bar.
- ❌ Keeping `sync-mcp-configs.mjs` running via cron "in case someone reintroduces an agent" — dead automation rots.
- ❌ Editing `.kilocode/mcp.json` or `.opencode/opencode.jsonc` manually before 90-day cooldown expires — the file is frozen, not live.
- ❌ Marking dropped agents as `status: deprecated` in a new file — hard-delete pattern applies; this decision + `git log` is the audit trail.

## Cross-refs

- Supersedes: [`fleet-cut-gocode-2026-07-01`](./fleet-cut-gocode-2026-07-01.md), [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md)
- [`agent-fleet-parity`](../../rules/agent/agent-fleet-parity.md) — heaviest edit target
- [`mcp-config-single-source-of-truth`](../../rules/agent/mcp-config-single-source-of-truth.md) — sync script rule dissolves
- [`globals-derived-from-workspace`](../../rules/agent/globals-derived-from-workspace.md) — derived-target table trims
- [`no-card-on-file`](../../rules/interaction/no-card-on-file.md) — why personal laptop stays agent-less
- [`knowledge-deletion-not-supersession`](../../rules/agent/knowledge-deletion-not-supersession.md) — cooldown deletion policy
- [`agents-md-three-place-update`](../../rules/agent/agents-md-three-place-update.md) — rule-edit discipline for reintroduction