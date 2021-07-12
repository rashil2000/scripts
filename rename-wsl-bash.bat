@echo off

call :isAdmin
if %errorlevel% == 0 (
  echo Running with administrator rights.

  echo INFO: Taking ownership of bash executable
  takeown /F C:\Windows\System32\bash.exe
  echo INFO: Modifying discretionary access control list for bash executable to give administrator full access
  icacls C:\Windows\System32\bash.exe /grant administrators:F
  echo INFO: Renaming to wsl-bash
  ren C:\Windows\System32\bash.exe wsl-bash.exe

) else (
  echo WARN: Access denied.
)

pause >nul
exit /b

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b
