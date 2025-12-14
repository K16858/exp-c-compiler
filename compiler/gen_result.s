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
    ori $v1, $zero, 2
    mult $v0, $v1
    mflo $v0
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 0
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sll $v0, $v0, 2
    addi $v0, $v0, 0
    add $v1, $v0, $t0
    ori $v0, $zero, 1
    sw $v0, 0($v1)
    ori $v0, $zero, 0
    ori $v1, $zero, 2
    mult $v0, $v1
    mflo $v0
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sll $v0, $v0, 2
    addi $v0, $v0, 0
    add $v1, $v0, $t0
    ori $v0, $zero, 2
    sw $v0, 0($v1)
    ori $v0, $zero, 1
    ori $v1, $zero, 2
    mult $v0, $v1
    mflo $v0
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 0
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sll $v0, $v0, 2
    addi $v0, $v0, 0
    add $v1, $v0, $t0
    ori $v0, $zero, 3
    sw $v0, 0($v1)
    ori $v0, $zero, 1
    ori $v1, $zero, 2
    mult $v0, $v1
    mflo $v0
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sll $v0, $v0, 2
    addi $v0, $v0, 0
    add $v1, $v0, $t0
    ori $v0, $zero, 4
    sw $v0, 0($v1)
    jr $ra
    nop
    
    #data segment
    .data 0x10004000
RESULT:
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
    .word 0xffffffff
