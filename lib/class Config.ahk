class CConfig
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