%{
    #include "define_and_assign_num.tab.h"
%}
%%
define              {return DEFINE;}
=                   {return ASSIGN;}
,                    {return COMMA;}
;                    {return SEMIC;}
[a-zA-Z][a-zA-Z0-9]* { return IDENT;}

[0-9]+          {return NUMBER;}
[ \t]+
\n
.                {return yytext[0];}
%%