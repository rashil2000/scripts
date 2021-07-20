#!/c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell

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
$NPPSettings = "$Env:APPDATA\Notepad++\config.xml"
$MSettings = "$Env:USERPROFILE\.config\mintty\config"
$GSettings = "$Env:USERPROFILE\.gitconfig"

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
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Tango Dark"', '"colorScheme": "Tango Light"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Campbell"', '"colorScheme": "some-light"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Bluloco Dark"', '"colorScheme": "Bluloco Light"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Ayu Dark"', '"colorScheme": "Ayu Light"')

  # Notepad++
  Set-Content `
    -Path $NPPSettings `
    -Value (Get-Content $NPPSettings).Replace("<GUIConfig name=`"stylerTheme`" path=`"$Env:APPDATA\Notepad++\themes\DarkModeDefault.xml`" />", "<GUIConfig name=`"stylerTheme`" path=`"$Env:APPDATA\Notepad++\stylers.xml`" />")
  Set-Content `
    -Path $NPPSettings `
    -Value (Get-Content $NPPSettings).Replace('<GUIConfig name="DarkMode" enable="yes" enableExperimental="yes" enableMenubar="yes" enableScrollbarHack="yes" />', '<GUIConfig name="DarkMode" enable="no" enableExperimental="no" enableMenubar="no" enableScrollbarHack="no" />')

  # Mintty
  Set-Content `
    -Path $MSettings `
    -Value (Get-Content $MSettings).Replace("ThemeFile=windows10", "ThemeFile=google-light")

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations calochortus-lyallii", "decorations hoopoe")
}
else {
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
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Tango Light"', '"colorScheme": "Tango Dark"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "some-light"', '"colorScheme": "Campbell"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Bluloco Light"', '"colorScheme": "Bluloco Dark"')
  Set-Content `
    -Path $WTSettings `
    -Value (Get-Content $WTSettings).Replace('"colorScheme": "Ayu Light"', '"colorScheme": "Ayu Dark"')

  # Notepad++
  Set-Content `
    -Path $NPPSettings `
    -Value (Get-Content $NPPSettings).Replace("<GUIConfig name=`"stylerTheme`" path=`"$Env:APPDATA\Notepad++\stylers.xml`" />", "<GUIConfig name=`"stylerTheme`" path=`"$Env:APPDATA\Notepad++\themes\DarkModeDefault.xml`" />")
  Set-Content `
    -Path $NPPSettings `
    -Value (Get-Content $NPPSettings).Replace('<GUIConfig name="DarkMode" enable="no" enableExperimental="no" enableMenubar="no" enableScrollbarHack="no" />', '<GUIConfig name="DarkMode" enable="yes" enableExperimental="yes" enableMenubar="yes" enableScrollbarHack="yes" />')

  # Mintty
  Set-Content `
    -Path $MSettings `
    -Value (Get-Content $MSettings).Replace("ThemeFile=google-light", "ThemeFile=windows10")

  # Git
  Set-Content `
    -Path $GSettings `
    -Value (Get-Content $GSettings).Replace("decorations hoopoe", "decorations calochortus-lyallii")
}
