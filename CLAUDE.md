# CLAUDE.md — Claude-Code-specific workspace rules

> **Read [`AGENTS.md`](./AGENTS.md) and [`README.md`](./README.md) first — they are the source of truth across all 5 agents.**
>
> This file holds **Claude-Code-only** rules. Other agents (OpenCode, Cline, Kilo Code, Antigravity) read `AGENTS.md` + their own per-agent stub at `.agents/<name>/`.

---

## How Claude Code is wired in this workspace

### Proxy chain: Hr → hai → Bedrock

- **Headroom (Hr)** listens on `localhost:8787`, permanently. No port migration, no env-override. Every client (Claude Code, userscripts, helper agents) hard-codes `8787`.
- Headroom is used **only as an input-compression proxy**. No memory/Qdrant/TOIN/learn features. Docker-only deployment.
- Claude Code uses **one** `~/.claude/settings.json` that always routes through Headroom on `:8787`. **No second config, no direct-to-Anthropic fallback, no profile-switching.**
- The chain: Claude Code → `localhost:8787` (Hr) → `localhost:6655` (hai, SAP corp routing) → Bedrock (Claude models).

If Headroom is down, Claude Code fails. That's intentional — single config, single chain, single source of truth.

### MCP servers

Workspace MCPs live in `c:/D/oriz/.mcp.json` (committed). User-credential MCPs live in `~/.claude.json` global. Add new MCPs via:

```bash
claude mcp add <name> -s project -- <command> <args...>
```

The `-s project` flag writes to `.mcp.json`. Default scope is `local` which writes to `~/.claude.json` projects — **don't do that for workspace MCPs**.

### Serena (codebase semantic search)

Serena MCP (`oraios/serena`, 25.8k⭐, LSP-based, no API key) is wired in `.mcp.json` with `--project .` so it works on any clone path. Activates on Claude Code restart, indexes `c:/D/oriz` on first prompt.

### OmniRoute (eval-only)

OmniRoute v3.8.37 is installed at `%APPDATA%\npm\omniroute.cmd`. **Eval-only.** Default Claude Code routing chain (Hr → hai → Bedrock) MUST stay intact. Don't set OmniRoute as `ANTHROPIC_BASE_URL`. Use it on its own port (`20128`) for comparison testing only.

---

## Claude Code skill triggers

Reflexes that fire automatically based on user phrasing:

| Phrase | Skill | What it does |
|---|---|---|
| "grill me", "stress-test", "interview me" | `grill-me` | Walks decision tree branch-by-branch via MCQ |
| "review the diff", "code review" | `/code-review` | Reviews current diff for bugs |
| "security review", "audit" | `/security-review` | OWASP-style audit of working tree |
| "verify it works", "run the app" | `/verify` | Runs the app and observes behavior |
| "simplify", "reduce" | `/simplify` | Cuts duplication/complexity |
| "deep research" | `/deep-research` | Multi-source fact-checked report |

Plus Claude Code's standard CLI: `/model`, `/effort`, `/fast`, `/skill`.

---

## Claude Code-specific edit-mode preferences

- **Read before Edit, always.** Harness enforces it; also prevents stale-match failures.
- **Edit > Write.** Edit for surgical changes; Write only for new files or full replacements after Read.
- **Batch independent tool calls** in one turn (parallel function calls in same response).
- **TaskCreate** for any task ≥3 steps; `in_progress` before starting, `completed` only when actually done.
- **No report/summary `.md` deliverables** — return findings inline unless user asked for a checked-in doc.

---

## What lives where

| Concern | File | Read by |
|---|---|---|
| Shared agent rules (Ponytail, Caveman, grill-me, OKF format, fleet) | `AGENTS.md` | All 5 agents |
| Claude-Code-only rules (Hr chain, MCP, skill triggers) | `CLAUDE.md` (this file) | Claude Code |
| Per-agent stubs | `.agents/<name>/` | That one agent |
| Knowledge tree | `knowledge/` | All agents (durable decisions, services, runbooks) |
| Workspace MCP servers | `.mcp.json` | Claude Code (other agents have their own native config; see `.agents/*/`) |
| User-credential MCPs (smithery, github auth) | `~/.claude.json` global | Claude Code only |

---

## Where this file came from

Reorganized 2026-06-27 after user feedback: "Don't add Claude-specific rules to the shared knowledge base. Put them in CLAUDE.md."

Migrated from `knowledge/rules/agent/`:
- `single-claude-config-always-hr.md` → "Proxy chain" section above
- `keep-hr-port-8787.md` → "Proxy chain" section above
- `serena-mcp-installed.md` → "Serena" section above
- `omniroute-eval-install.md` → "OmniRoute" section above

Migrated rules are deleted from `knowledge/rules/agent/` in the same commit (git history is the audit trail; no `superseded:` banners).
