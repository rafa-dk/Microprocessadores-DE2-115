.global DIV

DIV:
# Prologo
    subi sp, sp, 16
    stw ra, 12(sp)
    stw fp, 8(sp)
    stw r18,  4(sp)
    stw r19,  0(sp)
    
    addi fp, sp, 16
    
# r6 = r18 / r19
mov r6, r0

DIV_LOOP:
    blt r18, r19, FIM_DIV
    sub r18, r18, r19
    addi r6, r6, 1
    br DIV_LOOP

FIM_DIV:
    ldw ra, 12(sp)
    ldw fp, 8(sp)
    ldw r18, 4(sp)
    ldw r19, 0(sp)
    addi sp, sp, 16

    ret