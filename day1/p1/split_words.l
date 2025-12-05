%%
[^ \t\n]+ {printf("Word: %s\n", yytext);}
[ \t\n]
%%

int main(void) {
 yylex();
 return 0;
}