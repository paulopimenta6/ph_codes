#include <stdio.h>
#include <stdlib.h>

int main(){
	int contador;
	contador=0;

	while(contador<5){
		printf("Isso é uma mensagem de repetição! Está é a %d \n", contador);
		contador=contador+1;
	}
	return 0;
}

