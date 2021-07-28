; Exercice to turn on the Green LED. Programmed with Stellaris ICDI (installed a patch as this programming option has been discontinued
; in KEIL) and with Segger J-Link edu mini (soldered connectors and branch jumper wires as shown in https://wiki.segger.com/TM4C123G_LaunchPad


SYSCTL_BASE			EQU	   	0x400FE000						; System Control registers base
RCGCGPIO_OFFSET		EQU	   	0x608							; General-Purpose Input/Output Run Mode Clock Gating Control
SYSCTL_RCGCGPIO_R	EQU	   	SYSCTL_BASE + RCGCGPIO_OFFSET	; RCGCGPIO register address
						   
GPIO_F_BASE			EQU	   	0x40025000						; GPIO Port F (APB): 0x4002.5000
						   
GPIO_F_DIR_OFFSET	EQU		0x400	
GPIO_F_DIR_R		EQU	   	GPIO_F_BASE + GPIO_F_DIR_OFFSET	; GPIO Direction register


; /!\ The GPIO ports allow for the modification of individual bits in the GPIODATA register by using bits [9:2]
;     of the address bus as a mask. In this manner, software drivers can modify individual GPIO pins in a single
;     instruction without affecting the state of the other pins. Therefore in order to write to GPIODATA, the 
;     corresponding bits in the mask Otherwise, the bit values remain unchanged by the write.
;     The value 0x3FC (0b1111111100) enables all the 8 pins of the port F

GPIO_F_DATA_OFFSET	EQU	   	0x3FC	
GPIO_F_DATA_R		EQU		GPIO_F_BASE + GPIO_F_DATA_OFFSET	; GPIO DATA Output(/Input) register

GPIO_F_DEN_OFFSET	EQU		0x51C
GPIO_F_DEN_R		EQU		GPIO_F_BASE + GPIO_F_DEN_OFFSET	; GPIO Digital Enable. To use the pin as a digital input or output 
															; the corresponding GPIODEN bit must be set.
	
GPIO_F_EN			EQU		1 << 5							; bit 5 of RCGCGPIO register : Port F Run Mode Clock Gating Control
															; value 1  : Enable and provide a clock to GPIO Port F in Run mode
LED_RED				EQU		1 << 1							; LED RED    = PF1
LED_BLUE			EQU		1 << 2							; LED GREEN  = PF2
LED_GREEN			EQU		1 << 3							; LED BLUE   = PF3
	

			AREA |.text|, CODE; READONLY, ALIGN=2
			THUMB
			ENTRY
			EXPORT __main

__main
					BL		GPIO_Init

Loop
					BL		LED_On
					B		Loop
	
GPIO_Init
					; Enable the clock for PORT F
					LDR		R1, = SYSCTL_RCGCGPIO_R
					LDR		R0, [R1]
					ORR		R0, #GPIO_F_EN
					STR		R0, [R1]
					NOP
					NOP
					
					; Set PF1 pin as output
					LDR		R1, = GPIO_F_DIR_R
					LDR		R0, [R1]
					ORR		R0, #LED_RED
					STR		R0, [R1]
					
					; Digital enable of PF1 pin as output
					LDR		R1, = GPIO_F_DEN_R
					LDR		R0, [R1]
					ORR		R0, #LED_RED
					STR		R0, [R1]
					
					BX		LR
					
LED_On				
					; Set GPIO PF1 at 1
					LDR		R1, = GPIO_F_DATA_R
					MOV		R0, #LED_RED
					STR		R0, [R1]
					
					BX		LR
					
					ALIGN
					END
					
					
					
					
					
	