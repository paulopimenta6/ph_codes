//algoritmo de vetor de strings com ponteiros

#include <stdio.h>
#include <stdlib.h>

int main(){
	
	char *cores[]={"amarelo", "azul", "vermelho", "branco", "preto", "verde", "rosa"}, **aponta_cores;	
	
	aponta_cores=cores;
	
	while(*aponta_cores){
		printf("Cor: %s \n", *aponta_cores);
		aponta_cores++;
	}
	
	return 0;
	
}
