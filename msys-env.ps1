param(
  [String]$EnvName,
  [String]$Msys2Root = 'D:\Msys2'
)

# Setup some default paths. Note that this order will allow user installed
# software to override 'system' software.
# Modifying these default path settings can be done in different ways.
# To learn more about startup files, refer to your shell's man page.

$Env:MSYS2_PATH = "$Msys2Root\usr\local\bin;$Msys2Root\usr\bin;$Msys2Root\bin"
$Env:MANPATH = '/usr/local/man:/usr/share/man:/usr/man:/share/man'
$Env:INFOPATH = "$Msys2Root\usr\local\info;$Msys2Root\usr\share\info;$Msys2Root\usr\info;$Msys2Root\share\info"

# manpage colors
$e = [char]0x1b
$Env:LESS_TERMCAP_mb="$e[1;31m"  # begin blink
$Env:LESS_TERMCAP_md="$e[1;36m"  # begin bold
$Env:LESS_TERMCAP_me="$e[0m"     # reset bold/blink
$Env:LESS_TERMCAP_so="$e[01;33m" # begin reverse video
$Env:LESS_TERMCAP_se="$e[0m"     # reset reverse video
$Env:LESS_TERMCAP_us="$e[1;32m"  # begin underline
$Env:LESS_TERMCAP_ue="$e[0m"     # reset underline
# colored GCC warnings and errors
$Env:GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# MSYSTEM Environment Information
# Copyright (C) 2016 Renato Silva
# Licensed under public domain

# Once sourced, this script provides common information associated with the
# current MSYSTEM. For example, the compiler architecture and host type.

# The MSYSTEM_ prefix is used for avoiding too generic names. For example,
# makepkg is sensitive to the value of CARCH, so MSYSTEM_CARCH is defined
# instead. The MINGW_ prefix does not influence makepkg-mingw variables and
# is not used for the MSYS shell.

$Env:MSYSTEM = $EnvName

Remove-Item -ErrorAction SilentlyContinue `
  Env:\MSYSTEM_PREFIX, `
  Env:\MSYSTEM_CARCH, `
  Env:\MSYSTEM_CHOST, `
  Env:\MINGW_MOUNT_POINT, `
  Env:\MINGW_CHOST, `
  Env:\MINGW_PREFIX, `
  Env:\MINGW_PACKAGE_PREFIX

switch ($Env:MSYSTEM) {
  "MINGW32" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\mingw32"
    $Env:MSYSTEM_CARCH = 'i686'
    $Env:MSYSTEM_CHOST = 'i686-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-$Env:MSYSTEM_CARCH"
  }
  "MINGW64" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\mingw64"
    $Env:MSYSTEM_CARCH = 'x86_64'
    $Env:MSYSTEM_CHOST = 'x86_64-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-$Env:MSYSTEM_CARCH"
  }
  "CLANG32" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\clang32"
    $Env:MSYSTEM_CARCH = 'i686'
    $Env:MSYSTEM_CHOST = 'i686-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-clang-$Env:MSYSTEM_CARCH"
  }
  "CLANG64" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\clang64"
    $Env:MSYSTEM_CARCH = 'x86_64'
    $Env:MSYSTEM_CHOST = 'x86_64-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-clang-$Env:MSYSTEM_CARCH"
  }
  "CLANGARM64" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\clangarm64"
    $Env:MSYSTEM_CARCH = 'aarch64'
    $Env:MSYSTEM_CHOST = 'aarch64-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-clang-$Env:MSYSTEM_CARCH"
  }
  "UCRT64" {
    $Env:MSYSTEM_PREFIX = "$Msys2Root\ucrt64"
    $Env:MSYSTEM_CARCH = 'x86_64'
    $Env:MSYSTEM_CHOST = 'x86_64-w64-mingw32'
    $Env:MINGW_CHOST = $Env:MSYSTEM_CHOST
    $Env:MINGW_PREFIX = $Env:MSYSTEM_PREFIX
    $Env:MINGW_PACKAGE_PREFIX = "mingw-w64-ucrt-$Env:MSYSTEM_CARCH"
  }
  Default {
    $Env:MSYSTEM = 'MSYS'
    $Env:MSYSTEM_PREFIX = "$Msys2Root\usr"
    $Env:MSYSTEM_CARCH = "$(& $Msys2Root\usr\bin\uname -m)"
    $Env:MSYSTEM_CHOST = "$Env:MSYSTEM_CARCH-pc-msys"
  }
}

switch ($Env:MSYSTEM) {
  { $PSItem -like "MINGW*" -or $PSItem -like "CLANG*" -or $PSItem -like "UCRT*" } {
    $Env:MINGW_MOUNT_POINT = $Env:MINGW_PREFIX
    $Env:PATH = "$Env:MINGW_MOUNT_POINT\bin;$Env:MSYS2_PATH;$Env:PATH"
    $Env:PKG_CONFIG_PATH = "$Env:MINGW_MOUNT_POINT\lib\pkgconfig;$Env:MINGW_MOUNT_POINT\share\pkgconfig"
    $Env:ACLOCAL_PATH = "$Env:MINGW_MOUNT_POINT\share\aclocal;$Msys2Root\usr\share\aclocal"
    $Env:MANPATH = "$Env:MINGW_MOUNT_POINT\local\man;$Env:MINGW_MOUNT_POINT\share\man;$Env:MANPATH"
  }
  Default {
    $Env:PATH = "$Env:MSYS2_PATH;$Msys2Root\opt\bin;$Env:PATH"
    $Env:PKG_CONFIG_PATH = "$Msys2Root\usr\lib\pkgconfig;$Msys2Root\usr\share\pkgconfig;$Msys2Root\lib\pkgconfig"
  }
}

$Env:CONFIG_SITE = "$Msys2Root\etc\config.site"
$Env:SYSCONFDIR = "$Msys2Root\etc"

# TMP and TEMP as defined in the Windows environment must be kept
# for windows apps, even if started from msys2. However, leaving
# them set to the default Windows temporary directory or unset
# can have unexpected consequences for msys2 apps, so we define
# our own to match GNU/Linux behaviour.
#
# Note: this uppercase/lowercase workaround does not seem to work.
# In fact, it has been removed from Cygwin some years ago. See:
#
#     * https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/base-files.git;a=commitdiff;h=3e54b07
#     * https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/base-files.git;a=commitdiff;h=7f09aef
#
$Env:TMP = "$Msys2Root\tmp"
$Env:TEMP = "$Msys2Root\tmp"

$Env:PRINTER = "Microsoft Print to PDF"

"$Msys2Root\usr\bin\site_perl", `
"$Msys2Root\usr\lib\perl5\site_perl\bin", `
"$Msys2Root\usr\bin\vendor_perl", `
"$Msys2Root\usr\lib\perl5\vendor_perl\bin", `
"$Msys2Root\usr\bin\core_perl" `
  | ForEach-Object { if (Test-Path -Path $_ -PathType Container) { $Env:PATH += ";$_" } }

$Env:TZ = "$(& $Msys2Root\usr\bin\tzset)"
$Env:LC_CTYPE = "$(& $Msys2Root\usr\bin\locale -uU)"
$Env:HOSTNAME = "$(& $Msys2Root\usr\bin\hostname)"
$Env:SHELL = if ($PSVersionTable.PSVersion.Major -le 5) { (Get-Command powershell).Source } else { (Get-Command pwsh).Source }

Write-Host "`n[Minimal System 2] Environment initialized for: $Env:MSYSTEM"
