$REPO = "C:\D\oriz\repos\own\agent-skills"
$targets = @(
  "C:\Users\C5420321\.gemini\skills",
  "C:\Users\C5420321\.cline\skills",
  "C:\Users\C5420321\.config\opencode\skills",
  "C:\Users\C5420321\.kilocode\skills"
)
foreach ($t in $targets) {
  $parent = Split-Path $t -Parent
  if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
  if (Test-Path $t) {
    Write-Host "EXISTS already: $t"
    continue
  }
  New-Item -ItemType Junction -Path $t -Target $REPO | Out-Null
  Write-Host "Created junction: $t -> $REPO"
}
