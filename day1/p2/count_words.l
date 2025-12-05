%{
 int num_words = 0;
%}
%%
[^ \t\n]+ {printf("Word: %s\n", yytext); num_words++;}
[ \t\n]
%%
int main(void) {
 yylex();
 printf("#words=%d\n", num_words);
 return 0;
}