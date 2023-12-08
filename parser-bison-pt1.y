%{
#include <stdio.h>

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

%token <str_val>ID ATRIB PEV MAIS DIV <int_val>NUM LPAR RPAR INT

%%

/* gramatica para declaracoes (exemplo) */
programa: declaracoes atrib ;

declaracoes: decl declaracoes | ;

/* ao declarar uma variavel, a tabela de simbolos é incrementada com o ID e um endereço */
decl : INT ID PEV { tabsimb[nsimbs] = (simbolo){$2, nsimbs}; nsimbs++; };

/* chamada da função getendereco() para obter o endereço de uma variavel */
atrib : ID ATRIB expr PEV {printf("\natribuir em %s, endereço %%%d\n", $1, getendereco($1)); };

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
