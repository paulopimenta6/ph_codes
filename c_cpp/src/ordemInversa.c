#include <stdio.h>
#include <stdlib.h>
#define MAX 3

int main(){

	int i, vetor[MAX];

	printf("+++Serao pedidos 3 valores+++ \n");

	for(i=0; i<MAX; i++){
		printf("Digite um valor [%d]: \n", i+1);
		scanf("%d", &vetor[i]);
	}

	printf("os valores invertidos sao: " );
	for(i=2; i>=0; i--){
		printf("%d \t", vetor[i]);
	}

	return 0;

}
