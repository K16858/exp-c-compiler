%{
    #include "define.tab.h"
%}
%%
define {return DEFINE;}
[a-zA-Z][a-zA-Z0-9]* {return IDENT;}
; {return SEMIC;}
[ \t]+
\n {return 0;}
. {return yytext[0];}
%%
