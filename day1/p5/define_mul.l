%{
    #include "define_mul.tab.h"
%}
%%
define {return DEFINE;}
[a-zA-Z][a-zA-Z0-9]* {return IDENT;}
,                    {return COMMA;}
;                    {return SEMIC;}
[ \t]+
\n                       {return 0;}
.                {return yytext[0];}
%%
