ProcessHIDData(wParam, lParam) {
	static msgVals := {"fnPressed":[0xFF10,0x1110], "ejPressed":[0xFF08,0x1108], "pwrPressed":[0xFF03,0x1303]}
	
	SetTimer, SendDelete, Off
	
	msg := cfg.hidMessage
	cfg.fnPrevState := cfg.fnPressed
	cfg.ejPrevState := cfg.ejPressed
	
	for c, v in msgVals
		cfg[c] := (v[1] & msg = v[2]) ? 1 : 0
	
	
	;~ cfg.fnPrevState := cfg.fnPressed
	;~ cfg.ejPrevState := cfg.ejPressed
	;~ cfg.fnPressed:=(0xFF10 & msg = 0x1110) ? 1 : 0
	;~ cfg.ejPressed:=(0xFF08 & msg = 0x1108) ? 1 : 0
	
	; Power Pressed
	;~ if (0xFF03&msg = 0x1303) {
	
	if (cfg.pwrPressed) {
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
			cfg.pwrPressed := 1
			CheckSuspend()
		}
	} 
	if (fnValue = 0x1302) {	; Power is released
		if (!GetKeyState("Alt"))
			cfg.pwrPrevState:=1, cfg.pwrPressed:=0
	}
	if (cfg.isSuspend = 0)
		ProcessModKeys()
}
