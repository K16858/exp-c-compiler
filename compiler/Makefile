parser: parser.tab.c lex.yy.c ast.c code_generation.c
	gcc parser.tab.c lex.yy.c ast.c code_generation.c -o parser -lfl -ly

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex lexer.l

test: parser
	./parser < ./tests/test1.txt

clean:
	rm -f parser parser.tab.c parser.tab.h lex.yy.c