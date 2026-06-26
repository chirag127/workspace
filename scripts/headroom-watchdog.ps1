# headroom-watchdog.ps1
# Pings Hr /health every 60s. Restart container on 3 consecutive failures.
param(
  [int]$IntervalSec = 60,
  [int]$Threshold = 3,
  [int]$RestartGraceSec = 30,
  [string]$DockerExe = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe',
  [string]$ContainerName = 'headroom-proxy',
  [string]$LogPath = "$env:USERPROFILE\headroom-watchdog.log"
)
$ErrorActionPreference = 'Continue'
$failCount = 0
function Log([string]$msg) {
  $ts = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  "$ts $msg" | Out-File -Append -FilePath $LogPath -Encoding utf8
}
Log "Watchdog started (interval=${IntervalSec}s, threshold=$Threshold)"
while ($true) {
  try {
    $r = Invoke-WebRequest -Uri 'http://localhost:8787/health' -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
    if ($r.StatusCode -eq 200) { $failCount = 0 } else { $failCount++; Log "HTTP $($r.StatusCode) ($failCount/$Threshold)" }
  } catch { $failCount++; Log "Ping failed: $($_.Exception.Message) ($failCount/$Threshold)" }
  if ($failCount -ge $Threshold) {
    Log "RESTARTING $ContainerName after $failCount failures"
    & $DockerExe restart $ContainerName 2>&1 | ForEach-Object { Log "  docker: $_" }
    $failCount = 0
    Start-Sleep -Seconds $RestartGraceSec
  }
  Start-Sleep -Seconds $IntervalSec
}
