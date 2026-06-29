---
type: rule
title: "Workspace Root Cleanliness"
description: "Workspace root is canonical-config-only. No generated, derived, or junction content lives here — only committed-first source files."
tags: [workspace, config, junctions, clean-root, infrastructure]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - knowledge/rules/agent/globals-derived-from-workspace.md
  - knowledge/rules/infrastructure/workspace-root-cleanliness.md
---

# Workspace Root Cleanliness

## Rule

The workspace root (`C:\D\oriz\`) is **canonical-config-only**. Every file or directory at root must be a committed-first source — never a junction, symlink, derived copy, or generated artefact whose canonical copy lives somewhere else.

## What belongs at root

- `AGENTS.md`, `CLAUDE.md`, `ZCODE.md`, `ANTIGRAVITY.md`, `*.md` pointer files — **yes** (canonical source)
- `.mcp.json`, `Makefile`, `package.json` — **yes** (canonical source)
- `.agents/`, `.claude/`, `.opencode/`, `.kilocode/`, `.antigravity/`, `.mimocode/`, `.zcode/` — **yes** (canonical agent configs — agents, commands, MCP configs, rules)
- `knowledge/`, `scripts/`, `templates/`, `repos/` — **yes** (canonical source trees)

## What does NOT belong at root

- Skills junctions (e.g., `.claude/skills/`, `.opencode/skills/`) — **NO.** Use user-global dirs instead.
- Staging directories (e.g., `.staging/`) — **NO.** Temp work in `C:\Users\<user>\AppData\Local\Temp\`.
- Per-agent showcase mirror clones — **NO.** Showcase repos were deleted 2026-06-29; configs live in this repo only.
- Any `node_modules/` at root — **NO.** Each sub-package manages its own.

## Where junctions go instead

All agent skill junctions live in user-global directories, created by `node scripts/wire-agent-skills-junctions.mjs`:

| Agent | User-global skills path |
|---|---|
| Claude Code | `~/.claude/skills/` |
| OpenCode | `~/.config/opencode/skills/` |
| Kilo Code | `~/.kilocode/skills/` |
| ZCode | `~/.zcode/skills/` |
| MiMoCode | `~/.config/mimocode/skills/` |
| Antigravity | `~/.gemini/skills/` |

All point to the canonical source: `C:\D\oriz\repos\own\infra\agent-skills\`.

## Enforcement

When adding any new file or directory to the workspace root, ask: "Is this the canonical source of this content, or does it live somewhere else?" If the content has a canonical home elsewhere, put it there — not here.
