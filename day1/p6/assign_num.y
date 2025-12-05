%{
    #include <stdio.h>
    #include "assign_num.tab.h"
    extern int yylex();
    extern int yyerror();
%}

%token IDENT SEMIC ASSIGN NUMBER

%union{
    int num;
    char* str;
}

%%
statement
    : IDENT ASSIGN NUMBER SEMIC {printf("OK!\n");}
;
%%
int main(void) {
    if (yyparse()) {
    fprintf(stderr, "Error!\n");
    return 1;
    }
    return 0;
}
