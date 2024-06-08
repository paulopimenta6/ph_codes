#include <stdio.h>
#include <stdlib.h>

int main (){
	char nome[30]="Universidade de Sao Paulo";
	char *ptr_str;
	
	ptr_str=nome;
	
	printf("A string e referenciada: %s \n", ptr_str);
	printf("A string exibida via ponteiro: \n");
	
	while(*ptr_str){
		printf("%c", *ptr_str);
		ptr_str++;
	}
	
	ptr_str=nome;
	
	printf("\n");
	//printf("------------- \n");
	printf("A string total e: %s \n", ptr_str);
	printf("A string total pelo vetor: %s \n", nome);
	return 0;
	
}
