---
title: Install auto-start services (Headroom + cavemem)
date: 2026-06-28
type: runbook
tags: [windows, task-scheduler, headroom, cavemem, autostart]
---

# install-auto-start-services

Register Windows Task Scheduler entries so Headroom (Docker, `:8787`) and the cavemem worker (`127.0.0.1:37777`) come up automatically at user logon. Source: `knowledge/decisions/architecture/infrastructure/hosting-github-pages-with-analytics-everywhere-2026-06-28.md` Section 2.

## Why both must auto-start

- **Headroom container `headroom-proxy`** — the Hr-hai-Bedrock proxy chain. Claude Code is configured to talk to `localhost:8787`; if Headroom is down at login, every Claude Code session fails immediately.
- **cavemem worker** — backs `127.0.0.1:37777`. Hooks and the MCP server write/read observations through the worker; without it, memory writes are silently dropped.

Docker Desktop has `--restart unless-stopped` on the container, but the *Docker daemon itself* still needs to be running. The Headroom task runs `docker start headroom-proxy` which is a no-op if the daemon already auto-started the container and a fix-up if it didn't.

## What the installer does

`scripts/install-auto-start.cmd`:

1. Pre-flight checks (`docker`, container `headroom-proxy` exists, `cavemem` on PATH).
2. Renders the two XML templates under `scripts/auto-start/`, substituting `USER_PLACEHOLDER`, `CAVEMEM_PLACEHOLDER`, `USERPROFILE_PLACEHOLDER`, and writes UTF-16 LE (required by `schtasks /xml`).
3. `schtasks /create /xml ... /f` registers two tasks (idempotent — `/f` replaces any existing entry):
   - `Oriz-Headroom-Login` → `docker start headroom-proxy`
   - `Oriz-Cavemem-Login` → `cavemem.cmd start` (CWD = `%USERPROFILE%`)
4. Verifies both tasks report `Status: Ready`.
5. Manually triggers each task once and checks the post-run state.

Both tasks are: logon-triggered for the current user, hidden, restart up to 3x on failure (1-min interval), `LeastPrivilege` (no UAC prompt required).

## Install

From the workspace root (cmd.exe or Git Bash):

```cmd
scripts\install-auto-start.cmd
```

Idempotent — safe to re-run after editing XML.

## Verify

```cmd
schtasks /query /tn "Oriz-Headroom-Login" /fo LIST
schtasks /query /tn "Oriz-Cavemem-Login" /fo LIST
```

Both should show `Status: Ready`. After login:

```powershell
docker ps --filter name=headroom-proxy --filter status=running
curl -fsS http://127.0.0.1:8787/health
cavemem status   # worker should show "running"
```

Expected: container `Up`, health 200, cavemem worker pid present, listening on `127.0.0.1:37777`.

## Uninstall

```cmd
scripts\uninstall-auto-start.cmd
```

Deletes both tasks and the two rendered XML files (`.headroom-task.rendered.xml`, `.cavemem-task.rendered.xml`). The source XML templates under `scripts/auto-start/` are kept.

## Troubleshooting

**`ERROR: Access is denied.` during install** — happened when XML used `<RunLevel>HighestAvailable</RunLevel>`. Fixed by using `LeastPrivilege` — neither service needs admin (docker pipe is in the user's docker-users group; cavemem writes to `%USERPROFILE%\.cavemem`).

**Docker daemon not running at login** — `docker start headroom-proxy` will fail until Docker Desktop starts. Docker Desktop has its own logon auto-start setting (Settings -> General -> Start Docker Desktop when you sign in to your computer). Enable it. The task's `RestartOnFailure` (1 min x 3) gives Docker time to come up.

**`cavemem not on PATH`** — installer aborts. Install via `npm i -g cavemem` then re-run.

**Container name mismatch** — installer checks for `headroom-proxy` specifically (matches `scripts/headroom-ensure.ps1`). If you have a container named `headroom` instead, either rename it or edit `scripts/auto-start/headroom-task.xml`.

**Confirm a task actually fires at logon** — `Event Viewer -> Applications and Services Logs -> Microsoft -> Windows -> TaskScheduler -> Operational` and filter on the task name.

## Files

- `scripts/install-auto-start.cmd` — installer (cmd-shell, Git-Bash-callable).
- `scripts/uninstall-auto-start.cmd` — remover.
- `scripts/auto-start/headroom-task.xml` — XML template (UTF-8 source; installer re-emits UTF-16 LE with placeholders filled).
- `scripts/auto-start/cavemem-task.xml` — XML template.
- `scripts/auto-start/.{headroom,cavemem}-task.rendered.xml` — generated, gitignore-worthy (leading dot).
