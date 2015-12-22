CheckSuspend() {
	Menu, Tray, Rename, % (cfg.isSuspend ? "Enable ":"Disable ") cfg.Name , % (cfg.isSuspend?"Disable ":"Enable ") cfg.Name
	if (!cfg.isSuspend) {
		cfg.Suspend()
		TrayTip, % cfg.Name, Suspended, 1, 1
	} else {
		cfg.Reset()
		TrayTip, % cfg.Name, Restored, 1, 1
	}
}