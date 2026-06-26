@echo off
REM Wrapper for HeadroomWatchdog scheduled task
start "" /min powershell.exe -NoProfile -WindowStyle Hidden -File "c:\D\oriz\scripts\headroom-watchdog.ps1"
