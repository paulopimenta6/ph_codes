//algoritmo de vetor de strings com ponteiros

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	
	char *cores[]={"amarelo", "azul", "vermelho", "branco", "preto", "verde", "rosa", 0}; 
	char **aponta_cores;
	
	aponta_cores=cores;
	
	while(*aponta_cores){
		printf("Cor: %s \n", *aponta_cores); //em arquitetura ARM havera um item a mais impresso ao contrario de outras arquiteturas	
		aponta_cores++;
	}	

	printf("-----------\n");
	
	char s[]="A vonta ao mundo em 80 dias";
	char *ptr=s;
	
	printf("%s \n", s);
	printf("Imprimindo o primeiro elemento pelo vetor - s[0]: %c \n", s[0]);
	printf("Imprimindo o primeiro elemento pelo ponteiro - *(ptr): %c \n", *(ptr));
	printf("Imprimindo o primeiro elemento pelo ponteiro - *(s): %c \n", *(s));

	printf("-----------\n");

	printf("%s \n", s);
	printf("%s \n", ptr);	
	
	printf("-----------\n");
	
	while(*ptr){
		printf("%c", *ptr);			
		ptr++;
	}

	printf("\n");
	printf("-----------\n");
	
	ptr=s;
	int i=0;
	
	while(*ptr){
		printf("O endereco de memoria apontado por ptr em s %p \n", ptr);	
		printf("O endereco de memoria de s: %p \n", &s[i]);
		ptr++;
		i++;			
	}
	return 0;
	
}
