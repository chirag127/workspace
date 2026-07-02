---
type: decision
title: "SAP hyperspace docs crawl — deferred to interactive SSO"
description: "Crawl of SAP corp AI-proxy docs + internal GHE profile blocked by MS Entra SSO; requires user's live browser session."
tags: [sap, corp, mcp, sso, entra, hyperspace, agent-browser]
timestamp: 2026-07-02
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/cc-settings-balance
---

# SAP hyperspace docs crawl — deferred

## Target URLs

- `https://ai-docs.portal.hyperspace.tools.sap/llm-proxy/guides/connect-your-tools/` — SAP internal docs, LLM proxy / MCP tool connection guide
- `https://github.tools.sap/settings/profile` — SAP internal GitHub Enterprise, profile settings (for `gh mcp register` equivalent)

## Auth

- Microsoft Entra SSO. Tenant `42f7676c-f455-423c-82f6-dc2d99791af7` (SAP corp).
- Both hosts redirect anonymous requests to `login.microsoftonline.com`.
- Neither has a PAT / API-key fallback usable from CLI without prior interactive login.

## Why we care

- MCP server registration for the SAP corp fleet: register our workspace MCP servers against SAP's internal registry so hai/OmniRoute can call them.
- `github.tools.sap` = SAP internal GHE. Needed for `gh mcp register` (or equivalent) and any PR against SAP-internal repos.
- Hyperspace `llm-proxy` docs = ground truth for how the corp `hai` chain expects tool-use / MCP wiring.

## Attempt 2026-07-02

- `agent-browser 0.31.1` installed and healthy.
- `sap` session existed but had **no persisted auth state** — `agent-browser eval "location.href" --session sap` returned `about:blank`, indicating the browser process from the earlier headed launch was gone and no cookies survived.
- `agent-browser read <url> --session sap` returned an empty 1-byte file — auth wall, no content.
- Did NOT retry per no-fork-divergence-style discipline: one failed auth attempt is enough signal.

## What we would do if authenticated

1. `agent-browser open https://ai-docs.portal.hyperspace.tools.sap/llm-proxy/guides/connect-your-tools/ --session sap --headed` — user completes Entra SSO interactively.
2. `agent-browser read <url> --session sap` — save markdown to `C:/D/oriz/tmp/sap-hyperspace-crawl.md`.
3. Enumerate sidebar links (`/llm-proxy/*`, `/guides/*`) via `agent-browser snapshot`; batch-read each.
4. `gh auth login --hostname github.tools.sap` (uses SAP GHE OAuth device flow).
5. Register workspace MCP servers per hyperspace guide instructions.
6. Land facts in `knowledge/services/infra/sap-hyperspace-*.md` (caveman style) — free-tier N/A (corp), auth flow documented, MCP registration steps.

## Deferred to

Next session where user is at corp laptop with active SSO. Trigger phrase from user: "resume SAP crawl" or similar.

## Anti-patterns avoided

- No public leak: this file names the tenant ID (already visible in any SAP employee's Entra token — not a secret) but no SAP-internal content, code, or docs.
- No repeated auth retry — first empty response = defer, per session-timeout evidence.
- No fake fallback docs — nothing written to `tmp/sap-hyperspace-crawl.md` since nothing was fetched.

## Cross-refs

- [`rules/agent/preferences/cc-settings-balance`](../../../rules/agent/preferences/cc-settings-balance.md) — Hr chain is corp-Bedrock; MCP registration would extend that chain
- Attempt file (empty, kept for audit): `C:/D/oriz/tmp/sap-read-attempt.txt`
