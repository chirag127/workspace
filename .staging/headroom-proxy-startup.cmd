@echo off
REM Headroom proxy launcher — invoked by Task Scheduler at logon.
REM ASR-safe: calls pipx venv python.exe directly with -c wrapper (no headroom.exe shim).
set "LOG=%USERPROFILE%\headroom.log"
echo. >> "%LOG%"
echo [%DATE% %TIME%] HeadroomProxyAtLogin start (pid=%RANDOM%) >> "%LOG%"
"C:\Users\C5420321\pipx\venvs\headroom-ai\Scripts\python.exe" -c "from headroom.cli import main; import sys; sys.argv=['headroom','proxy','--port','8787']; main()" >> "%LOG%" 2>&1
echo [%DATE% %TIME%] HeadroomProxyAtLogin exit code=%ERRORLEVEL% >> "%LOG%"
