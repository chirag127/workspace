#Requires -Version 5.1
<#
.SYNOPSIS
  Start OmniRoute dev server from source.

.DESCRIPTION
  - Skips if :20128 already listening
  - Pulls upstream/main (fast-forward only)
  - pnpm install if package.json or pnpm-lock.yaml changed
  - Starts pnpm dev in a Windows Terminal tab titled "OmniRoute Dev"
#>

$ErrorActionPreference = 'Continue'
$repo = 'C:\D\oriz\repos\frk\omniroute'
$psPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

# 1. Skip if already running
$listening = Get-NetTCPConnection -LocalPort 20128 -State Listen -ErrorAction SilentlyContinue
if ($listening) {
    Write-Host "OmniRoute already on :20128. Skipping."
    exit 0
}

if (-not (Test-Path $repo)) {
    Write-Host "Repo not found: $repo" -ForegroundColor Red
    exit 1
}

# 2. Resolve pnpm
$pnpmCmd = Get-Command pnpm -ErrorAction SilentlyContinue
$pnpmList = @(
    "$env:APPDATA\npm\pnpm.cmd",
    "$env:ProgramFiles\nodejs\pnpm.cmd"
)
if ($pnpmCmd) { $pnpmList += $pnpmCmd.Source }
$pnpm = $pnpmList | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if (-not $pnpm) {
    Write-Host "pnpm not found. Run: npm install -g pnpm" -ForegroundColor Red
    exit 1
}

Set-Location $repo

# 3. Hash lockfiles before pull
$lockBefore = if (Test-Path 'pnpm-lock.yaml') { (Get-FileHash 'pnpm-lock.yaml' -Algorithm SHA256).Hash } else { '' }
$pkgBefore  = if (Test-Path 'package.json')   { (Get-FileHash 'package.json'   -Algorithm SHA256).Hash } else { '' }

# 4. Pull upstream
git fetch upstream 2>&1 | Out-Null
git merge --ff-only upstream/main 2>&1 | Out-Null

# 5. Decide if install needed
$lockAfter = if (Test-Path 'pnpm-lock.yaml') { (Get-FileHash 'pnpm-lock.yaml' -Algorithm SHA256).Hash } else { '' }
$pkgAfter  = if (Test-Path 'package.json')   { (Get-FileHash 'package.json'   -Algorithm SHA256).Hash } else { '' }
$needsInstall = (-not (Test-Path 'node_modules')) -or ($lockBefore -ne $lockAfter) -or ($pkgBefore -ne $pkgAfter)

# 6. Build inner command
$innerScript = if ($needsInstall) {
    "Set-Location '$repo'; Write-Host 'Installing...'; & '$pnpm' install; & '$pnpm' dev"
} else {
    "Set-Location '$repo'; & '$pnpm' dev"
}

# 7. Base64-encode for wt argument safety
$bytes   = [System.Text.Encoding]::Unicode.GetBytes($innerScript)
$encoded = [Convert]::ToBase64String($bytes)

# 8. Launch in Windows Terminal
$wtArgs = "new-tab --title `"OmniRoute Dev`" -d `"$repo`" `"$psPath`" -NoExit -EncodedCommand $encoded"
Start-Process wt -ArgumentList $wtArgs

Write-Host "OmniRoute launching at http://localhost:20128 (~10-30s)"
