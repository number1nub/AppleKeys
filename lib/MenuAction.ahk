MenuAction() {
	if (A_ThisMenuItem ~= "(En|Dis)able AppleKeys")
		CheckSuspend()
	else if (A_ThisMenuItem = "Reload") {
		cfg.Reset()
		Reload
		Pause
	}
}