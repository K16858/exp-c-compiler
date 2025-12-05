# 2. Compile lex.yy.c using gcc
split_words: lex.yy.c
	gcc lex.yy.c -o split_words -lfl
# 1. Generate lex.yy.c from split_words.l using flex
lex.yy.c: split_words.l
	flex split_words.l