
			AREA		simpleFPU, CODE, READONLY
			ENTRY
			EXPORT		__main
					
; simple addition with FPU
__main	
			; enable FPU 
			LDR		R0,=0xE000ED88
			LDR		R1,[R0]
			ORR		R1,R1,#(0xF<<20)
			STR		R1,[R0]

			VMOV.F	S0, #0x3F800000 ; S0 <= 1.0
			VMOV.F	S1, S0			; S1 <= 1.0
			VADD.F	S2, S1, S0		; S2 <= 1.0 + 1.0 = 2.0 (0x40000000)
				
Stop		B 			Stop
			ALIGN
			END
				