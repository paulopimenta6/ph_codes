#include <stdlib.h>
#include <stdio.h>

int main(){

	int a=50;

	printf("Gerando tabela ASCII: \n");

	do{
		printf("(%d, %c) \n", a, a);
		a++;
	}while(a<=75);

	return 0;

}
