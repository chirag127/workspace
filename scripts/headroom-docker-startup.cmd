@echo off
REM Auto-start Headroom Docker container at Windows login
REM Installed via: schtasks /Create /SC ONLOGON /TN "HeadroomDockerProxy" /TR "C:\D\oriz\scripts\headroom-docker-startup.cmd" /DELAY 0000:30 /F

set DOCKER="C:\Program Files\Docker\Docker\resources\bin\docker.exe"
set CONTAINER=headroom-proxy

echo [%DATE% %TIME%] Starting Headroom Docker proxy...

REM Ensure Docker Desktop is running
%WINDIR%\System32\timeout.exe /t 15 /nobreak >nul

REM Check if container exists
%DOCKER% inspect %CONTAINER% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Container exists. Starting...
    %DOCKER% start %CONTAINER%
) else (
    echo Container missing. Creating...
    %DOCKER% run -d --name %CONTAINER% --restart unless-stopped -p 8787:8787 -e ANTHROPIC_TARGET_API_URL=http://host.docker.internal:6655/anthropic chops/headroom:latest proxy --port 8787
)

echo Done.