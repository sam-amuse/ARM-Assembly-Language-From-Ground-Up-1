

				AREA	ComplexEq, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Solve the equation (A + 8B + 7C - 30) / 4
; With A = 25, B = 19, C = 99
; Solution is 210, 0xD2 stored in R2 at the end
; multiply and divide with shifting instruction
__main		

		MOV		R0, #25						; R0 contains A				
		MOV		R1, #19						; R0 contains B		
		ADD		R0, R0, R1 , LSL #3			; Logical Shift Left of 3 (multiply by 2^3)
											; R0 = R0+8*R1 = A+8B
		MOV		R1, #99
		MOV 	R2, #7
		MLA		R0, R1, R2, R0				; R0 = R1*R2 + R0 (Multiply-Accumulate)
											; R0 = 7C    + (A+8B)
		SUB		R0, R0, #30
		MOV		R0, R0, ASR #2				; Arithmetic Shift Right by 2 (divide by 2^2)
		
Stop	B 		Stop
				
				ALIGN
				END