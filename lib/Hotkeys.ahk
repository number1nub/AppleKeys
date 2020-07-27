; fn+F3 = PrtScr
$F3::
hotkeyF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{PrintScreen}
	else
		SendInput, {Blind}{F3}
}


; fn+alt F3 = PrtScr for Active Window
$!F3::
hotkeyAltF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}!{PrintScreen}
	else
		SendInput, {Blind}!{F3}
}

; fn+ctrl F3 = Ctrl+PrtScr
$^F3::
hotkeyCtrlF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}^{PrintScreen}
	else
		SendInput, {Blind}^{F3}
}

; fn+F4 = Run TM
$F4::
hotkeyF4() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}#c{Down 2}{Enter}
	else
		SendInput, {Blind}{F4}
}

; WinMPlayer: Previous
$F7::
hotkeyF7() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Prev}  ; Previous
	else
		SendInput, {Blind}{F7}
}

; WinMPlayer: Pause/Unpause
$F8::
hotkeyF8() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Play_Pause} ; Pause/Unpause
	else
		SendInput, {Blind}{F8}
}

; WinMPlayer: Next
$F9::
hotkeyF9() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Next} ; Next
	else
		SendInput, {Blind}{F9}
}

; System volume: Mute/Unmute
$F10::
hotkeyF10() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Volume_Mute} ; Mute/unmute the master volume.
	else
		SendInput, {Blind}{F10}
}

; System volume: Volume Down
$F11::
hotkeyF11() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
	else
		SendInput, {Blind}{F11}
}


; Fn + F12 ==> Volume Up
$F12::
hotkeyF12() {
	if (cfg.lctrlPressed && !cfg.ejPressed && !cfg.fnPressed)
		SendInput, {Blind}{Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
	else
		SendInput, {Blind}{F12}
}



; Fn + Up ==>> Page Up
$UP::
hotkeyPgUp() {
	if (cfg.lctrlPressed && !cfg.ejPressed) {
		if (GetKeyState("Shift"))
			SendInput, {Blind}{Control Up}+{PgUp}
		else
			SendInput, {Blind}{Control Up}{PgUp}
	}
	else
		SendInput, {Blind}{Up}
}

; Fn + Down ==>> Page Down
$Down::
hotkeyPgDn() {
	if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed)
		SendInput, {Blind}{Control Up}^{PgDn}
	else if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed)
		SendInput, {Blind}{Control Up}{PgDn}
	else
		SendInput, {Blind}{Down}
}


; Fn + Left ==>> Home
$*Left::
hotkeyHome() {
	mods := GetMods()
	if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{Control Up}+{Home}
		else
			sendinput, {Blind}{Control Up}{Home}
	}
	else if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{Control Up}^+{Home}
		else
			SendInput, {Blind}{Control Up}^{Home}
	}
	else
		SendInput, {Blind}%mods%{Left}
}


; Fn + Right ==>> End
$*Right::
hotkeyEnd() {
	mods := GetMods()
	if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{Control Up}+{End}
		else
			SendInput, {Blind}{Control Up}{End}
	}
	else if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{Control Up}^+{End}
		else
			SendInput, {Blind}{Control Up}^{End}
	}
	else
		SendInput, {Blind}%mods%{Right}
}


; Send Delete keystroke repeatedly while Eject still pressed
;~ SendDelete:
;~ if (cfg.ejPressed) {
	;~ SendInput, {Blind}{Delete}
	;~ SetTimer, SendDelete, -75
	;~ return
;~ }
;~ SetTimer, SendDelete, Off
;~ SendInput, {Delete Up}
;~ return


; LCtrl ==>> Fn
$*LControl Up::
hotkeyLCtrlUp() {
	cfg.lctrlPressed := 0
	SendInput, {Blind}{F24 Up}
}


$*LControl::
hotkeyLCtrlDn() {
	cfg.lctrlPressed := 1
	;~ SetTimer, SendDelete, Off ;#[CHANGED: Not sure this should be here...]
	SendInput, {F24 down}
}

; Plus-minus ==>> `/~
VKE2::VKC0

; >/< ==>> Shift
VKC0::LShift


; RWin ==> Control
RWin::Control


; Allow using the Right Alt key as a FN key for volume
#IfWinNotActive, ahk_class XLMAIN
>!F10::SendInput, {Blind}{Volume_Mute}
>!F11::SendInput, {Blind}{Volume_Down}
>!F12::SendInput, {Blind}{Volume_Up}

#IfWinActive,