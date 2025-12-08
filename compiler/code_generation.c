#include <stdio.h>
#include "ast.h"

void print_node(Node *n) {
    if (n != NULL) {
        printf("type: %s\n", node_types[n->type]);
    }
}

void gen_code(Node *n) {
    printf("gen_code\n");
    print_node(n);
    if (n->child != NULL) {
        gen_code(n->child);
    }
    if (n->brother != NULL) {
        gen_code(n->brother);
    }
}
