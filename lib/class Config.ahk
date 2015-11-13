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
		
		for c, v in this.KEY_STATES
			this[v] := 0
	}
	
	Reset() {
		this.isSuspend := 0
		Suspend, Off
	}
	
	Suspend() {
		for c, v in this.KEY_STATES
			this[c] := 0
		Send, {CtrlUp}{AltUp}
		this.isSuspend := 1
		SetTimer, SendDelete, Off
		Suspend, On
	}
}