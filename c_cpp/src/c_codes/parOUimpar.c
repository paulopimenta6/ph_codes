#include <stdlib.h>
#include <stdio.h>
#define MAX 10

int main(){

	int vetor[MAX], cont, contPar, contImpar;

    cont=0;
    contPar=0;
    contImpar=0;

	while(cont<10){

		printf("Digite o valor de indice [%d]: ", cont+1);
		scanf("%d", &vetor[cont]);

		if(vetor[cont]%2==0){
			contPar++;
		}
		else{
			contImpar++;
		}

		cont++;
	}

	printf("Ha %d numeros pares", contPar);
	printf("\nHa %d numeros impares", contImpar);

	return 0;
}
