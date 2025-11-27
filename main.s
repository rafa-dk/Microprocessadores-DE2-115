/****
RTI
****/
.org 0x20

#PROLOGO
#Salva contexto (registradores volateis que a ISR ou chamadas dentro dela podem modificar)
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
    #r15 e r16 sao usados como variaveis globais da animacao, nao salvamos para manter o estado

	addi fp, sp, 80
#--------------------------
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS
	subi ea, ea, 4
	
	andi r13, et, 2
	bne r13, r0, BOTAO_IRQ
	andi r13, et, 1 
	bne r13, r0, TIMER_IRQ
	call OTHER_INTERRUPTS

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
TIMER_IRQ:
    #Limpa o bit de timeout do timer
    movia r10, 0x10002000
    stwio r0, 0(r10)    #Escreve 0 no status para limpar o bit TO
	movia r12, DIRECAO_ANIMACAO
	ldw r12, (r12)

DIREITA:
    movia r7, ORDEM_ANIMACAO
    slli r8, r15, 2    #r8 = r15 * 4 (r20 ja tem 4)
    add r7, r7, r8
    ldw r7, (r7)

    add r8, sp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

    call DISPLAY
	mov r15, r0
	beq r12, r0, LEFT
	
RIGHT:
    call SHIFT_R
	br FIM_RTI
LEFT:
	call SHIFT_L
    br FIM_RTI

BOTAO_IRQ:
	movia r9, BOTOES	#BOTOES

	#Key 1 ou Key 2
	ldwio r11, (r9)
	andi r12, r11, 0b100	#Eh Key 2?
	bne r12, r0, BOTAO_2

	movia r11, DIRECAO_ANIMACAO
	ldw r12, (r11)
	xori r12, r12, 1
	stw r12, (r11)
	ldw r12, (r11)

	stwio r0, (r9)	#Limpa edge capture
	br FIM_RTI

BOTAO_2:
	movia r11, STOP_BUTTON_ANIMACAO
	ldw r12, (r11)
	xori r12, r12, 1
	stw r12, (r11)
	ldw r12, (r11)

	stwio r0, (r9)	#Limpa edge capture

	beq	r12, r0, STOP

RESUME:
	call RESUME_ANIMACAO
	br FIM_RTI

STOP:
	call STOP_ANIMACAO
	br FIM_RTI


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
	ldwio r12, CONTROL(r10)		#Leitura de control
	mov r11, r12		
	andhi r11, r11, 0xffff		#Mascara para wspace
	beq r11, r0, WSPACE		#Caso !wspace retorna
	movia r4, INICIO_CHAR
	slli r6, r5, 2
	add r4, r4, r6
	ldw r4, (r4)			#Carrega caracter inicio
	stwio r4, DATA(r10)		#Escreve dado em terminal do altera
	addi r5, r5, 1
	bne r5, r7, WSPACE
	#Escrever caracter na memoria



POLLING:

	call UART
	
	addi r4, r4,-0x30		#Converte para decimal
	beq r4, r0, LED_VER

	addi r8, r0, 1
	beq r4, r8, TRIANGULAR_VER

	addi r8, r0, 2
	beq r4, r8, ANIMACAO_VER

	br POLLING


LED_VER:
	call LED
	br POLLING

TRIANGULAR_VER:
	call UART
	addi r4, r4,-0x30		#Converte para decimal
	bne r4, r0, POLLING
	call ESPACO
	call TRIANGULAR
	br POLLING

ANIMACAO_VER:
	call UART
	addi r4, r4,-0x30		#Converte para decimal
	bne r4, r0, POLLING
	call ESPACO
	call ANIMACAO
	br POLLING
