#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	int x, cont, total;
	char letra;

	cont=0;
	total=0;

	do{
		printf("Digite um numero: \n");
		scanf("%d", &x);

		cont++;
		total=total+x;

		printf("Digite uma letra: \n");
                scanf(" %c", &letra);

	}while(letra!='q');

	printf("Parando... \n");
	printf("Repeticoes=%d e total=%d \n", cont, total);

	return 0;

}
