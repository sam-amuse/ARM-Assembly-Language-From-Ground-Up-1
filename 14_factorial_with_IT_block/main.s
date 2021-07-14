

				AREA	FactorialWithIT, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Factorial with If Then instruction
; Computing n factorial with n = 10
; result at the end R7 = 0x00375F00 (3628800 = !10 in decimal)
__main		

		
		MOV		R6, #10			²
		MOV		R7, #1
		
Loop
		CMP		R6, #0
		ITTT 	GT				; IF THEN THEN THEN  ... Greater than
		; the 3 following lines are not executed when R6 = 0 in the last loop
		; thanks to the GT keywork at the end of each instruction
		MULGT	R7, R6, R7		; THEN (if greater) R7 = R6 * R7
		SUBGT	R6, R6, #1		; THEN (if greater) decrement the counter
		BGT		Loop			; THEN (if greater) branch if R6 > 0
								; flag N update by the CMP instruction
		
				
Stop	B 		Stop
				
				ALIGN
				END