.global ARQANI
.global ORDEM_ANIMACAO

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

    # Inicializa variaveis GLOBAIS da animacao (usadas na ISR) ANTES de habilitar interrupcoes
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4
    movi r4, 0
    movia r5, UART_BASE
    mov r6, r0
	movi r8, 0		#topo da pilha
	movi r7, 0		#digito

    call RESUME_ANIMACAO
    call BUTTOM_ON

ANIMACAO_LOOP:
    call UART
    movi r9, 0x2
    addi r4, r4,-0x30
    bne r4, r9, ANIMACAO_LOOP
    call UART
    movi r9, 0x1
    addi r4, r4, -0x30
    beq r4, r9, FIM_ANIMACAO
    br ANIMACAO_LOOP

FIM_ANIMACAO:
    call STOP_ANIMACAO
    call BUTTOM_OFF

#Apagar Display
    movi r15, 0		#num de iteracoes
    movi r7, 12

OFF_ANIMACAO:
    slli r8, r15, 2    #r8 = r15 * 4 (r20 ja tem 4)
    add r8, sp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, OFF_ANIMACAO #Se r15 nao eh 8, continua o loop

    call DISPLAY
    call ESPACO

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
