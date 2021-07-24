; Blink the green LED of the STM32F446 NUCLEO 64 Board using BSRR and ODR (commented) registers
; green  LED is on the PA5

; /!\ Warning : On my  nucleo board, the programming and debugging pins are SWDIO and SWCLK are respectively 
;		        PA13 and PA14 therefore while setting the GPIO A Port as output it makes
; 				programming and debug disfunctional. You get "Internal command error" after 
;				the chip programming and the debug session is shut down
;				I did not have this issue on the STM32F407 discovery board as LEDs are on port D

; 				You can handle this problem by selecting in Options->Debug->(Use ST-Link Debugger) Settings->Connect "Under Reset"


; Enable clock of the GPIO port A
RCC_BASE				EQU		0x40023800
AHB1ENR_OFFSET			EQU		0x30
RCC_AHB1ENR				EQU		RCC_BASE + AHB1ENR_OFFSET
GPIOA_EN				EQU		1 << 0  						; Bit 0 GPIOAEN: IO port A clock enable 

; Set the GPIO port (MODe Register) A as outputs
GPIOA_BASE				EQU		0x40020000
GPIOA_MODER_OFFSET		EQU		0x0	
GPIOA_MODER				EQU		GPIOA_BASE + GPIOA_MODER_OFFSET	; These bits are written by software to configure the I/O direction mode
																; value 01: General purpose output mode
; Toggle the output value with GPIOA_ODR (Output Data Register)
GPIOA_ODR_OFFSET		EQU		0x14
GPIOA_ODR				EQU		GPIOA_BASE + GPIOA_ODR_OFFSET

GPIOA_BSRR_OFFSET		EQU		0x18
GPIOA_BSRR				EQU		GPIOA_BASE + GPIOA_BSRR_OFFSET

LED_GREEN_ON  			EQU 	1 << 5						; green led on GPIO PA5	
LED_GREEN_OFF			EQU		0 << 5
	
BSRR_5_SET				EQU		1 << 5	
BSRR_5_RESET			EQU		1 << 21	
	
; GPIO A LED port mode offsets
GPIOA_MODER_GREEN 		EQU		1 << 10 						; Careful (LED_GREEN*2) does not work
	
DELAY					EQU		0x000F
	 
; 1 delay loop = 3*62.5 ns = 187.5 ns
; therefore 1 second corresponds to 1 sec / 187.5 ns = 5 333 333

ONESEC					EQU		5333333	
HALFSEC					EQU		2666666
ONETENTHSEC				EQU		533333


	
			AREA |.text|, CODE, READONLY, ALIGN=2
			THUMB
			EXPORT __main

__main
			BL			GPIOA_Init	
			
GPIOA_Init
			; set bit GPIOA_EN in RCC_AHB1ENR register
			LDR			R0, =RCC_AHB1ENR
			LDR			R1, [R0]
			ORR			R1, #GPIOA_EN
			STR			R1, [R0]
			
			; set the pins as outputs
			LDR			R0, = GPIOA_MODER
			LDR			R1, = GPIOA_MODER_GREEN
			STR			R1, [R0]								; set the LED pins of register D as outputs
			MOV			R1, #0
			;LDR			R2, = GPIOA_ODR							; set the register D outputs address in R2
			LDR			R2, = GPIOA_BSRR

Blink			
			;MOVW		R1, #LED_GREEN_ON
			MOV			R1, #BSRR_5_SET
			STR			R1, [R2]								; enable the green LED for 1 second
			LDR			R3, = ONETENTHSEC
			BL			Delay
			
			;MOVW		R1, #LED_GREEN_OFF
			MOV			R1, #BSRR_5_RESET
			STR			R1, [R2]								; disable the green LED for 1 second
			LDR			R3, = ONETENTHSEC
			BL			Delay
			
			BL			Blink
			
Delay
			SUBS		R3, R3, #1		
			BNE			Delay
			BX			LR
			ALIGN

			END



