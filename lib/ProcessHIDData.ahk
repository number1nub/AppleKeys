ProcessHIDData(wParam, lParam) {
	SetTimer, SendDelete, Off
	
	cfg.fnPrevState:=cfg.fnPressed, cfg.fnPressed:=(0xFF10&cfg.hidMessage)=0x1110?1:0
	cfg.ejPrevState:=cfg.ejPressed, cfg.ejPressed:=(0xFF08&cfg.hidMessage)=0x1108?1:0
	
	if ((0xFF03&cfg.hidMessage) = 0x1303) {	;Power pressed --> Suspend script
		if (GetKeyState("Alt")) {
			if (m("Quit Apple Keys?", "title:ARE YOU SURE??","ico:?", "btn:yn")="YES") {
				cfg.Reset()
				ExitApp
			}
		}
		else if (GetKeyState("Ctrl")) {
			Reload
			Pause
		}
		else{
			pwrPressed := 1
			CheckSuspend()
		}
	} 
	if (fnValue = 0x1302) {	; Power is released
		if (!GetKeyState("Alt"))
			pwrPrevState:=1, pwrPressed:=0
	}
	if (cfg.isSuspend = 0)
		ProcessModKeys()
}
