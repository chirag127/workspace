$WshShell = New-Object -ComObject WScript.Shell
$lnkPath = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup\DockerDesktop.lnk'
$shortcut = $WshShell.CreateShortcut($lnkPath)
$shortcut.TargetPath = 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
$shortcut.WorkingDirectory = 'C:\Program Files\Docker\Docker'
$shortcut.Description = 'Docker Desktop (auto-start at login for headroom-proxy chain)'
$shortcut.Save()
Write-Host "Created: $lnkPath"
Test-Path $lnkPath
