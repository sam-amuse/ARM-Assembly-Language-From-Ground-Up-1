
				AREA	JumpTable, CODE, READONLY
				ENTRY
				EXPORT		__main
					
num		EQU		4						; number of functions
					
; Jump Table to perform the selected operation
__main		
		MOV 	R0, #3					; select of the operation ADD(0) SUB(1) MUL(2) UDIV(3)
										; and host result at the end
		MOV		R1, #4
		MOV		R2, #2
		
		BL		arith_func

Stop	B 		Stop

arith_func
		CMP		R0, #num				
		MOVHS	PC, LR					; if R0 > num, return from the function
		ADRL	R3, jump_table			; ADRL load a PC/register-relative address into a register.
		LDR		PC, [R3, R0, LSL #2]	; load the PC(next instruction) with the operation label offset

jump_table
		DCD		do_add
		DCD		do_sub
		DCD		do_mul
		DCD		do_div
			
do_add
		ADD		R0, R1, R2
		BX 		LR	
do_sub
		SUB		R0, R1, R2
		BX 		LR
do_mul
		MUL		R0, R1, R2
		BX 		LR
do_div
		UDIV	R0, R1, R2
		BX 		LR

		END
				