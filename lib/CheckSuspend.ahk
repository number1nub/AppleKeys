CheckSuspend() {		
	if (!cfg.isSuspend) {
		cfg.Suspend()
		TrayTip, AWK Helper, Suspended, 1, 1
		Soundplay, off.wav		
	}
	else {
		cfg.Reset()
		TrayTip, AWK Helper, Restored, 1, 1
		Menu, Tray, Icon, % FileExist(ico:="AppleKeys.ico") ? ico : ""
		Soundplay , on.wav
	}	
}