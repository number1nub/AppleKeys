#NoEnv
#SingleInstance, Force
#MaxHotkeysPerInterval 1000
DetectHiddenWindows, On
SetBatchLines, -1
TrayMenu()
CheckUpdate()

global cfg := new CConfig()

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
	if (Type=cfg.RIM_TYPEHID && Vendor=1452  && cfg.RIMHIDregistered=0) {
		cfg.RIMHIDregistered := 1
		NumPut(UsagePage, RawDevice, 0, "UShort"), NumPut(Usage, RawDevice, 2, "UShort")
		if (!DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, cfg.RID_Size)){
			m("Failed to register for AWK device!","ico:!")
			ExitApp
		}
	}
}
OnMessage(0x00FF, "InputMessage")
return


#Include <CheckSuspend>
#Include <CheckUpdate>
#Include <class Config>
#Include <ExpandEnv>
#Include <GetMods>
#Include <Hotkeys>
#Include <InputMessage>
#Include <m>
#Include <Mem2Hex>
#Include <MenuAction>
#Include <ProcessHIDData>
#Include <ProcessModKeys>
#Include <TrayMenu>