@echo off
setlocal enableextensions enabledelayedexpansion
rem ============================================================
rem install-auto-start.cmd
rem Register Windows Task Scheduler entries for Headroom + cavemem
rem at user logon. Idempotent: re-running replaces existing tasks.
rem ============================================================

set "SCRIPT_DIR=%~dp0"
set "AUTO_DIR=%SCRIPT_DIR%auto-start"
set "HR_XML_SRC=%AUTO_DIR%\headroom-task.xml"
set "CM_XML_SRC=%AUTO_DIR%\cavemem-task.xml"
set "HR_XML_OUT=%AUTO_DIR%\.headroom-task.rendered.xml"
set "CM_XML_OUT=%AUTO_DIR%\.cavemem-task.rendered.xml"
set "HR_TASK=Oriz-Headroom-Login"
set "CM_TASK=Oriz-Cavemem-Login"
set "HR_CONTAINER=headroom-proxy"

echo.
echo === Oriz auto-start installer ===
echo.

rem ---------- pre-flight ----------
echo [1/6] Pre-flight checks...

where docker >nul 2>&1
if errorlevel 1 (
  echo ERROR: docker not on PATH. Install Docker Desktop first.
  exit /b 1
)

for /f "delims=" %%N in ('docker ps -a --filter "name=^%HR_CONTAINER%$" --format "{{.Names}}" 2^>nul') do set "FOUND_HR=%%N"
if not "!FOUND_HR!"=="%HR_CONTAINER%" (
  echo ERROR: Docker container "%HR_CONTAINER%" not found.
  echo        Run scripts\headroom-ensure.ps1 to create it first.
  exit /b 1
)

where cavemem >nul 2>&1
if errorlevel 1 (
  echo ERROR: cavemem not on PATH. Install with: npm i -g cavemem
  exit /b 1
)

rem Find cavemem.cmd absolute path (Task Scheduler needs absolute)
set "CAVEMEM_PATH="
for /f "delims=" %%P in ('where cavemem.cmd 2^>nul') do (
  if not defined CAVEMEM_PATH set "CAVEMEM_PATH=%%P"
)
if not defined CAVEMEM_PATH (
  for /f "delims=" %%P in ('where cavemem 2^>nul') do (
    if not defined CAVEMEM_PATH set "CAVEMEM_PATH=%%P"
  )
)
if not defined CAVEMEM_PATH (
  echo ERROR: could not resolve cavemem absolute path.
  exit /b 1
)

echo   docker: OK
echo   container %HR_CONTAINER%: OK
echo   cavemem: !CAVEMEM_PATH!

rem ---------- render XMLs (substitute placeholders + write UTF-16 LE) ----------
echo.
echo [2/6] Rendering task XML files...

set "FULL_USER=%USERDOMAIN%\%USERNAME%"
if not defined USERDOMAIN set "FULL_USER=%USERNAME%"

rem PowerShell handles substitution + UTF-16 LE encoding (schtasks requirement)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$u=$env:FULL_USER; $up=$env:USERPROFILE; $cm=$env:CAVEMEM_PATH;" ^
  "(Get-Content -Raw -Path $env:HR_XML_SRC) -replace 'USER_PLACEHOLDER',$u | Set-Content -Encoding Unicode -NoNewline -Path $env:HR_XML_OUT;" ^
  "((Get-Content -Raw -Path $env:CM_XML_SRC) -replace 'USER_PLACEHOLDER',$u -replace 'CAVEMEM_PLACEHOLDER',$cm -replace 'USERPROFILE_PLACEHOLDER',$up) | Set-Content -Encoding Unicode -NoNewline -Path $env:CM_XML_OUT"
if errorlevel 1 (
  echo ERROR: XML render failed.
  exit /b 1
)
echo   rendered: !HR_XML_OUT!
echo   rendered: !CM_XML_OUT!

rem ---------- register tasks (idempotent via /f) ----------
echo.
echo [3/6] Registering "%HR_TASK%"...
schtasks /create /tn "%HR_TASK%" /xml "%HR_XML_OUT%" /f >nul
if errorlevel 1 (
  echo ERROR: failed to register %HR_TASK%.
  exit /b 1
)
echo   OK

echo.
echo [4/6] Registering "%CM_TASK%"...
schtasks /create /tn "%CM_TASK%" /xml "%CM_XML_OUT%" /f >nul
if errorlevel 1 (
  echo ERROR: failed to register %CM_TASK%.
  exit /b 1
)
echo   OK

rem ---------- verify ----------
echo.
echo [5/6] Verifying...
schtasks /query /tn "%HR_TASK%" /fo LIST | findstr /C:"Status:" /C:"TaskName:"
schtasks /query /tn "%CM_TASK%" /fo LIST | findstr /C:"Status:" /C:"TaskName:"

rem ---------- test run ----------
echo.
echo [6/6] Test-running both tasks...
schtasks /run /tn "%HR_TASK%" >nul
schtasks /run /tn "%CM_TASK%" >nul
echo   triggered; waiting 5s...
ping -n 6 127.0.0.1 >nul

echo.
echo --- post-run state ---
docker ps --filter "name=%HR_CONTAINER%" --filter "status=running" --format "  docker: {{.Names}} {{.Status}}"
tasklist /fi "imagename eq node.exe" /v 2>nul | findstr /I "cavemem" >nul && echo   cavemem: worker process found || echo   cavemem: check with 'cavemem status'

echo.
echo === DONE. To uninstall: scripts\uninstall-auto-start.cmd ===
endlocal
exit /b 0
