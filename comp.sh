bison -d parser-bison.y
flex lexico-flex.l
gcc lex.yy.c parser-bison.tab.c -o out -w
./out < $1 > $2
./pilheitor $2

#   comando:
#   bash comp.sh [programa].cs [saida].pil