.global MULT

MULT:
# Prologo
    subi sp, sp, 16
    stw ra, 12(sp)
    stw fp, 8(sp)
    stw r19, 4(sp)
    stw r6, 0(sp)
    
    addi fp, sp, 16
    
mov r7, r0
MULT_LOOP:
    beq r19, r0, MULT_END
    add r7, r7, r6
    subi r19, r19, 1
    br MULT_LOOP

MULT_END:
    ldw ra, 12(sp)
    ldw fp, 8(sp)
    ldw r19, 4(sp)
    ldw r6, 0(sp)
    addi sp, sp, 16

    ret