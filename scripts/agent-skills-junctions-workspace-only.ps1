$REPO = "C:\D\oriz\repos\own\agent-skills"
$workspace = "C:\D\oriz"

# 1. Delete global skill dirs + backups
$globals = @(
  "C:\Users\C5420321\.claude\skills",
  "C:\Users\C5420321\.gemini\skills",
  "C:\Users\C5420321\.cline\skills",
  "C:\Users\C5420321\.config\opencode\skills",
  "C:\Users\C5420321\.kilocode\skills"
)
foreach ($g in $globals) {
  if (Test-Path $g) {
    $item = Get-Item $g -Force
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
      cmd /c rmdir $g
      Write-Host "Removed junction: $g"
    } else {
      Remove-Item -Path $g -Recurse -Force
      Write-Host "Removed real dir: $g"
    }
  }
}

# Delete backup dirs
$backups = @(
  "C:\Users\C5420321\.gemini\skills-backup-20260628-212053",
  "C:\Users\C5420321\.cline\skills-backup-20260628-212053",
  "C:\Users\C5420321\.config\opencode\skills-backup-20260628-212053",
  "C:\D\oriz\.agents\skills-backup-2026-06-28",
  "C:\Users\C5420321\.claude\skills-archive"
)
foreach ($b in $backups) {
  if (Test-Path $b) {
    Remove-Item -Path $b -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Removed backup: $b"
  }
}

# 2. Create 4 workspace-local junctions
$jpaths = @(
  "C:\D\oriz\.claude\skills",
  "C:\D\oriz\.opencode\skills",
  "C:\D\oriz\.kilocode\skills",
  "C:\D\oriz\.gemini\skills"
)
foreach ($j in $jpaths) {
  $parent = Split-Path $j -Parent
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
  if (Test-Path $j) {
    $item = Get-Item $j -Force
    if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
      cmd /c rmdir $j
    } else {
      Remove-Item $j -Recurse -Force
    }
  }
  New-Item -ItemType Junction -Path $j -Target $REPO | Out-Null
  Write-Host "Junction: $j -> $REPO"
}

Write-Host "`nDone."
