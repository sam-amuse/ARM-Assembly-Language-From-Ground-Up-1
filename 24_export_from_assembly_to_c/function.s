	
			; |.text| section is important to be able to call it from C
			AREA		|.text|, CODE, READONLY		
			EXPORT		Number				

Number	
			; By convention, you use registers R0 to R3 to pass arguments to subroutines,
			; and R0 to pass a result back to the callers.
			MOV		R7, #121
			BX		LR
			ALIGN
			END
				