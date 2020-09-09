#include <stdio.h>
#include <stdlib.h>

//algoritmo com funcao

void inicializa(int s[10]){

	int i;
	
	for(i=0; i<10; i++){
		s[i]=0; //inicializando o vetor
		}

	}

void mostra(int s[10]){

	int i;

	printf("O vator ficou assim: \n");

	for(i=0; i<10; i++){
		printf("| %d ", s[i]);
		}
	printf("|");
	printf("\n\n");

	}

int main(){

	int v[10];

	inicializa(v);
	mostra(v);

	return 0;

	}
