@echo off
REM ============================================================
REM  install-agents.cmd
REM
REM  Installs the free coding agents wired to this workspace:
REM    - Claude Code   (already installed; verifies only)
REM    - OpenCode      (npm i -g opencode-ai)
REM    - Kilo Code     (VS Code ext kilocode.Kilo-Code)
REM    - ZCode         (GUI IDE; verifies install + wires skills)
REM    - Antigravity   (manual install from https://antigravity.google.com/)
REM    - Codeep        (npm i -g codeep@latest)
REM    - Claurst       (npm i -g claurst)
REM    - gocode        (binary download to ~/bin)
REM    - Coddy         (binary download to ~/bin)
REM
REM  Also wires user-global skill junctions for all agents.
REM  Workspace root is NOT modified (workspace-root-cleanliness rule).
REM  All rules live in C:\D\oriz\AGENTS.md (workspace source of truth)
REM
REM  Idempotent. Self-elevates.
REM ============================================================
setlocal

net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
  echo [bootstrap] re-launching as admin...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd -ArgumentList '/c %~f0 %*' -Verb RunAs"
  exit /b
)

where pwsh >nul 2>&1
if %ERRORLEVEL% EQU 0 (set "PS=pwsh") else (set "PS=powershell")

%PS% -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-agents.ps1" %*
set "RC=%ERRORLEVEL%"

echo.
echo ============================================================
if "%RC%"=="0" (
  echo  DONE. Exit code: 0
) else (
  echo  FAILED. Exit code: %RC%
)
echo  Window auto-closes in 30 s. Press any key to close now.
echo ============================================================
REM /NOBREAK = ignore Ctrl-C as "skip" (any other key still skips).
REM No "beep" or bell character anywhere, so Windows alert sound stays silent.
timeout /T 30 /NOBREAK >nul

exit /b %RC%

