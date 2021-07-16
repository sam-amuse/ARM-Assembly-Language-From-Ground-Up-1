
			AREA		simpleFPU, CODE, READONLY
			ENTRY
			EXPORT		__main
					
; transfer floating point number from/to normal/FP registers
__main	
			; enable FPU 
			LDR		R0,=0xE000ED88
			LDR		R1,[R0]
			ORR		R1,R1,#(0xF<<20)
			STR		R1,[R0]

			LDR 	R3, =0x3F800000 	; load FP value in  main register
			VMOV.F	S3, R3				; move value from main to fp register
			
			VLDR.F	S4, = 6.0221415e23	; load FP value in  FP register
			VMOV.F	R4, S4				; move value from fp register to main 

Stop		B 			Stop
			ALIGN
			END
				