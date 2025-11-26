/****
RTI
****/
.org 0x20

#PROLOGO
	addi sp, sp, -8
	stw ra, 4(sp)
	stw fp, 0(sp)

	addi fp, sp, 0	
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
	ldw ra, 4(sp)
	ldw fp, 0(sp)
	addi sp, sp, 8
	eret


#ROTINA TIMER
EXT_IRQ1:
	DIREITA:
    #Empilha o digito

    movia r7, ORDEM_ANIMACAO
    slli r8, r15, 2    #r8 = r15 * 4 (r20 ja tem 4)
    add r7, r7, r8
    ldw r7, (r7)

    add r8, fp, r8      #r8 = sp + offset
    stw r7, (r8)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

    call DISPLAY
    call SHIFT
    mov r15, r0
	movia r9, 0b0101
	stwio r9, 4(r10)
    br FIM_RTI

	

FIM_KEY:
	ret


/****
MAIN
****/

.equ DATA, 0x0000
.equ CONTROL, 0x0004
.equ STACK, 0x10000

.global _start

_start:
	#Inicializa o Stack Pointer (sp)
	movia sp, STACK
	mov fp, sp
	movia r10, 0x10001000
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
	call ARQTRI
	br POLLING

ANIMACAO:
	call UART
	addi r4, r4,-0x30		#converte para decimal
	bne r4, r0, POLLING
	call ARQANI
	br POLLING

INICIO_CHAR:
.word 69,110,116,114,101,32,99,111,109,32,111,32,99,111,109,97,110,100,111,58
