---
type: runbook
title: "Start dev server from source (OmniRoute, freellmapi, any fleet fork)"
description: "Step-by-step: replace global npm install with a local cloned-fork dev server. Auto-start on Windows login, pull upstream on every launch, run via Windows Terminal tab."
tags: [runbook, dev-server, omniroute, freellmapi, fork, windows, startup]
timestamp: 2026-06-30
format_version: okf-v0.1
status: active
related:
  - decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30
  - decisions/agent-tooling/freellmapi-dev-server-from-source-2026-06-30
  - rules/development/windows-shortcut-absolute-binary-paths
  - rules/development/fork-discipline
---

# Start dev server from source

Generalised procedure for migrating any fleet fork from global package install (`npm install -g <pkg>` / `pipx install <pkg>`) to running the dev server out of `repos/frk/<name>`. Already applied to OmniRoute and freellmapi; the pattern below works for any new fork.

## When to use this

- The upstream ships releases faster than you want to `npm install -g` (OmniRoute ships ~daily)
- You want to run unmerged PRs / patches (the `tls-options.mjs` missing-file bug we hit on omniroute@3.8.41 was fixed in source long before the npm version)
- You want verbose dev logs (Next.js / Vite output is invisible behind the global install's stdout silencing)
- You want to make a quick local patch and PR back upstream

## Pre-requisites

- `git` on PATH (yes for this machine)
- `pnpm` AND `npm` on PATH (yes — at `C:\Program Files\nodejs\`)
- Windows Terminal (`wt`) installed (yes)
- The upstream repo has a `dev` script in `package.json` (verify via `cat package.json | grep '"dev"'`)

## Procedure

### 1. Fork the upstream to `chirag127`

```powershell
gh repo fork <upstream-org>/<upstream-name> --org chirag127 --clone=false --default-branch-only
```

If GitHub creates a `<name>-1` because `<name>` was taken by an earlier fork, delete the old one first:

```powershell
gh api orgs/chirag127/repos --paginate --jq '.[] | select(.name | startswith("<name>")) | "\(.name) | fork=\(.fork) | parent=\(.parent.full_name)"'
gh repo delete chirag127/<duplicate-name> --yes
```

Verify the canonical fork's `parent` matches the desired upstream.

### 2. Clone into the workspace

```powershell
git clone https://github.com/chirag127/<name>.git C:\D\oriz\repos\frk\<name>
cd C:\D\oriz\repos\frk\<name>
git remote add upstream https://github.com/<upstream-org>/<upstream-name>.git
```

### 3. Identify the dev command + port

```powershell
Get-Content package.json | Select-String -Pattern '"(dev|start|build)"'
```

Find the port:
- Check `.env.example` for `PORT=` or similar
- Grep the server entry for `listen(` calls
- If nothing matches, check the framework default (Next.js → 3000, Vite → 5173, Hono → user-configured)

### 4. Write the start script

Save as `C:\D\oriz\scripts\start-<name>-dev.ps1`. Template — fill in the bracketed placeholders:

```powershell
#Requires -Version 5.1
$ErrorActionPreference = 'Continue'
$repo = 'C:\D\oriz\repos\frk\<NAME>'
$psPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$serverPort = <PORT>   # e.g. 20128 for OmniRoute, 3001 for freellmapi

# Idempotency: skip if already running
$listening = Get-NetTCPConnection -LocalPort $serverPort -State Listen -ErrorAction SilentlyContinue
if ($listening) {
    Write-Host "<NAME> already on :$serverPort (PID $($listening[0].OwningProcess))" -ForegroundColor Yellow
    Start-Sleep 3
    exit 0
}

if (-not (Test-Path $repo)) { Write-Host "repo missing"; exit 1 }
Set-Location $repo

# Track lockfile state BEFORE pull (decide if install is needed)
$lockBefore = if (Test-Path '<LOCKFILE>') { (Get-FileHash '<LOCKFILE>' -Algorithm SHA256).Hash } else { '' }
$pkgBefore  = if (Test-Path 'package.json') { (Get-FileHash 'package.json' -Algorithm SHA256).Hash } else { '' }

# Pull upstream
git fetch upstream 2>&1 | Out-Null
git merge --ff-only upstream/main 2>&1 | Out-Null

# Re-hash; install only if changed
$lockAfter = if (Test-Path '<LOCKFILE>') { (Get-FileHash '<LOCKFILE>' -Algorithm SHA256).Hash } else { '' }
$pkgAfter  = if (Test-Path 'package.json') { (Get-FileHash 'package.json' -Algorithm SHA256).Hash } else { '' }
$needsInstall = (-not (Test-Path 'node_modules')) -or ($lockBefore -ne $lockAfter) -or ($pkgBefore -ne $pkgAfter)

# ABSOLUTE PATH — see rules/development/windows-shortcut-absolute-binary-paths
$pm = 'C:\Program Files\nodejs\<PM>.cmd'   # pnpm.cmd OR npm.cmd
$inner = if ($needsInstall) {
    "Write-Host 'Installing...'; & '$pm' install; & '$pm' <DEV-CMD>"
} else {
    "& '$pm' <DEV-CMD>"
}

Start-Process wt -ArgumentList "new-tab --title `"<NAME> Dev`" -d `"$repo`" `"$psPath`" -NoExit -Command `"$inner`""
Write-Host "<NAME> dev launching on http://localhost:$serverPort"
Start-Sleep 3
```

Replace `<NAME>`, `<PORT>`, `<LOCKFILE>` (`pnpm-lock.yaml` or `package-lock.json`), `<PM>` (`pnpm` or `npm`), `<DEV-CMD>` (`dev` or `run dev`).

### 5. Create the startup shortcut

```powershell
$startupDir = [System.Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupDir "<NAME> Dev.lnk"
$scriptPath = "C:\D\oriz\scripts\start-<name>-dev.ps1"

$wsh = New-Object -ComObject WScript.Shell
$lnk = $wsh.CreateShortcut($shortcutPath)
$lnk.TargetPath = "powershell.exe"
$lnk.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$lnk.WorkingDirectory = "C:\D\oriz"
$lnk.IconLocation = "powershell.exe,0"
$lnk.Description = "Auto-pull and start <NAME> dev server"
$lnk.Save()
```

### 6. Optional: desktop shortcut for manual trigger

```powershell
$desktop = [System.Environment]::GetFolderPath('Desktop')
Copy-Item $shortcutPath (Join-Path $desktop "<NAME> Dev.lnk") -Force
```

### 7. First-time install + sanity test

```powershell
& "C:\D\oriz\scripts\start-<name>-dev.ps1"
```

A new Windows Terminal tab should appear, run `pnpm install` / `npm install` (5-8 min one-time), then start the dev server. Visit `http://localhost:<PORT>` to confirm.

### 8. Stop the old global install

```powershell
# Free the port if the old npm-installed version is still running
Get-NetTCPConnection -LocalPort <PORT> -State Listen | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force
}
# Optionally uninstall the global
npm uninstall -g <pkg-name>
```

## Currently applied to

- **OmniRoute** — `repos/frk/omniroute`, port 20128, `pnpm dev`, [decision](../../decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30.md)
- **freellmapi** — `repos/frk/freellmapi`, port 3001 (server) + 5173 (client), `npm run dev`, [decision](../../decisions/agent-tooling/freellmapi-dev-server-from-source-2026-06-30.md)

## Reverting (back to global install)

```powershell
# Remove the startup + desktop shortcuts
Remove-Item "$([Environment]::GetFolderPath('Startup'))\<NAME> Dev.lnk"
Remove-Item "$([Environment]::GetFolderPath('Desktop'))\<NAME> Dev.lnk"

# Stop the dev server
Get-NetTCPConnection -LocalPort <PORT> -State Listen | ForEach-Object {
    Stop-Process -Id $_.OwningProcess -Force
}

# Reinstall the global
npm install -g <pkg-name>
```

The fork at `repos/frk/<name>` can stay — it's just no longer auto-started.

## Common gotchas

- **`pnpm` or `npm` "command not found"** in the spawned tab → script used bareword instead of absolute path. See [`windows-shortcut-absolute-binary-paths`](../../rules/development/windows-shortcut-absolute-binary-paths.md).
- **Local diverged from upstream** → script reports the fast-forward merge failed and continues with current HEAD. Either rebase your local commits onto upstream, or accept the staleness.
- **Port already in use** → script exits cleanly (idempotency check). If you want to force a restart: `Get-NetTCPConnection -LocalPort <PORT> -State Listen | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force }` then re-run the script.
- **Defender ASR blocks `.exe` in `AppData\...`** → first run prompts for permission; allow and subsequent runs work.

## See also

- [`omniroute-dev-server-from-source-2026-06-30`](../../decisions/agent-tooling/omniroute-dev-server-from-source-2026-06-30.md)
- [`freellmapi-dev-server-from-source-2026-06-30`](../../decisions/agent-tooling/freellmapi-dev-server-from-source-2026-06-30.md)
- [`windows-shortcut-absolute-binary-paths`](../../rules/development/windows-shortcut-absolute-binary-paths.md)
- [`fork-discipline`](../../rules/development/fork-discipline.md)
