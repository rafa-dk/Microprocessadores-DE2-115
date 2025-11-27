/***
LED
***/

.global LED

LED:
    #Prologo
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

#Leitura do comando
#1. Leitura do segundo digito: '0' ou '1'
    call UART    #r4 = '0' ou '1'
    mov r5, r4               #Guarda o subcomando

#2. Leitura do primeiro digito de xx
    call UART     #r4 = ASCII do primeiro digito de XX
    mov r6, r4               #Salva

#3. Leitura do segundo de xx
    call UART     #r4 = ASCII do segundo digito de XX
    mov r7, r4               #Salva

#4. Converte ascii para o num xx
    addi r6, r6, -48         #r6 = (xx / 10)
    addi r7, r7, -48         #r7 = (xx % 10)
    muli r8, r6, 10
    add  r4, r8, r7          #r4 = indice do led (xx)

#5. Leitura do valor atual dos leds
    movia r9, LED_RED
    ldwio r10, 0(r9)

#6. Verifica se o comando eh para acender 00 ou apagar 01
    addi r5, r5, -48         #Subcomando vira numero (0 ou 1)
    beq r5, r0, LIGA_LED     #00 xx -> acender

    addi r11, r0, 1
    beq r5, r11, DESLIGA_LED #01 xx -> apagar

    br FIM_LED                     #Comando invalido -> retorna

#Acende o led
LIGA_LED:
    movi r12, 1
    sll r12, r12, r4         #Cria mascara 1 << xx
    or r10, r10, r12         #Liga o bit
    stwio r10, 0(r9)
    br FIM_LED

#Apaga o led
DESLIGA_LED:
    movi r12, 1
    sll r12, r12, r4
    nor r12, r0, r12         #Inverte mascara
    and r10, r10, r12        #Limpa o bit
    stwio r10, 0(r9)
    br FIM_LED

FIM_LED:

    call ESPACO

    #Epilogo
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
    
