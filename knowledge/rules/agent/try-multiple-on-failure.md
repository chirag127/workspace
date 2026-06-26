---
type: rule
title: 'Try multiple alternatives on failure — never stop at first fail'
description: When a website/API/tool/install path fails, try ≥3 alternatives before reporting blocker. Captured 2026-06-27.
tags: [agent-behavior, resilience, fallback, retries]
timestamp: 2026-06-27
format_version: okf-v0.1
status: active
related:
  - rules/agent/preferences/max-proactive-grill-always
---

# Try multiple alternatives on failure

## Rule

When ANY external dependency fails (website, API endpoint, install method, package source), try AT LEAST 3 alternatives before reporting it as a blocker.

## How to apply

- HTTP fetch fails → try 3 mirror URLs / alternate instances (e.g. SearXNG: baresearch.org failed → try priv.au, searx.be, opnxng.com)
- npm install fails → try yarn, pnpm, direct GitHub clone
- pipx fails (ASR/build) → try Docker, then npm SDK, then docker-compose
- API endpoint 5xx → 3 retries with exponential backoff, then alt endpoint
- Package not found → search PyPI, npm, GHCR, GitHub Releases, GitLab Registry, jsr.io
- Tool not on PATH → check 5 common install locations before declaring missing

## Why

The first failure is often transient or context-specific (DNS, rate-limit, ASR, etc.). Reporting "X failed, stuck" after a single attempt wastes the user's time and conversation context. Three attempts catch ~95% of recoverable failures.

## Anti-patterns

- Single retry = "didn't really try"
- Retrying the same URL 3× ignoring the actual error
- Asking the user "should I try alternatives?" — just try them
