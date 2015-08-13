ProcessHIDData(wParam, lParam) {
	SetTimer, SendDelete, Off
	Transform, FnValue, BitAnd, 0xFF10, cfg.hidMessage
	if (FnValue = 0x1110)
		cfg.fnPrevState:=cfg.fnPressed, cfg.fnPressed:=1
	else
		cfg.fnPrevState := cfg.fnPressed, cfg.fnPressed := 0
	
	
	Transform, FnValue, BitAnd, 0xFF08, cfg.hidMessage
	if (FnValue = 0x1108)
		cfg.ejPrevState := cfg.ejPressed, cfg.ejPressed := 1
	else
		cfg.ejPrevState := cfg.ejPressed, cfg.ejPressed := 0
	
	
	; Filter bit 1 fnd 2 (Power key)
	Transform, FnValue, BitAnd, 0xFF03, cfg.hidMessage
	if (FnValue = 0x1303) {	;Power pressed --> Suspend script
		if (GetKeyState("Alt")) {
			MsgBox 4643, ARE YOU SURE?, Quit Apple Keys?
			IfMsgBox, Yes
			{
				cfg.Reset()
				ExitApp
			}
		}
		else
			pwrPressed:=1, CheckSuspend()
	} 
	if (fnValue = 0x1302)	; Power is released
		if (!GetKeyState("Alt"))
			pwrPrevState := 1, pwrPressed := 0
	
	
	if (FnValue = 0x1303) tt
		cfg.pwrPressed:=1, CheckSuspend()
	if (fnValue = 0x1302)
		cfg.pwrPrevState := 1, cfg.pwrPressed := 0
	
	if (cfg.isSuspend = 0)
		ProcessModKeys()
}
