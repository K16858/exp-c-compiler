parser: parser.tab.c lex.yy.c
	gcc parser.tab.c lex.yy.c -o parser -lfl -ly

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex -d lexer.l