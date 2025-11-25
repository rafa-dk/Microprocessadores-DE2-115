.global ARQLED
.equ LED_RED, 0x10000000   #Endereco do registrador dos LEDs

ARQLED:

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

	addi fp, sp, 32

#--------leitura do comando------------
# 1. leitura do segundo dígito: '0' ou '1'
    call UART    #r4 = '0' ou '1'
    mov r5, r4               #guarda o subcomando

# 2. leitura do primeiro dígito de xx
    call UART     #r4 = ASCII do primeiro dígito de XX
    mov r6, r4               #salva

# 3. leitura do segundo de xx
    call UART     #r4 = ASCII do segundo dígito de XX
    mov r7, r4               #salva

# 4. converte ascii para o num xx
    addi r6, r6, -48         #r6 = (xx / 10)
    addi r7, r7, -48         #r7 = (xx % 10)
    muli r8, r6, 10
    add  r4, r8, r7          #r4 = índice do led (xx)

# 5. leitura do valor atual dos leds
    movia r9, LED_RED
    ldwio r10, 0(r9)

# 6. verifica se o comando é para acender 00 ou apagar 01
    addi r5, r5, -48         #subcomando vira número (0 ou 1)
    beq r5, r0, LIGA_LED     #00 xx → acender

    addi r11, r0, 1
    beq r5, r11, DESLIGA_LED #01 xx → apagar

    br FIM_LED                     #comando inválido → retorna

#------acende o led---------
LIGA_LED:
    movi r12, 1
    sll r12, r12, r4         #cria máscara 1 << xx
    or r10, r10, r12         #liga o bit
    stwio r10, 0(r9)
    br FIM_LED

#------apaga o led---------
DESLIGA_LED:
    movi r12, 1
    sll r12, r12, r4
    nor r12, r0, r12         #inverte máscara
    and r10, r10, r12        #limpa o bit
    stwio r10, 0(r9)
    br FIM_LED

FIM_LED:
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
    
