#include <stdio.h>
#include <stdlib.h>

int main(){
	
	int x, *p;
	
	x=8;
	p=&x;
	
	printf("O valor de x e: %d \n", x);
	printf("O valor de x acessado pelo ponteiro e: %d \n", *p); //exibindo o valor de x apotando por p
	printf("O valor do ponteiro p e: %p \n", p); //%p e o identificador de ponteiro
	
	return 0;
	
}
	 
