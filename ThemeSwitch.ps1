#!/usr/bin/env -S pwsh -nop

# Script for toggling Windows theme and Spotify colorscheme.

if (!(Get-ItemProperty `
  -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
  -Name AppsUseLightTheme).AppsUseLightTheme) {
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Light.theme"

  spicetify config color_scheme catppuccin-latte
} else {
  themetool changetheme "$Env:LOCALAPPDATA\Microsoft\Windows\Themes\My_Dark.theme"

  spicetify config color_scheme catppuccin-mocha
}

spicetify apply -q