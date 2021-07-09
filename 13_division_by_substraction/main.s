

				AREA	ComplexEq, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Division by substraction
; Final result in R2 is 201 (0xC9 in hexa)
__main		

		LDR		R0, =2010		; denominator
		MOV		R1, #10			; numerator
		MOV		R2, #0
		
Loop	CMP		R0, R1			;
		BLO		Stop			; Branch Lower if R0 < R1 (unsigned comparison)	
								; in other word when R0/R1 is not integer anymore
		SUBS	R0, R0, R1		; substract with R0 = R0-R1
		ADD		R2, R2, #1		; increment the division counter (quotient result at the end)
		B		Loop
				
Stop	B 		Stop
				
				ALIGN
				END