.global ARQANI
.global ORDEM_ANIMACAO

.equ UART_VALID, 0x10001000 
.equ DISPLAYS_BASE, 0x10000020  #Endereco base dos displays de 7 segmentos
.equ STACK, 0x10000

ARQANI:
    movia sp, STACK
	mov fp, sp
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

    
/*
Sub-rotina DISPLAY
Exibe nos displays de 7 segmentos os digitos que foram previamente
calculados e colocados na pilha

Argumentos (passados por convenção de 'triangular.s'):
- r16: Contem o numero de digitos a serem exibidos
- r4: Endereco do buffer com os digitos

Registradores usados: r4, r5, r6, r7, r8, r9, r10
 */
DISPLAY:
    # --- Salva os registradores que serão usados ---
    subi sp, sp, 40
    stw ra, 36(sp)
    stw fp, 32(sp)
    stw r5, 28(sp)
    stw r6, 24(sp)
    stw r7, 20(sp)
    stw r8, 16(sp)
    stw r9, 12(sp)
    stw r10, 8(sp)
    stw r11, 4(sp)
    stw r12, 0(sp)

    addi fp, sp, 40

    movia r9, DISPLAYS_BASE #r9 = Endereco do registrador dos displays
    mov r10, r0             #r10 = contador de displays (0, 1, 2...)
    mov r11, r0             #r11 = buffer acumulador para os displays (inicia zerado)
    mov r12, r0             #r12 = buffer acumulador para os displays high (inicia zerado)

DISPLAY_LOOP:
    #Se o contador de displays (r10) for igual ao numero de digitos (r16), terminamos
    beq r10, r16, WRITE_DISPLAYS

    #Calcula o endereco do digito no buffer (r4)
    movi r6, 4              #Carrega 4 em r6 para multiplicacao
    mul r5, r10, r6         #Calcula o offset para o digito atual (0*4, 1*4, ...)
    add r5, fp, r5          #SOMA r4 (base) e r5 (offset) para obter o endereco final do digito
    ldw r7, (r5)           #r7 = carrega o digito (ex: 3)

    #Converte o digito (0-9) para o codigo do display de 7 segmentos
    movia r8, SETE_SEG      #Carrega o endereco da tabela de conversao
    add r8, r8, r7          #Adiciona o digito como um indice
    ldb r8, (r8)           #Carrega o byte do padrao de 7 segmentos

    # Verifica se eh Low (0-3) ou High (4-7)
    blt r10, r6, PROCESS_LOW

PROCESS_HIGH:
    subi r5, r10, 4         # Indice relativo (0-3)
    slli r5, r5, 3     
    sll r8, r8, r5
    or r12, r12, r8
    br NEXT_ITER

PROCESS_LOW:
    slli r5, r10, 3       
    sll r8, r8, r5
    or r11, r11, r8

NEXT_ITER:
    #Prepara para o proximo display
    addi r10, r10, 1        #Incrementa o contador de displays
    br DISPLAY_LOOP

WRITE_DISPLAYS:
    #Escreve a palavra completa de 32 bits nos displays
    stwio r11, 0(r9)        #Escreve nos displays 0-3 (offset 0x00)
    stwio r12, 16(r9)       #Escreve nos displays 4-7 (offset 0x10)

END_DISPLAY:
    ldw ra, 36(sp)
    ldw fp, 32(sp)
    ldw r5, 28(sp)
    ldw r6, 24(sp)
    ldw r7, 20(sp)
    ldw r8, 16(sp)
    ldw r9, 12(sp)
    ldw r10, 8(sp)
    ldw r11, 4(sp)
    ldw r12, 0(sp)
    addi sp, sp, 40
/*****************************************************/

#SHIFT

SHIFT:
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

    # r4 = endereço do vetor ORDEM_ANIMACAO

    movia r4, ORDEM_ANIMACAO

    # carrega o último elemento (posição 7)
    ldw r5, 28(r4)        # 7 * 4 = 28

    # desloca todos os outros para a direita
    movi r6, 6            # índice = 6
SHIFT_LOOP:
    slli r7, r6, 2        # r7 = r6 * 4
    add r9, r4, r7      # r4 + (i * 4)
    ldw r8, (r9)     # lê ORDEM[i]

    addi r7, r7, 4
    add r9, r4, r7
    stw r8, (r9)     # escreve em ORDEM[i+1]
    addi r6, r6, -1
    bge r6, r0, SHIFT_LOOP

    # coloca o último elemento na posição 0
    stw r5, (r4)

FIM_SHIFT:
    # Epilogo
    ldw ra, 28(sp)
    ldw fp, 24(sp)
    ldw r4, 20(sp)
    ldw r5, 16(sp)
    ldw r6, 12(sp)
    ldw r7, 8(sp)
    ldw r8, 4(sp)
    ldw r9, 0(sp)
    addi sp, sp, 32

/***************************************************/

    ldw r4, (r5)
    bne r4, r0, FIM_ANIMACAO
    br DIREITA

ESQUERDA: 


    #call DISPLAY

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


SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x00
#Caracteres para o display: 0,1,2,3,4,5,6,7,8,9, space

