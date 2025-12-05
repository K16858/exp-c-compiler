%{
    #include "parser.tab.h"
%}
%%
define              {return DEFINE;}
array                {return ARRAY;}
if                      {return IF;}
else                  {return ELSE;}
while                 {return LOOP;}
func              {return FUNCTION;}
"("                {return L_PARAN;}
")"                {return R_PARAN;}
"["              {return L_BRACKET;}
"]"              {return R_BRACKET;}
"{"                {return L_BRACE;}
"}"                {return R_BRACE;}
"=="                    {return EQ;}
"<"                     {return LT;}
">"                     {return GT;}
"="                 {return ASSIGN;}
"+"                    {return ADD;}
"-"                    {return SUB;}
"*"                    {return MUL;}
"/"                    {return DIV;}
,                    {return COMMA;}
;                    {return SEMIC;}
[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = (char*)malloc(sizeof(char) * yyleng);
    strncpy(yylval.str, yytext, yyleng);
    return IDENT;
}

-?[0-9]+           {yylval.num = atoi(yytext); return NUMBER;}
[ \t]+
\n
.                {return yytext[0];}
%%