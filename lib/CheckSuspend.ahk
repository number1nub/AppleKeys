CheckSuspend() {		
	if (!cfg.isSuspend) {
		cfg.isSuspend      := 1
		cfg.fnPressed      := 0
		cfg.fnPrevState    := 0
		cfg.ejPressed      := 0
		cfg.ejPrevState    := 0
		cfg.pwrPressed     := 0
		cfg.pwrPrevState   := 0
		cfg.lctrlPressed   := 0
		cfg.lctrlPrevState := 0
		Suspend , On
		SetTimer, SendDelete, Off			
		SendInput {rCtrl Up}
		TrayTip, AWK Helper, Suspended, 1, 1
		Menu, Tray, Icon, % FileExist(ico:="AppleKeys-Suspend.ico") ? ico : FileExist("AppleKeys.ico") ? "AppleKeys.ico" : ""
		Soundplay, off.wav		
	}
	else {
		cfg.isSuspend := 0
		Suspend , Off
		TrayTip, AWK Helper, Restored, 1, 1
		Menu, Tray, Icon, % FileExist(ico:="AppleKeys.ico") ? ico : ""
		Soundplay , on.wav	
	}	
}