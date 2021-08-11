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

; Win+N -> Microsoft Edge
#n::
    Run, C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
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
