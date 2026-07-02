---
type: decision
title: "OmniRoute: run from source via dev server, auto-pull on boot"
description: "Switch from `npm install -g omniroute` to running the cloned fork's dev server. Auto-start on Windows login pulls upstream and launches pnpm dev in a dedicated Windows Terminal tab."
tags: [omniroute, dev-server, ai-gateway, auto-start, windows]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/headroom-always-on-proxy-2026-06-26
  - decisions/agent-tooling/task-scheduler-at-login-2026-06-26
  - rules/development/windows-shortcut-absolute-binary-paths
  - runbooks/operations/start-dev-server-from-source
---

# OmniRoute: dev server from source, auto-pull on boot

## Decision

OmniRoute (the AI gateway router) runs from a **local clone of the fork**, not from `npm install -g omniroute`. The fork at `chirag127/OmniRoute` tracks `diegosouzapw/OmniRoute` as upstream. On every Windows login, a startup script:

1. Fast-forward merges `upstream/main` into local `main`
2. Runs `pnpm install` only if `package.json` or `pnpm-lock.yaml` changed
3. Spawns `pnpm dev` in a dedicated Windows Terminal tab titled "OmniRoute Dev"
4. Skips if `:20128` is already in use

Dashboard at `http://localhost:20128` after ~10-30s Next.js compile.

## Why this replaces `npm install -g omniroute`

The global npm install pulls 1000+ packages, takes 18+ minutes per update. OmniRoute ships releases multiple times daily (v3.8.36 through v3.8.42 in the week of 2026-06-25). Either you:

- Update daily and burn ~2 hours/week on `npm install -g omniroute`, OR
- Pin a version and miss security/bug fixes (e.g. #5562 `tls-options.mjs` missing from npm tarball — fixed in source long before the published package)

Running from source:
- `git pull` is seconds, not minutes
- See verbose Next.js compile logs (debugging routing issues)
- Patch bugs locally without waiting for an npm publish
- Test unreleased branches (their own `release/v3.8.42` was usable from source before the npm version landed)

## Why a fork (not direct clone of upstream)

Per [`fork-discipline`](../../rules/development/fork-discipline.md): all forks live under `chirag127/<upstream-name>` with upstream wired as a remote. This gives:

- Capability to send PRs back to `diegosouzapw/OmniRoute` from a clean branch
- Audit trail for any local patches via `git diff upstream/main..origin/main`
- One uniform pattern across the fleet — same shape as the [MCP forks rule](../../rules/development/mcp-fork-pattern-in-frk.md)

## Auto-start mechanism

`shell:startup` shortcut at `C:\Users\<USER>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\OmniRoute Dev.lnk` invokes:

```
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\D\oriz\scripts\start-omniroute-dev.ps1"
```

The script is idempotent (port check) and safe to run repeatedly.

Manual triggers:
- Desktop shortcut: `C:\Users\<USER>\Desktop\OmniRoute Dev.lnk`
- Terminal: `& "C:\D\oriz\scripts\start-omniroute-dev.ps1"`

## Why Windows shortcut over Task Scheduler

[`task-scheduler-at-login-2026-06-26`](./task-scheduler-at-login-2026-06-26.md) is the family standard for "run on login." For a single dev server that the user wants to **see** (Windows Terminal tab visible, output readable), `shell:startup` is simpler than Task Scheduler:

- No XML task definition
- No `-RunAsAdmin` complications
- Tab opens on the user's desktop session (Task Scheduler hides it by default)
- Removable by deleting one `.lnk` file

For services that should run invisible-in-background (Hr, cavemem hooks), Task Scheduler remains the right tool.

## Replacement procedure

See [`runbooks/operations/start-dev-server-from-source`](../../runbooks/operations/start-dev-server-from-source.md) for the step-by-step migration from `npm install -g omniroute` to the dev-server path.

## Caveats

- Requires Node 22+ and pnpm globally available (already on this machine)
- First-run `pnpm install` from cold repo takes 5-8 min (one-time cost)
- The dev server runs on Node directly, not Docker — if container isolation is needed, switch to `docker run diegosouzapw/omniroute` (also documented in the runbook)
- Diverged commits (local-only changes on `main`) will block the fast-forward merge — the script warns and continues with current HEAD

## Path note for `shell:startup`

When constructing the `wt new-tab ... pwsh -Command "..."` arg string, use **absolute paths** to `pnpm.cmd` / `npm.cmd` — `wt`-spawned shells don't reliably inherit the User PATH. See [`rules/development/windows-shortcut-absolute-binary-paths`](../../rules/development/windows-shortcut-absolute-binary-paths.md).

## See also

- [`runbooks/operations/start-dev-server-from-source`](../../runbooks/operations/start-dev-server-from-source.md) — the migration runbook (covers freellmapi and any future fleet fork)
- [`headroom-always-on-proxy-2026-06-26`](./headroom-always-on-proxy-2026-06-26.md) — Hr is the chain Claude Code → Hr → hai → Bedrock; OmniRoute is parallel to this, not in the chain
- [`fleet-cut-to-4-agents-2026-06-29`](./fleet-cut-to-4-agents-2026-06-29.md) — OmniRoute isn't a coding agent in the fleet; it's a gateway router complementing them
