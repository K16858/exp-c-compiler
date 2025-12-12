{"PROGRAM_0": {"DECLARATIONS_1": {"DECL_STATEMENT_2": {"ARRAY_3": {"IDENT_4(a)": {},"EXPRESSION_5": {"NUMBER_6(10)": {}}}},"DECLARATIONS_7": {"DECL_STATEMENT_8": {"IDENT_9(x)": {}}}},"STATEMENTS_10": {"STATEMENT_11": {"ASSIGNMENT_STATEMENT_12": {"ARRAY_13": {"IDENT_14(a)": {},"EXPRESSION_15": {"NUMBER_16(0)": {}}},"NUMBER_17(10)": {}}},"STATEMENTS_18": {"STATEMENT_19": {"ASSIGNMENT_STATEMENT_20": {"IDENT_21(x)": {},"NUMBER_22(2)": {}}},"STATEMENTS_23": {"STATEMENT_24": {"ASSIGNMENT_STATEMENT_25": {"IDENT_26(x)": {},"EXPRESSION_27": {"ADD_OP_28": {"IDENT_29(x)": {},"NUMBER_30(1)": {}}}}}}}}}}
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
#   This is an ARRAY ASSIGNMENT
    ori $v0, $zero, 2
    sw $v0, 40($t0)
    lw $v0, 40($t0)
    nop
    addi $sp, $sp, -4
    sw $v0, 0($sp)
    ori $v0, $zero, 1
    or $v1, $v0, $zero
    lw $v0, 0($sp)
    nop
    addi $sp, $sp, 4
    add $v0, $v0, $v1
    sw $v0, 40($t0)
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
