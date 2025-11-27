/*********
TRIANGULAR
**********/

.global TRIANGULAR

TRIANGULAR:
    #Prologo
    subi sp, sp, 60
    stw ra, 56(sp)
    stw fp, 52(sp)
    stw r16, 48(sp)
    stw r17, 44(sp)
    stw r18, 40(sp)
    stw r19, 36(sp)
    stw r20, 32(sp)
    
    addi fp, sp, 60

    #Inicializacao
    movi r16, 0         #Contador de digitos
    movi r19, 10        #Divisor (10)
    movi r20, 4         #Tamanho da palavra (4 bytes)
    mov r17, r0         #Variavel para calcular o numero triangular

CONVERTER:
    movia r10, ALAVANCAS
    ldwio r18, (r10)    #Le valor das chaves para r18 (Dividend)
    andi r18, r18, 0xFF #Mascara para 8 bits
    mov r6, r18
    beq r6, r0, DIVISAO

NUM_TRIANGULAR:
    #Calcula o numero triangular
    add r18, r18, r17
    addi r17, r17, 1
    bne r6, r17, NUM_TRIANGULAR

DIVISAO:
    #Divide r18 por 10
    div r6, r18, r19   #r6 = r18 / 10 (quociente)

    #Calcula o resto: resto = numero - (quociente * 10)
    mul r7, r6, r19   #r7 = quociente * 10
    sub r7, r18, r7     #r7 = r18 - r7 (resto)

    #Armazena o digito no buffer
    slli r8, r16, 2     #Offset = contador * 4
    add r8, sp, r8     #Endereco = Base + Offset
    stw r7, (r8)       #Salva o digito

    addi r16, r16, 1    #Incrementa contador

    mov r18, r6         #Atualiza o numero com o quociente
    bne r18, r0, DIVISAO #Se quociente != 0, continua

    #Chama DISPLAY
    call DISPLAY

FIM_TRI:
    #Epilogo
    ldw ra, 56(sp)
    ldw fp, 52(sp)
    ldw r16, 48(sp)
    ldw r17, 44(sp)
    ldw r18, 40(sp)
    ldw r19, 36(sp)
    ldw r20, 32(sp)
    addi sp, sp, 60

    ret