; When SW1 is pressed LED blinks red
; When SW2 is pressed LED blinks green
; When both are pressed LED blinks blue


SYSCTL_BASE			EQU	   	0x400FE000						; System Control registers base
RCGCGPIO_OFFSET		EQU	   	0x608							; General-Purpose Input/Output Run Mode Clock Gating Control
SYSCTL_RCGCGPIO_R	EQU	   	SYSCTL_BASE + RCGCGPIO_OFFSET	; RCGCGPIO register address
						   
GPIO_F_BASE			EQU	   	0x40025000						; GPIO Port F (APB): 0x4002.5000
						   
GPIO_F_DIR_OFFSET	EQU		0x400	
GPIO_F_DIR_R		EQU	   	GPIO_F_BASE + GPIO_F_DIR_OFFSET	; GPIO Direction register

GPIO_F_DATA_OFFSET	EQU	   	0x3FC							; The value 0x3FC enables all 8 port pins (cf datasheet and previous exercice)
GPIO_F_DATA_R		EQU		GPIO_F_BASE + GPIO_F_DATA_OFFSET; GPIO DATA Output(/Input) register

GPIO_F_DEN_OFFSET	EQU		0x51C
GPIO_F_DEN_R		EQU		GPIO_F_BASE + GPIO_F_DEN_OFFSET	; GPIO Digital Enable. 

GPIO_F_PUR_OFFSET	EQU		0x510							; When a bit is set, a weak pull-up resistor on the corresponding GPIO signal is enabled
GPIO_F_PUR_R		EQU		GPIO_F_BASE + GPIO_F_PUR_OFFSET


; /!\ the NMI and JTAG/SWD debug port can only be converted to GPIOs through a deliberate set of writes to the GPIOLOCK, GPIOCR, and the corresponding registers.
GPIO_F_LOCK_OFFSET	EQU		0x520
GPIO_F_LOCK_R		EQU		GPIO_F_BASE + GPIO_F_LOCK_OFFSET; GPIOLOCK register enables write access to the GPIOCR register 

GPIO_F_CR_OFFSET	EQU		0x524
GPIO_F_CR_R			EQU		GPIO_F_BASE + GPIO_F_CR_OFFSET	; GPIOCR register determines which bits of GPIOPUR/GPIODEN are committed when an access is performed
															; This register is designed to prevent accidental programming of the registers that control connectivity 
															; to the NMI and JTAG/SWD debug hardware

LOCK_KEY			EQU		0x4C4F434B						; value given in the datasheet to unlock the CR register

GPIO_F_EN			EQU		1 << 5							; bit 5 of RCGCGPIO register : Port F Run Mode Clock Gating Control
															
LED_RED				EQU		1 << 1							; LED RED    = PF1
RED_OFF				EQU		0 << 1
LED_BLUE			EQU		1 << 2							; LED GREEN  = PF2
LED_GREEN			EQU		1 << 3							; LED BLUE   = PF3
ALL_LED_OFF			EQU		0x0
SW1					EQU		1 << 4							; SW1 		 = PF4 
SW2					EQU		1 << 0							; SW2		 = PF0 

; The switch buttons are active low, pressed they connect to the ground
SW1_PRESSED			EQU 	0x01
SW2_PRESSED			EQU		0x10							; equivalent to 0b0001.0000
BOTH_PRESSED		EQU		0x00
NONE_PRESSED		EQU		0x11							; equivalent to 0b0001.0001


ONESEC				EQU		5333333							; 1 second delay (cf previous exercices for the calculation of it)

			AREA |.text|, CODE, READONLY, ALIGN=2
			THUMB
			ENTRY
			EXPORT __main

__main
					BL		GPIO_Init
					
Loop
					BL		GPIO_Read						; return R0 as a parameter of the function called
					
					CMP		R0, #BOTH_PRESSED
					BEQ		_both_pressed
					
					CMP		R0, #NONE_PRESSED				
					BEQ		_none_pressed
					
					CMP		R0, #SW1_PRESSED
					BEQ		_switch1
					
					CMP		R0, #SW2_PRESSED
					BEQ		_switch2
					
					B		Loop
					
; switch 1 is pressed, turn on Red LED	
_switch1
					MOV 	R0, #LED_RED
					BL		LED_Blink
					B		Loop
					
; switch 2 is pressed, turn on Green LED					
_switch2
					MOV 	R0, #LED_GREEN
					BL		LED_Blink
					B		Loop

; both are pressed, turn on Blue LED
_both_pressed
					MOV 	R0, #LED_BLUE
					BL		LED_Blink
					B		Loop
					
; none pressed, turn off all LED
_none_pressed
					MOV 	R0, #ALL_LED_OFF
					BL		LED_Blink
					B		Loop
					
GPIO_Init
					; Enable the clock for PORT F
					LDR		R1, = SYSCTL_RCGCGPIO_R
					LDR		R0, [R1]
					ORR		R0, #GPIO_F_EN
					STR		R0, [R1]
					NOP
					NOP
					
					; unlock PF0
					LDR		R1, = GPIO_F_LOCK_R
					LDR		R0, = LOCK_KEY
					STR		R0, [R1] 
					
					; commit PF0
					LDR		R1, = GPIO_F_CR_R
					MOV		R0, #0xFF
					STR		R0, [R1]
					
					; switches are by default already inputs
					; Set PF1 pin as output
					LDR		R1, = GPIO_F_DIR_R
					LDR		R0, [R1]
					ORR		R0, #LED_RED
					ORR		R0, #LED_GREEN
					ORR		R0, #LED_BLUE
					STR		R0, [R1]
					
					; Digital enable of PF1(RED) and PF3(GREEN) pin as output
					LDR		R1, = GPIO_F_DEN_R
					LDR		R0, [R1]
					ORR		R0, #LED_RED
					ORR		R0, #LED_GREEN
					ORR		R0, #LED_BLUE
					ORR		R0, #SW1
					ORR		R0, #SW2
					STR		R0, [R1]
					
					; Set the pull-up register configuration for the 2 switches
					LDR		R1, =GPIO_F_PUR_R
					LDR		R0, [R1]
					ORR		R0, #SW1
					ORR		R0, #SW2
					STR		R0, [R1]
					
					BX		LR

Delay
					SUBS	R3, R3, #1
					BNE		Delay
					BX		LR
					
					
LED_Blink

					; /!\ The link register will be overwritten as a nested BL calls are done
					; Therefore we store the initial LR value with a PUSH and restore it at the end with POP directly in PC
					PUSH    {R0,lr}
					
					; Receive the value of R0 from the calling function (to know which LED is selected)
					; selected LED On for 1 second
					LDR		R1, = GPIO_F_DATA_R
					STR		R0, [R1]
					LDR		R3, =ONESEC

					BL 		Delay
					
					; all LED Off for 1 second
					MOV		R0, #0
					STR		R0, [R1]
					LDR		R3, =ONESEC
					BL 		Delay
					
					POP    {R0,pc}
					;BX		LR
					
GPIO_Read
					LDR		R1, = GPIO_F_DATA_R
					LDR		R0, [R1]
					AND		R0, R0, #0x11 								; check the value of the 2 switches at bit position 1 and 4 with #0x11 as mask
					
					BX		LR											; return R0 value as function output




					ALIGN
					END
