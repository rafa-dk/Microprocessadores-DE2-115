/****
SHIFT
****/

.global SHIFT_R
.global SHIFT_L

SHIFT_L:
    #Prologo
    subi sp, sp, 32
    stw ra, 28(sp)
    stw fp, 24(sp)
    stw r4, 20(sp)
    stw r5, 16(sp)
    stw r6, 12(sp)
    stw r7, 8(sp)
    stw r8, 4(sp)
    stw r9, 0(sp)

    addi fp, sp, 32

    #r4 = endereco do vetor ORDEM_ANIMACAO

    movia r4, ORDEM_ANIMACAO

    #Carrega o ultimo elemento (posicao 7)
    ldw r5, 28(r4)        #7 * 4 = 28

    #Desloca todos os outros para a direita
    movi r6, 6            #Indice = 6
SHIFT_LOOP_L:
    slli r7, r6, 2        #r7 = r6 * 4
    add r9, r4, r7      #r4 + (i * 4)
    ldw r8, (r9)     #Le ORDEM[i]

    addi r7, r7, 4
    add r9, r4, r7
    stw r8, (r9)     #Escreve em ORDEM[i+1]
    addi r6, r6, -1
    bge r6, r0, SHIFT_LOOP_L

    #Coloca o ultimo elemento na posicao 0
    stw r5, (r4)

    br FIM_SHIFT

SHIFT_R:
    #Prologo
    subi sp, sp, 32
    stw ra, 28(sp)
    stw fp, 24(sp)
    stw r4, 20(sp)
    stw r5, 16(sp)
    stw r6, 12(sp)
    stw r7, 8(sp)
    stw r8, 4(sp)
    stw r9, 0(sp)

    addi fp, sp, 32

    #r4 = endereco do vetor ORDEM_ANIMACAO
    movia r4, ORDEM_ANIMACAO

    #Carrega o primeiro elemento (posicao 0)
    ldw r5, 0(r4)        #Salva elemento 0

    #Desloca todos os outros para a esquerda (indice menor)
    movi r6, 1            #Indice = 1
SHIFT_LOOP_R:
    slli r7, r6, 2        #r7 = r6 * 4 (offset atual)
    add r9, r4, r7        #r9 = &ORDEM[i]
    ldw r8, (r9)          #Le ORDEM[i]

    subi r7, r7, 4        #Offset anterior (i-1)
    add r9, r4, r7        #r9 = &ORDEM[i-1]
    stw r8, (r9)          #Escreve em ORDEM[i-1]

    addi r6, r6, 1        #i++
    movi r7, 8            #Limite
    blt r6, r7, SHIFT_LOOP_R

    #Coloca o primeiro elemento na ultima posicao (7)
    stw r5, 28(r4)

FIM_SHIFT:
    #Epilogo
    ldw ra, 28(sp)
    ldw fp, 24(sp)
    ldw r4, 20(sp)
    ldw r5, 16(sp)
    ldw r6, 12(sp)
    ldw r7, 8(sp)
    ldw r8, 4(sp)
    ldw r9, 0(sp)
    addi sp, sp, 32

    ret