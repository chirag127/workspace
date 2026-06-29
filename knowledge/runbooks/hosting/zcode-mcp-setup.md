---
type: runbook
title: "ZCode MCP Server Setup"
description: "Step-by-step guide for configuring all 8 workspace MCP servers in ZCode via the GUI."
tags: [zcode, mcp, setup, runbook]
timestamp: 2026-06-29
format_version: okf-v0.1
status: active
related:
  - knowledge/rules/agent/mcp-config-single-source-of-truth.md
  - .mcp.json
  - ZCODE.md
---

# ZCode MCP Server Setup

ZCode configures MCP servers via its GUI only — **not** via `.mcp.json`. The canonical server list lives in `C:\D\oriz\.mcp.json`. Use this runbook when opening ZCode in this workspace for the first time, or after adding a new MCP server to `.mcp.json`.

## Pre-flight

- ZCode installed and workspace opened at `C:\D\oriz`
- `uvx` available (MCP servers `fetch` and `serena` use it): `uvx --version`
- `npx` / Node.js available: `node --version`
- `codebase-memory-mcp.exe` installed at `C:\Users\C5420321\AppData\Local\Programs\codebase-memory-mcp\`

## Steps

### 1. Open MCP Settings

In ZCode: **Settings** (lower-left gear icon) → **MCP Servers** → **Add Server**.

### 2. Add each server

Add the following servers one by one. For each: click **Add Server**, fill in the fields, click **Save**.

---

#### `fetch` — Web page fetcher

| Field | Value |
|---|---|
| Name | `fetch` |
| Type | `stdio` |
| Command | `uvx` |
| Args | `mcp-server-fetch` |

---

#### `searxng` — Private search via SearXNG

| Field | Value |
|---|---|
| Name | `searxng` |
| Type | `stdio` |
| Command | `npx` |
| Args | `-y mcp-searxng` |
| Env | `SEARXNG_URL=https://baresearch.org` |

---

#### `open-websearch` — DuckDuckGo search

| Field | Value |
|---|---|
| Name | `open-websearch` |
| Type | `stdio` |
| Command | `npx` |
| Args | `-y open-websearch` |
| Env | `MODE=stdio`, `DEFAULT_SEARCH_ENGINE=duckduckgo` |

---

#### `mcp-crawl` — Web crawler (local)

| Field | Value |
|---|---|
| Name | `mcp-crawl` |
| Type | `stdio` |
| Command | `node` |
| Args | `./scripts/crawl-mcp/server.js` |

> Note: path is relative to workspace root `C:\D\oriz\`.

---

#### `serena` — Code intelligence (LSP-backed)

| Field | Value |
|---|---|
| Name | `serena` |
| Type | `stdio` |
| Command | `uvx` |
| Args | `--from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project .` |

> On first use, `uvx` downloads the Serena package. Allow ~30 s.

---

#### `codebase-memory` — Cross-session codebase memory

| Field | Value |
|---|---|
| Name | `codebase-memory` |
| Type | `stdio` |
| Command | `C:/Users/C5420321/AppData/Local/Programs/codebase-memory-mcp/codebase-memory-mcp.exe` |
| Args | *(leave empty)* |

---

#### `chirag127` — Smithery remote tools gateway

| Field | Value |
|---|---|
| Name | `chirag127` |
| Type | `http` |
| URL | `https://mcp.smithery.run/chirag127` |

---

#### `one-search-mcp` — Multi-engine search

| Field | Value |
|---|---|
| Name | `one-search-mcp` |
| Type | `stdio` |
| Command | `npx` |
| Args | `-y one-search-mcp` |
| Env | `SEARCH_PROVIDER=local` |

---

### 3. Verify

After adding all servers, click **Refresh** on the MCP Servers page. All 8 servers should show a green status indicator.

If a server shows red/error:
- `fetch` / `serena`: run `uvx --version` in terminal — reinstall with `pip install uv` if missing.
- `mcp-crawl`: verify `scripts/crawl-mcp/server.js` exists in the workspace.
- `codebase-memory`: verify the `.exe` path exists; reinstall from the codebase-memory-mcp release page if missing.

## Maintenance

When `.mcp.json` changes (new server added or args updated), re-run this runbook for the changed server only. ZCode GUI updates are manual — there is no auto-sync from `.mcp.json` to ZCode.
