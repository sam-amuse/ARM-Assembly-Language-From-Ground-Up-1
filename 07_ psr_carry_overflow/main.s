
		AREA	myCode, CODE, READONLY
		ENTRY
		EXPORT		__main
			
			
__main

; check the xPSR register for the bits N and Z

		MOV		R2, #4
		MOV		R3, #2
		MOV		R4, #4
		
		SUBS	R5, R3, R2			; 2 - 4 = -2 (N (Negative) bit should be set)
		SUBS	R5, R2, R3			; 4 - 2 = 2  (N bit should be clear)
		
		SUBS  	R5, R2, R4			; 2 - 2 = 0  (Z (Zero) bit should be set)

; check the carry (bit C in xPSR register)

		LDR		R0, =0xF62562FA
		LDR		R1, =0xF412963B
	
		LDR		R6, =0x80000000 	; -2147483648, the smallest 2's complement value on 32 bits, the underflow limit
		LDR		R7, =0x00000001 	; 1 2 in 2's complement on 32 bits

		
		MOV		R2, #0x35
		MOV		R3,	#0x21
		
		; with S option of ADDS the condition flags are updated on the result of the operation
		; in other words , it updates the xPSR register based on the add result
		
		ADDS	R4, R2, R3			; 0x35 + #0x21 ADDS result without carry (clear the default value 1 that Carry bit has after reset)
		ADC		R5, R2, R3			; Add with Carry C = 0 (of the previous ADD)
									; R6 = R2 + R3 + 0 =  0x56
		
		ADDS	R4, R1, R0			; 0xF.... + 0xF.... ADDS result with carry 
							
		ADC		R5, R2, R3			; Add with Carry  C = 1(of the previous ADD)
									; R6 = R2 + R3 + 1 =  0x57
									
		SUBS	R5, R6, R7			; R5 = -21474836480 - 1 = 2147483647
									; Sub with underflow signaled with the overflow V = 1 
		

; check the overflow (and carry) bits
		LDR		R1, =1000000000
		LDR		R2, =2000000000
		LDR		R3, =3000000000
		LDR		R4, =4000000000
		LDR		R5, =4100000000
		
		MOV		R8, #0
		MOV		R9, #0
		
		ADDS	R8, R8, R1			; no overflow, no carry 
		ADC		R9, R9, #0			; result = 0

		ADDS	R8, R8, R2			; overflow in 2's complement (R8 = 0xB2D05E00 > 2^31)
									; this is an error in signed arithmetic
		ADC		R9, R9, #0			; R9 = 0
		
		ADDS	R8, R8, R3			; carry in 2's complement (R8 = 0x165A0BC00 > 2^32)
									; this is an error in unsigned arithmetic
		ADC		R9, R9, #0			; R9 = 1
		
		ADDS	R8, R8, R4			; C = 1 and V = 0
		ADC		R9, R9, #0			; R9 = 2
		
		ADDS	R8, R8, R5			; C = 1 and V = 0
		ADC		R9, R9, #0			; R9 = 3

Stop	B 		Stop

		END