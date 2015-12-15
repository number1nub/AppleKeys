class CConfig
{
	static KEY_STATES       := ["ejPressed","ejPrevState","fnPressed","fnPrevState","hidMessage","isSuspend","lctrlPressed","lctrlPrevState","pwrPressed","pwrPrevState"]
		 , RID_INPUT        := 0x10000003
		 , RIDEV_INPUTSINK  := 0x00000100
		 , RIDI_DEVICEINFO  := 0x2000000b
		 , RIDI_DEVICENAME  := 0x20000007
		 , RIM_TYPEMOUSE    := 0
		 , RIM_TYPEKEYBOARD := 1
		 , RIM_TYPEHID      := 2
		 , RIMHIDRegistered := 0
		 , HIDList_Size     := 8
		 , RID_Size         := 12
		 , RIDInfo_Size     := 32
	
	__New() {
		Gui, +ToolWindow +hwndHWND
		Gui, Show, x0 y0 h0 w0, AppleKeysHelper
		this.HWND := HWND
		this.Unlock()
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
		this.isSuspend := 1
		Suspend, On
	}
	
	Unlock() {
		SendInput, {Blind}{CtrlUp}{RControl Up}{ShiftUp}{AltUp}{Delete Up}
		for c, v in CConfig.KEY_STATES
			this[v] := 0
	}
}