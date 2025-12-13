INITIAL_GP = 0x10008000 # initial value of global pointer
INITIAL_SP = 0x7ffffffc # initial value of stack pointer
# system call service number
stop_service = 99

       .text # テキストセグメントの開始
init:
    # initialize $gp (global pointer) and $sp (stack pointer)
    la $gp, INITIAL_GP # $gp ←0x10008000 (INITIAL_GP)
    la $sp, INITIAL_SP # $sp ←0x7ffffffc (INITIAL_SP)
    jal main # jump to ‘main’
    nop # (delay slot)
    li $v0, stop_service # $v0 ←99 (stop_service)
    syscall # stop
    nop
    # not reach here
stop: # if syscall return
    j stop # infinite loop...
    nop # (delay slot)

.text 0x00001000 # 以降のコードを 0から配置 x00001000
main:
    la $t0, RESULT
    ori $v0, $zero, 0
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 10
    sw $v0, 0($v1)
    ori $v0, $zero, 2
    sw $v0, 0($t0)
    lw $v0, 0($t0)
    nop
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 3
    sw $v0, 0($v1)
    lw $v0, 0($t0)
    nop
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sw $v0, 0($t0)
    ori $v0, $zero, 3
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v0, $v0, $t0
    lw $v0, 0($v0)
    nop
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 3
    addi $v1, $v0, 0
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    xor $t2, $v0, $v1
    slti $t2, $t2, 1
    beq $t2, $zero, IF_FALSE_0
    nop
    ori $v0, $zero, 4
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 4
    sw $v0, 0($v1)
    j IF_END_0
    nop
IF_FALSE_0:
    ori $v0, $zero, 5
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 5
    sw $v0, 0($v1)
    ori $v0, $zero, 6
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 6
    sw $v0, 0($v1)
    ori $v0, $zero, 7
    # offset 4
    sll $v0, $v0, 2
    addi $v0, $v0, 4
    add $v1, $v0, $t0
    ori $v0, $zero, 8
    sw $v0, 0($v1)
IF_END_0:
    jr $ra
    nop
    
    #data segment
    .data 0x10004000
RESULT:
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
