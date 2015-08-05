MenuAction() {
	if (A_ThisMenuItem = "Apple Keys Enabled") {
		enabled := !enabled
		Menu, Tray, ToggleCheck, %A_ThisMenuItem%
	}
	else if (A_ThisMenuItem = "Reload")
		Reload
	else if (A_ThisMenuItem = "Exit")
		ExitApp
}