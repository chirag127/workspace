---
type: rule
title: 'Headroom — proxy-only at session level, NEVER baked into oriz apps'
description: Hr runs as Docker proxy at the agent layer. NEVER import Hr SDK into oriz packages or apps. Vendor-lock + adds 60MB+ deps for marginal gain.
tags: [headroom, vendor-lock, scope, compression]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - decisions/architecture/agent-tooling/headroom-027-docker-2026-06-27
  - decisions/architecture/packaging/zero-in-house-packages-inline-analytics-2026-06-25
---

# Headroom — proxy-only, NEVER in-app

## Rule

Hr lives at the AGENT layer (Claude Code → Hr Docker → hai → Bedrock).
NEVER `pip install headroom-ai` or `npm install headroom-ai` inside oriz apps/libs.

## Why

- Hr SDK is 60MB+ with optional deps. Bloats every consumer.
- Vendor lock-in to one compression library that's still 0.x semver.
- Hr's value is at the wire (proxy compression). In-app `compress()` is duplicative because Hr proxy already compresses everything that hits it.
- Per `zero-in-house-packages-inline-analytics` — apps stay community-deps only.

## Allowed Hr touchpoints

| Layer | Allowed? | How |
|---|---|---|
| Claude Code config | ✅ | `ANTHROPIC_BASE_URL=http://localhost:8787` |
| Docker container | ✅ | `headroom-proxy` long-running, `--restart unless-stopped` |
| Win Task Scheduler | ✅ | At-login start |
| oriz library/app `package.json` deps | ❌ | NEVER |
| oriz library/app `requirements.txt` | ❌ | NEVER |
| Agent skills | ✅ | Hr's MCP server tools (`headroom_compress`, `headroom_retrieve`, `headroom_stats`) — read-only metrics |
| Headroom learn (CLAUDE.md corrections) | ✅ | `headroom learn` mines past sessions, writes corrections. Apply manually. |

## Top 5 known issues to be aware of

Surveyed `chopratejas/headroom` (redirects to `headroomlabs-ai/headroom`) open issues on 2026-06-27. The five most operator-relevant for our Hr→hai→Bedrock chain on Windows:

1. **#1307 — Lossy `tool_result` compression corrupts agent decisions** (open, multi-comment, no fix on 0.27.0). Only `--no-optimize` fully exempts tool output; `--tool-profile` levels (`conservative`/`moderate`/`aggressive`) are all lossy. `exclude_tools` / `protect_recent_reads_fraction` have no CLI/env surface. Agents re-reading older tool output get a compressed (false) version. Workaround: run with `--no-optimize` for any session that depends on exact tool output (defeats compression purpose).

2. **#1417 — Hr proxy fails after Bash tool_result with Anthropic-compatible third-party upstream** (open, bug-labelled). Exactly our chain (Claude Code → Hr → hai → Bedrock). PR open; until merged, tool-call ordering can desync between client view and proxied view. Workaround: pin Hr to the version with the fix once tagged; monitor for 200→4xx flips after `Bash` results.

3. **#1443 / #1442 — `ANTHROPIC_BASE_URL=http://127.0.0.1:8787` returns "Invalid API key"** (open onboarding bug). Authentication header forwarding regression. Our setup uses `http://localhost:8787` which currently works; do not switch to `127.0.0.1` form without testing.

4. **#1466 — Windows compatibility: Headroom not working on Windows** (open, recent). Native-Python install path is broken on Windows. This is exactly why we run the Docker container — the Docker path is the only supported Windows path. Never attempt `pip install headroom-ai` on Windows host.

5. **#1450 — CCR on-demand `headroom_retrieve` never intercepted for streaming clients → leaks as unknown tool** (open). Streaming clients (most modern Claude Code flows) bypass Hr's retrieve interception, so `headroom_retrieve` tool-calls land in the upstream model as undefined tools and surface as errors. Workaround: disable on-demand retrieve in Hr config if errors appear; rely on inline expansion only.

Plus one to watch (not in top 5 but related): **#1453 — pyo3 0.24 → 0.29 security bumps** (RUSTSEC-2026-0176/0177). Low ops impact for proxy users but a reminder Hr is on 0.x and ships native code.

## Cross-refs

- Hr Docker rule: `decisions/architecture/agent-tooling/headroom-027-docker-2026-06-27.md`
- Zero in-house pkg rule: `decisions/architecture/packaging/zero-in-house-packages-inline-analytics-2026-06-25.md`
- Hr port pin: `rules/agent/keep-hr-port-8787.md`
