#Requires -Version 5.1
<#
.SYNOPSIS
  Manual-trigger script: pull latest freellmapi from upstream and start dev server.

.DESCRIPTION
  - Pulls latest from upstream (tashfeenahmed/freellmapi main)
  - Runs npm install if package.json or lockfile changed since last run
  - Starts `npm run dev` in a Windows Terminal tab titled "freellmapi Dev"
  - Idempotent: if the dev server is already running on :3001, skips startup

.NOTES
  Manual trigger only — NOT wired to Windows startup (per user instruction).
  Source: C:\D\oriz\repos\frk\freellmapi (oriz-org fork, tracks tashfeenahmed upstream).
  Default ports: server :3001, client (vite) :5173.
#>

$ErrorActionPreference = 'Continue'
$repo = 'C:\D\oriz\repos\frk\freellmapi'
$psPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
$serverPort = 3001

# 1. Skip if already running on the server port
$listening = Get-NetTCPConnection -LocalPort $serverPort -State Listen -ErrorAction SilentlyContinue
if ($listening) {
    Write-Host "freellmapi already listening on :$serverPort (PID $($listening[0].OwningProcess)). Skipping." -ForegroundColor Yellow
    Start-Sleep 3
    exit 0
}

if (-not (Test-Path $repo)) {
    Write-Host "freellmapi repo not found at $repo" -ForegroundColor Red
    Start-Sleep 5
    exit 1
}

Set-Location $repo

# 2. Track lockfile state BEFORE the pull
$lockBefore = if (Test-Path 'package-lock.json') { (Get-FileHash 'package-lock.json' -Algorithm SHA256).Hash } else { '' }
$pkgBefore  = if (Test-Path 'package.json')      { (Get-FileHash 'package.json'      -Algorithm SHA256).Hash } else { '' }

# 3. Pull upstream/main (fast-forward only)
Write-Host "Pulling upstream/main..."
git fetch upstream 2>&1 | Out-Null
$beforePull = git rev-parse HEAD
git merge --ff-only upstream/main 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Fast-forward merge failed (local diverged). Continuing with current HEAD." -ForegroundColor Yellow
}
$afterPull = git rev-parse HEAD
if ($beforePull -ne $afterPull) {
    Write-Host "Updated $beforePull -> $afterPull" -ForegroundColor Green
} else {
    Write-Host "Already up to date." -ForegroundColor Cyan
}

# 4. Re-hash; if lockfile or package.json changed, re-install
$lockAfter = if (Test-Path 'package-lock.json') { (Get-FileHash 'package-lock.json' -Algorithm SHA256).Hash } else { '' }
$pkgAfter  = if (Test-Path 'package.json')      { (Get-FileHash 'package.json'      -Algorithm SHA256).Hash } else { '' }
$nodeModulesExists = Test-Path 'node_modules'
$needsInstall = (-not $nodeModulesExists) -or ($lockBefore -ne $lockAfter) -or ($pkgBefore -ne $pkgAfter)

# 5. Build the inner command — use full path to npm.cmd so spawned shell
#    doesn't depend on inheriting User PATH
$npm = 'C:\Program Files\nodejs\npm.cmd'
$innerScript = if ($needsInstall) {
    "Write-Host 'Installing dependencies...'; & '$npm' install; & '$npm' run dev"
} else {
    "& '$npm' run dev"
}

# 6. Base64-encode the inner script so wt's argument parsing can't break it.
#    -EncodedCommand expects UTF-16LE base64.
$bytes = [System.Text.Encoding]::Unicode.GetBytes($innerScript)
$encoded = [Convert]::ToBase64String($bytes)

# 7. Launch in a Windows Terminal tab
$wtArgs = "new-tab --title `"freellmapi Dev`" -d `"$repo`" `"$psPath`" -NoExit -EncodedCommand $encoded"
Start-Process wt -ArgumentList $wtArgs

Write-Host ""
Write-Host "freellmapi dev server launching in new Windows Terminal tab." -ForegroundColor Green
Write-Host "  Server: http://localhost:$serverPort"
Write-Host "  Client: http://localhost:5173 (Vite)"
Start-Sleep 3
