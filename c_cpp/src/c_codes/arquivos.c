#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX        800
#define MAX2    640000
#define FNMAX      200
#define cinza      int

/*
 * Este arquivo contem um programa que usa as funções que manipulam arquivos
 * pedidas no enunciado do EP4. Você pode colocar as funções diretamente no
 * seu ep.
 *
 */

/* 
 * Funcao LeInt:
 * Devolve o proximo inteiro do arquivo ou indica fim de arquivo.
 *
 * Em caso de erro, a funcao devolve EOF.
 *
 */

int LeInt (FILE * arq) {
  int num, aux, c;

  while (1) {
    aux = fscanf (arq, "%d", &num);
    if (aux == 1) return num;

    c = fgetc (arq);

    if (c == '#') {
      /* inicia linha de comentario no arquivo pgm */
      while ((c != '\n') && (c != EOF)) {
	/* come todos os caracteres ate' um '\n' ou fim de arquivo */
        c = fgetc (arq);
      }
    }

    /* verifica se encontrou fim de arquivo */
    if (c == EOF) return c;

    if (c != '\n') {
      /* caractere inesperado: formato incorreto */
      return EOF;
    }

  }

  return 0;
}

/*
 * Funcao LeDesenho ( char nomearq[FNMAX], cinza M[MAX][MAX], int *pm, int *pn, int *pmax );
 *
 * A string nomearq guarda o nome de um arquivo em formato PGM.  Devem
 * ser devolvidos em *pm, *pn, e *pmax os valores do número de linhas,
 * de colunas e o valor máximo que codifica um tom de cinza do arquivo
 * de nome nomearq, respectivamente.  O desenho que está contido no
 * arquivo deve ser devolvido na matriz M.  A função deve retornar $0$
 * se não houver qualquer erro, e deve retornar $1$ caso algum erro
 * tenha sido encontrado (ou por conta da manipulação do arquivo, ou
 * por conta do valor de MAX ser insuficiente).
 *
 * Esta função depende da função: int LeInt (FILE *arq).
 *
 */

int LeDesenho( char nomearq[FNMAX], cinza M[MAX][MAX], int *pm, int *pn, int *pmax ) {

  FILE *arq ;
  char key[128] ;
  int  aux, i, j ;
  

  arq = fopen(nomearq, "r") ;
  if(arq == NULL) {
    printf("Erro na abertura do arquivo %s\n", nomearq) ;
    return 1 ;
  }

  
  aux = fscanf(arq, "%s", key) ;

  if(aux != 1) {
    printf("Erro na leitura do arquivo %s\n", nomearq) ;
    fclose(arq) ;
    return 1 ;
  }

  if(strcmp(key,"P2") != 0) {
    printf("Formato desconhecido\n") ;
    fclose(arq) ;
    return 1 ;
  }

  /* numero de colunas */
  *pn = LeInt (arq); 

  /* numero de linhas */
  *pm = LeInt (arq);  

  /* valor maximo do tom de cinza */
  *pmax = LeInt (arq);

  if(*pm == EOF || *pn == EOF || *pmax == EOF) {
    printf ("%d %d %d\n", *pn, *pm, *pmax);
    printf("Formato incorreto\n") ;
    fclose(arq) ;
    return 1 ;
  }
 
  if(*pm>MAX || *pn>MAX) {
    printf("Dimensao da matriz e' maior que o permitido\n") ;
    fclose(arq);
    return 1 ;
  }
 
  for(i=0; i<*pm; i++) {
    for(j=0; j<*pn; j++) {
      aux = M[i][j] = LeInt (arq);
      if(aux == EOF) {
        printf("Formato ou dado incorreto\n") ;
        fclose(arq) ;
        return 1 ;
      }
    }
  }
 
  fclose(arq) ;
  return 0 ;
}

/* Função: int LeTexto( char nomearq[FNMAX], char T[MAX2], int *pk ); 
 *
 * A string nomearq contém o nome de um arquivo.  O texto presente
 * nele deverá ser devolvido em T.  Deve-se devolver em *pk o número
 * de caracteres lidos e armazenados em T.  A função deve retornar $0$
 * se não houver erro algum, e deve retornar 1 caso algum erro tenha
 * sido encontrado (ou por conta da manipulação do arquivo, ou por
 * conta do valor de MAX2 ser insuficiente).
 *
 * Se um caractere lido tiver codigo ASCII negativo, a funcao
 * emitira' uma mensagem de erro e devolvera' um valor indicando erro. 
 *
 */

int LeTexto(char nomearq[FNMAX], char T[MAX2], int *pk) {
  FILE *arq ;
  char c ;
  int  i ;

  arq = fopen(nomearq, "r") ;
  if(arq == NULL) {
    printf("Erro na abertura do arquivo %s\n", nomearq) ;
    return 1 ;
  }

  i = 0 ;
  c = fgetc(arq) ;

  while(!feof(arq)) {
    if(i>=MAX2) {
      printf("Mensagem muito longa\n") ;
      fclose(arq) ;
      return 1 ;
    }

    if (c < 0) {
      printf ("Caractere %c desconhecido. Codigo do caractere: %d\n", c, c);
      fclose(arq) ;
      return 1 ;
    }

    T[i] = c ;
    i++ ;

    c=fgetc(arq) ;
  }
  *pk = i ;

  fclose(arq) ;

  return 0 ;
}

/* Função: int EscreveDesenho( char nomearq[FNMAX], cinza M[MAX][MAX], int m, int n, int max);
 *
 * Ela recebe em nomearq uma string com o nome de um arquivo, abre-o
 * para escrita e coloca no arquivo nomearq o desenho da matriz M com
 * m linhas e n colunas, usando o formato PGM.  O valor max
 * corresponde ao máximo valor de um tom de cinza e deve ser este o
 * valor a ser escrito no arquivo PGM na linha correspondente.  A
 * função deve retornar $0$ se não houver erro algum e $1$ caso algum
 * erro tenha sido encontrado por conta da manipulação do arquivo.
 *
 */

int EscreveDesenho(char nomearq[FNMAX], cinza M[MAX][MAX], int m, int n, int max) {
  FILE *arq ;
  int  i, j ;

  arq = fopen(nomearq, "w") ;
  if(arq == NULL) {
    printf("Erro na abertura do arquivo %s\n", nomearq) ;
    return 1 ;
  }

  fprintf(arq, "P2\n") ;
  fprintf(arq, "%d %d\n", n, m) ;
  fprintf(arq, "%d\n", max) ;

  for(i=0; i<m; i++) {
    for(j=0; j<n; j++) {
      fprintf(arq, "%03d ", M[i][j]) ;
    }
    fprintf(arq, "\n") ;
  }

  fclose(arq) ;
  return 0 ;
}

/* Função: int EscreveTexto( char nomearq[FNMAX], char T[MAX2], int k );
 *
 * A string nomearq contém o nome de um arquivo, que deverá receber
 * uma cópia do texto T de k letras.  A função deve retornar $0$ se
 * não houver qualquer erro, e deve retornar $1$ caso algum erro tenha
 * sido encontrado por conta da manipulação do arquivo.
 *
 * Se um caractere lido tiver codigo ASCII negativo, a funcao emitira' uma
 * mensagem de erro.
 *
 */

int EscreveTexto(char nomearq[FNMAX], char T[MAX2], int k) {

  FILE *arq ;
  int  i ;
  char c;

  arq = fopen(nomearq, "w") ;

  if(arq == NULL) {
    printf("Erro na abertura do arquivo %s\n", nomearq) ;
    fclose(arq) ;
    return 1 ;
  }

  i = 0 ;
  while(i<k) {

    c = T[i] ;

    if (c < 0) {
      printf ("Caractere %c desconhecido. Codigo do caractere: %d\n", c, c);
      fclose(arq) ;
      return 1 ;
    }

    fprintf(arq, "%c", c) ;

    i++ ;
  }

  fclose(arq) ;

  return 0 ;
}

int main() {
  cinza D[MAX][MAX];
  int m, n, max;
  char T[MAX2] ;
  int k ;
  char fname[FNMAX] ;
  int erro ;

  /* leitura do arquivo (imagem) de entrada */
  printf("Arquivo que contem o desenho original: ") ;
  scanf("%s", fname) ;
 
  erro = LeDesenho(fname, D, &m, &n, &max) ;
  if(erro) {
    printf(" \nERRO: Operacao abortada devido a erro na leitura\n");
    return 0;
  }

  /* leitura do nome do arquivo (imagem) de saida */
  printf("Gravar desenho marcado em: ") ;
  scanf("%s", fname) ;

  erro = EscreveDesenho(fname, D, m, n, max) ;
  if(erro) {
    printf(" \nERRO: Operacao abortada devido a erro na escrita\n");
    return 0;
  }

  printf("Arquivo que contém a mensagem a ser ocultada: ") ;
  scanf("%s", fname) ;

  erro = LeTexto(fname, T, &k) ;
  if(erro) {
    printf(" \nERRO: Operacao abortada devido a erro na leitura\n");
    return 0;
  }

  printf("Gravar mensagem decodificada em: ") ;
  scanf("%s", fname) ;

  erro = EscreveTexto(fname, T, k) ;
  if(erro) {
    printf(" \nERRO: Operacao abortada devido a erro na escrita\n");
    return 0;
  }

  return 0;
}
