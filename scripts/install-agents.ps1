<#
.SYNOPSIS
  Install coding agents wired to this workspace.
  Also wires user-global skill junctions for all agents.
  Workspace root is NOT modified (workspace-root-cleanliness rule).
  All rules live in C:\D\oriz\AGENTS.md.

  Fleet (10 agents, 8 installed + 2 pending):
    - Claude Code, ZCode, OpenCode, Kilo Code, Antigravity, MiMoCode
    - Codeep, Claurst, gocode, Coddy (new free CLI/TUI agents)
    - Crab Code (pending: needs Rust/Cargo)
    - free-code (pending: Linux/macOS only)
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Suppress the noisy IWR progress bar (135 MB MSIX download streams 100k+
# lines otherwise and hides real errors).
$ProgressPreference = 'SilentlyContinue'

function Step($m) { Write-Host "`n=== $m ===" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  [ok] $m"   -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m"   -ForegroundColor Yellow }
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

$Workspace = 'C:\D\oriz'

# ── 0. winget ─────────────────────────────────────────────────────────────
Step '0. winget'
if (-not (Have winget)) {
  Warn 'winget missing. Installing App Installer (Microsoft.DesktopAppInstaller)...'
  $msix = Join-Path $env:TEMP 'AppInstaller.msixbundle'

  # Cache: skip 135 MB redownload if previously fetched.
  $needDownload = $true
  if (Test-Path $msix) {
    $sizeMB = [math]::Round((Get-Item $msix).Length / 1MB, 1)
    if ($sizeMB -gt 50) {
      Ok ("Reusing cached MSIX at $msix ($sizeMB MB)")
      $needDownload = $false
    } else {
      Remove-Item $msix -Force
    }
  }
  if ($needDownload) {
    Write-Host '  Downloading App Installer (~135 MB)...' -ForegroundColor DarkGray
    try {
      Invoke-WebRequest -UseBasicParsing -Uri 'https://aka.ms/getwinget' -OutFile $msix
    } catch {
      throw "MSIX download failed: $($_.Exception.Message). Check internet, or download manually from https://aka.ms/getwinget and place at $msix"
    }
  }

  Write-Host '  Installing MSIX...' -ForegroundColor DarkGray
  try {
    Add-AppxPackage -Path $msix -ForceApplicationShutdown -ErrorAction Stop
  } catch {
    throw "Add-AppxPackage failed: $($_.Exception.Message). Corporate policy may block AppX install. Try installing 'App Installer' from Microsoft Store manually: https://www.microsoft.com/store/productId/9NBLGGH4NNS1"
  }
  $env:PATH = "$env:LOCALAPPDATA\Microsoft\WindowsApps;$env:PATH"
  if (-not (Have winget)) { throw 'winget install ran but command still not on PATH. Open a new cmd window and re-run.' }
}
Ok 'winget present'

# Helper: run a native cmd that prints progress to stderr without
# tripping PS's RemoteException-on-stderr behavior under strict mode.
function Invoke-Native($cmdline) {
  $prev = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    & cmd /c "$cmdline 2>&1" | Out-Host
    return $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $prev
  }
}

# ── 1. Node (for OpenCode) ────────────────────────────────────────────────
Step '1. Node.js'
if (-not (Have node)) {
  Invoke-Native 'winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements --disable-interactivity' | Out-Null
  $env:PATH = "$env:ProgramFiles\nodejs;$env:PATH"
}
Ok ('node: ' + ((node --version 2>&1) | Out-String).Trim())

# ── 2. Claude Code (verify only) ──────────────────────────────────────────
Step '2. Claude Code'
if (Have claude) {
  Ok ('claude: ' + ((claude --version 2>&1) | Out-String).Trim())
} else {
  Warn 'claude CLI not on PATH. (Already installed per session context; no install attempted.)'
}

# ── 3. OpenCode ───────────────────────────────────────────────────────────
Step '3. OpenCode'
if (-not (Have opencode)) {
  Invoke-Native 'npm install -g opencode-ai' | Out-Null
  # npm global bin (%APPDATA%\npm) often isn't on PATH for a fresh shell.
  # Refresh in-process so the Have-check below sees it.
  $npmBin = Join-Path $env:APPDATA 'npm'
  if (Test-Path $npmBin) { $env:PATH = "$npmBin;$env:PATH" }
}
if (Have opencode) {
  Ok ('opencode: ' + ((opencode --version 2>&1) | Select-Object -First 1 | Out-String).Trim())
} else {
  # Last-ditch: check the path directly even if PATH refresh didn't help.
  $opencodeCmd = Join-Path $env:APPDATA 'npm\opencode.cmd'
  if (Test-Path $opencodeCmd) {
    Ok ("opencode installed at $opencodeCmd (PATH refresh needed - open new cmd window)")
  } else {
    Warn 'opencode install failed'
  }
}

# ── 4. VS Code + Kilo Code ────────────────────────────────────────────────
Step '4. VS Code + Kilo Code'

# VS Code installs go to either system-wide or user-local. Check both.
$vsCodeBins = @(
  (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin'),
  (Join-Path $env:ProgramFiles  'Microsoft VS Code\bin')
)
foreach ($p in $vsCodeBins) {
  if (Test-Path $p) { $env:PATH = "$p;$env:PATH" }
}

if (-not (Have code)) {
  Invoke-Native 'winget install --id Microsoft.VisualStudioCode -e --silent --accept-source-agreements --accept-package-agreements --disable-interactivity' | Out-Null
  # Re-scan both possible install locations after winget.
  foreach ($p in $vsCodeBins) {
    if (Test-Path $p) { $env:PATH = "$p;$env:PATH" }
  }
}

if (Have code) {
  Ok ('code: ' + ((code --version 2>&1) | Select-Object -First 1 | Out-String).Trim())
  Invoke-Native 'code --install-extension kilocode.Kilo-Code --force'     | Out-Null
  Ok 'Kilo Code installed via VS Code'
} else {
  Warn ("code CLI not on PATH. Looked in:`n     " + ($vsCodeBins -join "`n     ") + "`n  Open a new cmd window (PATH refresh) and re-run if VS Code was just installed.")
}

# ── 5. Wire .kilocode/rules -> .agents/kilocode/rules ─────────────────────
# Kilo Code reads <repo>/.kilocode/rules/ - symlink that to .agents/kilocode/rules/
# so the pointer file is picked up.
Step '5. Workspace symlink for Kilo Code'
$kilocodeDir = Join-Path $Workspace '.kilocode'
$kilocodeRules = Join-Path $kilocodeDir 'rules'
$agentsKiloRules = Join-Path $Workspace '.agents\kilocode\rules'

if (-not (Test-Path $kilocodeDir)) {
  New-Item -ItemType Directory -Path $kilocodeDir -Force | Out-Null
}
if (Test-Path $kilocodeRules) {
  $item = Get-Item $kilocodeRules -Force
  if ($item.LinkType -eq 'SymbolicLink' -and $item.Target -eq $agentsKiloRules) {
    Ok 'Symlink already correct'
  } else {
    Warn ".kilocode\rules exists and is not the expected symlink. Leaving in place; please remove manually if you want it symlinked."
  }
} else {
  try {
    New-Item -ItemType SymbolicLink -Path $kilocodeRules -Target $agentsKiloRules -ErrorAction Stop | Out-Null
    Ok ('symlinked .kilocode\rules -> .agents\kilocode\rules')
  } catch {
    & cmd /c mklink /J "$kilocodeRules" "$agentsKiloRules" 2>&1 | Out-Host
    if (Test-Path $kilocodeRules) {
      Ok ('directory junction created .kilocode\rules -> .agents\kilocode\rules')
    } else {
      Warn 'Could not create symlink or junction. Kilo Code will not see the pointer until this is fixed.'
    }
  }
}

# ── 6. ZCode — verify install + wire ~/.zcode/AGENTS.md ───────────────────
Step '6. ZCode (verify + setup)'
$zcodeAgentsDir = Join-Path $env:USERPROFILE '.zcode'
$zcodeAgentsMd  = Join-Path $zcodeAgentsDir 'AGENTS.md'
if (-not (Test-Path $zcodeAgentsDir)) {
  New-Item -ItemType Directory -Path $zcodeAgentsDir -Force | Out-Null
}
# Link global AGENTS.md so ZCode picks up workspace rules cross-project.
if (-not (Test-Path $zcodeAgentsMd)) {
  $src = Join-Path $Workspace 'AGENTS.md'
  try {
    New-Item -ItemType HardLink -Path $zcodeAgentsMd -Target $src -ErrorAction Stop | Out-Null
    Ok "Linked ~/.zcode/AGENTS.md -> $src"
  } catch {
    Copy-Item $src $zcodeAgentsMd
    Ok "Copied AGENTS.md to ~/.zcode/AGENTS.md (hard-link failed; update manually when AGENTS.md changes)"
  }
} else {
  Ok '~/.zcode/AGENTS.md already exists'
}
# Check if ZCode is installed (it's a GUI app — no CLI to check, look for the exe)
$zcodeExes = @(
  (Join-Path $env:LOCALAPPDATA 'Programs\ZCode\ZCode.exe'),
  (Join-Path $env:ProgramFiles  'ZCode\ZCode.exe')
)
$zcodeFound = $zcodeExes | Where-Object { Test-Path $_ }
if ($zcodeFound) {
  Ok "ZCode found at: $($zcodeFound | Select-Object -First 1)"
} else {
  Warn 'ZCode not found. Install manually from https://zcode.z.ai/ then re-run this script.'
}

# ── 7. Codeep ──────────────────────────────────────────────────────────
Step '7. Codeep'
if (-not (Have codeep)) {
  Invoke-Native 'npm install -g codeep@latest' | Out-Null
}
if (Have codeep) {
  Ok ('codeep: ' + ((codeep --version 2>&1) | Out-String).Trim())
} else {
  Warn 'codeep install failed'
}

# ── 8. Claurst ──────────────────────────────────────────────────────────
Step '8. Claurst'
if (-not (Have claurst)) {
  Invoke-Native 'npm install -g claurst' | Out-Null
}
if (Have claurst) {
  Ok ('claurst: ' + ((claurst --version 2>&1) | Out-String).Trim())
} else {
  Warn 'claurst install failed'
}

# ── 9. gocode (binary to ~/bin) ─────────────────────────────────────────
Step '9. gocode'
$gocodeExe = Join-Path $env:USERPROFILE 'bin\gocode.exe'
if (-not (Have gocode) -and -not (Test-Path $gocodeExe)) {
  $gocodeZip = Join-Path $env:TEMP 'gocode.zip'
  $gocodeUrl = 'https://github.com/AlleyBo55/gocode/releases/download/v0.9.0/gocode_0.9.0_windows_amd64.zip'
  Write-Host '  Downloading gocode...' -ForegroundColor DarkGray
  Invoke-WebRequest -UseBasicParsing -Uri $gocodeUrl -OutFile $gocodeZip
  Expand-Archive -Path $gocodeZip -DestinationPath (Join-Path $env:USERPROFILE 'bin') -Force
  Remove-Item $gocodeZip -Force
  # Refresh PATH
  $env:PATH = "$env:USERPROFILE\bin;$env:PATH"
}
if (Have gocode) {
  Ok ('gocode: ' + ((gocode --version 2>&1) | Out-String).Trim())
} elseif (Test-Path $gocodeExe) {
  Ok "gocode installed at $gocodeExe (restart terminal if not on PATH)"
} else {
  Warn 'gocode install failed'
}

# ── 10. Coddy (binary to ~/bin) ──────────────────────────────────────────
Step '10. Coddy'
$coddyExe = Join-Path $env:USERPROFILE 'bin\coddy.exe'
if (-not (Have coddy) -and -not (Test-Path $coddyExe)) {
  $coddyZip = Join-Path $env:TEMP 'coddy.zip'
  $coddyUrl = 'https://github.com/coddy-project/coddy-agent/releases/download/0.9.26/coddy_0.9.26_windows_amd64.zip'
  Write-Host '  Downloading Coddy...' -ForegroundColor DarkGray
  Invoke-WebRequest -UseBasicParsing -Uri $coddyUrl -OutFile $coddyZip
  Expand-Archive -Path $coddyZip -DestinationPath (Join-Path $env:USERPROFILE 'bin') -Force
  Remove-Item $coddyZip -Force
  # Refresh PATH
  $env:PATH = "$env:USERPROFILE\bin;$env:PATH"
}
if (Have coddy) {
  Ok ('coddy: ' + ((coddy --version 2>&1) | Out-String).Trim())
} elseif (Test-Path $coddyExe) {
  Ok "coddy installed at $coddyExe (restart terminal if not on PATH)"
} else {
  Warn 'coddy install failed'
}

# ── 11. Wire user-global skill junctions (all agents) ───────────────────
Step '11. Wire user-global skill junctions'
node (Join-Path $Workspace 'scripts\wire-agent-skills-junctions.mjs')
if ($LASTEXITCODE -eq 0) {
  Ok 'Skill junctions wired'
} else {
  Warn 'Some skill junctions failed — check output above'
}

# ── 12. Summary ───────────────────────────────────────────────────────────
Step '12. Done'
Write-Host ''
Write-Host '  Workspace source of truth: C:\D\oriz\AGENTS.md' -ForegroundColor Green
Write-Host ''
Write-Host '  Agents wired (10 total, 8 installed + 2 pending):'
Write-Host '    - Claude Code (reads C:\D\oriz\CLAUDE.md + AGENTS.md)'         -ForegroundColor Green
Write-Host '    - ZCode       (reads ~/.zcode/AGENTS.md + C:\D\oriz\AGENTS.md)' -ForegroundColor Green
Write-Host '    - OpenCode    (reads C:\D\oriz\AGENTS.md)'                      -ForegroundColor Green
Write-Host '    - Kilo Code   (reads C:\D\oriz\.kilocode\rules\)'               -ForegroundColor Green
Write-Host '    - MiMoCode    (reads C:\D\oriz\AGENTS.md + CLAUDE.md)'          -ForegroundColor Green
Write-Host '    - Antigravity (install manually; reads C:\D\oriz\AGENTS.md)'    -ForegroundColor Green
Write-Host '    - Codeep      (reads .codeep/agents/ + C:\D\oriz\AGENTS.md)'   -ForegroundColor Green
Write-Host '    - Claurst     (ACP protocol; reads C:\D\oriz\AGENTS.md)'        -ForegroundColor Green
Write-Host '    - gocode      (binary in ~/bin; reads C:\D\oriz\AGENTS.md)'    -ForegroundColor Green
Write-Host '    - Coddy       (binary in ~/bin; reads C:\D\oriz\AGENTS.md)'    -ForegroundColor Green
Write-Host '  Pending:' -ForegroundColor Yellow
Write-Host '    - Crab Code   (needs Rust/Cargo)'                               -ForegroundColor Yellow
Write-Host '    - free-code   (Linux/macOS only)'                               -ForegroundColor Yellow
Write-Host ''
Write-Host '  Skill junctions (user-global, not in workspace root):' -ForegroundColor DarkGray
Write-Host '    ~/.claude/skills/, ~/.config/opencode/skills/, ~/.kilocode/skills/' -ForegroundColor DarkGray
Write-Host '    ~/.zcode/skills/, ~/.config/mimocode/skills/, ~/.gemini/skills/' -ForegroundColor DarkGray
Write-Host ''
