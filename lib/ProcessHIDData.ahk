ProcessHIDData(wParam, lParam) {
	static keyMsgs:={fnPressed:[0xFF10,0x1110], ejPressed:[0xFF08,0x1108], pwrPressed:[0xFF03,0x1303]}
	
	for c, v in keyMsgs
		cfg[StrReplace(c,"Pressed","PrevState")]:=cfg[c], cfg[c]:=(v[1]&cfg.hidMessage=v[2])?1:0
	
	;{== Power Key Pressed ==>>
	if (!cfg.pwrPressed && cfg.pwrPrevState) {
		if (GetKeyState("Alt")) {
			if (m("Quit AppleKeys?", "title:ARE YOU SURE??","ico:?", "btn:yn")="YES")
				cfg.Reset(), Exit()
		}
		else if (cfg.lctrlPressed) {
			cfg.Reset()
			Reload
			Pause
		}
		else
			CheckSuspend()
	}
	;}
	
	
	if (cfg.isSuspend)
		return
	
	
	;{== Eject Pressed ==>>
	if (cfg.ejPressed != cfg.ejPrevState) {
		if (cfg.ejPressed) 
			SendInput, % "{Blind}" (cfg.fnPressed ? "^" : GetMods()) "{Delete}"
		else
			SendInput, {Blind}{Delete Up}
	}
	;}
	
	
	;{== Fn Pressed ==>>
	if (cfg.fnPressed != cfg.fnPrevState)
		SendInput, % "{Blind}{Control " (cfg.fnPressed ? "Down" : "Up") "}"
	;}
}