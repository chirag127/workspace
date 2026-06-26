@echo off
REM ============================================================
REM  install-speed-stack.cmd — auto-install RTK + Ponytail.
REM
REM  Headroom is already in the proxy chain (Docker on :8787).
REM  This installs the other two layers: RTK (shell) + Ponytail (output).
REM
REM  Idempotent. Re-runs converge. Self-elevates for cargo/rustup install.
REM ============================================================
setlocal

REM ── Self-elevate ──
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  echo [bootstrap] re-launching as admin...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd -ArgumentList '/c %~f0 %*' -Verb RunAs"
  exit /b
)

where pwsh >nul 2>&1
if %ERRORLEVEL% EQU 0 (set "PS=pwsh") else (set "PS=powershell")

%PS% -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-speed-stack.ps1" %*
exit /b %ERRORLEVEL%
