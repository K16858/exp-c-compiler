%{
    #include <stdio.h>
    #include "define_mul.tab.h"
    extern int yylex();
    extern int yyerror();
%}
%token DEFINE IDENT COMMA SEMIC
%%
statement
    : DEFINE idents SEMIC {printf("OK!\n");}
;
idents
    : IDENT COMMA idents
    | IDENT
;
%%
int main(void) {
    if (yyparse()) {
    fprintf(stderr, "Error!\n");
    return 1;
    }
    return 0;
}