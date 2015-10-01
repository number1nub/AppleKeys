
; fn+F3 = PrtScr
$F3::
hotkeyF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {PrintScreen}
	else
		SendInput {F3}
}


; fn+alt F3 = PrtScr for Active Window
$!F3::
hotkeyAltF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput !{PrintScreen}
	else 
		SendInput !{F3}
}

; fn+ctrl F3 = Ctrl+PrtScr
$^F3::
hotkeyCtrlF3() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput ^{PrintScreen}
	else 
		SendInput ^{F3}
}

; fn+F4 = Run TM
$F4::
hotkeyF4() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {F4}
	else
		SendInput {blind}#c{Down 2}{Enter}
}

; WinMPlayer: Previous
$F7::
hotkeyF7() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {Media_Prev}  ; Previous
	else
		SendInput {F7}
}

; WinMPlayer: Pause/Unpause
$F8::
hotkeyF8() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {Media_Play_Pause} ; Pause/Unpause
	else
		SendInput {F8}
}

; WinMPlayer: Next
$F9::
hotkeyF9() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {Media_Next} ; Next
	else
		SendInput {F9}
}

; System volume: Mute/Unmute
$F10::
hotkeyF10() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {Volume_Mute} ; Mute/unmute the master volume.
	else
		SendInput {F10}
}

; System volume: Volume Down
$F11::
hotkeyF11() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0)
		SendInput {Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
	else
		SendInput {F11}
}


; switch F12 to Insert
;~ *F12::SendInput {Blind}{Insert}


; System volume: Volume Down
$F12::
hotkeyF12() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0 && cfg.fnPressed=0)
		SendInput {Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
	else
		SendInput {F12}
}



; Up ==>> Page Up
$UP:: 
hotkeyPgUp() {
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0) {
		if (GetKeyState("Shift"))
			SendInput {rCtrl Up}+{PgUp}
		else
			SendInput {rCtrl Up}{PgUp}
	}
	else
		SendInput {UP}
}

; Down ==>> Page Down
$Down::
hotkeyPgDn() { 
	if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0)
		SendInput {rctrl up}^{PgDn}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0)
		SendInput {rCtrl Up}{PgDn}
	else
		SendInput {Down}
}


; Left ==>> Home
$*Left::
hotkeyHome() {
	mods := GetMods()
	if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput {rCtrl Up}+{Home}
		else
			sendinput {rCtrl up}{Home}
	}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput {rCtrl up}^+{Home}
		else
			SendInput {rCtrl up}^{Home}
	}
	else
		SendInput %mods%{Left}
}


; Right ==>> End
$*Right::
hotkeyEnd() {
	mods := GetMods()
	if (cfg.lctrlPressed=1 && cfg.fnPressed=0 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput {rCtrl Up}+{End}
		else
			sendinput {rCtrl up}{End}
	}
	else if (cfg.lctrlPressed=1 && cfg.fnPressed=1 && cfg.ejPressed=0){
		if (GetKeyState("Shift"))
			SendInput {rCtrl up}^+{End}
		else
			SendInput {rCtrl up}^{End}
	}
	else
		SendInput %mods%{Right}
}


; Send Delete keystroke repeatedly while Eject still pressed
SendDelete:
if (cfg.ejPressed = 1) {
	SendInput {Blind}{delete}
	SetTimer, SendDelete, -40
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
	SendInput {F24 up}
}


$*lControl::
LCtrlDn() {	
	cfg.lctrlPrevState:=0, cfg.lctrlPressed:=1	
	SetTimer, SendDelete, Off
	SendInput {F24 down}
}