.global RESUME_ANIMACAO
.global PAUSE_ANIMACAO

STOP_ANIMACAO:
    # Prologo
    subi sp, sp, 20
    stw ra, 16(sp)
    stw fp, 12(sp)
    stw r6, 8(sp)
    stw r9, 4(sp)
    stw r10, 0(sp)

    addi fp, sp, 20

    # DESABILITAR interrupções do TIMER
    movia r10, 0x10002000     # base do timer

    # 1. Desliga o timer e desativa ITO (bit 2)
    stwio r0, 4(r10)          # CONTROL = 0 -> timer parado, sem interrupção
    stwio r0, 0(r10)          # Limpa bit TO (Timeout) para garantir que nao haja INT pendente

    # 2. Limpa o bit da interrupção do timer em IENABLE (assumindo IRQ 0)
    rdctl r6, ienable
    andi  r6, r6, 0b11111110     # limpa bit 0
    wrctl ienable, r6

    # 3. desabilitar todas as interrupções globais:
    rdctl r6, status
    andi  r6, r6, 0xFFFE        # zera bit PIE
    wrctl status, r6

    ret

RESUME_ANIMACAO:
    # Prologo
    subi sp, sp, 20
    stw ra, 16(sp)
    stw fp, 12(sp)
    stw r6, 8(sp)
    stw r9, 4(sp)
    stw r10, 0(sp)

    addi fp, sp, 20

    # Inicializa variaveis GLOBAIS da animacao (usadas na ISR) ANTES de habilitar interrupcoes
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4
    movi r4, 0
    movia r5, UART_BASE
    mov r6, r0
	movi r8, 0		#topo da pilha
	movi r7, 0		#digito

    #habilitar interrupcoes
	#1. setar timer
	#-> interrupt timer (0x10002000)
	movia r10, 0x10002000	#timer
	movia r9, 10000000     #200ms

	andi r6, r9, 0xFFFF
	stwio r6, 8(r10)	#low

	srli r6, r9, 16
	stwio r6, 12(r10)	#high

	movia r9, 0b111
	stwio r9, 4(r10)

	#2. setar o respectivo no bit no ienable (IRQ 1) 
	movia r9, 0b1
	wrctl ienable, r9	#habilita INT no PB

	#3. seta o bit PIE do processador
	movi r9, 1
	wrctl status, r9

    # Epilogo
    ldw ra, 16(sp)
    ldw fp, 12(sp)
    ldw r6, 8(sp)
    ldw r9, 4(sp)
    ldw r10, 0(sp)
    addi sp, sp, 20

    ret
