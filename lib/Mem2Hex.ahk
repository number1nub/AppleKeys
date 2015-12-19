Mem2Hex(pointer, len) {
	Hex := 0
	Loop, %len%
		Hex:=Hex*0x100, Hex:=Hex+*Pointer+0, Pointer++
	Return Hex
}