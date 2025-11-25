/****
RTI
****/
.org 0x20

#PROLOGO
	addi sp, sp, -4
	stw ra, (sp)
#--------------------------
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS
	subi ea, ea, 4
	
	andi r13, et, 1 
	beq r13, r0, OTHER_INTERRUPTS
	call EXT_IRQ1

OTHER_INTERRUPTS:
	br FIM_RTI

OTHER_EXCEPTIONS:
#EPILOGO
FIM_RTI:
	ldw ra, (sp)
	addi sp, sp, 4
	eret


#ROTINA KEY
EXT_IRQ1:

	

FIM_KEY:
	ret


/****
MAIN
****/

.equ DATA, 0x0000
.equ CONTROL, 0x0004
.equ STACK, 0x10000

.global _start

_start:
	#Inicializa o Stack Pointer (sp)
	movia sp, STACK
	mov fp, sp
	movia r10, 0x10001000
/*
#habilitar interrupcoes
	#1. setar timer
	#-> interrupt timer (0x10002000)
	movia r8, 0x10002000	#timer
	movia r9, 25000000	
	
	andi r6, r9, 0xFFFF
	stwio r6, 8(r8)		#low

	srli r6, r9, 16
	stwio r6, 12(r8)		#high

	movia r9, 0b111
	stwio r9, 4(r8)

	#2. setar o respectivo no bit no ienable (IRQ 1) 
	movia r9, 0b1
	wrctl ienable, r9	#habilita INT no PB

	#3. seta o bit PIE do processador
	movi r9, 1
	wrctl status, r9*/

POLLING:

	call UART
	
	addi r4, r4,-0x30		#converte para decimal
	beq r4, r0, LED

	addi r8, r0, 1
	beq r4, r8, TRIANGULAR

	addi r8, r0, 2
	beq r4, r8, ANIMACAO

	br POLLING


LED:
	call ARQLED
	br POLLING

TRIANGULAR:
	call UART
	addi r4, r4,-0x30		#converte para decimal
	bne r4, r0, POLLING
	call ARQTRI
	br POLLING

ANIMACAO:
	call ARQANI
	br POLLING



/*
	1/2s -> 25.000.000
	
	movia r8, 0x10002000	#timer
	movia r9, 25000000	
	
	andi r10, r9, 0xFFFF
	swtio r10, 8(r8)		#low

	srli r10, r9, 16
	stwio r10, 12(r8)	#high

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	stwio r9, UART
_start:

	andi r9, r10, 0xFF

	stwio r9, UART

	movia r11, LAST_CHAR
	stw r9, (r11)	#salva ultimo char na memoria

LAST_CHAR:
.word 00

*/
