#!/usr/bin/env -S pwsh -nop

$GSettings   = "~/.config/git/config"
$SPTSettings = "~/.config/spotify-tui/config.yml"

# Script for toggling theme settings for system, apps, and tools.
# Handles:
#   - Windows Theme
#   - conhost
#   - windowsterminal
#   - git
#   - Spotify TUI

$WTSettings = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

if (!(Get-ItemProperty `
  -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
  -Name AppsUseLightTheme).AppsUseLightTheme) {
  # Windows Theme
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Light.theme"

  # Windows Console
  colortool -b some-light.ini

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "dark"', '"theme": "light"').
        Replace('ps-dark.gif', 'ps-light.gif').
        Replace('"colorScheme": "Tango Dark"', '"colorScheme": "Tango Light"').
        Replace('"colorScheme": "Campbell"', '"colorScheme": "some-light"').
        Replace('"colorScheme": "Bluloco Dark"', '"colorScheme": "Bluloco Light"').
        Replace('"tabColor": "#0D1117"', '"tabColor": "#f9f9f9"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations calochortus-lyallii", "decorations hoopoe")

  # Spotify TUI
  Set-Content `
    -Path $SPTSettings `
    -Value ((Get-Content $SPTSettings).
        Replace('Cyan', 'Blue').
        Replace('Gray', 'DarkGray').
        Replace('White', 'Black').
        Replace('Magenta', 'Green'))

} else {
  # Windows Theme
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Dark.theme"

  # Windows Console
  colortool -b campbell.ini

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "light"', '"theme": "dark"').
        Replace('ps-light.gif', 'ps-dark.gif').
        Replace('"colorScheme": "Tango Light"', '"colorScheme": "Tango Dark"').
        Replace('"colorScheme": "some-light"', '"colorScheme": "Campbell"').
        Replace('"colorScheme": "Bluloco Light"', '"colorScheme": "Bluloco Dark"').
        Replace('"tabColor": "#f9f9f9"', '"tabColor": "#0D1117"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations hoopoe", "decorations calochortus-lyallii")

  # Spotify TUI
  Set-Content `
    -Path $SPTSettings `
    -Value ((Get-Content $SPTSettings).
        Replace('Blue', 'Cyan').
        Replace('DarkGray', 'Gray').
        Replace('Black', 'White').
        Replace('Green', 'Magenta'))

}
