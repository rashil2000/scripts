#!pwsh

# Script for toggling theme settings for system, apps, and tools.
# Handles:
#   - Wallpaper
#   - System Theme
#   - Apps Theme
#   - Accent color*
#   - conhost
#   - windowsterminal
#   - git

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DeskWall
{
  [DllImport("User32.dll", CharSet=CharSet.Unicode)]
  public static extern int SystemParametersInfo (Int32 uAction, Int32 uParam, String lpvParam, Int32 fuWinIni);
}
"@

$ThemeRegistry = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$WTSettings = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
$GSettings = "$Env:USERPROFILE\.config\git\config"

$CheckWall = Get-ItemProperty `
  -Path 'HKCU:\Control Panel\Desktop\' `
  -Name WallPaper
$CheckTheme = Get-ItemProperty `
  -Path $ThemeRegistry `
  -Name AppsUseLightTheme

if (!$CheckTheme.AppsUseLightTheme) {
  # Wallpaper
  if ($CheckWall.WallPaper -ne "$Env:DATA_DIR\Pictures\Wallpapers\bliss-windows-day.jpg") {
    [DeskWall]::SystemParametersInfo(0x0014, 0, "$Env:DATA_DIR\Pictures\Wallpapers\bliss-windows-day.jpg", 0x03) | Out-Null
  }

  # System
  Set-ItemProperty `
    -Path $ThemeRegistry `
    -Name SystemUsesLightTheme `
    -Value 1

  # Apps
  Set-ItemProperty `
    -Path $ThemeRegistry `
    -Name AppsUseLightTheme `
    -Value 1

  # Accent Colour
  <# Set-ItemProperty `
    -Path HKCU:\SOFTWARE\Microsoft\Windows\DWM `
    -Name AccentColor `
    -Type DWord `
    -Value 4294967295 #>

  # Windows Console
  colortool -b some-light.ini

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "dark"', '"theme": "light"').
        Replace('"colorScheme": "Tango Dark"', '"colorScheme": "Tango Light"').
        Replace('"colorScheme": "Campbell"', '"colorScheme": "some-light"').
        Replace('"colorScheme": "Bluloco Dark"', '"colorScheme": "Bluloco Light"').
        Replace('"tabColor": "#0f1419"', '"tabColor": "#fafafa"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations calochortus-lyallii", "decorations hoopoe")
} else {
  # Wallpaper
  if ($CheckWall.WallPaper -ne "$Env:DATA_DIR\Pictures\Wallpapers\bliss_windows_night.jpg") {
    [DeskWall]::SystemParametersInfo(0x0014, 0, "$Env:DATA_DIR\Pictures\Wallpapers\bliss_windows_night.jpg", 0x03) | Out-Null
  }

  # System
  Set-ItemProperty `
    -Path $ThemeRegistry `
    -Name SystemUsesLightTheme `
    -Value 0

  # Apps
  Set-ItemProperty `
    -Path $ThemeRegistry `
    -Name AppsUseLightTheme `
    -Value 0

  # Accent Colour
  <# Set-ItemProperty `
    -Path HKCU:\SOFTWARE\Microsoft\Windows\DWM `
    -Name AccentColor `
    -Type DWord `
    -Value 4278190080 #>

  # Windows Console
  colortool -b campbell.ini

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "light"', '"theme": "dark"').
        Replace('"colorScheme": "Tango Light"', '"colorScheme": "Tango Dark"').
        Replace('"colorScheme": "some-light"', '"colorScheme": "Campbell"').
        Replace('"colorScheme": "Bluloco Light"', '"colorScheme": "Bluloco Dark"').
        Replace('"tabColor": "#fafafa"', '"tabColor": "#0f1419"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations hoopoe", "decorations calochortus-lyallii")
}
