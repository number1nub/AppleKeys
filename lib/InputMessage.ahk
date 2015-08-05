InputMessage(wParam, lParam, msg, hwnd) {
	Res := DllCall("GetRawInputData", UInt, lParam, UInt, cfg.RID_INPUT, UInt, 0, "UInt *", Size, UInt, 16)
	VarSetCapacity(Buffer, Size)
	Res  := DllCall("GetRawInputData", UInt, lParam, UInt, cfg.RID_INPUT, UInt, &Buffer, "UInt *", Size, UInt, 16)
	Type := NumGet(Buffer, 0 * 4)
	
	/*
		if (Type = cfg.RIM_TYPEMOUSE) {
			LastX := NumGet(Buffer, (16 + (4 * 3)), "Int")
			LastY := NumGet(Buffer, (16 + (4 * 4)), "Int")
			cfg.hidMessage := 0
		}
		else if (Type = cfg.RIM_TYPEKEYBOARD) {
			ScanCode := NumGet(Buffer, (16 + 0), "UShort")
			VKey := 
			cfg.hidMessage := NumGet(Buffer, (16 + 8))
		}
		else
	*/
	
	if (Type = cfg.RIM_TYPEHID) {
		SizeHid:=NumGet(Buffer, (16 + 0))
		InputCount:=NumGet(Buffer, (16 + 4))
		Loop %InputCount% {
			Addr:=&Buffer + 24 + ((A_Index - 1) * SizeHid)
			cfg.hidMessage := Mem2Hex(Addr, SizeHid)
			ProcessHIDData(wParam, lParam)
		}
	}
	return
}