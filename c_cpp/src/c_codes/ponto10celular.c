//algoritmo de vetor de strings com ponteiros

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	
	char *cores[]={"amarelo", "azul", "vermelho", "branco", "preto", "verde", "rosa", 0}; 
	char **aponta_cores;	
//	int i;
	
	aponta_cores=cores;
	
	while(*aponta_cores){
		printf("Cor: %s \n", *aponta_cores);
		printf("ha %ld letras \n", strlen(*aponta_cores));
		aponta_cores++;
	}
	
//	for(i=0; *(aponta_cores+i); i++){
//		printf("%s \n", *(aponta_cores+i));
//	}	

	return 0;
	
}
