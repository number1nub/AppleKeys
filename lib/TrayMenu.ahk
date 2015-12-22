TrayMenu(hideDef:="") {
	static scrName:="AppleKeys", icoUrl:="http://files.wsnhapps.com/AppleKeys/AppleKeys.ico"
	
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Disable AppleKeys, MenuAction
	Menu, Tray, Default, Disable AppleKeys
	Menu, Tray, Add
	Menu, Tray, Add, Check For Update, CheckForUpdate
	if (!A_IsCompiled && !hideDef) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add,
	Menu, Tray, Add, Reload, MenuAction
	Menu, Tray, Add, Exit
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico)) {
			URLDownloadToFile, %icoUrl%, % (ico:=A_ScriptDir "\" scrName ".ico")
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	Menu, Tray, Tip, % scrName (A_IsAdmin ? " (Admin)":"") (cfg.Version ? " v" cfg.Version:"") " Running..."
}