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
    {top = build_node2(PROGRAM, $1, top);}
;
decl_function
    : FUNCTION IDENT L_PARAN IDENT R_PARAN L_BRACE statements R_BRACE
    {$$ = build_node2(STATEMENTS_AST, $1, top);}
;
function
    : IDENT L_PARAN var R_PARAN
;
declarations
    : decl_statement declarations
    | decl_statement
;
statements
    : statement statements 
    | statement
;
statement
    : assignment_statement
    | loop_statement
    | if_statement
    | decl_function
    | function
;
loop_statement
    : LOOP L_PARAN condition R_PARAN L_BRACE statements R_BRACE
;
if_statement
    : IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE 
    | IF L_PARAN condition R_PARAN L_BRACE statements R_BRACE ELSE L_BRACE statements R_BRACE
;
decl_statement
    : DEFINE IDENT SEMIC
    | ARRAY array SEMIC
;
var
    : IDENT
    | NUMBER
    | array
;
array
    : IDENT L_BRACKET expression R_BRACKET
    | array L_BRACKET expression R_BRACKET
;
condition
    : expression cond_op expression
;
assignment_statement
    : IDENT ASSIGN expression SEMIC
    | IDENT array ASSIGN expression
;
expression
    : expression add_op term
    | term
;
term
    : term mul_op factor
    | factor
;
factor
    : var
    | L_PARAN expression R_PARAN
;
add_op
    : ADD | SUB
;
mul_op
    : MUL | DIV
;
cond_op
    : EQ | LT | GT
;
%%
