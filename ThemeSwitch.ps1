#!/usr/bin/env -S pwsh -nop

$GSettings  = "~/.config/git/config"
$WTSettings = "$Env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"

# Script for toggling theme settings for system, apps, and tools.
# Handles:
#   - System
#   - Terminal
#   - git
#   - Spotify

if (!(Get-ItemProperty `
  -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
  -Name AppsUseLightTheme).AppsUseLightTheme) {
  # Windows Theme
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Light.theme"

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "dark"', '"theme": "light"').
        Replace('dark.jpg', 'light.jpg').
        Replace('"colorScheme": "Tango Dark"', '"colorScheme": "Tango Light"').
        Replace('"colorScheme": "Campbell"', '"colorScheme": "some-light"').
        Replace('"colorScheme": "Bluloco Dark"', '"colorScheme": "Bluloco Light"').
        Replace('"tabColor": "#0D1117"', '"tabColor": "#f9f9f9"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations calochortus-lyallii", "decorations hoopoe")

  # Spotify
  spicetify config color_scheme blue-light
  spicetify apply

} else {
  # Windows Theme
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Dark.theme"

  # Windows Terminal
  Set-Content `
    -Path $WTSettings `
    -Value ((Get-Content $WTSettings).
        Replace('"theme": "light"', '"theme": "dark"').
        Replace('light.jpg', 'dark.jpg').
        Replace('"colorScheme": "Tango Light"', '"colorScheme": "Tango Dark"').
        Replace('"colorScheme": "some-light"', '"colorScheme": "Campbell"').
        Replace('"colorScheme": "Bluloco Light"', '"colorScheme": "Bluloco Dark"').
        Replace('"tabColor": "#f9f9f9"', '"tabColor": "#0D1117"'))

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations hoopoe", "decorations calochortus-lyallii")

  # Spotify
  spicetify config color_scheme blue-dark
  spicetify apply

}
