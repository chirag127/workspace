$startup = [Environment]::GetFolderPath('Startup')
$path = Join-Path $startup 'DockerDesktop.lnk'
$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($path)
$sc.TargetPath = 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
$sc.WorkingDirectory = 'C:\Program Files\Docker\Docker'
$sc.Save()
Write-Output $path
