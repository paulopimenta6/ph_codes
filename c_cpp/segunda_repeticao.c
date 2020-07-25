#include <stdio.h>
#include <stdlib.h>

/*Este codigo simples dara uma contagem regressiva*/

int main(){
	int contador;
	contador=10;

	while(contador>=0){
			printf("Valor: %d \n", contador);
			contador=contador-1;
	}
	printf("-------------- \n");
	printf("Já esta finalizado a contagem regressiva! \n");

	return 0;
	}
