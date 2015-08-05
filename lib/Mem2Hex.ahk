Mem2Hex(pointer, len) {
	multiply:=0x100, Hex := 0
	Loop, %len%
		Hex:=Hex*multiply, Hex:=Hex+*Pointer+0, Pointer ++
	Return Hex
}