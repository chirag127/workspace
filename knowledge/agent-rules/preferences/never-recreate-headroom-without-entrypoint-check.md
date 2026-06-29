---
type: rule
title: 'Never recreate headroom-proxy container without checking entrypoint'
description: headroom-extras ENTRYPOINT already headroom. docker run CMD must start with proxy..., not headroom proxy...
tags: [headroom, docker, agent-behavior, hard-rule, feedback, incident]
timestamp: 2026-06-28
format_version: okf-v0.1
status: active
related:
  - core-concepts/headroom-internals-2026-06-27
  - decisions/agent-tooling/headroom-always-on-proxy-2026-06-26
---

# Never recreate headroom-proxy without checking entrypoint

## Incident 2026-06-28

Agent recreated the `headroom-proxy` container to add `HEADROOM_OUTPUT_SHAPER=1`. Used `docker run ... headroom-extras:latest headroom proxy --host 0.0.0.0 --port 8787`. The image's ENTRYPOINT is `headroom`, so the container's actual argv became `headroom headroom proxy --host ... --port ...` ? "Got unexpected extra arguments (headroom proxy)" ? crash-loop ? Claude Code chain down ? user had to manually restore via Kilo Code.

## Rules

1. **Never call `docker run` against `headroom-extras:latest` without first inspecting its ENTRYPOINT and CMD.** Use `docker inspect headroom-extras:latest --format='{{.Config.Entrypoint}} | {{.Config.Cmd}}'` first.

2. **The image's ENTRYPOINT is `headroom`.** The agent's `docker run` `[command [args...]]` portion must therefore start with the subcommand (`proxy`), NOT with the binary name. Correct: `docker run ... headroom-extras:latest proxy --host 0.0.0.0 --port 8787`. Wrong: `docker run ... headroom-extras:latest headroom proxy ...`.

3. **Prefer `docker update` or env file swap over container recreation when only env vars change.** Docker does not support live env mutation, but the existing CMD/ENTRYPOINT can be preserved by:
   - `docker stop headroom-proxy && docker commit headroom-proxy hr-snapshot:latest && docker rm headroom-proxy && docker run -d --name headroom-proxy ... hr-snapshot:latest` — preserves entrypoint+cmd from the running snapshot.
   - Or: use a compose file (`docker-compose.yml`) so the entrypoint/cmd never gets re-typed by hand.

4. **Verify within 5 seconds of recreation.** Always run `docker logs headroom-proxy 2>&1 | tail -5` immediately after `docker run`, and `curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8787/health`. If health != 200 or logs show "unexpected arguments", STOP and ask the user before retrying.

5. **Canonical invocation as of 2026-06-28 (verified):**
   ```bash
   # Image ENTRYPOINT is `[headroom proxy]`, CMD default is `[--host 0.0.0.0 --port 8787]`.
   # The docker-run `[command args...]` portion REPLACES the CMD; it does NOT prepend to ENTRYPOINT.
   # So the args we pass must be JUST the proxy flags — NOT `headroom`, NOT `proxy`.
   docker run -d --name headroom-proxy --restart unless-stopped -p 8787:8787 \
     -v headroom-data:/data \
     -e ANTHROPIC_TARGET_API_URL=http://host.docker.internal:6655/anthropic \
     -e HEADROOM_TELEMETRY=on \
     -e HEADROOM_CODE_AWARE_ENABLED=1 \
     -e HEADROOM_HOST=0.0.0.0 \
     -e HEADROOM_OUTPUT_SHAPER=1 \
     headroom-extras:latest \
     --host 0.0.0.0 --port 8787 --memory
   ```
   The first arg after the image name is `--host`, not `headroom`. Adding `headroom` or `proxy` before `--host` produces `headroom proxy headroom proxy ...` ? crash-loop.

6. **Hr feature flags reference** (all currently ENABLED 2026-06-28):
   - `--memory` flag enables persistent memory (SQLite, not Qdrant; per-project DB by default)
   - `HEADROOM_OUTPUT_SHAPER=1` enables output token reduction (~20-30%, 5× input cost on Opus)
   - `HEADROOM_CODE_AWARE_ENABLED=1` enables AST-based code compression (tree-sitter)
   - `HEADROOM_TELEMETRY=on` opts into anonymous aggregate stats
   - Hr `Optimization: ENABLED`, `Caching: ENABLED`, `Rate Limit: ENABLED` are all defaults — on without env vars

## Why this hurts so much

Hr is the single config in `~/.claude/settings.json`. There is no fallback. Hr down = Claude Code down. Cost in user-frustration far exceeds the value of any env tweak the agent was attempting.

## Default position

If unsure about the entrypoint, **don't recreate the container**. Ask the user, or use the existing `docker-compose.yml` (if one exists), or hand the user the exact `docker run` line and let them execute it manually.
