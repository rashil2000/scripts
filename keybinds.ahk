#KeyHistory 0

; Win+Y -> Windows PowerShell
;#y::
;Run, C:\Windows\System32\conhost.exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
;Return

; Win+Alt+Y -> Administrator: Windows PowerShell
;#!y::
;try {
;    Run, *RunAs C:\Windows\System32\conhost.exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
;}
;Return

; Win+Enter -> Windows Terminal
#Enter::
    Sleep, 150
    Run, C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe
Return

; Win+Shift+Enter -> Administrator: Windows Terminal
#+Enter::
    try {
        Run, *RunAs C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe
    }
Return

; Win+Backspace -> Neovim
#Backspace::
    Sleep, 150
    Run, C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe -p Neovim -d C:\Users\%A_UserName%
Return

; Win+Backslash -> Vifm
#\::
    Sleep, 150
    Run, C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe -p Vifm
Return

; Win+N -> Microsoft Edge
#n::
    Run, C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
Return

; Win+Shift+C -> Just Color Picker
#+c::
    Run, C:\Users\%A_UserName%\Scoop\apps\jcpicker\current\jcpicker.exe
Return

; Win+Shift+G -> Screen To Gif
#+g::
    Run, C:\Users\%A_UserName%\Scoop\apps\screentogif\current\screentogif.exe /open screen
Return

; Ctrl+Alt+RightClick -> Toggle transparency for any window
^!RButton::
    WinGet, currentTransparency, Transparent, A
    if (currentTransparency = OFF) {
        WinSet, Transparent, 200, A
    } else {
        WinSet, Transparent, OFF, A
    }
Return

; Inside Chromium applications
#IfWinActive ahk_class Chrome_WidgetWin_1
{
    ; Ctrl+Shift+1 -> GitHub
    ^+1::
        Run https://github.com
    Return

    ; Ctrl+Shift+2 -> Twitter
    ^+2::
        Run https://twitter.com
    Return

    ; Ctrl+Shift+3 -> WhatsApp
    ^+3::
        Run https://web.whatsapp.com
    Return

    ; Ctrl+Shift+4 -> Teams
    ^+4::
        Run https://teams.microsoft.com
    Return

    ; Ctrl+Shift+5 -> HackerNews
    ^+5::
        Run https://news.ycombinator.com
    Return

    ; Ctrl+Shift+6 -> Reddit
    ^+6::
        Run https://youtube.com
    Return
}
