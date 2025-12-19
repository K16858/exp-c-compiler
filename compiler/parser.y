%{
    #include <stdio.h>
    #include "ast.h"
    extern int yylex();
    extern int yyerror();
    extern Node *top;
%}

%union{
    struct node *np;
    char *sp;
    int ival;
}

%token <sp> IDENT
%token <ival> NUMBER
%token DEFINE ARRAY IF ELSE LOOP L_PARAN R_PARAN L_BRACKET R_BRACKET L_BRACE R_BRACE EQ LT GT SEMIC ASSIGN ADD SUB MUL DIV MOD COMMA FUNCTION
%type <np> program decl_function function_call function_expr declarations statements statement loop_statement if_statement decl_statement var array condition assignment_statement expression term factor add_op mul_op cond_op idents vars

%%
program
    : declarations statements
    {top = build_node2(PROGRAM_AST, $1, $2);}
;
decl_function
    : FUNCTION IDENT L_PARAN IDENT R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(DECL_FUNCTION_AST, build_node2(IDENT_AST, build_ident_node(IDENT_AST, $2), build_ident_node(IDENT_AST, $4)), $7);}
    | FUNCTION IDENT L_PARAN idents R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(DECL_FUNCTION_AST, build_node2(IDENT_AST, build_ident_node(IDENT_AST, $2), $4), $7);}
    | FUNCTION IDENT L_PARAN R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(DECL_FUNCTION_AST, build_ident_node(IDENT_AST, $2), $6);}
;
function_call
    : IDENT L_PARAN var R_PARAN SEMIC
    {$$ = build_node2(FUNCTION_AST, build_ident_node(IDENT_AST, $1), $3);}
    | IDENT L_PARAN vars R_PARAN SEMIC
    {$$ = build_node2(FUNCTION_AST, build_ident_node(IDENT_AST, $1), $3);}
    | IDENT L_PARAN R_PARAN SEMIC
    {$$ = build_node1(FUNCTION_AST, build_ident_node(IDENT_AST, $1));}
;
function_expr
    : IDENT L_PARAN var R_PARAN
    {$$ = build_node2(FUNCTION_AST, build_ident_node(IDENT_AST, $1), $3);}
    | IDENT L_PARAN vars R_PARAN
    {$$ = build_node2(FUNCTION_AST, build_ident_node(IDENT_AST, $1), $3);}
    | IDENT L_PARAN R_PARAN
    {$$ = build_node1(FUNCTION_AST, build_ident_node(IDENT_AST, $1));}
;
declarations
    : decl_statement declarations
    {$$ = build_node2(DECLARATIONS_AST, $1, $2);}
    | decl_statement
    {$$ = build_node1(DECLARATIONS_AST, $1);}
;
statements
    : statement statements 
    {$$ = build_node2(STATEMENTS_AST, $1, $2);}
    | statement
    {$$ = build_node1(STATEMENTS_AST, $1);}
;
statement
    : assignment_statement
    {$$ = build_node1(STATEMENT_AST, $1);}
    | loop_statement
    {$$ = build_node1(STATEMENT_AST, $1);}
    | if_statement
    {$$ = build_node1(STATEMENT_AST, $1);}
    | function_call
    {$$ = build_node1(STATEMENT_AST, $1);}
;
loop_statement
    : LOOP L_PARAN condition R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(LOOP_STATEMENT_AST, $3, $6);}
;
if_statement
    : IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE 
    {$$ = build_node2(IF_STATEMENT_AST, $3, $6);}
    | IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE
    {$$ = build_node2(IF_STATEMENT_AST, $3, build_node2(STATEMENTS_AST, $6, $10));}
;
decl_statement
    : DEFINE IDENT SEMIC
    {$$ = build_node1(DECL_STATEMENT_AST, build_ident_node(IDENT_AST, $2));}
    | DEFINE idents SEMIC
    {$$ = build_node1(DECL_STATEMENT_AST, $2);}
    | ARRAY array SEMIC
    {$$ = build_node1(DECL_STATEMENT_AST, $2);}
    | decl_function
    {$$ = $1;}
;
var
    : IDENT
    {$$ = build_ident_node(IDENT_AST, $1);}
    | NUMBER
    {$$ = build_num_node(NUMBER_AST, $1);}
    | array
    {$$ = $1;}
    | function_expr
    {$$ = $1;}
;
vars
    : vars COMMA var
    {$$ = build_node2(VARS_AST, $1, $3);}
    | var COMMA var
    {$$ = build_node2(VARS_AST, $1, $3);}
;
idents
    : idents COMMA IDENT
    {$$ = build_node2(IDENTS_AST, $1, build_ident_node(IDENT_AST, $3));}
    | IDENT COMMA IDENT
    {$$ = build_node2(IDENTS_AST, build_ident_node(IDENT_AST, $1), build_ident_node(IDENT_AST, $3));}
;
array
    : IDENT L_BRACKET expression R_BRACKET
    {$$ = build_node2(ARRAY_AST, build_ident_node(IDENT_AST, $1), build_node1(EXPRESSION_AST, $3));}
    | array L_BRACKET expression R_BRACKET
    {$$ = build_node2(ARRAY_AST, $1, build_node1(EXPRESSION_AST, $3));}
;
condition
    : expression cond_op expression
    {$$ = build_node2(CONDITION_AST, $2, build_node2(EXPRESSION_AST, build_node1(EXPRESSION_AST, $1), build_node1(EXPRESSION_AST, $3)));}
;
assignment_statement
    : IDENT ASSIGN expression SEMIC
    {$$ = build_node2(ASSIGNMENT_STATEMENT_AST, build_ident_node(IDENT_AST, $1), $3);}
    | array ASSIGN expression SEMIC
    {$$ = build_node2(ASSIGNMENT_STATEMENT_AST, $1, $3);}
;
expression
    : expression add_op term
    {$$ = build_node1(EXPRESSION_AST, build_node2($2->type, $1, $3));}
    | term
    {$$ = $1;}
;
term
    : term mul_op factor
    {$$ = build_node1(TERM_AST, build_node2($2->type, $1, $3));}
    | factor
    {$$ = $1;}
;
factor
    : var
    {$$ = $1;}
    | L_PARAN expression R_PARAN
    {$$ = $2;}
;
add_op
    : ADD
    {$$ = build_node0(ADD_OP_AST);}
    | SUB
    {$$ = build_node0(SUB_OP_AST);}
;
mul_op
    : MUL
    {$$ = build_node0(MUL_OP_AST);}
    | DIV
    {$$ = build_node0(DIV_OP_AST);}
    | MOD
    {$$ = build_node0(MOD_OP_AST);}
;
cond_op
    : EQ
    {$$ = build_node0(EQ_OP_AST);}
    | LT
    {$$ = build_node0(LT_OP_AST);}
    | GT
    {$$ = build_node0(GT_OP_AST);}
;
%%
