
			AREA		stackContext, CODE, READONLY
			ENTRY
			EXPORT		__main
					
; illustrate the stack operation in a context switch (of a RTOS for instance)
__main		
			LDR			R4, =0xBABEFACE
			LDR			R5, =0xDEADBEEF
			LDR			R6, =0xC0DEF0DE
			LDR			R7, =0xFADEFEED
			
			STMDB		SP! , {R4-R7, LR}		; (STM) Store Multiple registers, (DB) Decrement address Before each transfer
												; ! is an optional suffix to the final address written back into SP
												; initial SP = 0x20000400, after instruction SP = 0x200003EC 
												; difference is 0x14 = 20 = 5 * 4 as 5 registers have been stored
			LDR			R4, =0x00000000
			LDR			R5, =0x00000000
			LDR			R6, =0x00000000
			LDR			R7, =0x00000000
			
			LDMIA		SP! , {R4-R7, PC}		; (LDM) Load Multiple registers,  (IA) Increment address After each transfer
												;  R4-R7 are populated with their previous values and PC has been loaded with LR content

Stop		B 			Stop
			ALIGN
			END
				