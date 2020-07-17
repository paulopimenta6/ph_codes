#include <stdlib.h>
#include <stdio.h>

int main(){
	
	char casa, refeicao, bebida, compartilho;
	char interesse[30];
	int tipo;
	
	do{
		printf("Alguem em casa? \n");
		scanf("%c", &casa);
		fflush(stdin);
		
		if(casa=='s'){
			Break;
		}
		else{
			printf("Deixe mensagem \n");
			printf("Aguarde pelo ") 
