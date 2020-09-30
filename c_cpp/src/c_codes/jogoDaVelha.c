#include <stdio.h>
#include <stdlib.h>
#define MAX 3 

void inicializa_matriz(char m[][MAX]); //Funcao que cria a matriz do jogo da velha
void escolha_de_jogada(char m[][MAX]); //Escolha de indices e verificacao da matriz

int main(){

	char matrizJogodaVelha[MAX][MAX];
	
	printf("Jogo da velha \n");
	printf("Escolha um simbolo: X ou O \n");

	printf("Matriz inicial: \n");

	inicializa_matriz(matrizJogodaVelha);
	
	return 0;

	}

void inicializa_matriz(char m[][MAX]){

		int i, j;

		for(i=0; i<MAX; i++){
			for(j=0; j<MAX; j++){
				m[i][j]='\0';
				printf(" %c |", m[i][j]);
			}
			printf("\n");
		}
	}

void escolha_de_jogada(char m[][MAX]){

	int i, j;
	char jogada;

	printf("Deseja ser jofador 1: X ou jogador 2: O? \n");


	while(true){
		printf("Escolha um valor de linha \n");
		scanf("%d", &i);

		if(i>=0 || i<MAX){
			break;
		}
	}

	while(true){
		printf("Escolha um valor de coluna \n");
		scanf("%d", &j);
		
		if(j>=0 || j<MAX){
			break;
		}
	}	

	








