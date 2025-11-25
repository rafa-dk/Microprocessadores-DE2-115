.global ARQANI
ARQANI:

    movi r9, 0
	movi r8, 0		#topo da pilha
	movi r7, 0		#digito
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4

	#Prepara a pilha para armazenar 8 digitos
    subi sp, sp, 32

DIREITA:
    #Empilha o digito

    movia r7, ORDEM_ANIMACAO
    add r7, r7, r15
    ldb r7, (r7)

    mul r8, r15, r20    #r8 = r15 * 4 (r20 ja tem 4)
    add r8, sp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

call DISPLAY
br DIREITA

ESQUERDA:


    call DISPLAY

# Libera o espaco alocado na pilha para os digitos
addi sp, sp, 32

ret

ORDEM_ANIMACAO:
.byte 0x6, 0x2, 0x0, 0x2, 0xA, 0x1, 0x0, 0xA
