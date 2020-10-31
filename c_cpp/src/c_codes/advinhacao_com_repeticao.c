#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

	int iSecret, iGuess;
	
	//inicializando uma semente aleatoria usando a funcao time
	//A funcao time recebe o argumento NULL
	//A funcao time gera uma semente de numero aleatorio
	
	srand(time(NULL));
	
	//gerando um numero aleatorio
	
	iSecret=rand()%10+1; //rand gera um numero aleatorio entre 0 a 10.
			     //Lembrando que foi somando 1, pois rand()%10 geraria de 0 a 9
			     
	do{
		printf("Advinhe o numero de 1 a 10: \n");
		scanf("%d", &iGuess);
		
		if(iSecret<iGuess){
			printf("O numero é menor! \n");
				}
		else{
			if(iSecret>iGuess){
				printf("O numero é maior! \n");
					}
			}		
	}while(iSecret!=iGuess);
	
	printf("Parabens!!! Você acertou!!! \n");
	printf("O valor de %d é o correto! \n", iSecret);
	
	return 0;
	
	}
