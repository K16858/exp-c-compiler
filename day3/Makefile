define_and_assign_num: define_and_assign_num.tab.c lex.yy.c ast.c
	gcc define_and_assign_num.tab.c lex.yy.c ast.c -o define_and_assign_num -lfl -ly

define_and_assign_num.tab.c: define_and_assign_num.y
	bison -d define_and_assign_num.y

lex.yy.c: define_and_assign_num.l
	flex define_and_assign_num.l