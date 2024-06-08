#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h> 
#define MAX 3 

void inicializa_matriz(char m[][MAX]); //funcao que cria a matriz do jogo da velha
void escolha_jogador(char* jogador1, char* jogador2); //escolha de indices e verificacao da matriz
void imprime_matriz(char m[][MAX]); //imprime a matriz inicializada e atualizada
void faz_jogada(char m[][MAX], char jogada); //usuario joga X ou O
int verificaLinha(char m[][MAX], char jogada); //verifica linha
int verificaColuna(char m[][MAX], char jogada); //verifica coluna
int verificaDiagonalPrincipal(char m[][MAX], char jogada); //verifica diagonal principal
int verificaDiagonalSecundaria(char m[][MAX], char jogada); //verifica diagonal secundaria
int verificaEmpate(char m[][MAX]); //verifica se houve empate 

int main(){

	char matrizJogodaVelha[MAX][MAX], jogador1, jogador2, jogada;
	int i, ansLin, ansCol, ansDiaP, ansDiaS, ansEmp;	

	i=0;

	printf("Jogo da velha \n");
	printf("Matriz inicial: \n");
	
	inicializa_matriz(matrizJogodaVelha);	
	escolha_jogador(&jogador1, &jogador2);
	
	while(true){
		if(i%2==0){
			jogada=jogador1;
			faz_jogada(matrizJogodaVelha, jogada);
		}			
		else{
			jogada=jogador2;
			faz_jogada(matrizJogodaVelha, jogada);
		}
		
		imprime_matriz(matrizJogodaVelha);
		
		ansLin=verificaLinha(matrizJogodaVelha, jogada);
		if(ansLin==-1){
			break;
		}

		ansCol=verificaColuna(matrizJogodaVelha, jogada);
		if(ansCol==-1){
			break;
		}

		//criar funcao que analisa se ambas as diagonais foram completadas
		ansDiaP=verificaDiagonalPrincipal(matrizJogodaVelha, jogada);
		ansDiaS=verificaDiagonalSecundaria(matrizJogodaVelha, jogada);
		if(ansDiaP==-1 && ansDiaS==-1){
			break;	
		}

		ansDiaP=verificaDiagonalPrincipal(matrizJogodaVelha, jogada);
		if(ansDiaP==-1){
			break;
		}

		ansDiaS=verificaDiagonalSecundaria(matrizJogodaVelha, jogada);
		if(ansDiaS==-1){
			break;
		}

		ansEmp=verificaEmpate(matrizJogodaVelha);	
		if(ansEmp==-1){
			break;
		}

		i=i+1;
	}		

	return 0;
	
}

void inicializa_matriz(char m[][MAX]){

		int i, j;

		for(i=0; i<MAX; i++){
			for(j=0; j<MAX; j++){				
				m[i][j]=' ';
				printf("[ %cm[%d][%d] ]", m[i][j], i, j);				
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

int verificaLinha(char m[][MAX], char jogada){

	int i, j, cont;

	cont=0;	
	
	//verificando linha
	//exemplo:
	//m[0][0]==m[0][1]==m[0][2]
	//m[1][0]==m[1][1]==m[1][2]
	//m[2][0]==m[1][2]==m[2][2]
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]

	//verificando linha 
	//exemplo:
	//m[0][0]==m[1][0]==m[2][0]
	//modelo:
	//m[i][j]==X; cont=1
	//m[i][j+1]==X; cont=2
	//m[i][j+2]==X; cont=3


	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			if(m[i][j]==jogada){
				cont=cont+1;
				if(cont==3){
					printf("Linha feita! %c venceu! \n", jogada);
					return -1;
					break;
				}
			}
		}
		cont=0;
	}
	if(cont==3){
		return -1;
	}
	else{
		return 1;
	}			
}

int verificaColuna(char m[][MAX], char jogada){

	int i, j, cont;

	cont=0;	
	
	//verificando coluna
	//exemplo:
	//m[0][0]==m[1][0]==m[2][0]
	//m[1][0]==m[1][1]==m[2][1]
	//m[2][0]==m[2][1]==m[2][2]
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]

	//verificando linha 
	//exemplo:
	//m[0][0]==m[1][0]==m[2][0]
	//modelo:
	//m[i][j]==X; cont=1
	//m[i+1][j]==X; cont=2
	//m[i+2][j]==X; cont=3


	for(j=0; j<MAX; j++){
		for(i=0; i<MAX; i++){
			if(m[i][j]==jogada){
				cont=cont+1;
				if(cont==3){
					printf("Coluna feita! %c venceu! \n", jogada);					
					break;
				}
			}
		}
		cont=0;
	}
	if(cont==3){
		return -1;
	}
	else{
		return 1;
	}
}

int verificaDiagonalPrincipal(char m[][MAX], char jogada){

	int j, cont;

	cont=0;	
	
	//verificando coluna
	//exemplo:
	//m[0][0]==m[1][1]==m[2][2]
	//m[0][2]==m[1][1]==m[2][0]	
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]

	//verificando diagonal 
	//exemplo:
	//m[0][0]==jogada; cont=1
	//m[1][1]==jogada; cont=2
	//m[2][2]==jogada; cont=3

	for(j=0; j<MAX; j++){
		if(m[j][j]==jogada){
			cont=cont+1;
			if(cont==3){
				printf("Diagonal principal feita! %c venceu! \n", jogada);
				break;
			}
		}
	}	
	if(cont==3){
		return -1;
	}
	else{
		return 1;
	}
}

int verificaDiagonalSecundaria(char m[][MAX], char jogada){

	int i, j, cont;

	cont=0;	
	
	//verificando coluna
	//exemplo:
	//m[0][0]==m[1][1]==m[2][2]
	//m[0][2]==m[1][1]==m[2][0]	
	//modelo:
	//m[i][j]==m[i][i+1]==m[i][j+2]

	//verificando diagonal 
	//exemplo:
	//m[0][2]==jogada; cont=1
	//m[1][1]==jogada; cont=2
	//m[2][0]==jogada; cont=3

	for(j=(MAX-1), i=0; j>=0 && i<MAX; j--, i++){
		if(m[i][j]==jogada){
			cont=cont+1;
			if(cont==3){
				printf("Diagonal secundaria feita! %c venceu! \n", jogada);
				break;
			}
		}
	}
	if(cont==3){
		return -1;
	}
	else{
		return 1;
	}
}

int verificaEmpate(char m[][MAX]){

	int i, j, cont;
	cont=0;

	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			if(m[i][j]!=' '){
				cont=cont+1;
			}
		}
	}

	if(cont==MAX*MAX){
		printf("Ocorreu um empate \n");
		return -1;
	}
	else{
		return 1;
	}
}		 

void faz_jogada(char m[][MAX], char jogada){

	int linha, coluna;
	bool chave;

	chave=true;	

	while(chave){

		printf("Escolha uma linha: \n");
		scanf("%d", &linha);
			while(linha<0 || linha>(MAX-1)){
				printf("Linha fora dos limites \n");
				printf("Escolha uma linha: \n");
				scanf("%d", &linha);
			}

		printf("Escolha uma coluna: \n");
		scanf("%d", &coluna);		
			while(coluna<0 || coluna>(MAX-1)){
				printf("Coluna fora dos limites \n");
				printf("Escolha uma coluna: \n");
				scanf("%d", &coluna);
			}

		if(m[linha][coluna]==' '){
			m[linha][coluna]=jogada;
			chave=false;
		}
		else{
			printf("Local ja usado. Escolha outro: \n");
			chave=true;	
		}
	}
}
