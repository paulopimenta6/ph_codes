//alocacao de memoria dinamicamente
#include <stdio.h>
#include <stdlib.h>

int main(){
	
	int *p;
	p=(int*)malloc(sizeof(int));	
	
	if(!p){
		printf("Memoria insuficiente \n");
		exit(1);
	}
	else{
		printf("Memoria alocada com sucesso! \n");
	}
	
	free(p);
	
	return 0;
	
}
	
