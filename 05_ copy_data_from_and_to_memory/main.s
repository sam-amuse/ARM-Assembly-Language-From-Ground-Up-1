
RAM1_ADDR			EQU		0x20000000		
RAM2_ADDR			EQU		0x20000100

		AREA myCode, CODE, READONLY
		ENTRY
		EXPORT __main

; function __main		
__main
		BL		FILL			; BL ( Branch with Link) , 
								; branch to FILL label 
								; save the next instruction address into LR (Link Register : R14)
		BL		COPY
		
Stop
		B		Stop			; infinite loop for the end of the program

; function FILL : fill the first memory location with 10 times 0xDEADBEEF
FILL
		LDR		R1, =RAM1_ADDR	
		MOV		R0, #10			; set counter to 10
		LDR		R2, =0xDEADBEEF
		
L1		STR		R2, [R1]		; store the value present in R2 in the address pointed by R1
		ADD		R1, R1, #4		; increment the pointed address
		SUBS 	R0, R0, #1		; decrement the counter and update the status register with the SUBS instruction
		BNE		L1				; stay in the loop if and only if the zero flag is clear
		BX		LR				; return to the function that called the current function (__main function) 
								; branch back to the link register saved address

; function COPY : copy the first memory location 10 times to the second memory location
COPY	
		LDR		R1, =RAM1_ADDR
		LDR		R2, =RAM2_ADDR
		MOV		R0, #10

								; copy the data from RAM1_ADDR to RAM2_ADDR (through the R3 register)
L2		LDR		R3, [R1] 		; load the value present in the address pointed by R1 into the R3 register
		STR		R3, [R2]		; store the value present in the  R3 register into the address pointed by R2
								
		ADD		R1, R1, #4		; increment RAM1_ADDR address (4 bytes is the size of 0xDEADBEEF)
		ADD		R2, R2, #4		; increment RAM2_ADDR address
		SUBS	R0, R0, #1		; decrement the counter and update the status register 
		BNE		L2				; stay in the loop if and only if the zero flag is clear
		BX		LR				; return to the function that called the current function (__main function) 
								; branch back to the link register saved address
		
		END
		
		
		
		