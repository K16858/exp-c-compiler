result.txt: count_all	test.txt
	./count_all < test.txt > result.txt
# 2. Compile lex.yy.c using gcc
count_all: lex.yy.c
	gcc lex.yy.c -o count_all -lfl
# 1. Generate lex.yy.c from count_all.l using flex
lex.yy.c: count_all.l
	flex count_all.l