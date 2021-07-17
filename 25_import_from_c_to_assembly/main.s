			; |.text| is used for code sections produced by the C compiler
			; so this assembly section must be in the same that the C code
			AREA |.text|, CODE, READONLY		
			IMPORT Adder					; import the function name from C
			IMPORT num						; import the global variable name from C
			EXPORT __main
			ENTRY
; Exercice that calls a C function from Assembly code			
__main
			LDR		R1, =num				; store the address of the variable num in R1
			MOV		R0, #100		
			STR		R0, [R1]				; store the value 100 in the variable num
			BL		Adder					; call the C function Adder that will 32 to num
			
			END