#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define MAX 100

int main (){

	int cont, i, tamanho_pela_funcao;
	char palavra[MAX];

	printf("Programa de transformacao de caracteres de maiusculo em minusculo \n");
	printf("Digite uma palavra: \n");
	scanf(" %s", palavra);
	
	tamanho_pela_funcao=strlen(palavra);
	
	for(i=0; palavra[i]!='\0'; i++){
		palavra[i]=toupper(palavra[i]);
		cont=cont+1;		
	}
	
	printf("A quantidade de letras da palavra e: %d \n", cont);
	printf("A quantidade de letras pela funcao e: %d \n", tamanho_pela_funcao);
	printf("A palavra transformada em maiuscula e: %s \n", palavra);
	
	return 0;
	
}
