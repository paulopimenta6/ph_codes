#include <stdio.h>
#include <stdlib.h>

int main(){
	
	int contador=10, *temp, soma=0;
	
	printf("---------------- \n");
	printf("contador=%d \n", contador);
	//printf("temp=%d \n", *temp);
	printf("soma=%d \n", soma);
	//printf("endereco de mem: %p \n", temp);
	printf("---------------- \n");
	temp=&contador;
	printf("contador=%d \n", contador);
	printf("temp=%d \n", *temp);
	printf("soma=%d \n", soma);
	printf("endereco de mem: %p \n", temp);
	printf("---------------- \n");
	*temp=20;
	printf("contador=%d \n", contador);
	printf("temp=%d \n", *temp);
	printf("soma=%d \n", soma);
	printf("endereco de mem: %p \n", temp);
	printf("---------------- \n");
	temp=&soma;
	printf("contador=%d \n", contador);
	printf("temp=%d \n", *temp);
	printf("soma=%d \n", soma);
	printf("endereco de mem: %p \n", temp);
	printf("---------------- \n");
	*temp=contador;
	printf("contador=%d \n", contador);
	printf("temp=%d \n", *temp);
	printf("soma=%d \n", soma);
	printf("endereco de mem: %p \n", temp);
	printf("---------------- \n");
	
	printf("contador=%d, *temp=%d, soma=%d \n", contador, *temp, soma);
	
	return 0;
	
}
