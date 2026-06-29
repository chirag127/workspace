---
type: runbook
title: 'Upload MCP servers to Smithery toolbox `@chirag127/toolbox`'
description: How to add an existing MCP server (npm/PyPI/Docker) to your Smithery toolbox so it's reachable via the single `https://mcp.smithery.run/chirag127` endpoint. Covers the 3 uploadable servers (fetch, searxng, open-websearch) and the 3 non-uploadable ones (serena, codebase-memory, mcp-crawl) with reasons.
tags: [mcp, smithery, toolbox, runbook, single-source-of-truth]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - rules/agent/globals-derived-from-workspace
  - rules/agent/mcp-config-single-source-of-truth
  - services/mcp-smithery-toolbox
---

# Upload MCP servers to Smithery toolbox

## Goal

Maximise single-source-of-truth: collapse multiple MCP entries in `.mcp.json` into a single Smithery toolbox URL where physically possible.

## Eligibility

A server can join your Smithery toolbox if:

| Criterion | Why |
|---|---|
| ✅ Pure-network (no local file system / repo / binary deps) | Smithery containers are Linux, ephemeral, no access to your laptop |
| ✅ Public npm/PyPI/Docker package | Smithery pulls and runs in their container |
| ❌ Reads your local repo (e.g. `serena --project .`) | Smithery container has no access to your code |
| ❌ Local binary (e.g. `codebase-memory.exe`) | Wrong OS + no upload mechanism |
| ❌ Relative path command (e.g. `node ./scripts/crawl-mcp/server.js`) | Smithery doesn't see your scripts |

## Eligibility audit for your 6 local MCPs

| Server | Eligible? | Reason |
|---|---|---|
| `fetch` (`uvx mcp-server-fetch`) | ✅ | PyPI package, network-only |
| `searxng` (`npx -y mcp-searxng`) | ✅ | npm package, network-only |
| `open-websearch` (`npx -y open-websearch`) | ✅ | npm package, network-only |
| `mcp-crawl` (`node ./scripts/crawl-mcp/server.js`) | ❌ | Local script, not published |
| `serena` (`uvx --from git+... --project .`) | ❌ | Indexes your local repo |
| `codebase-memory` (`./codebase-memory-mcp.exe`) | ❌ | Windows binary, indexes your repo |

## Procedure (web UI — easiest)

1. Go to https://smithery.ai and sign in.
2. Navigate to your toolbox: `https://smithery.ai/server/@chirag127/toolbox`.
3. Click **Edit** → **Add Server**.
4. For each eligible package:
   - **fetch**: search `mcp-server-fetch`, click **Install to toolbox**.
   - **searxng**: search `mcp-searxng`, set `SEARXNG_URL=https://baresearch.org`, click **Install to toolbox**.
   - **open-websearch**: search `open-websearch`, set `MODE=stdio`, `DEFAULT_SEARCH_ENGINE=duckduckgo`, click **Install to toolbox**.
5. Save the toolbox.

## Procedure (CLI)

```cmd
npm install -g @smithery/cli
smithery mcp publish <package-url> -n @chirag127/toolbox
```

Note: `publish` is for your own MCP servers. To **add an existing public package** to your toolbox, the web UI is the supported path (the CLI is for publishing new servers).

## Removing from `.mcp.json` after upload

After verifying the 3 servers are reachable through `chirag127` toolbox:

```bash
# Test toolbox surface
curl -s https://mcp.smithery.run/chirag127 -X POST -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

If the response includes `mcp-server-fetch`, `mcp-searxng`, and `open-websearch` tool definitions:

```bash
node scripts/sync-globals.mjs --remove fetch,searxng,open-websearch
```

(or manually edit `.mcp.json` to drop those 3 entries, then `node scripts/sync-mcp-configs.mjs`).

## When to NOT consolidate

Keep `fetch`/`searxng`/`open-websearch` as direct entries in `.mcp.json` if:

- Smithery is slow / unreliable in your network.
- You need to debug the server's stderr (Smithery hides it).
- You need a config (e.g. different `SEARXNG_URL` per machine) that Smithery's toolbox shape doesn't support.

Otherwise: consolidating gains a smaller `.mcp.json`, fewer stdio processes per session.

## Cross-refs

- [`mcp-config-single-source-of-truth`](../../rules/agent/mcp-config-single-source-of-truth.md)
- [`globals-derived-from-workspace`](../../rules/agent/globals-derived-from-workspace.md)
- Smithery CLI: https://smithery.ai/docs/cli
