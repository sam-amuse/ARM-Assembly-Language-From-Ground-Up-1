		AREA	myCode, CODE, READONLY
		ENTRY
		EXPORT		__main
			
; Adding signed numbers		
__main
		LDR		R0, =SIGNED_DATA		; pointer address of the number list 
		MOV		R3, #9					; number of elements in the list
		MOV		R2, #0					; counter initialisation
		 
L		LDRSB	R1, [R0]				; load the n-th element of the list in R1 
		ADD		R2, R2, R1				; add the n-th value to the total
		ADD		R0, R0, #1				; increment the list pointer
		SUBS	R3, R3, #1				; decrement the counter
		BNE		L						; branch the loop back while different of 0

Stop	B 		Stop

; total of all number is 8 so at the end of the test R2 = 0x00000008
; /!\ Careful, all number are signed BYTES i.e.  : -10 is 0xF6 so 0xFFFFFFF6 on 4 bytes
SIGNED_DATA	DCB		+13,-10,+9,+14,-18,-9,+12,-19,+16	

		END