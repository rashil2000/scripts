<#
.SYNOPSIS
  Add cool warp effects (video+audio) to SSH commands
.DESCRIPTION
  The script momentarily changes the background GIF of a particular profile
  (with given name) of Windows Terminal, and plays an audio clip alongside.
  All assets are present in a particular place (with given location).
  The GIF is selected based on current color theme.
.PARAMETER ProfileName
  The name of the profile to apply changes to
.PARAMETER ProjectLocation
  The location of the project folder
.EXAMPLE
  WarpSSH PowerShell "~\Projects\Premiere Pro\WarpSSH"
.NOTES
  Written By: rashil2000
#>

param(
  [Parameter(Mandatory)]
  [String]$ProfileName,
  [Parameter(Mandatory)]
  [ValidateScript( { Test-Path -Path $_ -PathType Container } )]
  [String]$ProjectLocation
)

$WTSettingsFile = "${env:UserProfile}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

$Settings = Get-Content $WTSettingsFile | ConvertFrom-Json
$ProfileIndex = 0..($Settings.profiles.list.Count - 1) | Where-Object { $Settings.profiles.list[$_].name -eq $ProfileName }

$OldValue = $Settings.profiles.list[$ProfileIndex].backgroundImage

if ($Settings.profiles.list[$ProfileIndex].colorScheme -like '*Light*') {
  $Settings.profiles.list[$ProfileIndex].backgroundImage = "${ProjectLocation}\WarpSSH-light.gif"
} else {
  $Settings.profiles.list[$ProfileIndex].backgroundImage = "${ProjectLocation}\WarpSSH-dark.gif"
}

Set-Content -Path $WTSettingsFile -Value ($Settings | ConvertTo-Json -Depth 3)

$PlayWav = New-Object System.Media.SoundPlayer
$PlayWav.SoundLocation = "${ProjectLocation}\WarpSSH.wav"
$PlayWav.PlaySync()

$Settings.profiles.list[$ProfileIndex].backgroundImage = $OldValue
Set-Content -Path $WTSettingsFile -Value ($Settings | ConvertTo-Json -Depth 3)
