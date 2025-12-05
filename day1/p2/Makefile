# 2. Compile lex.yy.c using gcc
count_words: lex.yy.c
	gcc lex.yy.c -o count_words -lfl
# 1. Generate lex.yy.c from count_words.l using flex
lex.yy.c: count_words.l
	flex count_words.l