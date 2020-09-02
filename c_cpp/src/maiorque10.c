#include <stdlib.h>
#include <stdio.h>

int main(){
	
	int valor;
	
	printf("Digite um valor: \n");
	scanf("%d", &valor);
	
	if(valor==10){
		printf("O valor %d é igual a 10", valor);
	}
	if(valor>10){
		printf("O valor é maior que 10");
	}
	if(valor<10){
		printf("Menor que 10");
	}
	
	return 0;
	
}
		
