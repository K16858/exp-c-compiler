%{
    #include <stdio.h>
    #include "parser.tab.h"
    extern int yylex();
    extern int yyerror();
    extern Node *top;
%}

%union{
    struct node *np;
    char *sp;
    int ival;
}

%token DEFINE ARRAY IF ELSE LOOP L_PARAN R_PARAN L_BRACKET R_BRACKET L_BRACE R_BRACE EQ LT GT SEMIC ASSIGN ADD SUB MUL DIV IDENT NUMBER COMMA FUNCTION
%type <sp> program decl_function function declarations statements statement loop_statement if_statement decl_statement var array condition assignment_statement expression term factor add_op mul_op cond_op

%%
program
    : declarations statements
    {top = build_node2(PROGRAM, $1, $2);}
;
decl_function
    : FUNCTION IDENT L_PARAN IDENT R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(DECL_FUNCTION, build_node0(IDENT), $7);}
;
function
    : IDENT L_PARAN var R_PARAN
    {$$ = build_node1(FUNCTION, $3);}
;
declarations
    : decl_statement declarations
    {$$ = build_node2(DECLARATIONS, $1, $$);}
    | decl_statement
    {$$ = build_node1(DECLARATIONS, $1);}
;
statements
    : statement statements 
    {$$ = build_node2(STATEMENTS, $1, $$);}
    | statement
    {$$ = build_node1(STATEMENTS, $1);}
;
statement
    : assignment_statement
    {$$ = build_node1(STATEMENT, $1);}
    | loop_statement
    {$$ = build_node1(STATEMENT, $1);}    
    | if_statement
    {$$ = build_node1(STATEMENT, $1);}
    | decl_function
    {$$ = build_node1(STATEMENT, $1);}
    | function
    {$$ = build_node1(STATEMENT, $1);}
;
loop_statement
    : LOOP L_PARAN condition R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(LOOP_STATEMENT, $3, $6);}
;
if_statement
    : IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE 
    {$$ = build_node2(IF_STATEMENT, $3, $6);}
    | IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE
    {$$ = build_node2(IF_STATEMENT, $3, build_node2(STATEMENTS, $6, $10));}
;
decl_statement
    : DEFINE IDENT SEMIC
    {$$ = build_node1(DECL_STATEMENT, build_node0(IDENT));}
    | ARRAY array SEMIC
    {$$ = build_node1(DECL_STATEMENT, $2);}
;
var
    : IDENT
    {$$ = build_node1(VAR, build_node0(IDENT));}
    | NUMBER
    {$$ = build_node1(VAR, build_node0(NUMBER));}    
    | array
    {$$ = build_node1(VAR, $1);}    
;
array
    : IDENT L_BRACKET expression R_BRACKET
    {$$ = build_node2(ARRAY, build_node0(IDENT), build_node1(EXPRESSION, $3));}
    | array L_BRACKET expression R_BRACKET
    {$$ = build_node2(ARRAY, $1, build_node1(EXPRESSION, $3));}
;
condition
    : expression cond_op expression
    {$$ = build_node2(CONDITION, $2, build_node2(EXPRESSION, build_node1(EXPRESSION, $1), build_node1(EXPRESSION, $3)));}
;
assignment_statement
    : IDENT ASSIGN expression SEMIC
    {$$ = build_node2(ASSIGNMENT_STATEMENT, build_node0(IDENT), $3);}
    | array ASSIGN expression SEMIC
    {$$ = build_node2(ASSIGNMENT_STATEMENT, $1, $3);}
;
expression
    : expression add_op term
    {$$ = build_node2($2, $1, $3);}
    | term
    {$$ = $1;}
;
term
    : term mul_op factor
    {$$ = build_node2($2, $1, $3);}
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
    {$$ = build_node0(ADD_OP);}
    | SUB
    {$$ = build_node0(ADD_OP);}
;
mul_op
    : MUL
    {$$ = build_node0(MUL_OP);}
    | DIV
    {$$ = build_node0(MUL_OP);}
;
cond_op
    : EQ
    {$$ = build_node0(COND_OP);}
    | LT
    {$$ = build_node0(COND_OP);}
    | GT
    {$$ = build_node0(COND_OP);}
;
%%
