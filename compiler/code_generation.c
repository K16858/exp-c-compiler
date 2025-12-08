#include <stdio.h>
#include "ast.h"

typedef struct {
    char *name;
    int offset;
    int size;  
} Symbol;

Symbol *symbol_table;
int symbol_count;

void print_node(Node *n) {
    if (n != NULL) {
        printf("type: %s\n", node_types[n->type]);
    }
}

void gen_header() {
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
".text 0x00001000 # 以降のコードを 0から配置 x00001000\n";
    printf("%s", code);
}

void gen_code(Node *n) {
    printf("gen_code\n");
    print_node(n);
    gen_header();
    if (n->child != NULL) {
        gen_code(n->child);
    }
    if (n->brother != NULL) {
        gen_code(n->brother);
    }
}
