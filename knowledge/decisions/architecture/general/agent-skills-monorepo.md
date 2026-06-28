---
type: decision
title: 'Skills in .agents/skills/ workspace-scoped + junctions for all 5 agents'
description: Single canonical skills directory at .agents/skills/ in the oriz workspace. All 5 supported agents read it via NTFS junctions. Easy to migrate to another project (just copy the .agents/skills/ dir). Replaces the previous oriz-org/agent-skills submodule which was archived 2026-06-28.
tags: [architecture, skills, agents, junctions, workspace-scoped]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/playwright-over-chrome-devtools-mcp
---

# Skills in .agents/skills/ workspace-scoped

## What

All agent skills (21 as of 2026-06-28) live in **one canonical directory** at:

```
c:/D/oriz/.agents/skills/<skill-name>/SKILL.md
```

This dir is workspace-scoped, committed to the oriz umbrella repo, version-controlled with the rest of the workspace. Migrating to another project = copy `.agents/skills/` into the new project's root.

## Why this architecture (over previous submodule pattern)

Previously: `oriz-org/agent-skills` git submodule at `repos/own/agent-skills/`. Archived 2026-06-28 (`gh repo archive`). Reasons for the move:

1. **Submodule overhead** — every fresh clone required `--recurse-submodules` + bootstrap to set up symlinks. New project = friction.
2. **Submodule pointer drift** — `git submodule status` showed stale SHA if skills were edited but pointer not bumped. Forgettable.
3. **Skill discoverability** — skills inside `repos/own/agent-skills/` were buried 3 levels deep. Workspace-root `.agents/skills/` is discoverable.

Workspace-scoped trades submodule reusability for migration ergonomics. The 21 skills can still be extracted as a standalone repo later if needed.

## Per-agent paths — table of truth

Five agents are supported. Each reads skills from its own canonical path. All 4 per-agent paths are NTFS junctions pointing at `c:/D/oriz/.agents/skills/`.

| Agent | Project (workspace) path | Global (per-user) path | Junction status |
|---|---|---|---|
| **Canonical** | `c:/D/oriz/.agents/skills/` | n/a | real dir |
| **Claude Code** | `.claude/skills/` | `~/.claude/skills/` | both junctions → canonical |
| **Cline** | reads Claude's `.claude/skills/` | reads `~/.claude/skills/` | covered by Claude junctions |
| **Kilo Code** | `.kilocode/skills/` | `~/.kilocode/skills/` (not symlinked yet) | project junction → canonical |
| **OpenCode** | falls back to `.agents/skills/` natively | reads `~/.agents/skills/` | global junction → canonical |
| **Antigravity / Codex / 30+ Open Standard agents** | reads `.agents/skills/` natively | reads `~/.agents/skills/` | covered |

## How junctions are created on Windows

NTFS **junctions** (not symbolic links) are used because:
- Junctions work for any user without admin elevation
- Symbolic links require Developer Mode OR admin
- For directory targets, the behavior is identical

Create via:
```bash
python -c "import subprocess; subprocess.run(['cmd', '/c', 'mklink', '/J', r'C:\Users\C5420321\.claude\skills', r'C:\D\oriz\.agents\skills'])"
```

Or PowerShell elevated:
```powershell
New-Item -ItemType SymbolicLink -Path 'C:\Users\C5420321\.claude\skills' -Target 'C:\D\oriz\.agents\skills'
```

## Migration to a new project

1. Copy `.agents/skills/` into the new project's root (or symlink it).
2. Create junctions from `.claude/skills/` and `.kilocode/skills/` to the new location.
3. Optionally repoint `~/.claude/skills/` and `~/.agents/skills/` if you want the same skills used in OTHER projects too.

No git submodule init required. No bootstrap script. Just copy + 4 junction commands.

## Layout (21 skills as of 2026-06-28)

```
.agents/skills/
├── cloudflare/                       # Cloudflare platform reference
├── cloudflare-email-service/         # CF Email Sending + Routing
├── develop-userscripts/              # Tampermonkey/ScriptCat
├── frontend-design/                  # UI/UX component patterns
├── github-actions-docs/              # GH Actions reference
├── grill-me/                          # Decision-tree MCQ pattern
├── karpathy-guidelines/              # LLM coding guidelines
├── obsidian-bases/                   # Obsidian Bases (.base)
├── obsidian-cli/                     # Obsidian CLI ops
├── obsidian-defuddle/                # Markdown extraction
├── obsidian-json-canvas/             # .canvas files
├── obsidian-markdown/                # Obsidian Flavored Markdown
├── playwright-cli/                   # Browser automation
├── playwright-persistent-sessions/   # Persistent browser sessions
├── secure-linux-web-hosting/         # Linux server hardening
├── smithery-ai-cli/                  # Smithery toolbox CLI
├── use-my-browser/                   # Live browser session driver
├── web-design-reviewer/              # UX/A11Y review
├── webapp-testing/                   # Playwright app testing
├── workers-best-practices/           # CF Workers patterns
└── wrangler/                         # CF Wrangler CLI
```

## Invariants

- **`.agents/skills/` is the only canonical copy.** Edit skills here, commit to oriz.
- **All per-agent dirs are junctions.** If `~/.claude/skills/` becomes a real dir (someone copied content into it), the invariant breaks — `link.sh` is idempotent but won't clobber real dirs.
- **Skills added through the canonical path appear in all 5 agents automatically.** No copy step.
- **Removed: `oriz-org/agent-skills` submodule.** Repo archived on GitHub 2026-06-28. Don't re-add as a submodule.

## What was archived

The old submodule [`oriz-org/agent-skills`](https://github.com/oriz-org/agent-skills) was archived on GitHub via `gh repo archive`. Read-only from 2026-06-28 onwards. Reversible via `gh repo unarchive`. The 21 skills' git history is preserved in that archived repo if anyone needs blame data; otherwise the live source is here in oriz.

## Related

- [[playwright-over-chrome-devtools-mcp]] — playwright-cli + playwright-persistent-sessions are workspace-scoped skills, not MCPs
- [[grill-me-default]] — the grill-me discipline is one of the skills here
