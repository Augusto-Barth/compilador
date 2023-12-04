%{
#include <stdio.h>
// #include "parser-bison.tab.h"   // incluir o .h gerado pelo bison. Esse .h
                                // contem o enum dos tokens
%}

%option noyywrap
%%

"+" { return MAIS; }    // ao identificar um token na entrada, retornar para
"/" { return DIV; }     // o bison qual token foi identificado (dentre os
"(" { return LPAR; }    // definidos no enum do .h)
")" { return RPAR; }
"=" { return ATRIB; }
";" { return PEV; }
[0-9]+ { return NUM; }
[a-zA-Z][a-zA-Z0-9_]* { return ID; }
" " {}
"\n" {}
%%

/* A função main() agora está no .y do bison. Esta seção pode agora ficar vazia */
