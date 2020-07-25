#include <stdlib.h>
#include <stdio.h>

int main(){

	int contador;
	char letra;

	contador=0;
	letra='i'; /*Sera iniciada com \'i\' para dar inicio ao loop*/
        
        while(letra!='q'){
		printf("Esta é uma mensagem de repetição : %d\n", contador);
		printf("\n");
		printf("Deseja continuar? \"q\" \n");
                scanf("%c", &letra);
                printf("\n");		

		contador=contador+1;
	}

	printf("Parando... \n");

	return 0;

}
