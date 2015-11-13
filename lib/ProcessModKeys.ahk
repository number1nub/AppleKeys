ProcessModKeys() {
	if (cfg.lctrlPressed=0) {
		if (cfg.ejPressed=1 && cfg.ejPrevState=0) {
			if  (GetKeyState("Shift") || GetKeyState("Alt") || GetKeyState("Control"))
				SendInput {Blind}{Delete}
			else if (cfg.fnPressed=1)
				SendInput {Ctrl}{Delete}
			else {
				SendInput {Delete}
				SetTimer, SendDelete, -500
			}
		}
	}
	if (cfg.ejPressed=0) {
		if (cfg.fnPressed=1 && cfg.fnPrevState=0)
			SendInput {rCtrl Down}
		if (cfg.fnPressed=0 && cfg.fnPrevState=1)
			SendInput {rCtrl Up}
	}
	
	; lctrl + Eject
	if (cfg.lctrlPressed=1 && cfg.ejPressed=0 && cfg.ejPrevState=1 && cfg.fnPressed=0) {
		RegRead, ejCmd, HKCU, Software\WSNHapps\AppleKeys, ejCmd
		if (ErrorLevel || !ejCmd) {
			m("This command must be set!", "ico:!")
			;~ Run, *edit "%A_ScriptFullPath%"
		}
		else {
			Send, % "{Blind}" ExpandEnv(ejCmd) ;#[TODO: Handle custom actions]
		}
	}
}