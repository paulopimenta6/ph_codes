#include <stdio.h>
#include <stdlib.h>
#define pi 3.14

int main(){

	float raio, area;
	char ans;

	do{

		printf("Digite um valor para o raio: \n");
		scanf("%f", &raio);

		area=pi*raio*raio;

		printf("A area deste circulo e: %.2f", area);

		printf("\n");
		printf("Deseja continuar? s/S ou n/N");
		scanf(" %c", &ans);

	}while(ans=='s' || ans=='S');

	return 0;
}
