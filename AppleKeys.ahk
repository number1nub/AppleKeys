#NoEnv
#SingleInstance, Force
#MaxHotkeysPerInterval 1000
DetectHiddenWindows, On
SetWorkingDir, %A_ScriptDir%

global cfg:=new CConfig()

TrayMenu()

Gui, +ToolWindow +hwndHWND
Gui, Show, x0 y0 h0 w0, AppleWKHelper

Res := DllCall("GetRawInputDeviceList", UInt, 0, "UInt *", Count, UInt, cfg.SizeofRawInputDeviceList)
VarSetCapacity(RawInputList, cfg.SizeofRawInputDeviceList * Count)
Res := DllCall("GetRawInputDeviceList", UInt, &RawInputList, "UInt *", Count, UInt, cfg.SizeofRawInputDeviceList)

Loop %Count% {
	Handle := NumGet(RawInputList, (A_Index-1)*cfg.SizeofRawInputDeviceList)
	Type   := NumGet(RawInputList, (A_Index-1)*cfg.SizeofRawInputDeviceList+4)
	TypeName := (Type=cfg.RIM_TYPEMOUSE) ? "RIM_TYPEMOUSE" : (Type=cfg.RIM_TYPEKEYBOARD) ? "RIM_TYPEKEYBOARD" : (Type=cfg.RIM_TYPEHID) ? "RIM_TYPEHID" : "RIM_OTHER"
	VarSetCapacity(Info, cfg.SizeofRidDeviceInfo)
	NumPut(cfg.SizeofRidDeviceInfo, Info, 0)
	Length := cfg.SizeofRidDeviceInfo
	Res := DllCall("GetRawInputDeviceInfo", UInt, Handle, UInt, cfg.RIDI_DEVICEINFO, UInt, &Info, "UInt *", Length)
	if (Type=cfg.RIM_TYPEHID) {
		Vendor    := NumGet(Info, 4*2, "UShort")
		Product   := NumGet(Info, 4*3, "UShort")
		Version   := NumGet(Info, 4*4, "UShort")
		UsagePage := NumGet(Info, (4*5), "UShort")
		Usage     := NumGet(Info, (4*5)+2, "UShort")
	}
	VarSetCapacity(RawDevice, cfg.SizeofRawInputDevice), NumPut(cfg.RIDEV_INPUTSINK, RawDevice, 4), NumPut(HWND, RawDevice, 8)
	if (Type=cfg.RIM_TYPEHID && Vendor=1452  && cfg.rimHIDregistered=0) {
		cfg.rimHIDregistered := 1
		NumPut(UsagePage, RawDevice, 0, "UShort"), NumPut(Usage, RawDevice, 2, "UShort")
		Res := DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, cfg.SizeofRawInputDevice)
		if (!Res)
			throw {message:"Failed to register for AWK device!"}
	}
}
OnMessage(0x00FF, "InputMessage")
return


#Include lib\CheckSuspend.ahk
#Include lib\CheckUpdate.ahk
#Include lib\class Config.ahk
#Include Lib\ExpandEnv.ahk
#Include lib\GetMods.ahk
#Include lib\Hotkeys.ahk
#Include lib\InputMessage.ahk
#Include lib\m.ahk
#Include lib\Mem2Hex.ahk
#Include lib\MenuAction.ahk
#Include lib\ProcessHIDData.ahk
#Include lib\ProcessModKeys.ahk
#Include lib\TrayMenu.ahk