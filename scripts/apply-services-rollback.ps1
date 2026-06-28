# Rollback for apply-services-trim.ps1
# Sets disabled services back to Automatic, vmms back to Automatic,
# re-enables scheduled tasks. Run as Administrator.
# Does NOT restore deleted Run-key values or startup files — those are listed
# at the bottom for manual restoration if you want them.

$ErrorActionPreference = 'Continue'

function Auto-Svc($name) {
    $svc = Get-Service -Name $name -ErrorAction SilentlyContinue
    if (-not $svc) { Write-Host "[SKIP] $name not found" -ForegroundColor DarkGray; return }
    try { Set-Service -Name $name -StartupType Automatic -ErrorAction Stop; Write-Host "[AUTO] $name" -ForegroundColor Green }
    catch { Write-Host "[AUTO-FAIL] $name : $_" -ForegroundColor Red }
}

function Enable-Task($path, $name) {
    try {
        Enable-ScheduledTask -TaskPath $path -TaskName $name -ErrorAction Stop | Out-Null
        Write-Host "[TASK-ON] $path$name" -ForegroundColor Green
    } catch { Write-Host "[TASK-FAIL] $path$name : $_" -ForegroundColor Red }
}

Write-Host "`n=== Services -> Automatic ===" -ForegroundColor Cyan
$restore = @(
    'Spooler',
    'cpsvc',
    'SQLWriter',
    'PlanetVPNService',
    'MapsBroker',
    'GoogleUpdaterService150.0.7863.0',
    'GoogleUpdaterInternalService150.0.7863.0',
    'edgeupdate',
    'DiagTrack',
    'InventorySvc',
    'WSAIFabricSvc',
    'ClickToRunSvc',
    'FlexeraDockerMon',
    'mgssecsvc',
    'ndinit',
    'vmms'
)
$restore | ForEach-Object { Auto-Svc $_ }

Write-Host "`n=== Scheduled tasks -> Enabled ===" -ForegroundColor Cyan
Enable-Task '\' 'AgentsMdSync'
Enable-Task '\Microsoft\Office\' 'Office Actions Server'
Enable-Task '\Microsoft\Office\' 'Office Automatic Updates 2.0'
Enable-Task '\Microsoft\Office\' 'Office Background Push Maintenance'
Enable-Task '\Microsoft\Office\' 'Office Feature Updates Logon'
Enable-Task '\Microsoft\Office\' 'Office Startup Maintenance'

Write-Host @'

=== Manual restoration (if needed) ===
HKCU Run keys removed by apply-services-trim.ps1:
  Microsoft Edge Update  -> "C:\Users\C5420321\AppData\Local\Microsoft\EdgeUpdate\1.3.241.15\MicrosoftEdgeUpdateCore.exe"
  BraveSoftware Update   -> "C:\Users\C5420321\AppData\Local\BraveSoftware\Update\1.3.361.151\BraveUpdateCore.exe"
Startup files removed:
  %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\HeadroomWatchdog.cmd
  %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\MSN Weather.lnk
'@ -ForegroundColor Yellow
