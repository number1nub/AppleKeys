GetMods() {
	for a, b in {Alt:"!", Ctrl:"^", LWin: "#", Shift:"+"}
		mods .= GetKeyState(a) ? b : ""
	return mods
}