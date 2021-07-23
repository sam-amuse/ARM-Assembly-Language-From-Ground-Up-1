; Enable clock access to the PORT of the PINs with register bit RCC_AHB1ENR->GPIODEN = 1
; Set the PINs as outputs with GPIOD_MODER = 01
; Toggle the output value with GPIOD_ODR

; UM1472 User manual - Discovery kit with STM32F407VG MCU
; Schematic information from  Figure 7 in :
; green  LED : PD12
; orange LED : PD13
; red    LED : PD14
; blue   LED : PD15

; Enable clock of the GPIO port D
RCC_BASE				EQU		0x40023800
AHB1ENR_OFFSET			EQU		0x30
RCC_AHB1ENR				EQU		RCC_BASE + AHB1ENR_OFFSET
GPIOD_EN				EQU		1 << 3  						; Bit 3 GPIODEN: IO port D clock enable, 
																; value 1: IO port D clock enabled (in RCC_AHB1ENR)

; Set the GPIO port (MODe Register) D as outputs
GPIOD_BASE				EQU		0x40020C00
GPIOD_MODER_OFFSET		EQU		0x0	
GPIOD_MODER				EQU		GPIOD_BASE + GPIOD_MODER_OFFSET	; These bits are written by software to configure the I/O direction mode
																; value 01: General purpose output mode
; Toggle the output value with GPIOD_ODR (Output Data Register)
GPIOD_ODR_OFFSET		EQU		0x14
GPIOD_ODR				EQU		GPIOD_BASE + GPIOD_ODR_OFFSET

; GPIO D LED port output offsets
LED_GREEN  				EQU 	1 << 12			
LED_ORANGE 				EQU 	1 << 13
LED_RED    				EQU 	1 << 14
LED_BLUE   				EQU 	1 << 15
	
; GPIO D LED port mode offsets
GPIOD_MODER_GREEN 		EQU		1 << 24 						; Careful (LED_GREEN*2) does not work
GPIOD_MODER_ORANGE		EQU		1 << 26
GPIOD_MODER_RED   		EQU		1 << 28
GPIOD_MODER_BLUE  		EQU		1 << 30
	
DELAY					EQU		0x000F
	 
; system clock is 16 MHz, 1 clock cycle is 62.5n sec
; 1 Delay loop iteration is 3 cycles : 1 cycle for SUB, 2 cycles for BNE instruction (1+P with P=1)
; P here is the number of cycles required for a pipeline refill.
; In the ARM Cortex-M4 Processor Technical Reference Manual, you can read : 
; "The number of cycles required for a pipeline refill. This ranges from 1 to 3 depending on the alignment 
; and width of the target instruction, and whether the processor manages to speculate the address early."

; Therefore, my guess on the value P = 1 is that :
; - 1 no data is required to be loaded from memory
; - 2 the branch targeted instruction is the thumb-2 SUB instruction (short 2 bytes)
; - 3 in our simple delay loop,  the processor manages to speculate the address early

; 1 delay loop = 3*62.5 ns = 187.5 ns
; therefore 1 second corresponds to 1 sec / 187.5 ns = 5 333 333
; NB : ARM Cortex-M4 Processor Technical Reference Manual to know the number of cycles for each instruction

ONESEC					EQU		5333333							

	
			AREA |.text|, CODE, READONLY, ALIGN=2
			THUMB
			EXPORT __main

__main
			BL			GPIOD_Init	
			
GPIOD_Init
			; set bit GPIOD_EN in RCC_AHB1ENR register
			LDR			R0, =RCC_AHB1ENR
			LDR			R1, [R0]
			ORR			R1, #GPIOD_EN
			STR			R1, [R0]
			
			; set the pins as outputs
			LDR			R0, = GPIOD_MODER
			LDR			R1, = (GPIOD_MODER_GREEN :OR: GPIOD_MODER_ORANGE :OR: GPIOD_MODER_RED :OR: GPIOD_MODER_BLUE) 
			STR			R1, [R0]								; set the LED pins of register D as outputs
			MOV			R1, #0
			LDR			R2, = GPIOD_ODR							; set the register D outputs address in R2

Blink			
			MOVW		R1, #LED_GREEN
			STR			R1, [R2]								; enable the green LED for 1 second
			LDR			R3, = ONESEC
			BL			Delay
			
			MOVW		R1, #LED_ORANGE
			STR			R1, [R2]									
			LDR			R3, = ONESEC
			BL			Delay
			
			MOVW		R1, #LED_RED
			STR			R1, [R2]									
			LDR			R3, = ONESEC
			BL			Delay
			
			MOVW		R1, #LED_BLUE
			STR			R1, [R2]									
			LDR			R3, = ONESEC
			BL			Delay
			BL			Blink
			
Delay
			SUBS		R3, R3, #1		
			BNE			Delay
			BX			LR
			ALIGN

			END



