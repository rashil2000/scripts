@echo OFF

if "%2"=="" (
   set Msys2Root=D:\Msys2
) else (
   set Msys2Root=%2
)

:: Setup some default paths. Note that this order will allow user installed
:: software to override system software.
:: Modifying these default path settings can be done in different ways.
:: To learn more about startup files, refer to your shell's man page.

set MSYS2_PATH=%Msys2Root%\usr\local\bin;%Msys2Root%\usr\bin;%Msys2Root%\bin
set MANPATH=%Msys2Root%\usr\local\man;%Msys2Root%\usr\share\man;%Msys2Root%\usr\man;%Msys2Root%\share\man
set INFOPATH=%Msys2Root%\usr\local\info;%Msys2Root%\usr\share\info;%Msys2Root%\usr\info;%Msys2Root%\share\info

:: MSYSTEM Environment Information
:: Copyright (C) 2016 Renato Silva
:: Licensed under public domain

:: Once sourced, this script provides common information associated with the
:: current MSYSTEM. For example, the compiler architecture and host type.

:: The MSYSTEM_ prefix is used for avoiding too generic names. For example,
:: makepkg is sensitive to the value of CARCH, so MSYSTEM_CARCH is defined
:: instead. The MINGW_ prefix does not influence makepkg-mingw variables and
:: is not used for the MSYS shell.

set MSYSTEM=%1

set MSYSTEM_PREFIX=
set MSYSTEM_CARCH=
set MSYSTEM_CHOST=
set MINGW_MOUNT_POINT=
set MINGW_CHOST=
set MINGW_PREFIX=
set MINGW_PACKAGE_PREFIX=

if "%MSYSTEM%"=="MINGW32" (
    set MSYSTEM_PREFIX=%Msys2Root%\mingw32
    set MSYSTEM_CARCH=i686
    set MSYSTEM_CHOST=i686-w64-mingw32
    set MINGW_CHOST=i686-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\mingw32
    set MINGW_PACKAGE_PREFIX=mingw-w64-i686
) else if "%MSYSTEM%"=="MINGW64" (
    set MSYSTEM_PREFIX=%Msys2Root%\mingw64
    set MSYSTEM_CARCH=x86_64
    set MSYSTEM_CHOST=x86_64-w64-mingw32
    set MINGW_CHOST=x86_64-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\mingw64
    set MINGW_PACKAGE_PREFIX=mingw-w64-x86_64
) else if "%MSYSTEM%"=="CLANG32" (
    set MSYSTEM_PREFIX=%Msys2Root%\clang32
    set MSYSTEM_CARCH=i686
    set MSYSTEM_CHOST=i686-w64-mingw32
    set MINGW_CHOST=i686-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\clang32
    set MINGW_PACKAGE_PREFIX=mingw-w64-clang-i686
) else if "%MSYSTEM%"=="CLANG64" (
    set MSYSTEM_PREFIX=%Msys2Root%\clang64
    set MSYSTEM_CARCH=x86_64
    set MSYSTEM_CHOST=x86_64-w64-mingw32
    set MINGW_CHOST=x86_64-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\clang64
    set MINGW_PACKAGE_PREFIX=mingw-w64-clang-x86_64
) else if "%MSYSTEM%"=="CLANGARM64" (
    set MSYSTEM_PREFIX=%Msys2Root%\clangarm64
    set MSYSTEM_CARCH=aarch64
    set MSYSTEM_CHOST=aarch64-w64-mingw32
    set MINGW_CHOST=aarch64-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\clangarm64
    set MINGW_PACKAGE_PREFIX=mingw-w64-clang-aarch64
) else if "%MSYSTEM%"=="UCRT64" (
    set MSYSTEM_PREFIX=%Msys2Root%\ucrt64
    set MSYSTEM_CARCH=x86_64
    set MSYSTEM_CHOST=x86_64-w64-mingw32
    set MINGW_CHOST=x86_64-w64-mingw32
    set MINGW_PREFIX=%Msys2Root%\ucrt64
    set MINGW_PACKAGE_PREFIX=mingw-w64-ucrt-x86_64
) else (
    set MSYSTEM=MSYS
    set MSYSTEM_PREFIX=%Msys2Root%\usr
    for /f "tokens=* usebackq" %%f in (`%Msys2Root%\usr\bin\uname -m`) do set MSYSTEM_CARCH=%%f
    for /f "tokens=* usebackq" %%f in (`%Msys2Root%\usr\bin\uname -m`) do set MSYSTEM_CHOST=%%f-pc-msys
)

if "%MSYSTEM%"=="MSYS" (
    set "PATH=%MSYS2_PATH%;%Msys2Root%\opt\bin;%PATH%"
    set PKG_CONFIG_PATH=%Msys2Root%\usr\lib\pkgconfig;%Msys2Root%\usr\share\pkgconfig;%Msys2Root%\lib\pkgconfig
) else if "%MSYSTEM%"=="UCRT64" (
    set "PATH=%MSYS2_PATH%;%Msys2Root%\opt\bin;%PATH%"
    set PKG_CONFIG_PATH=%Msys2Root%\usr\lib\pkgconfig;%Msys2Root%\usr\share\pkgconfig;%Msys2Root%\lib\pkgconfig
) else (
    set MINGW_MOUNT_POINT=%MINGW_PREFIX%
    set "PATH=%MINGW_PREFIX%\bin;%MSYS2_PATH%;%PATH%"
    set PKG_CONFIG_PATH=%MINGW_PREFIX%\lib\pkgconfig;%MINGW_PREFIX%\share\pkgconfig
    set ACLOCAL_PATH=%MINGW_PREFIX%\share\aclocal;%Msys2Root%\usr\share\aclocal
    set MANPATH=%MINGW_PREFIX%\local\man;%MINGW_PREFIX%\share\man;%MANPATH%
)

set SYSCONFDIR=%Msys2Root%\etc

:: TMP and TEMP as defined in the Windows environment must be kept
:: for windows apps, even if started from msys2. However, leaving
:: them set to the default Windows temporary directory or unset
:: can have unexpected consequences for msys2 apps, so we define
:: our own to match GNU/Linux behaviour.
::
:: Note: this uppercase/lowercase workaround does not seem to work.
:: In fact, it has been removed from Cygwin some years ago. See:
::
::     * https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/base-files.git;a=commitdiff;h=3e54b07
::     * https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/base-files.git;a=commitdiff;h=7f09aef
::
set TMP=%Msys2Root%\tmp
set TEMP=%Msys2Root%\tmp

set PRINTER=Microsoft Print to PDF

if exist %Msys2Root%\usr\bin\site_perl set PATH=%PATH%;%Msys2Root%\usr\bin\site_perl
if exist %Msys2Root%\usr\lib\perl5\site_perl\bin set PATH=%PATH%;%Msys2Root%\usr\lib\perl5\site_perl\bin
if exist %Msys2Root%\usr\bin\vendor_perl set PATH=%PATH%;%Msys2Root%\usr\bin\vendor_perl
if exist %Msys2Root%\usr\lib\perl5\vendor_perl\bin set PATH=%PATH%;%Msys2Root%\usr\lib\perl5\vendor_perl\bin
if exist %Msys2Root%\usr\bin\core_perl set PATH=%PATH%;%Msys2Root%\usr\bin\core_perl

for /f "tokens=* usebackq" %%f in (`%Msys2Root%\usr\bin\tzset`) do set TZ=%%f
for /f "tokens=* usebackq" %%f in (`%Msys2Root%\usr\bin\locale -uU`) do set LC_CTYPE=%%f
for /f "tokens=* usebackq" %%f in (`%Msys2Root%\usr\bin\hostname`) do set HOSTNAME=%%f
set SHELL=%COMSPEC%

echo.
echo [Minimal System 2] Environment initialized for: %MSYSTEM%