# CLAUDE.md

> **Read [`AGENTS.md`](./AGENTS.md) first — it is the single source of truth for this repo and the entire `chirag127/oriz*` family.**

This file exists only to point Claude Code at `AGENTS.md`. All architecture, conventions, hosting, auth, secrets, design system, and submodule rules are documented there.

---

## Two rules every agent must follow at all times

1. **Self-update rule.** Every architectural / naming / stack decision the user makes in chat MUST be reflected in AGENTS.md before that conversation ends. If AGENTS.md and a recent chat contradict, the chat wins and AGENTS.md is wrong — update it in the same turn.

2. **Parallel-by-default rule.** Any work that can be parallelised MUST be fanned out via subagents. Sequential is the exception, justified in the commit message or task description when used.

Both rules are documented in full in AGENTS.md. They take precedence over individual prompts that contradict them.
