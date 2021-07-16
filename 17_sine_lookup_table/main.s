; Registers used :
; S0 = result register
; R1 = argument
; R2 = temp
; R4 = starting address of sine table
; R7 = copy of the argument to be compared to know if + or - sin(x)

				AREA	SineLookupTable, CODE, READONLY
				ENTRY
				EXPORT		__main
					
; Calculate the sine of a input value (in degrees) with a lookup table
; input value is in R1 and output value in S0
__main		
		MOV 	R1, #355
		;MOV 	R1, #315				; X = 315 degrees , sin(315) = -0.707107 = 0xBF3504F6
		;MOV 	R1, #225				; X = 225 degrees , sin(225) = -0.707107 = 0xBF3504F6
		;MOV 	R1, #135				; X = 135 degrees , sin(135) = +0.707107 = 0x3F3504F6 
		;MOV 	R1, #45					; X = 34 degrees ,  sin(34)  = +0.559193 = 0x3F0F2745
		MOV		R7, R1					; copy of X to be used in the retvalue function
		LDR		R2, =270				; use LDR instead of MOV as 270 > 255, the 8 bit immediat value
	    ;MOV 	R2, #270
		ADR		R4, sine_table			; load address of sin table			
		
		; 1 st quadrant with angle x < 90
		CMP		R1, #90					
		BLE		retvalue				; Branch Less or Equal
		; 2nd quadrant with angle 90< x < 180
		CMP		R1, #180				
		ITT		LE
		RSBLE	R1, R1, #180			; R1 = 180-R1  as sin(x) = sin(180-x)
		BLE		retvalue
		; 3nd quadrant with angle 180 < x < 270
		CMP		R1, #270				
		ITT		LE
		SUBLE	R1, R1, #180			; R1 = R1-180  as sin(x-180) = - sin(x)
		BLE		retvalue
		; 4th quadrant  270 < x < 360
		RSB		R1, R1, #360			; R1 = 360-R1  as sin(360° - x) = -sin(x)


; return 
retvalue
		ADD 		R5, R4, R1, LSL #2	; calculate the lookup table offset 
		VLDR.F 		S0, [R5]			; load the sin(x) as float number in S0
										; S0 = [R4 + R1*4]		
		
		; if X > 180 negate the value to return -sin(x)
		; otherwise leave it sin(x)
		CMP 		R7, #180				
		IT			GT							
		VNEGGT.F	S0, S0				; Floating-point negate instruction

Stop	B 		Stop
				
				ALIGN



; Sine values from 0 to 90 in ieee 754 FP format
sine_table
		DCD	0x00000000,0x3C8EF77F,0x3D0EF240,0x3D565E46
		DCD	0x3D8EDC3B,0x3DB27ED8,0x3DD612C6,0x3DF99674
		DCD	0x3E0E835D,0x3E20303C,0x3E31D0C8,0x3E43636F
		DCD	0x3E54E6E2,0x3E66598E,0x3E77BA66,0x3E8483EC
		DCD	0x3E8D204A,0x3E95B1C8,0x3E9E3779,0x3EA6B0D9
		DCD	0x3EAF1D3E,0x3EB77C02,0x3EBFCC7D,0x3EC80DE4
		DCD	0x3ED03FD5,0x3ED86162,0x3EE07229,0x3EE87160
		DCD	0x3EF05EA2,0x3EF83904,0x3F000000,0x3F03D987
		DCD	0x3F07A8C5,0x3F0B6D76,0x3F0F2745,0x3F12D5E0
		DCD	0x3F167913,0x3F1A108C,0x3F1D9C06,0x3F211B1D
		DCD	0x3F248DC1,0x3F27F37B,0x3F2B4C2B,0x3F2E976B
		DCD	0x3F31D51B,0x3F3504F6,0x3F3826AA,0x3F3B3A04
		DCD	0x3F3E3EC0,0x3F4134AC,0x3F441B75,0x3F46F30A
		DCD	0x3F49BB16,0x3F4C7357,0x3F4F1BBC,0x3F51B3F2
		DCD	0x3F543BD5,0x3F56B324,0x3F5919AC,0x3F5B6F4B
		DCD	0x3F5DB3D0,0x3F5FE718,0x3F6208E1,0x3F641908
		DCD	0x3F66175D,0x3F6803CD,0x3F69DE15,0x3F6BA637
		DCD	0x3F6D5BEE,0x3F6EFF19,0x3F708FB8,0x3F720D88
		DCD	0x3F737878,0x3F74D067,0x3F761544,0x3F7746ED
		DCD	0x3F786551,0x3F79704F,0x3F7A67E8,0x3F7B4BE8
		DCD	0x3F7C1C60,0x3F7CD91E,0x3F7D8234,0x3F7E177E
		DCD	0x3F7E98FE,0x3F7F06A2,0x3F7F605A,0x3F7FA637
		DCD	0x3F7FD816,0x3F7FF609,0x3F800000
	
		END
				