#include <stdio.h>
#include <stdlib.h>

int main(){
	
	char *cor[]={"azul", "branco", "vermelho"};
	char nome[]="Universidade de Sao Paulo";
	char *ptr1, **ptr2;
	
	ptr2=cor;
	ptr1=nome;
	
	while(*ptr2){
		printf("%s \n", *ptr2);
		ptr2++;
	}
	
	printf("usp: %s \n", ptr1);
	
	return 0;
	
}