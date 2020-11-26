//codigo de ponteiro de ponteiros

#include <stdlib.h>
#include <stdio.h>

int main(){
	
	int x, *p, **q;
	
	x=10;
	p=&x;
	q=&p; //ponteiro de ponteiro aqui e feito
	
	printf("-------\n");
	
	printf("O valor atribuido a x=%d \n", x);
	printf("O valor de x acessado pelo ponteiro unico p e: %d \n", *p);
	printf("O valor de x acessado pelo ponteiro duplo q e: %d \n", **q);
		
	printf("-------\n");
	
	printf("O valor do endereco de memoria de x: %p \n", &x);
	printf("O valor do endereco de memoria apontado por p e: %p \n", p);
	printf("O valor do endereco de memoria apontado por q (em p) e: %p \n", q);
	printf("O valor do endereco de memoria apontado por q (em x) e: %p \n", *q);
	
	printf("-------\n");
	
	printf("O valor do endereco de memoria de p e: %p \n", &p);
	printf("O valor do endereco de memoria de q e: %p \n", &q);
	
	return 0;
	
}
