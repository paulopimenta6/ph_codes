#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	char *dia[]={"domingo", "segunda-feira", "terça-feira", "quarta-feira", "quinta-feira", "sexta-feira", "sabado", 0};
	char **ptr_dia;
		
	ptr_dia=dia;
	
	while(*ptr_dia){
		printf("dia da semana: %s \n", *ptr_dia);
		ptr_dia++;
	} 

	printf("---------------\n");

	return 0;
}
