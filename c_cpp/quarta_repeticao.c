#include <stdio.h>
#include <stdlib.h>

int main(){
	int x, cont, total;
	char letra;

	cont=0;
        total=0;
	letra='i';

	printf("Programa de repetição \n");

        while(letra!='q'){
		printf("Digite um numero: \n");
		scanf("%d", &x);
                printf("Deseja continuar? Digite \"q\" para continuar: \n");
		fflush(stdin);
		scanf("%c", &letra);
		cont=cont+1;
	        total=total+x;	
	}

	printf("Parando...\n");
	printf("Repetições=%d e total=%d \n", cont, total);
        printf("O caracter de loop é: %c \n", letra);
	return 0;
}
