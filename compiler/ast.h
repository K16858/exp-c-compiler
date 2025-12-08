#include <stdio.h>
#include <stdlib.h>
extern int yyparse();
extern int yyerror();

// ノードタイプ
typedef enum{
    IDENT_AST=0,
    IDENTS_AST,
    NUMBER_AST,
    ADD_OP_AST,
    MUL_OP_AST,
    COND_OP_AST,
    VAR_AST,
    ARRAY_AST,
    CONDITION_AST,
    FACTOR_AST,
    TERM_AST,
    EXPRESSION_AST,
    DECLARATIONS_AST,
    STATEMENTS_AST,
    STATEMENT_AST,
    ASSIGNMENT_STATEMENT_AST,
    LOOP_STATEMENT_AST,
    IF_STATEMENT_AST,
    DECL_STATEMENT_AST,
    DECL_FUNCTION_AST,
    FUNCTION_AST,
    PROGRAM_AST
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
