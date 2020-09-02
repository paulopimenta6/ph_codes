#include <stdio.h>
#include <stdlib.h>

int main(){

	int a;

	a=0;

	printf("Gerando uma tabela ASCII... \n\n");

	do{
		printf("(%d, %c) \n", a,a); //imprimindo os caracteres ASCII
		a=a+1;
	}while(a<=255); //Lembrando que a tabela ASCII vai de 0 a 255

	return 0;

}	
