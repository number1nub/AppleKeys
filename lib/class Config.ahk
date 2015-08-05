class CConfig
{
	Static RID_INPUT                := 0x10000003
	Static RIDEV_INPUTSINK          := 0x00000100
	Static RIDI_DEVICEINFO          := 0x2000000b
	Static RIDI_DEVICENAME          := 0x20000007
	Static RIM_TYPEHID              := 2
	Static RIM_TYPEKEYBOARD         := 1
	Static RIM_TYPEMOUSE            := 0
	Static rimHIDregistered         := 0
	Static SizeofRawInputDevice     := 12
	Static SizeofRawInputDeviceList := 8
	Static SizeofRidDeviceInfo      := 32
	
	__New() {
		this.ejPressed      := 0
		this.ejPrevState    := 0
		this.fnPressed      := 0
		this.fnPrevState    := 0
		this.hidMessage     := 0
		this.isSuspend      := 0
		this.lctrlPressed   := 0
		this.lctrlPrevState := 0
		this.pwrPressed     := 0
		this.pwrPrevState   := 0
	}
}