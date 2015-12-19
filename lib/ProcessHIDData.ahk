ProcessHIDData(wParam, lParam) {
	SetTimer, SendDelete, Off
	
	cfg.fnPrevState:=cfg.fnPressed, cfg.ejPrevState:=cfg.ejPressed, cfg.pwrPrevState:=cfg.pwrPressed
	for c, v in {fnPressed:[0xFF10,0x1110], ejPressed:[0xFF08,0x1108], pwrPressed:[0xFF03,0x1303]}
		cfg[c] := (v[1]&cfg.hidMessage = v[2]) ? 1 : 0
		
	;{== Power Key Pressed ==>>
	if (!cfg.pwrPressed && cfg.pwrPrevState && !GetMods() && !cfg.fnPressed)
	{
		if (GetKeyState("Alt")) {
			if (m("Quit Apple Keys?", "title:ARE YOU SURE??","ico:?", "btn:yn")="YES") {
				cfg.Reset()
				ExitApp
			}
		}
		else if (GetKeyState("Ctrl")) {
			cfg.Reset()
			Reload
			Pause
		}
		else {
			CheckSuspend()
		}
	}
	;}
	
	if (cfg.isSuspend)
		return
	
	;{== Eject Pressed ==>>
	if (cfg.ejPressed != cfg.ejPrevState) {
		if (cfg.ejPressed) {
			if (cfg.fnPressed)
				SendInput, {Blind}^{Delete}
			else {
				SendInput, % "{Blind}" (GetMods()) "{Delete}"
				SetTimer, SendDelete, -350	
			}
		}
		else {
			SetTimer, SendDelete, off
			SendInput, {Blind}{Delete Up} 
		}
	}
	;}
	
	;{== Fn Pressed ==>>
	if (cfg.fnPressed != cfg.fnPrevState)
		SendInput, % "{Blind}{RControl " (cfg.fnPressed ? "Down":"Up") "}"
	;}
}