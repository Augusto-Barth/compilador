bison -d parser-bison.y
flex lexico-flex.l
gcc lex.yy.c parser-bison.tab.c -o compilador -w

if [ $# -ne 2 ]; then
    echo "Uso: bash comp.sh [programa].cs2 [saida].pil"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "O arquivo deve existir"
    exit 1
fi

if [ "${1: -4}" != ".cs2" ]; then
    echo "Arquivo de entrada deve ter extensão .cs2"
    exit 1
fi

if [ ! -f "pilheitor" ]; then
    g++ pilheitor.cpp -o pilheitor
fi

./compilador < $1 > $2
./pilheitor $2

#   comando:
#   bash compilar.sh [programa].cs2 [saida].pil