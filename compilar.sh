bison -d parser-bison.y
flex lexico-flex.l
gcc lex.yy.c parser-bison.tab.c -o compilador -w

if [ $# -ne 2 ]; then
    echo "Uso: bash comp.sh [programa].cs2 [saida].pil"
    exit 1
fi

if [ ! -f "$1" ] || [ ! -f "$2" ]; then
    echo "Arquivos devem existir"
    exit 1
fi

if [ "${1: -4}" != ".cs2" ]; then
    echo "Arquivo de entrada deve ter extensão .cs2"
    exit 1
fi

./compilador < $1 > $2
./pilheitor $2

#   comando:
#   bash comp.sh [programa].cs2 [saida].pil