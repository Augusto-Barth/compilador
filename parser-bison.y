%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int pilha_index = 0;
unsigned int pilha_atual = 0;
unsigned int pilha[1000];

/* Um simbolo da tabela de simbolos é um id e seu endereço */
typedef struct {
    char *id;
    int end;
} simbolo;

/* Tabela de simbolos */
simbolo tabsimb[1000];
int nsimbs = 0;

/* Procura uma variavel pelo nome, se ela eh encontrada, retorna se o endereco dela
   Se nao, estamos tentando acessar uma variavel nao declarada, erro semantico */
int getendereco(char *id) {
    for (int i=0;i<nsimbs;i++)
        if (!strcmp(tabsimb[i].id, id))
            return tabsimb[i].end; // achamos 
    fprintf(stderr, "ERROR: semantic error (variable %s not declared)\n", id); // nao achou a variavel
    exit(EXIT_FAILURE);
}

/* Insere uma variavel na tabela de simbolos se ela nao existe ainda
   Se ja existe, estamos tentando declarar uma variavel duas vezes, erro semantico */
void writeendereco(char* id){
    for (int i=0;i<nsimbs;i++)
        if (!strcmp(tabsimb[i].id, id)){
            fprintf(stderr, "ERROR: semantic error (variable %s already declared)\n", id); // ja existe variavel
            exit(EXIT_FAILURE);
        }
    tabsimb[nsimbs] = (simbolo){id, nsimbs}; nsimbs++; // inserindo na tabela
}

%}

%union {
    char *str_val;
    int int_val;
}

%token DECL MAIS MENOS DIV MUL MOD LPAR RPAR LCHAV RCHAV PEV ATRIB IGUAL DIF MENOR MENORIG MAIOR MAIORIG WHILE FOR IF ELSE IMPR LEIA SAIR <int_val>NUM <str_val>ID

%%

programa : listacomandos SAIR PEV {printf("SAIR\n"); };

listacomandos : comando
              | comando listacomandos;

comando : decl PEV
        | atrib PEV
        | laco 
        | if
        | expr PEV
        | print PEV
        | scan PEV;

laco: WHILE {
            pilha[pilha_index++] = pilha_atual++; 
            pilha[pilha_index++] = pilha_atual++;
            printf("R%d: NADA\n", pilha[pilha_index-2]); 
        }   /* ao ler um while, imprimir o rotulo de inicio */
      LPAR
      condicao {printf("GFALSE R%d\n", pilha[pilha_index-1]); } /* apos a condicao, se for falsa, vai para rotulo de fim */
      RPAR
      LCHAV
      listacomandos {
          printf("GOTO R%d\n", pilha[pilha_index-2]);         /* ao fim do bloco, volta para o rotulo do inicio do laco */
          printf("R%d: NADA\n", pilha[pilha_index-1]);        /* rotulo de fim do laco*/
          pilha_index -= 2;
      }
      RCHAV
      |
      FOR {
        pilha[pilha_index++] = pilha_atual++;
        pilha[pilha_index++] = pilha_atual++;
        pilha[pilha_index++] = pilha_atual++;
        pilha[pilha_index++] = pilha_atual++;
      }
      LPAR
      atrib {
            printf("R%d: NADA\n", pilha[pilha_index-4]);
      } /* Rotulo de inicio */
      PEV
      condicao {
            
            printf("GFALSE R%d\n", pilha[pilha_index-3]); /* se a condicao for falsa, vai para o fim */
            printf("GOTO R%d\n", pilha[pilha_index-2]); /* pula o terceiro "passo" do for, ele so 
                                                        eh executado no fim do bloco de codigo dentro do for*/
            printf("R%d: NADA\n", pilha[pilha_index-1]); /* inicio do codigo executado apos cada iteracao */
      }
      PEV
      atrib {
            printf("GOTO R%d\n", pilha[pilha_index-4]); /* volta para o inicio (condicao) */
            printf("R%d: NADA\n", pilha[pilha_index-2]); /* rotulo de comeco do bloco de codigo */
      }
      RPAR
      LCHAV
      listacomandos {
          printf("GOTO R%d\n", pilha[pilha_index-1]);   /* vai para o codigo executado apos cada iteracao */
          printf("R%d: NADA\n", pilha[pilha_index-3]); /* rotulo de fim do for */
          pilha_index -= 4;
      }
      RCHAV
      ;

condicao: expr MENOR expr {printf("MENOR\n"); }
        | expr MENORIG expr {printf("MENOREQ\n"); }
        | expr MAIOR expr {printf("MAIOR\n"); }
        | expr MAIORIG expr {printf("MAIOREQ\n"); }
        | expr IGUAL expr {printf("IGUAL\n"); }
        | expr DIF expr {printf("DIFER\n"); };


if : IF {
            pilha[pilha_index++] = pilha_atual++;
            pilha[pilha_index++] = pilha_atual++;
        }
        LPAR
        condicao { printf("GFALSE R%d\n", pilha[pilha_index-2]); }
        RPAR
        LCHAV 
        listacomandos
        RCHAV
        {
            printf("GOTO R%d\n", pilha[pilha_index-1]);
            printf("R%d: NADA\n", pilha[pilha_index-2]);
        }
        opt_else
        {
            printf("R%d: NADA\n", pilha[pilha_index-1]);
            pilha_index -= 2;
        };

opt_else : /* vazio */
         | ELSE
           LCHAV
           listacomandos
           RCHAV ;

print : IMPR LPAR expr RPAR {printf("IMPR\n"); };

scan : LEIA LPAR ID RPAR {printf("LEIA\n");
                            printf("ATR %%%d\n", getendereco($3)); };

decl : DECL ID { writeendereco($2); }
     | DECL ID ATRIB expr { writeendereco($2);
                                printf("ATR %%%d\n", getendereco($2)); };

atrib : ID ATRIB expr {printf("ATR %%%d\n", getendereco($1)); };

expr : expr MAIS termo {printf("SOMA\n");}
     | expr MENOS termo {printf("SUB\n");}
     | termo ;

termo : termo MUL fator {printf("MULT\n");}
      | termo DIV fator {printf("DIV\n");}
      | termo MOD fator {printf("MOD\n");}
      | fator ;

fator : ID {printf("PUSH %%%d\n", getendereco($1));}
      | NUM {printf("PUSH %d\n", $1);}
      | LPAR expr RPAR ;
%%

// extern FILE *yyin;                   // (*) descomente para ler de um arquivo,

int main(int argc, char *argv[]) {

//    yyin = fopen(argv[1], "r");       // (*)

    yyparse();

//    fclose(yyin);                     // (*)

    return 0;
}

void yyerror(char *s) { fprintf(stderr,"ERROR: %s\n", s); }
