
; fn+F3 = PrtScr
$F3::
hotkeyF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{PrintScreen}
	else
		SendInput, {Blind}{F3}
}


; fn+alt F3 = PrtScr for Active Window
$!F3::
hotkeyAltF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}!{PrintScreen}
	else 
		SendInput, {Blind}!{F3}
}

; fn+ctrl F3 = Ctrl+PrtScr
$^F3::
hotkeyCtrlF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}^{PrintScreen}
	else 
		SendInput, {Blind}^{F3}
}

; fn+F4 = Run TM
$F4::
hotkeyF4() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{F4}
	else
		SendInput, {Blind}#c{Down 2}{Enter}
}

; WinMPlayer: Previous
$F7::
hotkeyF7() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{Media_Prev}  ; Previous
	else
		SendInput, {Blind}{F7}
}

; WinMPlayer: Pause/Unpause
$F8::
hotkeyF8() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{Media_Play_Pause} ; Pause/Unpause
	else
		SendInput, {Blind}{F8}
}

; WinMPlayer: Next
$F9::
hotkeyF9() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{Media_Next} ; Next
	else
		SendInput, {Blind}{F9}
}

; System volume: Mute/Unmute
$F10::
hotkeyF10() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{Volume_Mute} ; Mute/unmute the master volume.
	else
		SendInput, {Blind}{F10}
}

; System volume: Volume Down
$F11::
hotkeyF11() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
	else
		SendInput, {Blind}{F11}
}


; switch F12 to Insert
;~ *F12::SendInput, {Blind}{Insert}


; System volume: Volume Down
$F12::
hotkeyF12() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0 && cfg.fnPressed=0)
		SendInput, {Blind}{Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
	else
		SendInput, {Blind}{F12}
}



; Up ==>> Page Up
$UP:: 
hotkeyPgUp() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0) {
		if (GetKeyState("Shift"))
			SendInput, {Blind}{rCtrl Up}+{PgUp}
		else
			SendInput, {Blind}{rCtrl Up}{PgUp}
	}
	else
		SendInput, {Blind}{UP}
}

; Down ==>> Page Down
$Down::
hotkeyPgDn() { 
	if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0)
		SendInput, {Blind}{rctrl up}^{PgDn}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0)
		SendInput, {Blind}{rCtrl Up}{PgDn}
	else
		SendInput, {Blind}{Down}
}


; Left ==>> Home
$*Left::
hotkeyHome() {
	mods := GetMods()
	if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{rCtrl Up}+{Home}
		else
			sendinput, {Blind}{rCtrl up}{Home}
	}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{rCtrl up}^+{Home}
		else
			SendInput, {Blind}{rCtrl up}^{Home}
	}
	else
		SendInput, {Blind}%mods%{Left}
}


; Right ==>> End
$*Right::
hotkeyEnd() {
	mods := GetMods()
	if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{rCtrl Up}+{End}
		else
			sendinput, {Blind}{rCtrl up}{End}
	}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{rCtrl up}^+{End}
		else
			SendInput, {Blind}{rCtrl up}^{End}
	}
	else
		SendInput, {Blind}%mods%{Right}
}


; Send Delete keystroke repeatedly while Eject still pressed
SendDelete:
if (cfg.ejPressed) {
	SendInput, {Blind}{Delete}
	SetTimer, SendDelete, -50
}
return



; Plus-minus ==>> `/~
VKE2::VKC0

; >/< ==>> Shift
VKC0::LShift



; lCtrl ==>> fn (Sets global var forcfg.lctrlPressed)
$*lControl up::
LCtrlUp() {
	cfg.lctrlPrevState:=1, cfg.lctrlPressed:=0
	SendInput, {Blind}{F24 up}
}


$*lControl::
LCtrlDn() {	
	cfg.lctrlPrevState:=0, cfg.lctrlPressed:=1	
	SetTimer, SendDelete, Off
	SendInput, {F24 down}
}