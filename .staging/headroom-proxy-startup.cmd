@echo off
REM Headroom proxy launcher — invoked by Task Scheduler at logon.
REM ASR-safe: calls pipx venv python.exe directly with -c wrapper (no headroom.exe shim).
REM
REM Hr→hai chain: ANTHROPIC_TARGET_API_URL forwards /v1/messages to the hai
REM Desktop App at :6655 (SAP corp auth + custom-domain routing). hai then
REM proxies to Anthropic. Confirmed against Headroom 0.19 source at
REM headroom/proxy/handlers/anthropic.py:1388 (uses self.ANTHROPIC_API_URL
REM which is hydrated from ANTHROPIC_TARGET_API_URL via providers/registry.py).
set "LOG=%USERPROFILE%\headroom.log"
set "ANTHROPIC_TARGET_API_URL=http://localhost:6655/anthropic"
echo. >> "%LOG%"
echo [%DATE% %TIME%] HeadroomProxyAtLogin start (pid=%RANDOM%) upstream=%ANTHROPIC_TARGET_API_URL% >> "%LOG%"
"C:\Users\C5420321\pipx\venvs\headroom-ai\Scripts\python.exe" -c "from headroom.cli import main; import sys; sys.argv=['headroom','proxy','--port','8787']; main()" >> "%LOG%" 2>&1
echo [%DATE% %TIME%] HeadroomProxyAtLogin exit code=%ERRORLEVEL% >> "%LOG%"
