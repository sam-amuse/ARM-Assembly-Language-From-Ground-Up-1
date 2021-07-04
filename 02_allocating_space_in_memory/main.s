		AREA myCode, CODE, READONLY
		ENTRY
		EXPORT __main
			
__main
		LDR 	R0, =A 		; R0 point to the address of A
		MOV 	R1, #0x33 		; set the value 5 in R1
		STR 	R1, [R0] 	; place the content of R1 at the address pointed by R0
		
		LDR 	R0, =D
		MOV 	R1, #0x22
		STR 	R1, [R0]
		
		LDR 	R0, =C
		MOV 	R1, #0x11
		STR 	R1, [R0]
		
Stop 	B		Stop
		
		AREA myData, DATA, READWRITE
		; Allocate the following variable in SRAM

A		SPACE 4 ; A is the address of the allocated 4 bytes
D		SPACE 4
C		SPACE 4
	
		END
		


		
		
	