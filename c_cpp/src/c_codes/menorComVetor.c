#include <stdio.h>
#include <stdlib.h>

int main(){

		int vetor[5], cont, i;
		cont=0;

		for(i=0; i<5; i++){
			printf("Digite um valor: \n");
			scanf("%d", &vetor[i]);

			if(vetor[i]<0){
				cont=cont+1;
						}
						}

		printf("Quantidade de vetores negativos: %d \n", cont);
		printf("Vetor negativo:");
		i=0;
		while(i<5){
			if(vetor[i]<0){
				printf(" %d |", vetor[i]);
						}
			i=i+1;
				}

		}
