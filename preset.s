.equ DATA, 0x0000
.equ CONTROL, 0x0004
.equ UART_BASE, 0x10001000
.equ ALAVANCAS, 0x10000040
.equ STACK, 0x10000
.equ LED_RED, 0x10000000
.equ DISPLAYS_BASE, 0x10000020
.equ BUTTOM_BASE, 0x10000058
.equ BOTOES, 0x1000005c

INICIO_CHAR:
.word 69,110,116,114,101,32,99,111,109,32,111,32,99,111,109,97,110,100,111,58,32

ORDEM_ANIMACAO:
.word 6,2,0,2,12,11,10,12

DIRECAO_ANIMACAO:
.word 1   #0 -> esquerda | 1 -> direita

STOP_BUTTON_ANIMACAO:
.word 1   #0 -> desligado | 1 -> ligado

/*
Tabela de conversao para 7 segmentos
0x3f -> '0'
0x06 -> '1'
0x5b -> '2'
0x4f -> '3'
0x66 -> '4'
0x6d -> '5'
0x7d -> '6'
0x07 -> '7'
0x7f -> '8'
0x6f -> '9'
0x5C -> 'o'
0x04 -> 'i'
0x00 -> ' ' (space)
*/
SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x5C, 0x04, 0x00


.global DATA
.global CONTROL
.global UART_BASE
.global ALAVANCAS
.global STACK
.global LED_RED
.global DISPLAYS_BASE
.global BUTTOM_BASE
.global BOTOES
.global INICIO_CHAR
.global ORDEM_ANIMACAO
.global DIRECAO_ANIMACAO
.global STOP_BUTTON_ANIMACAO
.global SETE_SEG
