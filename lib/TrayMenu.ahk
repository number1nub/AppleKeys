TrayMenu(hideDef:="") {
	static Version, scrName, icoUrl
	scrName := RegExReplace(A_ScriptName, "\.(ahk|exe)$")
	icoUrl := "http://files.wsnhapps.com/AppleKeys/" (ico:=scrName ".ico")
	;auto_version
	
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, Apple Keys: Enabled, MenuAction
	Menu, Tray, Add
	Menu, Tray, Add, Check For Update, CheckForUpdate
	if (!A_IsCompiled && !hideDef) {
		Menu, Tray, Add
		Menu, Tray, Add, Default AHK Menu, :DefaultAHK
	}
	Menu, Tray, Add,
	Menu, Tray, Add, Reload, MenuAction
	Menu, Tray, Add, Exit, MenuAction
	
	if (A_IsCompiled)
		Menu, Tray, Icon, % A_ScriptFullpath, -159
	else {
		if (!FileExist(ico))
			URLDownloadToFile, %icoUrl%, % (ico:=A_ScriptDir "\" scrName ".ico")
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	Menu, Tray, Tip, % scrName (Version ? " v" Version:"") " Running..."
}