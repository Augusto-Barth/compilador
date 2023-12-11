%{
#include <stdio.h>
#include "parser-bison.tab.h"
%}

%option noyywrap

%%

"MUTE".*$ {}
"SE QUER OUTRA?" { return DECL; }
"QUE OTA" { return MAIS; } 
"DROPA" { return MENOS; }
"SPLIT" { return DIV; }
"K" { return MUL; }
"CLUTCH" { return MOD; }
"(" { return LPAR; }
")" { return RPAR; }
"{" { return LCHAV; }
"}" { return RCHAV; }
"GG" { return PEV; }
"ENTAO TOMA" { return ATRIB; }
"==" { return IGUAL; }
"!=" { return DIF; }
"<" { return MENOR; }
"<=" { return MENORIG; }
">" { return MAIOR; }
">=" { return MAIORIG; }
"RUSH B" { return WHILE; }
"FAKE B" { return FOR; }
"ECO" { return IF; }
"ECO SECO" { return ELSE; }
"BANGUEI" {return IMPR; }
"CALL" { return LEIA; }
"NO SCOPE HEADSHOT VARADO CEGO PELA SMOKE" { return SAIR; }
[0-9]+|"-"[0-9]+ {
    yylval.int_val = atoi(yytext);
    return NUM;
}
[a-zA-Z][a-zA-Z0-9_]* {
    yylval.str_val = strdup(yytext);
    return ID;
}
[ \t\r\n]+ {}
. { yyerror("lexical error");
            exit(EXIT_FAILURE); }

%%