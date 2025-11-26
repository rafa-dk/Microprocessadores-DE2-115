.global DATA
.global CONTROL
.global UART_BASE
.global ALAVANCAS
.global STACK
.global LED_RED
.global DISPLAYS_BASE

.equ DATA, 0x0000
.equ CONTROL, 0x0004
.equ UART_BASE, 0x10001000 	#Endereco base da UART
.equ ALAVANCAS, 0x10000040
.equ STACK, 0x10000
.equ LED_RED, 0x10000000   #Endereco do registrador dos LEDs
.equ DISPLAYS_BASE, 0x10000020  #Endereco base dos displays de 7 segmentos





.global INICIO_CHAR
INICIO_CHAR:
.word 69,110,116,114,101,32,99,111,109,32,111,32,99,111,109,97,110,100,111,58

.global SETE_SEG
SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x00
#Caracteres para o display: 0,1,2,3,4,5,6,7,8,9, space

.global ORDEM_ANIMACAO
ORDEM_ANIMACAO:
.word 6,2,0,2,10,1,0,10

