; P = Q + R + S
; let Q=2, R=4, S=5

; v3 :  


		AREA SimpleEquation, CODE, READONLY
		ENTRY
		EXPORT __main
			
__main
		ADRL 	R4, Vals		; R4 points to the Vals area
								; Generate a register-relative address in the destination register,
								; for a label defined in a storage map.
		LDR		R1, [R4,#Q]
		LDR		R2, [R4,#R]
		LDR		R3, [R4,#S]
		
		ADD		R0, R1, R2 		; R0 <= R1 + R2
		ADD		R0, R0, R3 		; R0 <= (R1+R2) + R3
		
		
		; TODO @samir : The STR does not work ? READONLY problem ?
		STR		R0, [R4,#P]		
		
Stop 	B 		Stop
		

; offset values to index the variables
P		EQU		0	
Q		EQU		4	
R		EQU		8
S		EQU		12		
		
		; the AREA must be the same as the program as ADRL instruction can only access variables in the same AREA
		AREA SimpleEquation, DATA, READWRITE			
Vals	SPACE	4	; memory location for P
		DCD		2	; memory location for Q (DCD store the variable in 4 bytes)
		DCD		4	; memory location for R
		DCD		5	; memory location for S

		END