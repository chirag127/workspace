# Apply service / autostart trims
# Run as Administrator. Idempotent (Disabled-set is fine to re-run).
# Rollback: apply-services-rollback.ps1

$ErrorActionPreference = 'Continue'
Start-Transcript -Path "C:\Users\C5420321\AppData\Local\Temp\trim-out.txt" -Force | Out-Null

function Disable-Svc($name) {
    $svc = Get-Service -Name $name -ErrorAction SilentlyContinue
    if (-not $svc) { Write-Host "[SKIP] $name not found" -ForegroundColor DarkGray; return }
    if ($svc.Status -eq 'Running') {
        try { Stop-Service -Name $name -Force -ErrorAction Stop; Write-Host "[STOP] $name" -ForegroundColor Yellow }
        catch { Write-Host "[STOP-FAIL] $name : $_" -ForegroundColor Red }
    }
    try { Set-Service -Name $name -StartupType Disabled -ErrorAction Stop; Write-Host "[DISABLE] $name" -ForegroundColor Green }
    catch { Write-Host "[DISABLE-FAIL] $name : $_" -ForegroundColor Red }
}

function Manual-Svc($name) {
    $svc = Get-Service -Name $name -ErrorAction SilentlyContinue
    if (-not $svc) { Write-Host "[SKIP] $name not found" -ForegroundColor DarkGray; return }
    if ($svc.Status -eq 'Running') {
        try { Stop-Service -Name $name -Force -ErrorAction Stop; Write-Host "[STOP] $name" -ForegroundColor Yellow }
        catch { Write-Host "[STOP-FAIL] $name : $_" -ForegroundColor Red }
    }
    try { Set-Service -Name $name -StartupType Manual -ErrorAction Stop; Write-Host "[MANUAL] $name" -ForegroundColor Cyan }
    catch { Write-Host "[MANUAL-FAIL] $name : $_" -ForegroundColor Red }
}

function Disable-Task($path, $name) {
    try {
        Disable-ScheduledTask -TaskPath $path -TaskName $name -ErrorAction Stop | Out-Null
        Write-Host "[TASK-OFF] $path$name" -ForegroundColor Green
    } catch { Write-Host "[TASK-FAIL] $path$name : $_" -ForegroundColor Red }
}

function Remove-RunKey($hive, $name) {
    $key = "$hive\Software\Microsoft\Windows\CurrentVersion\Run"
    try {
        Remove-ItemProperty -Path $key -Name $name -ErrorAction Stop
        Write-Host "[RUN-DEL] $hive : $name" -ForegroundColor Green
    } catch { Write-Host "[RUN-SKIP] $hive : $name (not present)" -ForegroundColor DarkGray }
}

function Remove-StartupFile($path) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Force
        Write-Host "[STARTUP-DEL] $path" -ForegroundColor Green
    } else { Write-Host "[STARTUP-SKIP] $path" -ForegroundColor DarkGray }
}

Write-Host "`n=== Services -> Disabled ===" -ForegroundColor Cyan
$disable = @(
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
    'ndinit'
)
$disable | ForEach-Object { Disable-Svc $_ }

Write-Host "`n=== Services -> Manual ===" -ForegroundColor Cyan
Manual-Svc 'vmms'

Write-Host "`n=== Scheduled tasks -> Disabled ===" -ForegroundColor Cyan
Disable-Task '\' 'AgentsMdSync'
Disable-Task '\Microsoft\Office\' 'Office Actions Server'
Disable-Task '\Microsoft\Office\' 'Office Automatic Updates 2.0'
Disable-Task '\Microsoft\Office\' 'Office Background Push Maintenance'
Disable-Task '\Microsoft\Office\' 'Office Feature Updates Logon'
Disable-Task '\Microsoft\Office\' 'Office Startup Maintenance'

Write-Host "`n=== HKCU Run keys removed ===" -ForegroundColor Cyan
Remove-RunKey 'HKCU:' 'Microsoft Edge Update'
Remove-RunKey 'HKCU:' 'BraveSoftware Update'

Write-Host "`n=== Startup folder cleanup ===" -ForegroundColor Cyan
Remove-StartupFile "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\HeadroomWatchdog.cmd"
Remove-StartupFile "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\MSN Weather.lnk"

Write-Host "`nDone. Reboot recommended (not required)." -ForegroundColor Green
Stop-Transcript | Out-Null
