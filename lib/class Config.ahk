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
	static _iconName        := "AppleKeys.ico"
	static _suspendIconName := "AppleKeys-Suspend.ico"
	static _icoRootUrl      := "http://files.wsnhapps.com/AppleKeys/"
	static _version         := ;auto_version
	_isSuspend    := false
	_isRegistered := false
	_hwnd         := ""
	
	
	__New() {
		Gui, +ToolWindow +hwndMyHWND
		Gui, Show, x0 y0 h0 w0, AppleKeysHelper
		this._hwnd := MyHWND
		this.Reset()
	}
	
	
	;{------------- PROPERTIES ---------->>>
	
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
			return this._version
		}
		set {
			return
		}
	}
	
	IconName[] {
		get {
			return this._iconName
		}
		set {
			return
		}
	}
	
	IconUrl[] {
		get {
			return (this._icoRootUrl this._iconName)
		}
		set {
			return
		}
	}
	
	SuspendIconName[] {
		get {
			return this._suspendIconName
		}
		set {
			return
		}
	}
	
	SuspendIconUrl[] {
		get {
			(this._icoRootUrl this._suspendIconName)
		}
		set {
			return
		}
	}
	
	IsSuspend[] {
		get {
			return this._isSuspend
		}
		set {
			return this._isSuspend := value
		}
	}
	
	IsRegistered[] {
		get {
			return this._isRegistered
		}
		set {
			return this._isRegistered := value
		}
	}
	
	HWND[] {
		get {
			return this._hwnd
		}
		set {
			return
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
				this._CAction := curAct
			}
			return this._CAction
		}
		set {
			RegWrite, REG_SZ, HKCU, % this.REG_PATH, ejCmd, %value%
			return (this._CAction := value)
		}
	}
	;}<<<---------- PROPERTIES -------------
	
	
	Reset() {
		Suspend, Off
		if (FileExist(ico:=(A_ScriptDir "\" this._iconName))) 
			Menu, Tray, Icon, %ico%,, 1
		for c, v in CConfig.KEY_STATES
			this[v] := 0
	}
	
	Suspend() {
		for c, v in CConfig.KEY_STATES
			this[c] := 0
		UnStickKeys()
		this.IsSuspend := 1
		Suspend, On
		if (FileExist(ico:=(A_ScriptDir "\" this._suspendIconName))) 
			Menu, Tray, Icon, %ico%,, 1
	}
}