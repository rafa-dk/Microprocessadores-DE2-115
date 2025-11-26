/****
RTI
****/
.org 0x20

#PROLOGO
# Salva contexto (registradores voláteis que a ISR ou chamadas dentro dela podem modificar)
	subi sp, sp, 80
	stw ra, 76(sp)
	stw fp, 72(sp)
    stw r4, 68(sp)
    stw r5, 64(sp)
    stw r6, 60(sp)
    stw r7, 56(sp)
    stw r8, 52(sp)
    stw r9, 48(sp)
    stw r10, 44(sp)
    stw r11, 40(sp)
    stw r12, 36(sp)
    # r15 e r16 sao usados como variaveis globais da animacao, nao salvamos para manter o estado

	addi fp, sp, 80
#--------------------------
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS
	subi ea, ea, 4
	
	andi r13, et, 1 
	beq r13, r0, OTHER_INTERRUPTS
	call EXT_IRQ1

OTHER_INTERRUPTS:
	br FIM_RTI

OTHER_EXCEPTIONS:
#EPILOGO
FIM_RTI:
	#Restaura contexto
	ldw ra, 76(sp)
	ldw fp, 72(sp)
    ldw r4, 68(sp)
    ldw r5, 64(sp)
    ldw r6, 60(sp)
    ldw r7, 56(sp)
    ldw r8, 52(sp)
    ldw r9, 48(sp)
    ldw r10, 44(sp)
    ldw r11, 40(sp)
    ldw r12, 36(sp)
	addi sp, sp, 80
	
	eret
#ROTINA TIMER
EXT_IRQ1:
    # Limpa o bit de timeout do timer
    movia r10, 0x10002000
    stwio r0, 0(r10)    # Escreve 0 no status para limpar o bit TO

	DIREITA:
    #Empilha o digito

    movia r7, ORDEM_ANIMACAO
    slli r8, r15, 2    #r8 = r15 * 4 (r20 ja tem 4)
    add r7, r7, r8
    ldw r7, (r7)

    add r8, sp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

    call DISPLAY
    call SHIFT_R
    mov r15, r0

    br FIM_RTI

	

FIM_KEY:
	ret


/****
MAIN
****/

.global _start

_start:
	#Inicializa o Stack Pointer (sp)
	movia sp, STACK
	mov fp, sp
	movia r10, UART_BASE
	mov r5, r0
	movi r7, 20

INICIO:

WSPACE:
	ldwio r12, CONTROL(r10)		#leitura de control
	mov r11, r12		
	andhi r11, r11, 0xffff		#mascara para wspace
	beq r11, r0, WSPACE		#caso !wspace retorna
	movia r4, INICIO_CHAR
	slli r6, r5, 2
	add r4, r4, r6
	ldw r4, (r4)			#carrega caracter inicio
	stwio r4, DATA(r10)		#escreve dado em terminal do altera
	addi r5, r5, 1
	bne r5, r7, WSPACE
	#escrever caracter na memoria



POLLING:

	call UART
	
	addi r4, r4,-0x30		#converte para decimal
	beq r4, r0, LED

	addi r8, r0, 1
	beq r4, r8, TRIANGULAR

	addi r8, r0, 2
	beq r4, r8, ANIMACAO

	br POLLING


LED:
	call ARQLED
	br POLLING

TRIANGULAR:
	call UART
	addi r4, r4,-0x30		#converte para decimal
	bne r4, r0, POLLING
	
SPACE_TRI:
	movia r10, UART_BASE
	ldwio r12, CONTROL(r10)		#leitura de control
	mov r11, r12		
	andhi r11, r11, 0xffff		#mascara para wspace
	beq r11, r0, SPACE_TRI		#caso !wspace retorna
	movi r4, 32
	stwio r4, DATA(r10)		#escreve dado em terminal do altera
	bne r5, r7, SPACE_TRI

	call ARQTRI
	br POLLING

ANIMACAO:
	call UART
	addi r4, r4,-0x30		#converte para decimal
	bne r4, r0, POLLING
	call ARQANI
	br POLLING
