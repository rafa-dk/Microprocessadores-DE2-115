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

    movi r4, 0
    movia r5, UART_VALID
    mov r6, r0
	movi r8, 0		#topo da pilha
	movi r7, 0		#digito
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4

DIREITA:
    #Empilha o digito

    movia r7, ORDEM_ANIMACAO
    mul r8, r15, r20    #r8 = r15 * 4 (r20 ja tem 4)
    add r7, r7, r8
    ldw r7, (r7)

    add r8, sp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

    call DISPLAY
    call SHIFT
    ldw r4, (r5)
    bne r4, r0, FIM_ANIMACAO
    br DIREITA

ESQUERDA: 


    call DISPLAY

# Libera o espaco alocado na pilha para os digitos
FIM_ANIMACAO:
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
