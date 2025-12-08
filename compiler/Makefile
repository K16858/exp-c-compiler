parser: parser.tab.c lex.yy.c ast.c code_generation.c
	gcc parser.tab.c lex.yy.c ast.c code_generation.c -o parser -lfl -ly

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex lexer.l