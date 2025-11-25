.global UART

.equ DATA, 0x0000
.equ CONTROL, 0x0004
.equ UART_BASE, 0x10001000 	#Endereco base da UART

UART:
    subi sp, sp, 24
    stw ra, 20(sp)
	stw fp, 16(sp)
    stw r7, 12(sp)
    stw r10, 8(sp)
	stw r11, 4(sp)
	stw r12, 0(sp)

	addi fp, sp, 16

	movia r10, UART_BASE
POLLING:
	ldwio r7, DATA(r10)	    	#Leitura do registrador de Dados
	mov r4, r7		
	andi r4, r4, 0x8000	    	#Mascara para RVALID (Bit 15)
	beq r4, r0, POLLING 		#Caso !RVALID, continua no loop de polling
	andi r4, r7, 0xFF		#Armazena o dado lido (caractere ASCII) em r4 (ou outro registrador de retorno)

WSPACE:
	ldwio r12, CONTROL(r10)		#leitura de control
	mov r11, r12		
	andhi r11, r11, 0xffff		#mascara para wspace
	beq r11, r0, WSPACE		#caso !wspace retorna para POLLING
	stwio r4, DATA(r10)		#escreve dado em terminal do altera
	#Escrever caracter na memoria

END_UART:
	ldw ra, 20(sp)
	ldw fp, 16(sp)
    ldw r7, 12(sp)
    ldw r10, 8(sp)
	ldw r11, 4(sp)
	ldw r12, 0(sp)
    addi sp, sp, 24

    ret
	
