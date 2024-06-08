#include <stdlib.h>
#include <stdio.h>

int main(){
	
	int valor, *pont;
	
	valor=8;
	pont=&valor;
	
	printf("O valor de x e: %d \n", valor);
	printf("O endereco de x e: %p \n", &valor); 
	printf("O valor do ponteiro pont apontado em x e: %p \n", pont);
	printf("O endereço do ponteiro pont e: %p \n", &pont);
	printf("O valor de x acessado pelo ponteiro pont e: %d \n", *pont);
	
	return 0;
	
}	
