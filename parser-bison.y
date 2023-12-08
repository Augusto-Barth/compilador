%{
#include <stdio.h>
#include <string.h>

unsigned int pilha_index = 0;
unsigned int pilha[1000];

// Um simbolo da tabela de simbolos é um id e seu endereço
typedef struct {
    char *id;
    int end;
} simbolo;

// Vetor de simbolos (a tabela de simbolos em si)
simbolo tabsimb[1000];
int nsimbs = 0;

// Dado um ID, busca na tabela de simbolos o endereço respectivo
int getendereco(char *id) {
    for (int i=0;i<nsimbs;i++)
        if (!strcmp(tabsimb[i].id, id))
            return tabsimb[i].end;
}

%}

%union {
    char *str_val;
    int int_val;
}

%token DECL MAIS MENOS DIV MUL MOD INC DEC LPAR RPAR LCHAV RCHAV PEV ATRIB IGUAL DIF MENOR MENORIG MAIOR MAIORIG WHILE FOR IF ELSE IMPR LEIA SAIR <int_val>NUM <str_val>ID

%%

programa : listacomandos SAIR PEV {printf("SAIR\n"); };

listacomandos : comando
              | comando listacomandos

comando : decl PEV
        | atrib PEV
        | laco 
        | expr PEV
        | print PEV;

/* gramatica de exemplo para lacos */
laco: WHILE {
            pilha[pilha_index] = pilha_index++; 
            pilha[pilha_index] = pilha_index++;
            printf("R%d: NADA\n", pilha[pilha_index-1]); 
        }      /* ao ler um while, imprimir o rotulo de inicio */
      LPAR
      condicao {printf("GFALSE R%d\n", pilha[pilha_index]); } /* apos a condicao, se for falsa, vai para rotulo de fim */
      RPAR
      LCHAV
      listacomandos {
          printf("GOTO R%d\n", pilha[pilha_index-1]);         /* ao fim do bloco, volta para o rotulo do inicio do laco */
          printf("R%d: NADA\n", pilha[pilha_index]);        /* rotulo de fim do laco*/
          pilha_index -= 2;
      }
      RCHAV
      ;


/* condicao: ID {printf("PUSH %%%d\n", getendereco($1));} comp expr ; */
condicao: expr MENOR expr {printf("MENOR\n"); }
        | expr MENORIG expr {printf("MENOREQ\n"); }
        | expr MAIOR expr {printf("MAIOR\n"); }
        | expr MAIORIG expr {printf("MAIOREQ\n"); }
        | expr IGUAL expr {printf("IGUAL\n"); }
        | expr DIF expr {printf("DIFER\n"); }

/* comp: MENOR { return "MENOR"; }
    | MENORIG {printf("MENOREQ\n"); }
    | MAIOR {printf("MAIOR\n"); }
    | MAIORIG {printf("MAIOREQ\n"); }
    | IGUAL {printf("IGUAL\n"); }
    | DIF {printf("DIFER\n"); }; */

print : IMPR expr {printf("IMPR\n"); };

decl : DECL ID { tabsimb[nsimbs] = (simbolo){$2, nsimbs}; nsimbs++; }
     | DECL ID ATRIB expr { tabsimb[nsimbs] = (simbolo){$2, nsimbs}; nsimbs++;
                                printf("ATR %%%d\n", getendereco($2)); };

atrib : ID ATRIB expr {printf("ATR %%%d\n", getendereco($1)); };

expr : expr MAIS termo {printf("SOMA\n");}
     | termo ;

termo : termo DIV fator {printf("DIV");}
      | fator ;

fator : ID {printf("PUSH %%%d\n", getendereco($1));}
      | NUM {printf("PUSH %d\n", $1);}
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
