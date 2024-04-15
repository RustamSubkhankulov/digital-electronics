.text
main:
    li      t0, 10000
    li      a3, 1
    li      a4, 0
    li      a1, 0
loop:
    beq     a3, zero, magic_br_1 # branch #1
    addi    a3, a3, 0
    nop
    nop
    nop
    nop
    nop
    nop
magic_br_1:
    beq     a4, zero, magic_br_2 # branch #2
    addi    a4, a4, 0
magic_br_2:
    nop #7
    nop #0
    nop #1
    nop #2
    nop #3
    nop #4
    
    beq a4, zero, magic_br_3 #5
    nop #6
    	  
magic_br_3:    
    nop #7
    nop #0
    nop #1
    nop #2
    nop #3
    nop #4
    
    beq a3, zero, magic_br_4 #5
    nop #6 

magic_br_4:
    addi    a1, a1, 1
    bne     a1, t0, loop
