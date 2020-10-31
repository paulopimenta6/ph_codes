#include <stdio.h>
#include <stdlib.h>

int main(){

	int x, L, soma, aux;

	printf("Digite um valor maximo da sequencia de Fibonacci \n");
	scanf("%d", &x);

	aux=0;
	L=1;	
	soma=aux+L;

	printf("%d ", soma);

	while(soma<x){
		printf("%d ", soma);
		aux=L;		
		L=soma;		
		soma=L+aux;
		}

	return 0;

}
