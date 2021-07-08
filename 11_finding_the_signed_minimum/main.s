
				AREA	myCode, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Find the minimum of signed numbers
; At the end, -40 (0xD8 is present in R2 register)
__main		
				LDR		R0, =SIGNED_DATA
				MOV		R3, #8				; there is 8 elements in the list
				LDRSB	R2, [R0]			; load the first element of the list AS SIGNED NUMBER in R1 
				ADD		R0, R0, #1			; increment the list pointer
				
BEGIN			LDRSB	R1, [R0]			; load the next element of the list AS SIGNED NUMBER in R1 
				CMP		R1, R2				; compare with R1-R2 
				BGE		NEXT				; Branch Greater or Equal for SIGNED NUMBER : if CMP R1-R2 >=0 , then R1 >= R2
											; R2 is already the smallest element so directly branch to NEXT 
				MOV		R2, R1				; set R1 value in R2 as the new smallest element
				
NEXT			ADD		R0, R0, #1			; increment the list pointer
				SUBS	R3, R3, #1			; decrement the number of element counter
				BNE		BEGIN				; branch while non-zero result
				
Stop			B 		Stop
			
SIGNED_DATA		DCB		+13,-10,+19,+14,-18,-9,+12,-40
				
				ALIGN
				END