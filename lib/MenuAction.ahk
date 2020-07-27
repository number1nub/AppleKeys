MenuAction() {
	mi := StrReplace(A_ThisMenuItem, "&")
	
	if (mi ~= "(En|Dis)able " cfg.Name)
		CheckSuspend()
	else if (mi = "Reload") {
		cfg.Reset()
		Reload
		Pause
	}
	else if (mi = "Fix Sticky Keys") {
		UnStickKeys()
		TrayTip, AppleKeys, Un Stuck!
	}
}