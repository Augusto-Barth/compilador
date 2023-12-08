bison -d parser-bison.y
flex lexico-flex.l
gcc lex.yy.c parser-bison.tab.c -o out