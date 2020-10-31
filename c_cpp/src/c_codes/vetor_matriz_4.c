#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){

	char string[50];
	char frase[]="A volta ao mundo em 80 dias";
	int tamanho, i;	

	printf("Digite um conjunto de caracteres: \n");
	scanf(" %s", string);
	printf("%s \n", string);

	for(i=0; string[i]; i++){
		printf("%c", string[i]);
		}
	
	printf("\n");

	printf("O numero de caracteres e %d \n", i);
	tamanho=strlen(frase);
	printf("%s tem %d caracteres \n", frase, tamanho);

	return 0;

	}
