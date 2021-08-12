; Calculate the factorial of 8 with the value 0x00009D80 present in R0 at the end
; tested with several values, above !12, the 32 bits unsigned integer format will overflow
	
		AREA 	factorial, CODE, READONLY
		ENTRY
		EXPORT __main


; iterative factorial method
;__main
;		MOV	R0, #8		; compute factorial of 8
;    	MOV	R1, #1		; initialize the result register to 1
;Loop	CMP	R0, #1		
;		BLS	Done		; Branch to done only when R0 = 1 with  BLS = Branch (Unsigned) Lower or Same
;		MUL	R1, R0, R1	; multiply the factorial 8! = 8*7*6*...*2
;		SUB	R0, R0, #1	; decrement the value 
;		B	Loop
;Done	MOV	R0, R1		; move 1 (from line MOV	R1, #1) to R0
;		BX	LR
;		ALIGN
;		END

; recursive factorial method
__main
		MOV		R0, #8   		; R0 = n
		LDR		LR, = Stop		; load the LR register with the Stop label as otherwise it points to the next 
								; line after the __main function call, ie in the startup file 
Fact	CMP		R0, #1			
		BLS		Done			; Branch when n = 1 (Branch Unsigned Lower or Same)
		PUSH	{R0, LR}		; save current value of n (in R0) and LR on the stack
		SUB		R0, R0, #1		; R0 = n-1
		BL		Fact			; Fact function called with parameter n-1 from R0
		
		POP		{R1, LR}		; pop  n into R1 as R0 contains the return value of fact(n-1) 
								; which is the cumulative multiply result of the nested functions already called							
		MUL		R0, R0, R1		; R0 = R1 * R0 = n * Fact(n-1)
		BX		LR				; branch back to the POP instruction and does the multiply until reached the top nested loop
		
Done	MOV		R0, #1
		BX		LR				; equivalent to MOV PC, LR , load the PC with the saved LR address
		ALIGN

Stop	B		Stop 			; value of factorial 8, R0 = 0x00009D80

		END