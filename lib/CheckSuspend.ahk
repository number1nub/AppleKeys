CheckSuspend() {
	static sname:=RegExReplace(A_ScriptName, "\.(ahk|exe)\s*$")
	
	Menu, Tray, Rename,% (cfg.isSuspend?"Enable":"Disable") " Apple Keys" ,% (cfg.isSuspend?"Disable":"Enable") " Apple Keys" 
	if (!cfg.isSuspend) {
		cfg.Suspend()
		TrayTip, %sname%, Suspended, 1, 1
	}
	else {
		cfg.Reset()
		TrayTip, %sname%, Restored, 1, 1
		Menu, Tray, Icon, % FileExist(ico:="AppleKeys.ico") ? Lico : ""
	}	
}