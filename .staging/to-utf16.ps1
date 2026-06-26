$c = Get-Content -Raw -Encoding UTF8 'c:\D\oriz\.staging\docker-headroom-ensure.xml'
[System.IO.File]::WriteAllText('c:\D\oriz\.staging\docker-headroom-ensure.xml', $c, [System.Text.Encoding]::Unicode)
Write-Host "converted"
