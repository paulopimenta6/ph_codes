#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(){
	
	char min, mai;
	int cont;
	
	for(cont=1; cont<=10; cont++){
			printf("Digite uma letra: ");
			scanf(" %c", &min);                                                                                                                                                                                                                                                                                                                                                                                                                  
			mai=toupper(min);
			printf("A letra maiuscula e: %c", mai);
			printf("\n");			
			}
			
	return 0;
	
	}
