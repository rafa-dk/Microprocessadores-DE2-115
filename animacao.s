.global ARQANI
.global ORDEM_ANIMACAO

.equ UART_VALID, 0x10001000 

ARQANI:
    # Prologo
    subi sp, sp, 72
    stw ra, 68(sp)
    stw fp, 64(sp)
    stw r4, 60(sp)
    stw r5, 56(sp)
    stw r6, 52(sp)
    stw r8, 48(sp)
    stw r7, 44(sp)
    stw r15, 40(sp)
    stw r16, 36(sp)
    stw r20, 32(sp)
    
    addi fp, sp, 72

    #habilitar interrupcoes
	#1. setar timer
	#-> interrupt timer (0x10002000)
	movia r10, 0x10002000	#timer
	movia r9, 100000000     #200ms

	andi r6, r9, 0xFFFF
	stwio r6, 8(r10)	#low

	srli r6, r9, 16
	stwio r6, 12(r10)	#high

	movia r9, 0b101
	stwio r9, 4(r10)

	#2. setar o respectivo no bit no ienable (IRQ 1) 
	movia r9, 0b1
	wrctl ienable, r9	#habilita INT no PB

	#3. seta o bit PIE do processador
	movi r9, 1
	wrctl status, r9

    movi r4, 0
    movia r5, UART_VALID
    mov r6, r0
	movi r8, 0		#topo da pilha
	movi r7, 0		#digito
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4

ANIMACAO_LOOP:
    ldw r4, (r5)
    #bne r4, r0, FIM_ANIMACAO
    br ANIMACAO_LOOP


# Libera o espaco alocado na pilha para os digitos
FIM_ANIMACAO:

    # DESABILITAR interrupções do TIMER
    movia r10, 0x10002000     # base do timer

    # 1. Desliga o timer e desativa ITO (bit 2)
    stwio r0, 4(r10)          # CONTROL = 0 -> timer parado, sem interrupção

    # 2. Limpa o bit da interrupção do timer em IENABLE (assumindo IRQ 0)
    rdctl r6, ienable
    andi  r6, r6, 0b11111110     # limpa bit 0
    wrctl ienable, r6

    # 3. desabilitar todas as interrupções globais:
    rdctl r6, status
    andi  r6, r6, 0xFFFE        # zera bit PIE
    wrctl status, r6
    
    # Epilogo

    ldw ra, 68(sp)
    ldw fp, 64(sp)
    ldw r4, 60(sp)
    ldw r5, 56(sp)
    ldw r6, 52(sp)
    ldw r8, 48(sp)
    ldw r7, 44(sp)
    ldw r15, 40(sp)
    ldw r16, 36(sp)
    ldw r20, 32(sp)
    addi sp, sp, 72

    ret

ORDEM_ANIMACAO:
.word 6,2,0,2,10,1,0,10