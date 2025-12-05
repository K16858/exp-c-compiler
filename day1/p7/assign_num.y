%{
    #include <stdio.h>
    #include "assign_num.tab.h"
    extern int yylex();
    extern int yyerror();
%}

%union{
    int num;
    char* str;
}

%token DEFINE <str>IDENT SEMIC ASSIGN COMMA <num>NUMBER
%type <str>idents

%%
statement
    : IDENT ASSIGN NUMBER SEMIC {printf("OK! ident=%s, num=%d\n", $1, $3);}
    | DEFINE idents SEMIC {printf("OK! ident=%s\n", $2);}
    
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
