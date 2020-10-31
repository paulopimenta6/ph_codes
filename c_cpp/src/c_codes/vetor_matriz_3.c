#include <stdio.h>
#include <stdlib.h>

char frase[20]="Teste";

int main(){

	char frase[50];
	int i;
	
	for(i=0; i<26; i++){
		frase[i]='A'+ i; //incrementa a posicao
		}
	
	frase[i]='\0';

	printf("A string contem %s \n", frase);

	return 0;

	} 
