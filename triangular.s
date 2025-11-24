.equ ALAVANCAS, 0x10000040

.global ARQTRI
ARQTRI:
    subi sp, sp, 44
    stw ra, 40(sp)
    stw fp, 36(sp)
    stw r4, 32(sp)
    stw r5, 28(sp)
    stw r6, 24(sp)
    stw r7, 20(sp)
    stw r8, 16(sp)
    stw r10, 12(sp)
    stw r15, 8(sp)
    stw r17, 4(sp)
    stw r20, 0(sp)

    addi fp, sp, 36

	movi r8, 0		#acumulador = 0
	movi r7, 0		#contador = 1
	movi r15, 0		#numeros armazenados (num)
	movi r16, 0		#result_media = 0
	movi r17, 0xFFFFFF00	#mascara para num, usaremos com and ao inves de andi pois em andi o imediato tem q ser <= 16 bits
	movi r20, 0x4

/*
Assumimos que o valor das alavancas (0-255) esta em r4
r5 sera usado para o divisor (10)
r6 guardara o quociente
r7 guardara o resto (o dígito decimal)
Usaremos a pilha (stack) para armazenar os digitos temporariamente
*/
CONVERTER:
	movia r10, ALAVANCAS
	ldwio r4, (r10)
	andi r4, r4, 0xFF	#separa os 8 primeiros bits

	#Prepara a pilha para armazenar 3 digitos
    subi sp, sp, 12

    movia r5, 10        #Carrega o divisor 10 em r5
    mov r16, r0         #r16 sera nosso contador de digitos


DIVISAO:
    #Divide o numero por 10
    div r6, r4, r5      #r6 = r4 / 10 (quociente)

    #Calcula o resto
    mul r7, r6, r5      #r7 = quociente * 10
    sub r7, r4, r7      #r7 = r4 - (quociente * 10) -> este e o resto (digito)

    #Empilha o digito encontrado
    #O offset e calculado com base no numero de digitos ja processados
    mul r8, r16, r20    #r8 = r16 * 4 (r20 ja tem 4)
    add r8, sp, r8      #r8 = sp + offset
    stw r7, 0(r8)       #Salva o digito na pilha

    addi r16, r16, 1    #Incrementa o contador de digitos

    mov r4, r6          #O novo numero a ser dividido e o quociente
    bne r4, r0, DIVISAO #Se o quociente nao for zero, continua o loop

/*
Fim da conversao
Neste ponto, os digitos estao na pilha
Por exemplo, se o numero era 123:
sp[0] -> 3 (unidade)
sp[4] -> 2 (dezena)
sp[8] -> 1 (centena)
O registrador r16 contem a quantidade de digitos - 1
*/

call DISPLAY

# Libera o espaco alocado na pilha para os digitos
FIM_TRI:

    ldw ra, 40(sp)
    ldw fp, 36(sp)
    ldw r4, 32(sp)
    ldw r5, 28(sp)
    ldw r6, 24(sp)
    ldw r7, 20(sp)
    ldw r8, 16(sp)
    ldw r10, 12(sp)
    ldw r15, 8(sp)
    ldw r17, 4(sp)
    ldw r20, 0(sp)

    addi sp, sp, 44

    ret

addi sp, sp, 12

ret