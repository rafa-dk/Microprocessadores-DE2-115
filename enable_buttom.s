.global BUTTOM_ON
.global BUTTOM_OFF

BUTTOM_ON:
    #Prologo
    subi sp, sp, 16
    stw ra, 12(sp)
    stw fp, 8(sp)
    stw r8, 4(sp)
    stw r9, 0(sp)

    addi fp, sp, 16

    #habilitar interrupcoes
	#1. setar qual botao precisa da INT
	#-> interrupt mask register (0x10000058)
	movia r8, BUTTOM_BASE
	movia r9, 0b110
	stwio r9, (r8)

	#2. setar o respectivo no bit no ienable (IRQ 1) 
	wrctl ienable, r9	#habilita INT no PB

	#3. seta o bit PIE do processador
	movi r9, 1
	wrctl status, r9

    ret

BUTTOM_OFF:
    #desabilitar interrupcoes
    #1. limpar qual botao precisa da INT
    #-> interrupt mask register (0x10000058)
    movia r8, BUTTOM_BASE
    movi r9, 0b000
    stwio r9, (r8)

    #2. desabilitar o respectivo no bit no ienable (IRQ 1) 
    movi r9, 0b0
    wrctl ienable, r9	#desabilita INT no PB

    #3. limpa o bit PIE do processador
    movi r9, 0
    wrctl status, r9

    #Epilogo
    ldw ra, 12(sp)
    ldw fp, 8(sp)
    ldw r8, 4(sp)
    ldw r9, 0(sp)
    addi sp, sp, 16

    ret
