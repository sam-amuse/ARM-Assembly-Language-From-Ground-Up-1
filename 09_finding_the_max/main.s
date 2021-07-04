COUNT	RN	R0
MAX		RN	R1
POINTER	RN	R2
NEXT	RN	R3
MIN		RN	R4

		AREA	myData, DATA, READONLY

MYDATA	DCD		69,87,186,45,75,22,110,105	

		AREA	myCode, CODE, READONLY
		ENTRY
		EXPORT		__main
			
			; Find the maximum : /!\ works only with unsigned numbers			
__main
		MOV		COUNT, #8			; there is 8 elements in the list
		MOV		MAX, #0				; initialize the variable max to 0
									; for the first compare
		LDR		POINTER, =MYDATA	; add the address of the list in the POINTER register 
		
AGAIN	LDR		NEXT, [POINTER]		; load the element from the list into the register NEXT
		CMP		MAX, NEXT 			; MAX-NEXT ?
		BHS		CTNU				; Branch if Higher or Same
									; Branch to CTNU directly if MAX > NEXT
		MOV		MAX, NEXT			; if MAX-NEXT < 0, NEXT > MAX so replace MAX by NEXT

CTNU	ADD		POINTER, POINTER, #4; increment list pointer of 4 bytes (size of DCD variable)
		SUBS	COUNT, COUNT, #1	; decrease list count
		BNE		AGAIN				; stay in the loop while not 0
		
Stop	B 		Stop

		END