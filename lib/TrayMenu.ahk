TrayMenu(hideDef:="") {	
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Fix Sticky Keys, MenuAction
	Menu, Tray, Add, % "Disable " cfg.Name, MenuAction
	Menu, Tray, Default, Fix Sticky Keys
	Menu, Tray, Add
	Menu, Tray, Add, Check For Update, CheckForUpdate
	Menu, Tray, Add,
	Menu, Tray, Add, Reload, MenuAction
	Menu, Tray, Add, Exit
	if (!A_IsCompiled && !hideDef) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	;Main Icon
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159, 1
	else {
		if (!FileExist(ico:=(A_ScriptDir "\" cfg.IconName))) {
			URLDownloadToFile, % cfg.IconUrl, %ico%
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : "",, 1
	}
	;Suspend Icon
	if (!FileExist(sIco:=(A_ScriptDir "\" cfg.SuspendIconName))) {
		try
			URLDownloadToFile, % cfg._icoRootUrl cfg.SuspendIconName, %sIco%
		catch e 
			m("ico:!", e.message, e.what, e.extra)
	}
	Menu, Tray, Tip, % cfg.Name (A_IsAdmin ? " (Admin)":"") (cfg.Version ? " v" cfg.Version:"") " Running..."
}