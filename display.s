/****
MAIN
****/
.equ DISPLAYS_BASE, 0x10000020  #Endereco base dos displays de 7 segmentos

.global DISPLAY

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

    ret

SETE_SEG:
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x00
#Caracteres para o display: 0,1,2,3,4,5,6,7,8,9, space
