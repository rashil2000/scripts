#!/usr/bin/env pwsh

<#PSScriptInfo
.VERSION 1.0
.GUID c1d1fdb6-9cce-48f1-b5ba-0c70bf451de5
.AUTHOR Rashil Gandhi
.COMPANYNAME
.COPYRIGHT
.TAGS scoop list query bucket apps
.LICENSEURI
.PROJECTURI
.ICONURI
.REQUIREDMODULES
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.SYNOPSIS
	List scoop apps.
.DESCRIPTION
	Easily list installed scoop apps. Utilize PowerShell's pipeline to filter, sort or customize output.
.PARAMETER Query
	Return app names containing a substring.
.EXAMPLE
	PS C:\> List-Scoop
	List all installed apps
.EXAMPLE
	PS C:\> List-Scoop rust
	List all installed apps that contain the substring `rust` in the name
.LINK
  Written By: rashil2000
	Obviously, this requires scoop installed and available in PATH - https://scoop.sh
#>

param([String]$Query)

$result = scoop list $Query 6>&1
$i = 0
$apps = @()

while (++$i -lt $result.length) {
  if ("$($result[$i].ToString().Trim())" -eq "") {
      break
  }

  $app = [ordered]@{}

  $app.Name = "$($result[$i++].ToString().Trim())"
  $app.Version = "$($result[$i++])"
  $app.Info = ""
  $info = @()
  if ("$($result[$i])" -eq " *global*") {
    $info += "Global install"
    $i++
  }
  if ("$($result[$i])" -eq " *failed*") {
    $info += "Install failed"
    $i++
  } else {
    if ("$($result[$i])" -eq " *hold*") {
      $info += "Held package"
      $i++
    }
    $app.Source = "$($result[$i++].ToString().Trim(" []"))"
    $archval = if ([Environment]::Is64BitOperatingSystem) { "32bit" } else { "64bit" }
    if ("$($result[$i])" -eq " {$archval}") {
      $info += $archval
      $i++
    }
  }
  $app.Info = $info -join ', '

  $apps += $app
}

return $apps.ForEach({[PSCustomObject]$_})
