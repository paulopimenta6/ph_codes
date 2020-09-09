#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

	int i, numerosMegaSena;
	i=0;

	srand(time(NULL));

	printf("Gerando aleatoriamente os numeros da Mega Sena");
	printf("\n");
	printf("Os valores sao: ");

	while(i<=6){
		numerosMegaSena=1+(rand()%60);
		printf("%d ", numerosMegaSena);
		i++;
	}

	return 0;

}
