#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "string.h"

typedef struct {
    char *name;
    int offset;
    int size;  
} Symbol;

Symbol *symbol_table;
int symbol_count = 0;

void print_node(Node *n) {
    if (n != NULL) {
        printf("type: %s\n", node_types[n->type]);
    }
}

void gen_header(Node *n) {
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
        "main:";
    printf("%s\n", code);

    gen_code(n->child);
    gen_code(n->brother);
}

void register_var(Node *n) {
    strncpy(*(symbol_table + symbol_count)->name, n->child->variable, sizeof(n->child->variable)-1);
    (symbol_table + symbol_count)->offset = symbol_count * 4;
    (symbol_table + symbol_count)->size = 1;

    symbol_count++;
}

void gen_decl_var(Node *n) {
    printf("%s\n", n->child->variable);
    register_var(n);
    gen_code(n->brother);
}

void gen_assignment(Node *n) {
    char* code = "     ori $t1, $zero, 0";

    printf("%s\n", code);

    gen_code(n->child);
    gen_code(n->brother);
}

void gen_loop(Node *n) {
    printf("LOOP:\n");
    // condition
    gen_code(n->child);
    printf(" EXIT\n");
    // statements
    gen_code(n->brother);
    printf("    STATEMENTS\n");
    printf("    j LOOP\n");
    printf("    nop\n");
    printf("EXIT:\n");
}

void gen_code(Node *n) {
    // if (n->child != NULL) {
    //     gen_code(n->child);
    // }
    // if (n->brother != NULL) {
    //     gen_code(n->brother);
    // }

    if (n == NULL) {
        return;
    }
    // printf("gen_code\n");
    switch (n->type) {
        case PROGRAM_AST:
            gen_header(n);
            break;
        case DECLARATIONS_AST:
            gen_code(n->child);
            gen_code(n->brother);
            break;
        case DECL_STATEMENT_AST:
            gen_decl_var(n);
            break;
        case ASSIGNMENT_STATEMENT_AST:
            gen_assignment(n);
            break;
        case LOOP_STATEMENT_AST:
            gen_loop(n);      
            break;
        case CONDITION_AST:
            printf("    CONDITION");
            break;
        default:
            print_node(n);
            gen_code(n->child);
            gen_code(n->brother);
            break;
    }
}
