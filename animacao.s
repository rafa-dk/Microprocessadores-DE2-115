/****
RTI
****/
.org 0x20

#PROLOGO
	addi sp, sp, -4
	stw ra, (sp)
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
	ldw ra, (sp)
	addi sp, sp, 4
	eret


#ROTINA KEY
EXT_IRQ1:

DIREITA:
    #Empilha o digito

    movia r7, ORDEM_ANIMACAO
    mul r9, r15, r20    #r8 = r15 * 4 (r20 ja tem 4)
    add r7, r7, r9
    ldw r7, (r7)

    add r9, sp, r9      #r8 = sp + offset
    stw r7, (r9)       #Salva o digito na pilha

    addi r15, r15, 1    #Incrementa o contador de digitos

    bne r15, r16, DIREITA #Se r15 nao eh 8, continua o loop

    call DISPLAY
    call SHIFT

    stwio r0, (r8)    #reseta timer

    br FIM_RTI

ESQUERDA: 


    call DISPLAY

	

FIM_KEY:
	ret



/****
ANIMACAO
****/

.equ UART_VALID, 0x10001000 

.global ARQANI
.global ORDEM_ANIMACAO

ARQANI:

    # Prologo
    subi sp, sp, 76
    stw ra, 72(sp)
    stw fp, 68(sp)
    stw r4, 64(sp)
    stw r5, 60(sp)
    stw r6, 56(sp)
    stw r8, 52(sp)
    stw r9, 48(sp)
    stw r7, 44(sp)
    stw r15, 40(sp)
    stw r16, 36(sp)
    stw r20, 32(sp)
    
    addi fp, sp, 76


    #habilitar interrupcoes
	#1. setar timer
	#-> interrupt timer (0x10002000)
	movia r8, 0x10002000	#timer
	movia r9, 10000000      #200ms
	
	andi r6, r9, 0xFFFF
	stwio r6, 8(r8)		#low

	srli r6, r9, 16
	stwio r6, 12(r8)		#high

	movia r9, 0b111
	stwio r9, 4(r8)

	#2. setar o respectivo no bit no ienable (IRQ 1) 
	movia r9, 0b1
	wrctl ienable, r9	#habilita INT no PB

	#3. seta o bit PIE do processador
	movi r9, 1
	wrctl status, r9

    movi r4, 0
    movia r5, UART_VALID
    mov r6, r0
	movi r9, 0		#topo da pilha
	movi r7, 0		#digito
    movi r15, 0		#num de iteracoes
	movi r16, 0x8	#qtd de loops
    movi r20, 0x4

LOOP:
    ldw r4, (r5)
    bne r4, r0, FIM_ANIMACAO
    br LOOP

# Libera o espaco alocado na pilha para os digitos
FIM_ANIMACAO:
    ldw ra, 72(sp)
    ldw fp, 68(sp)
    ldw r4, 64(sp)
    ldw r5, 60(sp)
    ldw r6, 56(sp)
    ldw r8, 52(sp)
    ldw r9, 48(sp)
    ldw r7, 44(sp)
    ldw r15, 40(sp)
    ldw r16, 36(sp)
    ldw r20, 32(sp)
    addi sp, sp, 76

    ret

ORDEM_ANIMACAO:
.word 6,2,0,2,10,1,0,10
