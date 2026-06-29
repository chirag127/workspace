---
type: rule
title: 'MCP env credentials — Win env vars + Smithery profile (both layers)'
description: MCP env vars sync via Win system env (local) + Smithery profile (cross-machine). Never commit values
tags: [mcp, env, sync, smithery, no-commit-keys]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - agent-rules/mcp-no-key-in-repo-keyed-in-smithery
  - agent-rules/dont-dup-smithery-tools
---

# MCP env credentials — dual-layer sync

## Rule

MCP server credentials sync via TWO layers:

| Layer | Scope | What it stores |
|---|---|---|
| Windows env vars (`setx`) | This machine, all shells | Local-only credentials |
| Smithery profile | Cross-machine, cross-session | All keyed MCPs |

Both layers active. Win env is faster (no Smithery roundtrip). Smithery survives re-image / new machine.

## How to add a credential

```bash
# 1) Win env (local)
setx FIRECRAWL_API_KEY "fc-xxxxxx"

# 2) Smithery (persistent, cross-machine)
npx -y @smithery/cli install firecrawl-mcp --client claude
# Smithery CLI prompts for the key, stores in your Smithery vault
```

## NEVER

- Commit any key to `.env` (gitignored but human-error-prone)
- Commit any key to `.mcp.json` (would be public)
- Hardcode in scripts
- Share Smithery profile credentials between users

## Recovery

If you lose the Win env (new machine), Smithery profile restores everything:
```bash
npx -y @smithery/cli login
npx -y @smithery/cli sync --client claude
```
