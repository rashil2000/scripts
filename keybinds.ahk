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

; Win+Q -> Microsoft Edge
#q::
    Run, C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
Return

; Win+Shift+C -> Just Color Picker
#+c::
    Run, %SCOOP%\apps\jcpicker\current\jcpicker.exe
Return

; Win+Shift+G -> Screen To Gif
#+g::
    Run, %SCOOP%\apps\screentogif\current\screentogif.exe /open screen
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
    ; Ctrl+Shift+1 -> GitHub Notifications
    ^+1::
        Run https://github.com/notifications
    Return

    ; Ctrl+Shift+2 -> Twitter
    ^+2::
        Run https://twitter.com
    Return

    ; Ctrl+Shift+3 -> YouTube
    ^+3::
        Run https://youtube.com
    Return

    ; Ctrl+Shift+4 -> Reddit
    ^+4::
        Run https://reddit.com
    Return

    ; Ctrl+Shift+5 -> GMail
    ^+5::
        Run https://mail.google.com
    Return

    ; Ctrl+Shift+6 -> Yahoo Mail
    ^+6::
        Run https://mail.yahoo.com
    Return

    ; Ctrl+Shift+7 -> GMail (2)
    ^+7::
        Run https://mail.google.com/mail/u/2/
    Return

    ; Ctrl+Shift+8 -> IIT Kgp Mail
    ^+8::
        Run https://iitkgpmail.iitkgp.ac.in
    Return
}
