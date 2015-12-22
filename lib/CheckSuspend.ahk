CheckSuspend() {
	static sname := "AppleKeys"
	
	Menu, Tray, Rename, % (cfg.isSuspend ? "Enable":"Disable") " AppleKeys" , % (cfg.isSuspend?"Disable":"Enable") " AppleKeys"
	if (!cfg.isSuspend) {
		cfg.Suspend()
		TrayTip, %sname%, Suspended, 1, 1
	} else {
		cfg.Reset()
		TrayTip, %sname%, Restored, 1, 1
	}
}