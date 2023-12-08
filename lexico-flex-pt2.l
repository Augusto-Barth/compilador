%{
#include <stdio.h>
#include "parser-bison.tab.h"
%}

%option noyywrap
%%

"+" { return MAIS; }
"/" { return DIV; }
"(" { return LPAR; }
")" { return RPAR; }
"=" { return ATRIB; }
";" { return PEV; }
"while" { return WHILE; }   /* token para while (exemplo) */
[0-9]+ {
    yylval.int_val = atoi(yytext);
    return NUM;
}
[a-zA-Z][a-zA-Z0-9_]* {
    yylval.str_val = strdup(yytext);
    return ID;
}
" " {}
"\n" {}
%%
