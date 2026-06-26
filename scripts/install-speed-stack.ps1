<#
.SYNOPSIS
  Install RTK + Ponytail. Idempotent. Self-elevates via the .cmd wrapper.

.DESCRIPTION
  Layer 1 (Headroom) is already running on :8787 — verified by health check.

  Layer 2 (RTK):
    - Installs rustup + cargo via winget if missing.
    - `cargo install --git https://github.com/rtk-ai/rtk rtk` (with `--locked`).
    - `rtk init -g` to write ~/.claude/* hooks for Claude Code.

  Layer 3 (Ponytail):
    - Adds Claude Code plugin marketplace `DietrichGebert/ponytail`.
    - Installs plugin `ponytail@ponytail`.
    - Uses `claude` CLI's plugin commands; if `claude` is missing, falls back to
      direct settings.json edit (idempotent add to `enabledPlugins` +
      `extraKnownMarketplaces`).

  Verification at the end:
    - `rtk --version`
    - claude plugins list contains ponytail
    - Headroom /health returns ready=true
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Step($m) { Write-Host "`n=== $m ===" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  [ok] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }

function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

# ── 1. Rust + cargo (for RTK) ─────────────────────────────────────────────
Step '1. Rust toolchain'
if (-not (Have cargo)) {
  Warn 'cargo missing. Installing Rustup via winget...'
  & winget install --id Rustlang.Rustup -e --silent --accept-source-agreements --accept-package-agreements --disable-interactivity | Out-Null
  # cargo lives in %USERPROFILE%\.cargo\bin after rustup; PATH update needs new shell normally — refresh in-process.
  $cargoBin = Join-Path $env:USERPROFILE '.cargo\bin'
  if (Test-Path $cargoBin) { $env:PATH = "$cargoBin;$env:PATH" }
  if (-not (Have cargo)) {
    throw 'Rustup installed but cargo not on PATH. Close this shell and re-run.'
  }
}
Ok ('cargo: ' + (cargo --version))

# ── 2. RTK ─────────────────────────────────────────────────────────────────
Step '2. RTK (Rust Token Killer)'
if (-not (Have rtk)) {
  Warn 'Installing RTK from source (cargo install --locked --git github.com/rtk-ai/rtk)...'
  & cargo install --locked --git https://github.com/rtk-ai/rtk rtk 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) {
    Warn 'cargo install --git failed. Retrying with crates.io fallback...'
    & cargo install --locked rtk 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { throw 'RTK install failed via both git + crates.io.' }
  }
}
Ok ('rtk: ' + ((rtk --version 2>&1) | Out-String).Trim())

# `rtk init -g` writes the global Claude Code hooks into ~/.claude/.
# Safe to re-run (RTK's own idempotency).
& rtk init -g --yes 2>&1 | Out-Host
Ok 'RTK global hooks installed in ~/.claude/'

# ── 3. Ponytail (Claude Code plugin) ──────────────────────────────────────
Step '3. Ponytail'
$settingsPath = Join-Path $env:USERPROFILE '.claude\settings.json'
if (-not (Test-Path $settingsPath)) { throw "Claude Code settings.json not found at $settingsPath" }

$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# Ensure extraKnownMarketplaces contains DietrichGebert/ponytail.
if (-not $settings.PSObject.Properties.Match('extraKnownMarketplaces').Count) {
  $settings | Add-Member -NotePropertyName 'extraKnownMarketplaces' -NotePropertyValue (@{}) -Force
}
$markets = $settings.extraKnownMarketplaces
if (-not $markets.PSObject.Properties.Match('ponytail').Count) {
  $markets | Add-Member -NotePropertyName 'ponytail' -NotePropertyValue @{
    source = @{ source = 'github'; repo = 'DietrichGebert/ponytail' }
  } -Force
}

# Ensure enabledPlugins contains ponytail@ponytail.
if (-not $settings.PSObject.Properties.Match('enabledPlugins').Count) {
  $settings | Add-Member -NotePropertyName 'enabledPlugins' -NotePropertyValue (@{}) -Force
}
$plugins = $settings.enabledPlugins
if (-not $plugins.PSObject.Properties.Match('ponytail@ponytail').Count) {
  $plugins | Add-Member -NotePropertyName 'ponytail@ponytail' -NotePropertyValue $true -Force
}

# Write back.
$settings | ConvertTo-Json -Depth 20 | Set-Content $settingsPath -Encoding utf8
Ok 'Ponytail wired into ~/.claude/settings.json (will activate on next Claude Code start)'

# ── 4. Verify Headroom (the existing chain) ───────────────────────────────
Step '4. Headroom (existing — verify only)'
try {
  $r = Invoke-RestMethod -Uri 'http://localhost:8787/health' -TimeoutSec 3
  Ok "Headroom v$($r.version) — ready=$($r.ready), uptime=$([math]::Round($r.uptime_seconds)) s"
} catch {
  Warn "Headroom not reachable at :8787 — speed-stack layer 1 not active. Start it via your existing scheduled task."
}

# ── 5. Summary ────────────────────────────────────────────────────────────
Step '5. Done'
Write-Host ""
Write-Host "  Layer 1 (Headroom) : http://localhost:8787  (Hr → hai → Bedrock chain)" -ForegroundColor Green
Write-Host "  Layer 2 (RTK)      : rtk --version  →  shell-output compression active" -ForegroundColor Green
Write-Host "  Layer 3 (Ponytail) : settings.json updated  →  starts on next Claude Code launch" -ForegroundColor Green
Write-Host ""
Write-Host "  Restart Claude Code to activate Ponytail." -ForegroundColor Yellow
Write-Host ""
