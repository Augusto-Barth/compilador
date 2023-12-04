%{
#include <stdio.h>              // primeira parte: definicoes (o que tiver aqui
                                // vai ser copiado direto para o codigo gerado)
%}

/* coloque esta opcao para o flex ler apenas um arquivo */
%option noyywrap

%%

"SE QUER OUTRA?" { printf("DECL\n"); }
"QUE OTA" { printf("MAIS\n"); } // segunda parte: sequencia de strings ou regexs seguidos de o que fazer quando dar match
"DROPA" { printf("MENOS\n"); }
"SPLIT" { printf("DIV\n"); }
"K" { printf("MUL\n"); }
"CLUTCH" { printf("MOD\n"); }
"OTA" {printf("INC\n"); }
"MIADO" {printf("DEC\n"); }
"(" { printf("LPAR\n"); }
")" { printf("RPAR\n"); }
"GG" { printf("PEV\n"); }
"ENTAO TOMA" { printf("ATRIB\n"); }
"==" { printf("IGUAL\n"); }
"!=" { printf("DIF\n"); }
"<" { printf("MENOR\n"); }
"<=" { printf("MENORIG\n"); }
">" { printf("MAIOR\n"); }
">=" { printf("MAIORIG\n"); }
"RUSH B" { printf("WHILE\n"); }
"FAKE B" { printf("FOR\n"); }
"ECO" { printf("IF\n"); }
"ECO SECO" { printf("ELSE\n"); }
"BANGUEI" {printf("IMPR\n"); }
"CALL" { printf("LEIA\n"); }
"NO SCOPE HEADSHOT VARADO CEGO PELA SMOKE" { printf("SAIR\n"); }
-?[0-9]+ { printf("NUM: \"%s\"\n", yytext); }                 // yytext eh uma string com o texto em si do token reconhecido
[a-zA-Z][a-zA-Z0-9_]* { printf("ID: \"%s\"\n", yytext); }
" " {}
"\n" {}
%%

extern FILE *yyin;

int main(int argc, char *argv[]) {      // terceira parte: codigo em si (tb sera
                                        // copiado direto para o codigo gerado)

    // yyin = fopen(argv[1], "r");      // (*)descomentar para ler de arquivo ao
                                        // inves da entrada padrao

    yylex();                            // chamar yylex() para iniciar o
                                        // analisador

    // fclose(yyin);                    // (*)

    return 0;
}
