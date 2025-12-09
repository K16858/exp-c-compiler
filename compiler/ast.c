#include "ast.h"
#include <string.h>
extern void gen_code(Node *n);

#define MAXBUF 20

Node *top; // 抽象構文木のルートノード保存用

Node *build_num_node(NType t, int n) {
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p == NULL) {
        yyerror("out of memory");
    }
    p->type = t;
    p->ivalue = n;
    p->child = NULL;

    return p;
}

Node *build_ident_node(NType t, char *s) {
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p == NULL) {
        yyerror("out of memory");
    }
    p->type = t;
    if ((p->variable = (char *)malloc(sizeof(MAXBUF))) == NULL) {
        yyerror("out of memory");
    }
    strncpy(p->variable, s, MAXBUF);
    p->child = NULL;

    return p;
}

Node *build_node0(NType t) {
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p == NULL) {
        yyerror("out of memory");
    }
    p->type = t;
    p->child = NULL;

    return p;
}

Node *build_node1(NType t, Node *p1) {
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p == NULL) {
        yyerror("out of memory");
    }
    p->type = t;
    p->child = p1;

    return p;
}

Node *build_node2(NType t, Node *p1, Node *p2) {
    Node *p;
    p = (Node *)malloc(sizeof(Node));
    if (p == NULL) {
        yyerror("out of memory");
    }
    p->type = t;
    p->child = p1;
    p->child->brother = p2;

    return p;
}

char *node_types[] = {
    "IDENT",
    "IDENTS",
    "NUMBER",
    "ADD_OP",
    "SUB_OP",
    "MUL_OP",
    "DIV_OP",
    "EQ_OP",
    "LT_OP",
    "GT_OP",
    "VAR",
    "ARRAY",
    "CONDITION",
    "FACTOR",
    "TERM",
    "EXPRESSION",
    "DECLARATIONS",
    "STATEMENTS",
    "STATEMENT",
    "ASSIGNMENT_STATEMENT",
    "LOOP_STATEMENT",
    "IF_STATEMENT",
    "DECL_STATEMENT",
    "DECL_FUNCTION",
    "FUNCTION",
    "PROGRAM"
};

void print_node_type(int node_type) {
    printf("Node type: %s\n", node_types[node_type]);
}

int print_tree(Node *n, int num) {
    printf("\"%s_%d", node_types[n->type], num++);
    
    if (n->type == IDENT_AST && n->variable != NULL) {
        printf("(%s)", n->variable);
    } else if (n->type == NUMBER_AST) {
        printf("(%d)", n->ivalue);
    }
    
    printf("\": {");
    
    if (n->child != NULL) {
        num = print_tree(n->child, num);
    }
    printf("}");
    if (n->brother != NULL) {
        printf(",");
        num = print_tree(n->brother, num);
    }
    
    return num;
}

void print_tree_in_json(Node *n) {
    if (n != NULL) {
        int num = 0;
        printf("{");
        print_tree(n, num);
        printf("}\n");
    }
}

int main(void) {
    if (yyparse()) {
        fprintf(stderr, "Error!\n");
        return 1;
    }
    // AST生成完了
    // printf("[*] AST generation is completed\n");
    // AST表示
    // print_tree_in_json(top);
    // コード生成
    gen_code(top);
    return 0;
}
