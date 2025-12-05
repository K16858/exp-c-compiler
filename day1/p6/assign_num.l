%{
    #include "assign_num.tab.h"
%}
%%
=                   {return ASSIGN;}
;                    {return SEMIC;}
[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = (char*)malloc(sizeof(char) * yyleng);
    strncpy(yylval.str, yytext, yyleng);
    return IDENT;
}

[0-9]+          {yylval.num = atoi(yytext); return NUMBER;}
[ \t]+
\n                       {return 0;}
.                {return yytext[0];}
%%