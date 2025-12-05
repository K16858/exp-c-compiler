%{
 int num_words = 0;
 int num_chars = 0;
 int num_lines = 1;
%}
%%
[^ \t\n]+ {printf("Word: %s\n", yytext); num_words++; num_chars += yyleng;}
[ \t]
\n {num_lines++;}
%%
int main(void) {
 yylex();
 printf("#words=%d\n#chars=%d\n#lines=%d\n", num_words, num_chars, num_lines);
 return 0;
}