---
type: rule
title: "Run okf-prompt-lookup before answering knowledge-touching prompts"
description: "Every agent must surface top-3 OKF concept files before answering any non-trivial prompt. Claude Code does it via UserPromptSubmit hook; other agents must run scripts/okf-prompt-lookup.py themselves."
tags: [agent, knowledge, okf, discoverability, fleet-parity]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/agent-minimum-context.md
  - rules/agent/keep-knowledge-fresh.md
  - rules/agent/agent-fleet-parity.md
  - decisions/architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29.md
---

# Run okf-prompt-lookup before answering knowledge-touching prompts

The problem: `knowledge/` has 700+ concept files but agents don't grep before answering. Knowledge that's invisible to the agent is the same as knowledge that doesn't exist.

The fix: a stdlib-only Python script that scores `knowledge/index.md` lines against the user prompt by token overlap, returns top-3 matching concept-file paths.

## How each agent runs it

### Claude Code

Automatic. Wired into `~/.claude/settings.json` UserPromptSubmit hook. Fires on every user prompt, prepends top-3 hits as a system message. Zero agent effort.

### OpenCode, MiMoCode, Antigravity, ZCode

These agents have no UserPromptSubmit equivalent (audited 2026-06-29 — see [`decisions/architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29`](../decisions/architecture/agent-tooling/okf-auto-lookup-hook-2026-06-29.md)). They MUST run the script themselves at the start of any non-trivial task:

```bash
python C:/D/oriz/scripts/okf-prompt-lookup.py "<the user's prompt>" --limit 3
```

Read the top-3 returned files before deciding the approach. Same rigor as Claude Code's automatic surfacing.

### Kilo Code

Plugin route (`chat.message` hook) exists but requires a TypeScript/Bun plugin — deferred. Until built, Kilo follows the OpenCode pattern: run the script manually at task start.

## When to skip

- Pure conversational turn ("thanks", "yes continue", "ok") — script exits 1 on short prompts anyway
- Follow-up turn where the previous turn already surfaced and read relevant knowledge
- Trivial mechanical edits (rename, typo fix) where no decision is being made

## When NOT to skip

- Any architectural choice
- Any "how do I X" question
- Any prompt mentioning a domain term (auth, hosting, DNS, secrets, deploy, scaffold, env, MCP, package, etc.)
- Any prompt where you're about to answer from memory rather than from `knowledge/`

## Why this isn't just a soft suggestion

The auto-grep hook on CC has measured value (this session: user prompt about parallelism surfaced `parallel-fan-out-by-default` automatically; agent didn't have to think to grep). Fleet parity demands equivalent rigor everywhere — the harness limitation is no excuse for stale answers on personal-machine agents.

## Cross-refs

- [[agent-fleet-parity]] — same rules across all agents
- [[agent-minimum-context]] — read minimum, surfaced via this hook
- [[keep-knowledge-fresh]] — read knowledge before acting, this is the mechanism
