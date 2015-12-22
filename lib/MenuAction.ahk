MenuAction() {
	if (A_ThisMenuItem ~= "(En|Dis)able " cfg.Name)
		CheckSuspend()
	else if (A_ThisMenuItem = "Reload") {
		cfg.Reset()
		Reload
		Pause
	}
}