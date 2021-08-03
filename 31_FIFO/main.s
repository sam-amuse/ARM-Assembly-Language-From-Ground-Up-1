; /!\ This implementation of the circular FIFO/buffer/queue is of size 7 (SIZE-1)
; because the check for full fifo test is PutPt+1 = GetPt
; FIFO access sequence to test it is the following( X is the empty element)

; 10 | X  | X  | X  | X  | X  | X  | X |
; 10 | 20 | X  | X  | X  | X  | X  | X |
; 10 | 20 | 30 | X  | X  | X  | X  | X |
; 10 | 20 | 30 | 40 | X  | X  | X  | X |
; 10 | 20 | 30 | 40 | 50 | X  | X  | X |
; 10 | 20 | 30 | 40 | 50 | 60 | X  | X |
; 10 | 20 | 30 | 40 | 50 | 60 | 70 | X |
; FIFO Full -> Put function return 0
; X  | 20 | 30 | 40 | 50 | 60 | 70 | X  |
; X  | X  | 30 | 40 | 50 | 60 | 70 | X  |
; X  | X  | X  | 40 | 50 | 60 | 70 | X  |
; X  | X  | X  | 40 | 50 | 60 | 70 | 11 |
; 22 | X  | X  | 40 | 50 | 60 | 70 | 11 |
; 22 | X  | X  | 40 | 50 | 60 | 70 | 11 |
; 22 | 33 | X  | X  | 50 | 60 | 70 | 11 |
; 22 | 33 | X  | X  | X  | X  | X  | 11 |
; 22 | 33 | X  | X  | X  | X  | X  | X  |
; X  | 33 | X  | X  | X  | X  | X  | X  |
; X  | X  | X  | X  | X  | X  | X  | X  |
; FIFO Empty -> Get function return 0

		IMPORT	Fifo_Init
		IMPORT	Fifo_Put
		IMPORT	Fifo_Get
		IMPORT	Fifo_Size
	
		AREA 	DATA
		
n		SPACE	9			; address to receive the values received from the Fifo_Get subroutine
		EXPORT	n
	
		AREA 	myFIFO, CODE, READONLY, ALIGN=2
		THUMB
		EXPORT __main

__main
		BL		Fifo_Init
			
		MOV		R0, #10		
		BL		Fifo_Put	
		MOV		R0, #20
		BL		Fifo_Put	
		MOV		R0, #30	
		BL		Fifo_Put	
		MOV		R0, #40		
		BL		Fifo_Put	
		BL		Fifo_Size	; size of 4 
		MOV		R0, #50	
		BL		Fifo_Put
		MOV		R0, #60
		BL		Fifo_Put
		MOV		R0, #70
		BL		Fifo_Put
		BL		Fifo_Size	; size of 7 
		MOV		R0, #80
		BL		Fifo_Put	; put unsuccessful, return R0=0 (FIFO is full)		
		
		LDR		R0, = n		; address of receive buffer
		BL		Fifo_Get	; get value 10
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 20
		ADD		R0, R0, #1
		BL		Fifo_Get	; get value 30
		BL		Fifo_Size	; size of 4 
		MOV		R0, #11		
		BL		Fifo_Put	; put value 11 , return 1 successful
		MOV		R0, #22
		BL		Fifo_Put	; put value 22 , return 1 successful
		MOV		R0, #33
		BL		Fifo_Put	; buffer full (size-1) , return 0 successful
		LDR		R0, = n		
		ADD		R0, R0, #3	
		BL		Fifo_Get	; get value 40
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 50
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 60
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 70
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 11
		ADD		R0, R0, #1	
		BL		Fifo_Get	; get value 22
		ADD		R0, R0, #1		
		BL		Fifo_Get	; get unsuccessful, return R0=0 (FIFO empty)
		BL		Fifo_Size	; size of 0 		
		
Stop 	B 		Stop
		
		END



