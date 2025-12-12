#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "ast.h"

#define MAXBUF 20

void gen_header(Node *n);
void gen_fotter();
void gen_decl(Node *n);
void register_array(Node *n);
void gen_assign(Node *n);
void gen_loop(Node *n);
void gen_expression(Node *n);
void gen_code(Node *n);

typedef struct {
    char *name;
    int offset;
    int size;
    bool is_array;
} Symbol;

Symbol symbol_table[100];
int symbol_count;
int offset_count;
int if_count;
int loop_count;

void print_node(Node *n) {
    if (n != NULL) {
        printf("type: %s\n", node_types[n->type]);
    }
}

void init() {
    symbol_count = 0;
    offset_count = 0;
    if_count = 0;
    loop_count = 0;
}

void gen_header(Node *n) {
    init();
    char* code = 
        "INITIAL_GP = 0x10008000 # initial value of global pointer\n"
        "INITIAL_SP = 0x7ffffffc # initial value of stack pointer\n"
        "# system call service number\n"
        "stop_service = 99\n"
        "\n"
        "       .text # テキストセグメントの開始\n"
        "init:\n"
        "    # initialize $gp (global pointer) and $sp (stack pointer)\n"
        "    la $gp, INITIAL_GP # $gp ←0x10008000 (INITIAL_GP)\n"
        "    la $sp, INITIAL_SP # $sp ←0x7ffffffc (INITIAL_SP)\n"
        "    jal main # jump to ‘main’\n"
        "    nop # (delay slot)\n"
        "    li $v0, stop_service # $v0 ←99 (stop_service)\n"
        "    syscall # stop\n"
        "    nop\n"
        "    # not reach here\n"
        "stop: # if syscall return\n"
        "    j stop # infinite loop...\n"
        "    nop # (delay slot)\n"
        "\n"
        ".text 0x00001000 # 以降のコードを 0から配置 x00001000\n"
        "main:\n"
        "    la $t0, RESULT";
    printf("%s\n", code);

    gen_code(n->child);
    gen_code(n->child->brother);

    gen_fotter();
}

void gen_fotter() {
    char* code = 
        "    jr $ra\n"
        "    nop\n"
        "    \n"
        "    #data segment\n"
        "    .data 0x10004000\n"
        "RESULT:\n";
    printf("%s", code);
    for (int i=0; i < offset_count; i++) {
        printf("    .word 0xffffffff\n");
    }
}

void register_var(Node *n) {
    symbol_table[symbol_count].name = n->child->variable;
    symbol_table[symbol_count].offset = offset_count * 4;
    symbol_table[symbol_count].size = 1;
    symbol_table[symbol_count].is_array = false;

    symbol_count++;
    offset_count++;
}

void register_array(Node *n) {
    symbol_table[symbol_count].name = n->child->child->variable;
    symbol_table[symbol_count].offset = offset_count * 4;
    symbol_table[symbol_count].size = n->child->child->brother->child->ivalue;
    symbol_table[symbol_count].is_array = true;

    symbol_count++;
    offset_count += n->child->child->brother->child->ivalue;
}

int lookup_symbol_table(char *target_var) {
    for (int i=0; i < symbol_count; i++) {
        if (strncmp(symbol_table[i].name, target_var, MAXBUF) == 0) {
            return symbol_table[i].offset;
        }
    }

    return -1;
}

void gen_decl(Node *n) {
    if (n->child->type == IDENT_AST) {
        register_var(n);
    }
    else {
        register_array(n);
    }
}

void gen_assignment(Node *n) {
    if (n->child->type == IDENT_AST) {
        int offset = lookup_symbol_table(n->child->variable);
        if (offset < 0) {
            printf("No variable\n");
            return;
        }

        gen_code(n->child->brother);

        printf("    sw $v0, %d($t0)\n", offset);
    } else {
        int offset = lookup_symbol_table(n->child->child->variable);
        if (offset < 0) {
            printf("No variable\n");
            return;
        }

        gen_code(n->child->child->brother);

        printf("    addi $v1, $v0, %d\n", offset);
        printf("    ori $t2, $t2, 4\n");
        printf("    mult $v1, $t2\n");
        printf("    mflo $v1\n");
        printf("    add $v1, $v1, $t0\n");

        gen_code(n->child->brother);

        printf("    sw $v0, 0($v1)\n");
    }
}

void gen_loop(Node *n) {
    printf("LOOP_%d:\n", loop_count);
    // condition
    gen_code(n->child);
    printf("    beq $t2, $zero, EXIT_%d\n", loop_count);
    printf("    nop\n");
    // statements
    gen_code(n->child->brother);
    printf("    j LOOP_%d\n", loop_count);
    printf("    nop\n");
    printf("EXIT_%d:\n", loop_count);
    loop_count++;
}

void gen_if(Node *n) {
    // condition
    gen_code(n->child);
    printf("    beq $t2, $zero, IF_FALSE_%d\n", if_count);
    printf("    nop\n");
    
    //  else
    if (n->child->brother->type == STATEMENTS_AST) {
        gen_code(n->child->brother->child);
        printf("    j IF_END_%d\n", if_count);
        printf("    nop\n");
        printf("IF_FALSE_%d:\n", if_count);

        if (n->child->brother->child->brother != NULL) {
            gen_code(n->child->brother->child->brother);
        }
    } else {
        // no else
        gen_code(n->child->brother);
        printf("    j IF_END_%d\n", if_count);
        printf("    nop\n");
        printf("IF_FALSE_%d:\n", if_count);
    }
    
    printf("IF_END_%d:\n", if_count);
    if_count++;
}

void gen_push() {
    printf("    addi $sp, $sp, -4\n");
    printf("    sw $v0, 0($sp)\n");
}

void gen_pop() {
    printf("    lw $v0, 0($sp)\n");
    printf("    nop\n");
    printf("    addi $sp, $sp, 4\n");
}

void gen_var(Node *n) {
    int offset = lookup_symbol_table(n->variable);
    printf("    lw $v0, %d($t0)\n", offset);
    printf("    nop\n");
}

void gen_number(Node *n) {
    int num = n->ivalue;
    printf("    ori $v0, $zero, %d\n", num);
}

void gen_comparison(Node *n) {
    gen_code(n->child->brother->child);
    gen_push();
    gen_code(n->child->brother->child->brother);
    printf("    addi $v1, $v0, 0\n");
    gen_pop();

    switch (n->child->type) {
        case EQ_OP_AST:
            printf("    xor $t2, $v0, $v1\n");
            printf("    slti $t2, $t2, 1\n");
            break;
        case LT_OP_AST:
            printf("    slt $t2, $v0, $v1\n");
            break;
        case GT_OP_AST:
            printf("    slt $t2, $v1, $v0\n");
            break;
        default:
            break;
    }
}

void gen_expression(Node *n) {
    gen_code(n->child);
    gen_push();
    gen_code(n->child->brother);
    printf("    or $v1, $v0, $zero\n");
    gen_pop();

    switch (n->type) {
        case ADD_OP_AST:
            printf("    add $v0, $v0, $v1\n");
            break;
        case SUB_OP_AST:
            printf("    sub $v0, $v0, $v1\n");
            break;
        case MUL_OP_AST:
            printf("    mult $v0, $v1\n");
            printf("    mflo $v0\n");
            break;
        case DIV_OP_AST:
            printf("    div $v0, $v1\n");
            printf("    mflo $v0\n");
            break;
        default:
            break;
    }
}

void gen_code(Node *n) {
    if (n == NULL) {
        return;
    }
    switch (n->type) {
        case PROGRAM_AST:
            gen_header(n);
            break;
        case DECLARATIONS_AST:
            gen_code(n->child);
            gen_code(n->child->brother);
            break;
        case DECL_STATEMENT_AST:
            gen_decl(n);
            break;
        case ASSIGNMENT_STATEMENT_AST:
            gen_assignment(n);
            break;
        case LOOP_STATEMENT_AST:
            gen_loop(n);      
            break;
        case IF_STATEMENT_AST:
            gen_if(n);
            break;
        case CONDITION_AST:
            gen_comparison(n);
            break;
        case IDENT_AST:
            gen_var(n);
            break;
        case NUMBER_AST:
            gen_number(n);
            break;
        case ADD_OP_AST:
        case SUB_OP_AST:
        case MUL_OP_AST:
        case DIV_OP_AST:
            gen_expression(n);
            break;
        default:
            gen_code(n->child);
            gen_code(n->child->brother);
            break;
    }
}
