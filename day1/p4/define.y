%{
    #include <stdio.h>
    #include "define.tab.h"
    extern int yylex();
    extern int yyerror();
%}
%token DEFINE IDENT SEMIC
%%
statement
    :DEFINE IDENT SEMIC {printf("OK!\n");}
    ;
%%
int main(void) {
    if (yyparse()) {
    fprintf(stderr, "Error!\n");
    return 1;
    }
    return 0;
}