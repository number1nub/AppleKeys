ProcessModKeys() {
	
	; Eject Pressed --> Send Delete
	if (cfg.ejPressed=1 && cfg.ejPrevState=0 && cfg.lctrlPressed=0) {
		if (cfg.fnPressed=1)
			SendInput, {Blind}^{Delete}
		else if (GetMods() ~= "(\+\^\#\!)+")
			SendInput, {Blind}{Delete}
		else {
			SendInput, {Blind}{Delete}
			SetTimer, SendDelete, -250
		}
	}
	
	; FN --> RControl
	if (cfg.ejPressed=0) {
		if (cfg.fnPressed=1 && cfg.fnPrevState=0)
			SendInput, {Blind}{RControl Down}
		if (cfg.fnPressed=0 && cfg.fnPrevState=1)
			SendInput, {Blind}{RControl Up}
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