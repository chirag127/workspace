---
type: rule
title: "Headroom scoped-use policy"
description: "Headroom (Hr) is used only as input-compression proxy. No memory/Qdrant/TOIN/learn features. Docker-only deployment."
tags: [headroom, proxy, compression, docker]
timestamp: 2026-06-26
format_version: okf-v0.1
status: active
---

# Headroom scoped-use policy

## What we use

- **Input compression proxy** only — token + cache mode
- Docker deployment via `chopratejas/headroom:latest`
- Chain: `the AI agent → Hr :8787 → hai :6655 → Bedrock → claude-opus-4-7`

## What we DON'T use

- Memory / Qdrant / Neo4j backend — disabled
- TOIN (Traffic Observation Intelligence) — disabled
- Learn mode — disabled
- Persistent storage — stateless container
- CLI tools (`headroom wrap`, `headroom learn`) — not used
- npm SDK — not used in production

## Why

- Corporate ASR blocks headroom.exe direct-call; Docker bypasses
- `headroom-ai[all]` pipx install fails on hnswlib (Rust build blocked)
- npm SDK v0.22.4 available but unnecessary (Docker handles all)

## Known issues

ref: `.staging/research-headroom-issues-2026-06-26.md`

1. **ASR blocks headroom.exe** — Docker is the only working path on Windows
2. **hnswlib build fails on Windows** — MSVC Rust build scripts blocked by ASR
3. **Hr 0.19 vs 0.27** — 0.27 has Rust core (`rust_core: loaded`), better perf
4. **ANTHROPIC_TARGET_API_URL** must end in `/anthropic` for hai proxy
5. **Docker container may exit** if docker desktop restarts — solved by auto-start rule