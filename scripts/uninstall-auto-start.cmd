@echo off
setlocal
rem Remove the two Oriz auto-start tasks.
set "HR_TASK=Oriz-Headroom-Login"
set "CM_TASK=Oriz-Cavemem-Login"

echo Deleting %HR_TASK%...
schtasks /delete /tn "%HR_TASK%" /f 2>nul
echo Deleting %CM_TASK%...
schtasks /delete /tn "%CM_TASK%" /f 2>nul

rem Clean rendered XMLs
del /q "%~dp0auto-start\.headroom-task.rendered.xml" 2>nul
del /q "%~dp0auto-start\.cavemem-task.rendered.xml" 2>nul

echo Done.
endlocal
exit /b 0
