
		AREA	simpleShift, CODE, READONLY
		ENTRY
		EXPORT __main

; Test the Logical Shift Left instruction		
__main
		MOV		R0, #0x11		; value = 17 in decimal
		LSL		R1, R0, #1		; shift left is equivalent to multiply by 2
								; R1 = 17*2 = 34 (0x22)
		LSL		R2, R1, #1		; R2 = 0x22 *2 =  0x44

Stop 	B	Stop

		END