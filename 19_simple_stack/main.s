
			AREA		SimpleStack, CODE, READONLY
			ENTRY
			EXPORT		__main
					
; put 2 values in the stack and get them back
__main		
			LDR			R3, =0xDEADBEEF
			LDR			R4, =0xBABEFACE
			PUSH		{R3}				; check the SP(Stack Pointer) R13 = 0x20000400
											; 0xDEADBEEF is at address 0x200003FC (0x20000400 - 0x4)
			PUSH		{R4}				; 0xBABEFACE is at address 0x200003F8 (0x20000400 - 0x8)
			POP			{R5}				; R5 = 0xBABEFACE
			POP			{R6}				; R6 = 0xDEADBEEF

Stop		B 			Stop
			ALIGN
			END
				