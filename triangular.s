.equ ALAVANCAS, 0x10000040

.data
DIGITS_BUFFER:
    .skip 32

.text
.global ARQTRI
ARQTRI:
    # Prologo
    subi sp, sp, 32
    stw ra, 28(sp)
    stw fp, 24(sp)
    stw r16, 20(sp)
    stw r17, 16(sp)
    stw r18, 12(sp)
    stw r19, 8(sp)
    stw r20, 4(sp)
    
    addi fp, sp, 28

    # Inicializacao
    movi r16, 0         # Contador de digitos
    movia r17, DIGITS_BUFFER # Endereco do buffer
    movi r19, 10        # Divisor (10)
    movi r20, 4         # Tamanho da palavra (4 bytes)

CONVERTER:
    movia r10, ALAVANCAS
    ldwio r18, (r10)    # Le valor das chaves para r18 (Dividend)
    andi r18, r18, 0xFF # Mascara para 8 bits

DIVISAO:
    # Divide r18 por 10
    # Usamos r18 (callee-saved) para garantir que a chamada de div (se for macro/funcao)
    # nao corrompa o valor do dividendo.
    div r6, r18, r19    # r6 = r18 / 10 (quociente)

    # Calcula o resto: resto = numero - (quociente * 10)
    mul r7, r6, r19     # r7 = quociente * 10
    sub r7, r18, r7     # r7 = r18 - r7 (resto)

    # Armazena o digito no buffer
    mul r8, r16, r20    # Offset = contador * 4
    add r8, r17, r8     # Endereco = Base + Offset
    stw r7, 0(r8)       # Salva o digito

    addi r16, r16, 1    # Incrementa contador

    mov r18, r6         # Atualiza o numero com o quociente
    bne r18, r0, DIVISAO # Se quociente != 0, continua

    # Chama DISPLAY
    movia r4, DIGITS_BUFFER
    call DISPLAY

FIM_TRI:
    # Epilogo
    ldw ra, 28(sp)
    ldw fp, 24(sp)
    ldw r16, 20(sp)
    ldw r17, 16(sp)
    ldw r18, 12(sp)
    ldw r19, 8(sp)
    ldw r20, 4(sp)
    addi sp, sp, 32

    ret