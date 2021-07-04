; P = Q + R + S
; let Q=2, R=4, S=5

; v2 : use variables present in a DATA section 
; load instruction done on pc + offset to the get the variable location
; For instance LDR  R1, Q  is done as  LDR.W  r1,[pc,#16]

		AREA Variables, DATA, READONLY
			
Q		DCD		2	; create variable with initial value 2
					; DCD directive allocates one or more words of memory, 
					; aligned on four-byte boundaries and 
					; defines the initial runtime contents of the memory
R		DCD		4
S		DCD		5
		
		AREA SimpleEquation, CODE, READONLY
		ENTRY
		EXPORT __main
			
__main
		LDR		R1, Q
		LDR		R2, R
		LDR		R3, S
		
		ADD		R0, R1, R2 ; R0 <= R1 + R2
		ADD		R0, R0, R3 ; R0 <= (R1+R2) + R3
		
		
Stop 	B 		Stop

		END