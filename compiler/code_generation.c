#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

#define MAXBUF 20

void gen_header(Node *n);
void gen_fotter();
void gen_decl_var(Node *n);
void gen_assign(Node *n);
void gen_loop(Node *n);
void gen_expression(Node *n);
void gen_code(Node *n);

typedef struct {
    char *name;
    int offset;
    int size;  
} Symbol;

Symbol symbol_table[100];
int symbol_count;

void print_node(Node *n) {
    if (n != NULL) {
        printf("type: %s\n", node_types[n->type]);
    }
}

void init() {
    symbol_count = 0;
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
    gen_code(n->brother);

    gen_fotter();
}

void gen_fotter() {
    char* code = 
        "    jr $ra\n"
        "    nop\n"
        "    \n"
        "    #data segment\n"
        "    .data 0x10004000\n"
        "    RESULT: .word 0xffffffff\n";
    printf("%s", code);
}

void register_var(Node *n) {
    // Symbol current = symbol_table[symbol_count];
    
    // current.name = (char *)malloc(sizeof(MAXBUF));
    // strncpy(current.name, n->child->variable, MAXBUF);
    symbol_table[symbol_count].name = n->child->variable;
    symbol_table[symbol_count].offset = symbol_count * 4;
    symbol_table[symbol_count].size = 1;

    symbol_count++;
}

int lookup_symbol_table(char *target_var) {
    for (int i=0; i < symbol_count; i++) {
        if (strncmp(symbol_table[i].name, target_var, MAXBUF) == 0) {
            return symbol_table[i].offset;
        }
    }

    return -1;
}

void gen_decl_var(Node *n) {
    register_var(n);
    gen_code(n->child);
    gen_code(n->brother);
}

void gen_assignment(Node *n) {
    int offset = lookup_symbol_table(n->child->variable);
    if (offset < 0) {
        printf("No variable\n");
        return;
    }
    printf("    ori $v0, $zero, 0\n");
    printf("    sw $v0, %d($t0)\n", offset);

    gen_code(n->child);
    gen_code(n->brother);
}

void gen_loop(Node *n) {
    printf("LOOP:\n");
    // condition
    gen_code(n->child);
    printf("    beq $t2, $zero, EXIT\n");
    // statements
    gen_code(n->brother);
    printf("    STATEMENTS\n");
    printf("    j LOOP\n");
    printf("    nop\n");
    printf("EXIT:\n");
}

void gen_push() {
    printf("    addi $sp, $sp, -4\n");
    printf("    sw $v0, 0($sp)\n");
}

void gen_pop() {
    printf("    lw $v0, 0($sp)\n");
    printf("    addi $sp, $sp, 4\n");
}

void gen_var(Node *n) {
    printf("    lw $t0, %d($t0)");
}

void gen_number(Node *n) {
    int num = n->ivalue;
    printf("    ori $t0, $zero, %d", num);
}

void gen_expression(Node *n) {
    // switch (n->type) {
    //     case NUMBER_AST:
    //         printf("NUMBER\n");
    //         gen_code(n->child);
    //         break;
    //     case IDENT_AST:
    //         printf("IDENT\n");
    //         gen_code(n->child);
    //     default:
    //         break;
    // }
    gen_code(n->child);
    gen_push();
    gen_code(n->brother);
    printf("    ori $v1, $zero, $v0\n");
    gen_pop();
    switch (n->type) {
        case ADD_OP_AST:
            printf("    add $v0, $v0, $t1\n");
            break;
        case SUB_OP_AST:
            printf("    sub $v0, $v0, $t1\n");
            break;
        case MUL_OP_AST:
            printf("    mult $v0, $v0, $t1\n");
            break;
        case DIV_OP_AST:
            printf("    div $v0, $v0, $t1\n");
            break;
        default:
            break;
    }
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
            printf("    CONDITION\n");
            break;
        case IDENT_AST:
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
            gen_code(n->brother);
            break;
    }
}
