---
type: decision
title: 'Headroom out of request path — Claude Code → hai direct'
description: Hr 0.19 backend=anthropic enforces Anthropic.com auth shape; hai is Bedrock-shaped. Chain breaks. Claude Code → hai :6655 direct until Hr 0.27 (--backend bedrock) installable.
tags: [headroom, hai, hyperspace, proxy, sap, claude-code, bedrock]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
supersedes:
  - decisions/architecture/agent-tooling/hr-hai-chain-2026-06-27.md
related:
  - rules/agent/single-claude-config-always-hr
  - decisions/architecture/agent-tooling/headroom-install-all-paths-2026-06-26
---

# Headroom out of request path — hai direct

## Decision

Claude Code points `ANTHROPIC_BASE_URL` at hai Desktop App directly (`http://localhost:6655/anthropic/`). Hr remains installed + running on :8787 but is OUT of the Claude Code request path.

## Why

Hr 0.19 default `--backend anthropic` expects Anthropic.com-shape auth (sigv4-style). hai upstream is Bedrock-shape. When Hr's `ANTHROPIC_TARGET_API_URL` was pointed at hai, Hr's auth-injection broke the Bedrock-shape request and Anthropic.com → hai handshake returned 500.

Hr 0.27 has `--backend bedrock` which would solve this, but 0.27 needs MSVC Build Tools to install on Windows (hnswlib native build). Deferred per earlier session.

## E2E verified 2026-06-27

```bash
$ claude --print "reply only OK"
OK
```

- Claude Code v2.1.193 (latest, auto-update on)
- Default model: `claude-opus-latest`
- Request hits hai → Bedrock → opus-4-7 → response

## What this changes

- Hr proxy on :8787: stays installed, stays auto-starting (Win Task Scheduler), but NOT in Claude Code path. Free for non-corp use (testing, future direct-Anthropic experiments).
- Hr→hai chain rule [hr-hai-chain-2026-06-27.md](./hr-hai-chain-2026-06-27.md): superseded by this file.
- Compression: NO Hr compression on corp traffic. Accept the cost until Hr 0.27 lands.

## When to revisit

- Hr 0.27+ becomes installable on this Windows machine (MSVC available, or prebuilt wheel ships for Python 3.13/3.14 + win_amd64)
- OR Hr ships a `--backend hai` or `--passthrough` mode that bypasses auth injection

## Cross-refs

- Hr install paths: [headroom-install-all-paths-2026-06-26](./headroom-install-all-paths-2026-06-26.md)
- Hr install rule on always-on proxy: [headroom-always-on-proxy-2026-06-26](./headroom-always-on-proxy-2026-06-26.md)
