#NoEnv
#SingleInstance, Force
#MaxHotkeysPerInterval,5000
#HotkeyInterval,1
DetectHiddenWindows, On
SetBatchLines, -1
SendMode, Input
CheckAdmin()

global cfg:=new CConfig()

TrayMenu()
CheckUpdate()
DllCall("GetRawInputDeviceList", UInt, 0, "UInt *", Count, UInt, cfg.HIDList_Size)
VarSetCapacity(RawInputList, cfg.HIDList_Size*Count)
DllCall("GetRawInputDeviceList", UInt, &RawInputList, "UInt *", Count, UInt, cfg.HIDList_Size)
Loop %Count% {
	Handle := NumGet(RawInputList, (A_Index-1)*cfg.HIDList_Size)
	Type   := NumGet(RawInputList, (A_Index-1)*cfg.HIDList_Size+4)
	VarSetCapacity(Info, cfg.RIDInfo_Size), NumPut(cfg.RIDInfo_Size, Info, 0)
	DllCall("GetRawInputDeviceInfo", UInt, Handle, UInt, cfg.RIDI_DEVICEINFO, UInt, &Info, "UInt *", cfg.RIDInfo_Size)
	if (Type=cfg.RIM_TYPEHID) {
		Vendor    := NumGet(Info, 4*2, "UShort")
		Product   := NumGet(Info, 4*3, "UShort")
		Version   := NumGet(Info, 4*4, "UShort")
		UsagePage := NumGet(Info, (4*5), "UShort")
		Usage     := NumGet(Info, (4*5)+2, "UShort")
	}
	VarSetCapacity(RawDevice, cfg.RID_Size), NumPut(cfg.RIDEV_INPUTSINK, RawDevice, 4), NumPut(cfg.HWND, RawDevice, 8)
	if (Type=cfg.RIM_TYPEHID && Vendor=1452  && !cfg.IsRegistered) {
		cfg.IsRegistered := 1
		NumPut(UsagePage, RawDevice, 0, "UShort"), NumPut(Usage, RawDevice, 2, "UShort")
		if (!DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, cfg.RID_Size)){
			m("Failed to register for AWK device!","ico:!")
			ExitApp
		}
	}
}
OnMessage(0x00FF, "InputMessage")
return

CheckAdmin() {
	if (!A_IsAdmin) {
		if (%true% = "admin") {
			MsgBox, 262196,, Failed to get admin credentials.`n`nTry again?
			IfMsgBox, No
				ExitApp
		}
		Run, *RunAs "%A_ScriptFullPath%" admin
		ExitApp
	}
	return 1
}
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
CheckForUpdate() {
	if (!CheckUpdate())
		m("No update found.", "title:AppleKeys" (cfg.Version ? " v" cfg.Version : ""), "i")
}
CheckUpdate(_ReplaceCurrentScript:=1, _SuppressMsgBox:=0, _CallbackFunction:="", ByRef _Information:="") {
	Static Update_URL   := "https://raw.githubusercontent.com/number1nub/AppleKeys/SingleFile/AppleKeys.text"
		 , Download_URL := "https://raw.githubusercontent.com/number1nub/AppleKeys/SingleFile/AppleKeys.ahk"
		 , Retry_Count  := 2
	
	if (!version := cfg.Version)
		return
	Random, Filler, 10000000, 99999999	
	Version_File := A_Temp "\" Filler ".ini", Temp_FileName:=A_Temp "\" Filler ".tmp", VBS_FileName:=A_Temp "\" Filler ".vbs"
	Loop, %Retry_Count% {
		_Information := ""
		UrlDownloadToFile,%Update_URL%,%Version_File%
		Loop, Read, %Version_File%
		{
			UDVersion := A_LoopReadLine ? A_LoopReadLine : "N/A"
			break
		}
		if (UDVersion = "N/A") {
			FileDelete,%Version_File%
			if (A_Index = Retry_Count)
				_Information .= "The version info file doesn't have a ""Version"" key in the ""Info"" section or the file can't be downloaded."
			else
				Sleep, 500
			Continue
		}
		if (UDVersion > Version) {
			FileRead, changeLog, %Version_File%
			if (_SuppressMsgBox != 1 && _SuppressMsgBox != 3)
				if (m("There is a new version of " cfg.Name " available.", "Current version: " Version, "New version: " UDVersion, "Change Log:", "", changeLog, "", "Would you like to download it now?", "title:New version available", "btn:yn", "ico:i") = "Yes")
					MsgBox_Result := 1
			if (_SuppressMsgBox || MsgBox_Result) {
				URL := Download_URL
				SplitPath, URL,,, Extension					
				if (Extension = "ahk" && A_AHKPath = "")
					_Information .= "The new version of the script is an .ahk filetype and you do not have AutoHotKey installed on this computer.`r`nReplacing the current script is not supported."
				else if (Extension != "exe" && Extension != "ahk")
					_Information .= "The new file to download is not an .EXE or an .AHK file type. Replacing the current script is not supported."
				else {
					IniRead,MD5,%Version_File%,Info,MD5,N/A
					Loop, %Retry_Count% {
						UrlDownloadToFile,%URL%,%Temp_FileName%
						if (FileExist(Temp_FileName)) {
							if (MD5 = "N/A") {
								_Information.="The version info file doesn't have a valid MD5 key.", Success:= True
								Break
							}
							else {
								Ptr:=A_PtrSize?"Ptr":"UInt", H:=DllCall("CreateFile",Ptr,&Temp_FileName,"UInt",0x80000000,"UInt",3,"UInt",0,"UInt",3,"UInt",0,"UInt",0), DllCall("GetFileSizeEx",Ptr,H,"Int64*",FileSize), FileSize:=FileSize = -1 ? 0 : FileSize
								if (FileSize != 0) {
									VarSetCapacity(Data,FileSize,0), DllCall("ReadFile",Ptr,H,Ptr,&Data,"UInt",FileSize,"UInt",0,"UInt",0), DllCall("CloseHandle",Ptr,H), VarSetCapacity(MD5_CTX,104,0), DllCall("advapi32\MD5Init",Ptr,&MD5_CTX), DllCall("advapi32\MD5Update",Ptr,&MD5_CTX,Ptr,&Data,"UInt",FileSize), DllCall("advapi32\MD5Final",Ptr,&MD5_CTX), FileMD5:=""
									Loop, % StrLen(Hex:="123456789ABCDEF0")
										N := NumGet(MD5_CTX,87+A_Index,"Char"), FileMD5 .= SubStr(Hex,N>>4,1) SubStr(Hex,N&15,1)
									VarSetCapacity(Data,FileSize,0), VarSetCapacity(Data,0)
									if (FileMD5 != MD5) {
										FileDelete,%Temp_FileName%
										if (A_Index = Retry_Count)
											_Information .= "The MD5 hash of the downloaded file does not match the MD5 hash in the version info file."
										else
											Sleep, 500
										Continue
									}
									else
										Success := True
								}
								else
									DllCall("CloseHandle",Ptr,H), Success := True									
							}
						}
						else {
							if (A_Index = Retry_Count)
								_Information .= "Unable to download the latest version of the file from " URL "."
							else
								Sleep, 500
							Continue
						}
					}
				}
			}
		}
		else
			_Information .= "No update was found."
		FileDelete, %Version_File%
		Break
	}	
	if (_ReplaceCurrentScript && Success) {
		SplitPath, URL,,, Extension
		Process, Exist
		MyPID := ErrorLevel
		VBS_P1 =
		(LTrim Join`r`n
			On Error Resume Next
			Set objShell = CreateObject("WScript.Shell")
			objShell.Run "TaskKill /F /PID %MyPID%", 0, 1
			Set objFSO = CreateObject("Scripting.FileSystemObject")
		)
		if (A_IsCompiled) {
			SplitPath, A_ScriptFullPath,, Dir,, Name
			VBS_P2 =
			(LTrim Join`r`n
				Finished = False
				Count = 0
				Do Until (Finished = True Or Count = 5)
					Err.Clear
					objFSO.CopyFile "%Temp_FileName%", "%Dir%\%Name%.%Extension%", True
					if (Err.Number = 0) then
						Finished = True
						objShell.Run """%Dir%\%Name%.%Extension%"""
					else
						WScript.Sleep(1000)
						Count = Count + 1
					End if
				Loop
				objFSO.DeleteFile "%Temp_FileName%", True
			)
			Return_Val := Temp_FileName
		}
		else {
			if (Extension = "ahk") {
				FileMove,%Temp_FileName%,%A_ScriptFullPath%,1
				if (Errorlevel)
					_Information .= "Error (" Errorlevel ") unable to replace current script with the latest version."
				else {
					VBS_P2 =
					(LTrim Join`r`n
						objShell.Run """%A_ScriptFullPath%"""
					)
					Return_Val :=  A_ScriptFullPath
				}
			}
			else if (Extension = "exe") {
				SplitPath, A_ScriptFullPath,, FDirectory,, FName
				FileMove, %Temp_FileName%, %FDirectory%\%FName%.exe, 1
				FileDelete, %A_ScriptFullPath%
				VBS_P2 =
				(LTrim Join`r`n
					objShell.Run """%FDirectory%\%FName%.exe"""
				)
				Return_Val :=  FDirectory "\" FName ".exe"
			}
			else {
				FileDelete,%Temp_FileName%
				_Information .= "The downloaded file is not an .EXE or an .AHK file type. Replacing the current script is not supported."
			}
		}
		VBS_P3 =
		(LTrim Join`r`n
			objFSO.DeleteFile "%VBS_FileName%", True
		)
		if (_SuppressMsgBox < 2) {
			if (InStr(VBS_P2, "Do Until (Finished = True Or Count = 5)")) {
				VBS_P3.="`r`nif (Finished=False) Then", VBS_P3.="`r`nWScript.Echo ""Update failed.""", VBS_P3.="`r`nelse"
				if (Extension != "exe")
					VBS_P3 .= "`r`nobjFSO.DeleteFile """ A_ScriptFullPath """"
				VBS_P3.="`r`nWScript.Echo ""Update completed successfully.""", VBS_P3.="`r`nEnd if"
			}
			else
				VBS_P3 .= "`r`nWScript.Echo ""Update complected successfully."""
		}
		FileDelete, %VBS_FileName%
		FileAppend, %VBS_P1%`r`n%VBS_P2%`r`n%VBS_P3%, %VBS_FileName%
		if (_CallbackFunction != "") {
			if (IsFunc(_CallbackFunction))
				%_CallbackFunction%()
			else
				_Information .= "The callback function is not a valid function name."
		}
		RunWait, %VBS_FileName%, %A_Temp%, VBS_PID
		Sleep, 2000
		Process, Close, %VBS_PID%
		_Information := "Error (?) unable to replace current script with the latest version.`r`nPlease make sure your computer supports running .vbs scripts and that the script isn't running in a pipe."
	}
	_Information := _Information ? _Information : "None"
	Return Return_Val
}
Class CConfig
{
	static KEY_STATES       := ["ejPressed","ejPrevState","fnPressed","fnPrevState","hidMessage","isSuspend","lctrlPressed","lctrlPrevState","pwrPressed","pwrPrevState"]
	static RID_INPUT        := 0x10000003
	static RIDEV_INPUTSINK  := 0x00000100
	static RIDI_DEVICEINFO  := 0x2000000b
	static RIDI_DEVICENAME  := 0x20000007
	static RIM_TYPEMOUSE    := 0
	static RIM_TYPEKEYBOARD := 1
	static RIM_TYPEHID      := 2
	static HIDList_Size     := 8
	static RID_Size         := 12
	static RIDInfo_Size     := 32
	
	__New() {
		Gui, +ToolWindow +hwndHWND
		Gui, Show, x0 y0 h0 w0, AppleKeysHelper
		this.HWND := HWND
		this.Reset()
	}
	
	Name[] {
		get {
			return RegExReplace(A_ScriptName, "i)\.ahk|exe$")
		}
		set {
			return
		}
	}
	
	Version[] {
		get {
			return version:="1.1.13"
		}
		set {
			return
		}
	}
	
	IsSuspend[] {
		get {
			return this._IsSuspend
		}
		set {
			return this._IsSuspend := value
		}
	}
	
	IsRegistered[] {
		get {
			return this._IsRegistered
		}
		set {
			return this._IsRegistered := value
		}
	}
	
	HWND[] {
		get {
			return this._HWND
		}
		set {
			return this._HWND := value
		} 
	}
	
	CAction[] {
		get {
			if (!this._CAction) {
				RegRead, curAct, HKCU, % cfg.REG_PATH, ejCmd
				if (!curAct || ErrorLevel) {
					InputBox, curAct, Custom Action, Custom Action:,, 550, 130,,,,, % (ErrorLevel||!curAct) ? "" : curAct
					if (ErrorLevel || !curAct)
						return
					RegWrite, REG_SZ, HKCU, % cfg.REG_PATH, ejCmd, %curAct%
				}
			}
			return this._CAction := curAct
		}
		set {
			RegWrite, REG_SZ, HKCU, % this.REG_PATH, ejCmd, %value%
			return (this._CAction := value)
		}
	}
	
	Reset() {
		Suspend, Off
		SendInput, {Blind}{CtrlUp}{RControl Up}{ShiftUp}{AltUp}{Delete Up}
		for c, v in CConfig.KEY_STATES
			this[v] := 0
	}
	
	Suspend() {
		SetTimer, SendDelete, Off
		for c, v in CConfig.KEY_STATES
			this[c] := 0
		SendInput, {Blind}{CtrlUp}{AltUp}{RControl Up}{ShiftUp}
		this.IsSuspend := 1
		Suspend, On
	}
}
Exit() {
	cfg.Reset()
	ExitApp
}
ExpandEnv(str) {
	VarSetCapacity(dest,2000)
	DllCall("ExpandEnvironmentStrings", "str", str, "str", dest, int, 1999, "Cdecl int")
	return dest
}
GetMods() {
	for a, b in {Alt:"!", Ctrl:"^", LWin: "#", Shift:"+"}
		mods .= GetKeyState(a) ? b : ""
	return mods
}
; fn+F3 = PrtScr
$F3::
hotkeyF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{PrintScreen}
	else
		SendInput, {Blind}{F3}
}


; fn+alt F3 = PrtScr for Active Window
$!F3::
hotkeyAltF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}!{PrintScreen}
	else 
		SendInput, {Blind}!{F3}
}

; fn+ctrl F3 = Ctrl+PrtScr
$^F3::
hotkeyCtrlF3() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}^{PrintScreen}
	else 
		SendInput, {Blind}^{F3}
}

; fn+F4 = Run TM
$F4::
hotkeyF4() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}#c{Down 2}{Enter}
	else
		SendInput, {Blind}{F4}
}

; WinMPlayer: Previous
$F7::
hotkeyF7() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Prev}  ; Previous
	else
		SendInput, {Blind}{F7}
}

; WinMPlayer: Pause/Unpause
$F8::
hotkeyF8() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Play_Pause} ; Pause/Unpause
	else
		SendInput, {Blind}{F8}
}

; WinMPlayer: Next
$F9::
hotkeyF9() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Media_Next} ; Next
	else
		SendInput, {Blind}{F9}
}

; System volume: Mute/Unmute
$F10::
hotkeyF10() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Volume_Mute} ; Mute/unmute the master volume.
	else
		SendInput, {Blind}{F10}
}

; System volume: Volume Down
$F11::
hotkeyF11() {
	if (cfg.lctrlPressed && !cfg.ejPressed)
		SendInput, {Blind}{Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
	else
		SendInput, {Blind}{F11}
}


; Fn + F12 ==> Volume Up
$F12::
hotkeyF12() {
	if (cfg.lctrlPressed && !cfg.ejPressed && !cfg.fnPressed)
		SendInput, {Blind}{Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
	else
		SendInput, {Blind}{F12}
}



; Fn + Up ==>> Page Up
$UP:: 
hotkeyPgUp() {
	if (cfg.lctrlPressed && !cfg.ejPressed) {
		if (GetKeyState("Shift"))
			SendInput, {Blind}{RControl Up}+{PgUp}
		else
			SendInput, {Blind}{RControl Up}{PgUp}
	}
	else
		SendInput, {Blind}{Up}
}

; Fn + Down ==>> Page Down
$Down::
hotkeyPgDn() { 
	if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed)
		SendInput, {Blind}{RControl Up}^{PgDn}
	else if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed)
		SendInput, {Blind}{RControl Up}{PgDn}
	else
		SendInput, {Blind}{Down}
}


; Fn + Left ==>> Home
$*Left::
hotkeyHome() {
	mods := GetMods()
	if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{RControl Up}+{Home}
		else
			sendinput, {Blind}{RControl Up}{Home}
	}
	else if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{RControl Up}^+{Home}
		else
			SendInput, {Blind}{RControl Up}^{Home}
	}
	else
		SendInput, {Blind}%mods%{Left}
}


; Fn + Right ==>> End
$*Right::
hotkeyEnd() {
	mods := GetMods()
	if (cfg.lctrlPressed && !cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{RControl Up}+{End}
		else
			SendInput, {Blind}{RControl Up}{End}
	}
	else if (cfg.lctrlPressed && cfg.fnPressed && !cfg.ejPressed){
		if (GetKeyState("Shift"))
			SendInput, {Blind}{RControl Up}^+{End}
		else
			SendInput, {Blind}{RControl Up}^{End}
	}
	else
		SendInput, {Blind}%mods%{Right}
}


; Send Delete keystroke repeatedly while Eject still pressed
SendDelete:
if (cfg.ejPressed) {
	SendInput, {Blind}{Delete}
	SetTimer, SendDelete, -75
}
return


; LCtrl ==>> Fn
$*LControl Up::
hotkeyLCtrlUp() {
	cfg.lctrlPressed := 0
	SendInput, {Blind}{F24 Up}
}


$*LControl::
hotkeyLCtrlDn() {
	cfg.lctrlPressed := 1
	SetTimer, SendDelete, Off
	SendInput, {F24 down}
}

; Plus-minus ==>> `/~
VKE2::VKC0

; >/< ==>> Shift
VKC0::LShift


; RWin ==> RControl
RWin::RControl
InputMessage(wParam, lParam, msg, hwnd) {
	DllCall("GetRawInputData", UInt, lParam, UInt, cfg.RID_INPUT, UInt, 0, "UInt *", Size, UInt, 16)
	VarSetCapacity(Buffer, Size)
	DllCall("GetRawInputData", UInt, lParam, UInt, cfg.RID_INPUT, UInt, &Buffer, "UInt *", Size, UInt, 16)
	if (NumGet(Buffer, 0*4) = cfg.RIM_TYPEHID) {
		SizeHid := NumGet(Buffer, (16+0))
		Loop % NumGet(Buffer, (16+4))
			Addr:=&Buffer+24+((A_Index-1)*SizeHid), cfg.hidMessage:=Mem2Hex(Addr, SizeHid), ProcessHIDData(wParam, lParam)
	}
}
m(info*) {
	static icons:={"x":16,"?":32,"!":48,"i":64}, btns:={c:1,oc:1,co:1,ari:2,iar:2,ria:2,rai:2,ync:3,nyc:3,cyn:3,cny:3,yn:4,ny:4,rc:5,cr:5}
	for c, v in info {
		if RegExMatch(v, "imS)^(?:btn:(?P<btn>c|\w{2,3})|(?:ico:)?(?P<ico>x|\?|\!|i)|title:(?P<title>.+)|def:(?P<def>\d+)|time:(?P<time>\d+(?:\.\d{1,2})?|\.\d{1,2}))$", m_) {
			mBtns:=m_btn?1:mBtns, title:=m_title?m_title:title, timeout:=m_time?m_time:timeout
			opt += m_btn?btns[m_btn]:m_ico?icons[m_ico]:m_def?(m_def-1)*256:0
		} else
			txt .= (txt ? "`n":"") v
	}
	MsgBox, % (opt+262144), %title%, %txt%, %timeout%
	for c, v in ["OK", "YES", "NO", "CANCEL", "RETRY", "ABORT"]
		IfMsgBox, %v%
			return (mBtns ? v : "")
}
Mem2Hex(pointer, len) {
	Hex := 0
	Loop, %len%
		Hex:=Hex*0x100, Hex:=Hex+*Pointer+0, Pointer++
	Return Hex
}
MenuAction() {
	mi := StrReplace(A_ThisMenuItem, "&")
	
	if (mi ~= "(En|Dis)able " cfg.Name)
		CheckSuspend()
	else if (mi = "Reload") {
		cfg.Reset()
		Reload
		Pause
	}
	else if (mi = "Fix Sticky Keys")
		SendInput, {Blind}{CtrlUp}{RControl Up}{ShiftUp}{AltUp}
}
ProcessHIDData(wParam, lParam) {
	static keyMsgs:={fnPressed:[0xFF10,0x1110], ejPressed:[0xFF08,0x1108], pwrPressed:[0xFF03,0x1303]}
	
	SetTimer, SendDelete, Off
	for c, v in keyMsgs
		cfg[StrReplace(c,"Pressed","PrevState")]:=cfg[c], cfg[c]:=(v[1]&cfg.hidMessage=v[2])?1:0
	
	;{== Power Key Pressed ==>>
	if (!cfg.pwrPressed && cfg.pwrPrevState) {
		if (GetKeyState("Alt")) {
			if (m("Quit AppleKeys?", "title:ARE YOU SURE??","ico:?", "btn:yn")="YES")
				cfg.Reset(), Exit()
		}
		else if (cfg.lctrlPressed) {
			cfg.Reset()
			Reload
			Pause
		}
		else
			CheckSuspend()
	}
	;}
	
	if (cfg.isSuspend)
		return
	
	;{== Eject Pressed ==>>
	if (cfg.ejPressed != cfg.ejPrevState) {
		if (cfg.ejPressed) {
			if (cfg.fnPressed)
				SendInput, {Blind}^{Delete}
			else {
				SendInput, % "{Blind}" (GetMods()) "{Delete}"
				SetTimer, SendDelete, -350	
			}
		}
		else {
			SetTimer, SendDelete, off
			SendInput, {Blind}{Delete Up} 
		}
	}
	;}
	
	;{== Fn Pressed ==>>
	if (cfg.fnPressed != cfg.fnPrevState)
		SendInput, % "{Blind}{RControl " (cfg.fnPressed ? "Down":"Up") "}"
	;}
}
TrayMenu(hideDef:="") {
	static icoUrl:="http://files.wsnhapps.com/AppleKeys/AppleKeys.ico"
	
	Menu, DefaultAHK, Standard
	Menu, Tray, NoStandard
	Menu, Tray, Add, % "Disable " cfg.Name, MenuAction
	Menu, Tray, Add, Fix Sticky Keys, MenuAction
	Menu, Tray, Default, % "Disable " cfg.Name
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
			URLDownloadToFile, %icoUrl%, % (ico:=A_ScriptDir "\" cfg.Name ".ico")
			if (ErrorLevel)
				FileDelete, %ico%
		}
		Menu, Tray, Icon, % FileExist(ico) ? ico : ""
	}
	
	Menu, Tray, Tip, % cfg.Name (A_IsAdmin ? " (Admin)":"") (cfg.Version ? " v" cfg.Version:"") " Running..."
}