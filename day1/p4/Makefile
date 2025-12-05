define: define.tab.c lex.yy.c
	gcc define.tab.c lex.yy.c -o define -lfl -ly

define.tab.c: define.y
	bison -d define.y

lex.yy.c: define.l
	flex define.l