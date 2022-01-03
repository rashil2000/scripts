@echo off
setlocal enabledelayedexpansion

for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set E=%%b

for /f "tokens=1,* delims== usebackq" %%a in (`wmic computersystem get model /format:list ^| findstr "^Model="`) do set %%a=%%b

for /f "tokens=* usebackq" %%f in (`dir %UserProfile%\scoop\apps\ ^| find /c "<DIR>"`) do set /a scoop_pkgs=%%f - 3
for /f "tokens=* usebackq" %%f in (`cargo install --list ^| find /c ":"`) do set cargo_pkgs=%%f

set count=1
for /f "tokens=* usebackq" %%f in (`wmic os get Caption^,Version^,FreePhysicalMemory^,TotalVisibleMemorySize /format:list`) do (
  set var!count!=%%f
  set /a count=!count!+1
)
for /f "tokens=1,* delims==" %%a in ("%var3%") do set %%a=%%b
for /f "tokens=1,* delims==" %%a in ("%var4%") do set %%a=%%b
for /f "tokens=1,* delims==" %%a in ("%var5%") do set %%a=%%b
for /f "tokens=1,* delims==" %%a in ("%var6%") do set %%a=%%b
set Caption=%Caption:Microsoft =%
set /a totalram=%TotalVisibleMemorySize% / 1000000
set /a freeram=%FreePhysicalMemory% / 1000000
set /a usedram=%totalram% - %freeram%

set count=1
for /f "tokens=* usebackq" %%f in (`wmic logicaldisk %SystemDrive% get Freespace^,Size /format:list`) do (
  set var!count!=%%f
  set /a count=!count!+1
)
for /f "tokens=1,* delims==" %%a in ("%var3%") do set %%a=%%b
for /f "tokens=1,* delims==" %%a in ("%var4%") do set %%a=%%b
set /a all=%Size:~0,-6% / 1074
set /a free=%Freespace:~0,-6% / 1074
set /a used=%all% - %free%

echo  %E%[31m┌─────┐%E%[32m┌─────┐%E%[0m  %E%[1;34m%UserName%%E%[0m@%E%[1;34m%ComputerName%%E%[0m
echo  %E%[31m│     │%E%[32m│     │%E%[0m  %E%[1;32mos%E%[0m     %E%[33m%Caption%%E%[0m
echo  %E%[31m│     │%E%[32m│     │%E%[0m  %E%[1;32mhost%E%[0m   %E%[33m%Model%%E%[0m
echo  %E%[31m└─────┘%E%[32m└─────┘%E%[0m  %E%[1;32mkernel%E%[0m %E%[33m%Version%%E%[0m
echo  %E%[34m┌─────┐%E%[33m┌─────┐%E%[0m  %E%[1;32mpkgs%E%[0m   %E%[33m%scoop_pkgs% (scoop), %cargo_pkgs% (cargo)%E%[0m
echo  %E%[34m│     │%E%[33m│     │%E%[0m  %E%[1;32mmemory%E%[0m %E%[33m%usedram%G / %totalram%G%E%[0m
echo  %E%[34m│     │%E%[33m│     │%E%[0m  %E%[1;32mdisk%E%[0m   %E%[33m%used%G / %all%G%E%[0m
echo  %E%[34m└─────┘%E%[33m└─────┘%E%[0m  %E%[1;34m˙˙˙˙˙˙%E%[0m
