.global ESPACO

ESPACO:
    #Prologo
    subi sp, sp, 24
    stw ra, 20(sp)
    stw fp, 16(sp)
    stw r12, 12(sp)
    stw r11, 8(sp)
    stw r10, 4(sp)
    stw r6, 0(sp)

    addi fp, sp, 24

LOOP_ESPACO:
    addi fp, sp, 16
	movia r10, UART_BASE
	ldwio r12, CONTROL(r10)		#leitura de control
	mov r11, r12		
	andhi r11, r11, 0xffff		#mascara para wspace
	beq r11, r0, LOOP_ESPACO		#caso !wspace retorna
	movi r6, 32
	stwio r6, DATA(r10)		#escreve dado em terminal do altera

    #Epilogo
    ldw ra, 20(sp)
    ldw fp, 16(sp)
    ldw r12, 12(sp)
    ldw r11, 8(sp)
    ldw r10, 4(sp)
    ldw r6, 0(sp)
    addi sp, sp, 24

    ret
