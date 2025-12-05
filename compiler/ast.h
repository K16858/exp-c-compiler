#include <stdio.h>
#include <stdlib.h>
extern int yyparse();
extern int yyerror();

// ノードタイプ
typedef enum{
    IDENT=0,
    IDENTS,
    NUMBER,
    ADD_OP,
    MUL_OP,
    COND_OP,
    VAR,
    ARRAY,
    CONDITION,
    FACTOR,
    TERM,
    EXPRESSION,
    DECLARATIONS,
    STATEMENTS,
    STATEMENT,
    ASSIGNMENT_STATEMENT,
    LOOP_STATEMENT,
    IF_STATEMENT,
    DECL_STATEMENT,
    DECL_FUNCTION,
    FUNCTION,s
} NType;

// 抽象構文木のノードのデータ構造
typedef struct node{
    NType type;
    struct node *child;
    struct node *brother;
} Node;

// 抽象構文木のノードの生成
Node *build_node0(NType t);
Node *build_node1(NType t, Node *p1);
Node *build_node2(NType t, Node *p1, Node *p2);

// プリント用
extern char *node_types[];

// プロトタイプ宣言
void print_node_type(int node_type);
