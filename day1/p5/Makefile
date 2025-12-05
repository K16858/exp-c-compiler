define_mul: define_mul.tab.c lex.yy.c
	gcc define_mul.tab.c lex.yy.c -o define_mul -lfl -ly

define_mul.tab.c: define_mul.y
	bison -d define_mul.y

lex.yy.c: define_mul.l
	flex define_mul.l