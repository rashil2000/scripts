#KeyHistory 0

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
	Run https://reddit.com
	Return
}
