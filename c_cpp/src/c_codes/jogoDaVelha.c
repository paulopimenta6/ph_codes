#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h> 
#define MAX 3 

void inicializa_matriz(char m[][MAX]); //Funcao que cria a matriz do jogo da velha
void escolha_jogador(char* jogador1, char* jogador2); //Escolha de indices e verificacao da matriz
void imprime_matriz(char m[][MAX]);
void faz_jogada(char m[][MAX], char jogada);
void verifica(char m[][MAX], char jogada);

int main(){

	char matrizJogodaVelha[MAX][MAX], jogador1, jogador2;
	
	printf("Jogo da velha \n");
	printf("Escolha um simbolo: X ou O \n");

	printf("Matriz inicial: \n");
	inicializa_matriz(matrizJogodaVelha);
	
	escolha_jogador(&jogador1, &jogador2);

	printf("Jogador1: %c e Jogador2: %c \n", jogador1, jogador2);

	faz_jogada(matrizJogodaVelha, jogador1);
	imprime_matriz(matrizJogodaVelha);

	return 0;

	}

void inicializa_matriz(char m[][MAX]){

		int i, j;

		for(i=0; i<MAX; i++){
			for(j=0; j<MAX; j++){				
				m[i][j]=' ';
				printf("[ %c ]", m[i][j]);				
			}
			printf("\n");
		}
	}

void imprime_matriz(char m[][MAX]){

		int i, j;

		for(i=0; i<MAX; i++){
			for(j=0; j<MAX; j++){
				printf("[ %c ]", m[i][j]);
				}
		printf("\n");
		}

	}

void escolha_jogador(char* jogador1, char* jogador2){
	
	int chave;
	bool resposta;

	do{
		printf("Escolha 1: X ou 2: O \n");
		scanf("%d", &chave);

		if(chave==1 || chave==2){

			resposta=false;
		}
		else{

			resposta=true;
		}


	}while(resposta);

	if(chave==1){
		*jogador1='X';
		*jogador2='O';
	}

	else{
		*jogador1='O';
		*jogador2='X';
	}		

	}

void verifica(char m[][MAX], char jogada){

	int i, j;

	//verificando linha
	//exemplo:
	//m[0][0]==m[0][1]==m[0][2]
	//m[1][0]==m[1][1]==m[1][2]
	//m[2][0]==m[1][2]==m[2][2]
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]

	//verificando coluna 
	//exemplo:
	//m[0][0]==m[1][0]==m[2][0]
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]


	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			if(){
				printf("Linha feita! %c venceu!", jogada);
				break;
			}
			else{
		
				//colocar outros condicionais...
				
			}
		
	}

void faz_jogada(char m[][MAX], char jogada){

	int linha, coluna;

	//Se a pessoa errar uma linha ou uma coluna exatamente tera que preencher exatamente aquilo que ela errou

	do{

		printf("Escolha uma linha: \n");
		scanf("%d", &linha);

	}while(linha<0 || linha>(MAX-1));

	do{	

		printf("Escolha uma coluna: \n");
		scanf("%d", &coluna);

	}while(coluna<0 || coluna>(MAX-1));

	if(m[linha][coluna]==' '){
		m[linha][coluna]=jogada;
		}

	}

	












