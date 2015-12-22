MenuAction() {
	if (A_ThisMenuItem ~= "(En|Dis)able Apple Keys")
		CheckSuspend()
	else if (A_ThisMenuItem = "Reload") {
		cfg.Reset()
		Reload
		Pause
	}
}