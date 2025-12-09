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
    sw $v0, 4($t0)
    ori $v0, $zero, 1
    sw $v0, 0($t0)
LOOP:
    lw $v0, 0($t0)
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 11
    addi $v1, $v0, 0
    lw $v0, 0($sp)
    addi $sp, $sp, 4
    slt $t2, $v0, $v1
    beq $t2, $zero, EXIT
    nop
    lw $v0, 4($t0)
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    lw $v0, 0($t0)
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sw $v0, 4($t0)
    lw $v0, 0($t0)
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sw $v0, 0($t0)
    j LOOP
    nop
EXIT:
    jr $ra
    nop
    
    #data segment
    .data 0x10004000
RESULT:
    .word 0xffffffff
    .word 10
