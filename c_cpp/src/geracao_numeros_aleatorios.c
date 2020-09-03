#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int main(){

	int i;
	
	srand(time(NULL)); //gerando numeros aleatorios com a funcao srand()
			   //Gerando numeros aleatorios a partir do horario do mini pc	  
	
	printf("Valores de Rand \n");
	for(i=0; i<100; i++){			
			printf("%d \n", rand()%100);
			}
			
	return 0;
	
	}
