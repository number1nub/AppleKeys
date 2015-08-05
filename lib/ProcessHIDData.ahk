ProcessHIDData(wParam, lParam) {
	SetTimer, SendDelete, Off
	
	;Get Fn & Eject Key States
	Transform, FnValue, BitAnd, 0xFF10, cfg.hidMessage
	if (FnValue = 0x1110)	; Fn is pressed
		cfg.fnPrevState:=cfg.fnPressed, cfg.fnPressed:=1
	else	; Fn is released
		cfg.fnPrevState := cfg.fnPressed, cfg.fnPressed := 0
	
	;Get Eject key state
	Transform, FnValue, BitAnd, 0xFF08, cfg.hidMessage
	if (FnValue = 0x1108)	; Eject is pressed
		cfg.ejPrevState := cfg.ejPressed, cfg.ejPressed := 1
	else	; Eject is Released
		cfg.ejPrevState := cfg.ejPressed, cfg.ejPressed := 0
	
	;Get Power key state
	Transform, FnValue, BitAnd, 0xFF03, cfg.hidMessage
	if (FnValue = 0x1303)	;Power pressed --> Suspend script
		cfg.pwrPressed:=1, CheckSuspend()
	if (fnValue = 0x1302)	; Power is released
		cfg.pwrPrevState := 1, cfg.pwrPressed := 0
	
	if (cfg.isSuspend = 0)
		ProcessModKeys()
}