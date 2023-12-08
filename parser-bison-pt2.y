%{
#include <stdio.h>

%}

%union {
    char *str_val;
    int int_val;
}

%token <str_val>ID ATRIB PEV MAIS DIV <int_val>NUM LPAR RPAR WHILE

%%

/* gramatica de exemplo para lacos */
laco: WHILE {printf("R00: NADA\n"); }      /* ao ler um while, imprimir o rotulo de inicio */
      LPAR
      condicao {printf("GFALSE Rfim\n"); } /* apos a condicao, se for falsa, vai para rotulo de fim */
      RPAR
      atrib {
          printf("GOTO R00\n");         /* ao fim do bloco, volta para o rotulo do inicio do laco */
          printf("R01: NADA\n");        /* rotulo de fim do laco*/
      }
      ;

/* ATENCAO! Este eh apenas um exemplo utilizando dois rotulos fixos (R00 e R01).
   ISSO NAO É SUFICIENTE NO TRABALHO! Implemente uma PILHA DE ROTULOS, conforme visto em aula
  (fica como exercicio) */

condicao: /* descricao de condicoes fica como exercicio */ {printf("(condicao)\n"); } ;

atrib : ID ATRIB expr PEV {printf("\natribuir em %s\n", $1); };

expr : expr MAIS termo {printf("+ ");}
     | termo ;

termo : termo DIV fator {printf("/ ");}
      | fator ;

fator : ID {printf("%s ", $1);}
      | NUM {printf("%d ", $1);}
      | LPAR expr RPAR ;

%%

// extern FILE *yyin;                   // (*) descomente para ler de um arquivo

int main(int argc, char *argv[]) {

//    yyin = fopen(argv[1], "r");       // (*)

    yyparse();

//    fclose(yyin);                     // (*)

    return 0;
}

void yyerror(char *s) { fprintf(stderr,"ERRO: %s\n", s); }
