assign_num: assign_num.tab.c lex.yy.c
	gcc assign_num.tab.c lex.yy.c -o assign_num -lfl -ly

assign_num.tab.c: assign_num.y
	bison -d assign_num.y

lex.yy.c: assign_num.l
	flex assign_num.l