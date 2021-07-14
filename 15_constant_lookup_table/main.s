
				AREA	CteLookupTable, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Access a lookup table of floating point numbers and multiply them   
__main		


		; Enable the Floating Point Unit
		
		; cf Arm®v7-M Architecture Reference Manual , section B3.2.20 Coprocessor Access Control Register, CPACR
		; The 2 bits fields CP10 and CP11 in the CPACR (Coprocessor Access Control Register) together control 
		; access to the floating-point coprocessor
		
		LDR		R0, =0xE000ED88 		; CPACR is located at address 0xE000ED88
		LDR		R1, [R0]				; Read CPACR
		ORR		R1, R1, #(0xF << 20)	; Enable CP10 and CP11 bit fields(0b11 => Full access so 0b1111 for both)
		STR		R1, [R0]				; Write back the modified value to the CPACR
		ADRL	R1, ConstantTable		; Pseudo instruction to load a PC/register-relative address into register.
		
		; S registers are floating point registers that implie 32 bits FP values
		VLDR.F	S2, [R1, #20]			; load the value at the address pointed by R1 + 20 (5*4) therefore Pi (3.14159)
		VLDR.F	S3, [R1, #12]			; load the value at the address pointed by R1 + 12 (3*4) therefore 10.0
		VMUL.F	S4, S2, S3				; multiply both and store result in S4 (31.4159)
				
Stop	B 		Stop
				
				ALIGN


; floating point numbers in IEEE-754 (not rounded) format
; the number is represented in binary form with a base 2 power
; ie decimal 85.125  => binary 1010101.001 => binary 1.010101001 * 2^6
; sign bit 31 = 0 (positive) 
; exponent bits 30-23 => 6 = 133 (- 127) => 133 (0x10000101)
; mantissa bits 22-0 => 010101001 (all the bits except the first 1)
;                       sign exponent   mantissa
; result in binary    = 0    10000101   01010100100000000000000
; hexa grouped binary =	0100 0010 1010 1010 0100 0000 0000 0000  		    
; result in hexa      = 4    2    A    A    4    0    0    0
ConstantTable
				DCD 0x3F800000 ; 1.0 => 1.0 * 2^0 
							   ; with sign 0 , exponent 0 => (127-127) 127 =(0b01111111), mantissa 0
				               ; 0011 1111 1000 0000 ....
							   ; 3    F    8    0
				DCD	0x40000000 ; 2.0 => 1.0 * 2^1
							   ; with sign 0, exponent 1  => (128-127)  => 128 = (0b10000000), mantissa 0 
							   ; 0100 0000 ....
							   ; 4    0 
				DCD	0x80000000 ; -0.0
				DCD	0x41200000 ; 10.0
				DCD 0x42C80000 ; 100.0
				DCD 0x40490FDA ; pi (3.14159) , single precision floating offers here 6 decimal digits precision
							   ;	
							   
				DCD 0x402DF854 ; e
					
				END
				