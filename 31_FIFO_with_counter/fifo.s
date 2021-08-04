; FIFO is EMPTY or FULL when tail pointer (GetPt) = head pointer (PutPt)
; to differentiate between them, a flag is used
; when the FIFO head starts a new round, flag is set to 1
; when the FIFO tail starts a new round, flag is set to 0
; therefore when PutPt = GetPt , 
; if Flag = 1 , Fifo is full, Head is one round in advance to Tail
; if Flag = 0 , Fifo is empty, Head and Tail are in the same round

; Note that the first four registers r0-r3 are passed as arguments to the subroutine
; and to return a result value from a function

		AREA 	DATA
	
SIZE	EQU		8	
PutPt   SPACE  	4	
GetPt   SPACE   4
Fifo    SPACE   SIZE					; 4 bytes FIFO
Flag	SPACE   4

		EXPORT	PutPt	[DATA, SIZE=4]
		EXPORT	GetPt	[DATA, SIZE=4]
		EXPORT	Fifo	[DATA, SIZE=8]
		EXPORT	Flag	[DATA, SIZE=4]
		
		EXPORT	Fifo_Init
		EXPORT	Fifo_Put
		EXPORT	Fifo_Get
		EXPORT	Fifo_Size
		
		AREA	fifo, CODE, READONLY

; Both get and put pointers set to the beginning of the FIFO
Fifo_Init
		LDR		R0, = Fifo				; address of Fifo (beginning) 
		LDR		R1, = PutPt
		STR		R0, [R1]				; fifo address stored in PutPt 	
		LDR		R1, = GetPt
		STR		R0, [R1]				; fifo address stored in GetPt 
		LDR		R2, = Flag
		MOV		R0, #0
		STR 	R0, [R2]				; star with a clear flag
		
		BX		LR
		
Fifo_Put
		LDR		R1, = PutPt
		LDR		R2, [R1]				; PutPt 		
		LDR		R12, = Fifo+SIZE
		CMP		R2, R12					; check if should wrap  => PutPt = Fifo+SIZE 
		BNE		NoWrap
		LDR		R2, = Fifo				; wrap
		LDR		R6, = Flag
		MOV		R7, #1
		STR 	R7, [R6]				; set the flag to 1, Head wrapped
NoWrap	LDR		R12, = GetPt
		LDR		R12, [R12]
		CMP		R2, R12					; check 1/2 of FIFO full => PutPt = GetPt 
		BNE		NotFull
		LDR		R6, = Flag
		LDR		R6, [R6]
		CMP		R6, #1					; check 2/2 of FIFO full => Flag = 1
		BNE		NotFull
		MOV		R0, #0					
		BX 		LR	
NotFull	STRB	R0, [R2]				; add the current element				
		ADD		R2, R2, #1
		STR		R2, [R1]				; increment PutPt		
		MOV		R0, #1					
		BX 		LR						

Fifo_Get
		PUSH	{R4, R5, LR}
		LDR		R1, = PutPt
		LDR		R1, [R1]				; load put pointer address in R1
		LDR		R2, = GetPt
		LDR		R3, [R2]				; load get pointer address in R3		
		CMP		R1, R3					
		BNE		N_Empty					; check 1/2 of FIFO empty => PutPt = GetPt 
		LDR		R6, = Flag
		LDR		R6, [R6]
		CMP		R6, #0					; check 2/2 of FIFO empty => Flag = 0			
		BNE		N_Empty
		MOV		R0, #0					
		B		done
N_Empty LDRSB	R4, [R3]				; retrieve/load the FIFO element pointed by GetPt into R4		
		MOV		R5, #0
		STRB	R5, [R3]				; remove the value from the FIFO (by overwritting is with 0) after the get is done 
		STRB	R4, [R0]				; store this FIFO at the address pointed by R0 (pointer passed passed as arguments in the main routine call)
		ADD		R3, R3, #1
		LDR		R5, = Fifo+SIZE  		
		CMP		R3, R5					; check if the getPt needs a wrap around to the beginning of the FIFO
		BNE		NoWrap2
		LDR		R3, = Fifo
		LDR		R6, = Flag
		MOV		R7, #0
		STR 	R7, [R6]				; set the flag to 0, Tail wrapped
NoWrap2 STR		R3, [R2]				; load the new GetPt address that has been incremented or wrapped around
done	POP		{R4, R5, PC}
	
	
Fifo_Size
		LDR		R1, = PutPt
		LDR		R1, [R1]
		LDR		R2, = GetPt
		LDR		R3, [R2]
		SUB		R0, R1, R3
		AND		R0, #(SIZE-1)
		BX		LR
		
		ALIGN
		END
		

		
		