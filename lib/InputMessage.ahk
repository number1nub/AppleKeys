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