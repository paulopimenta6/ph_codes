//exercicios do livro do professor Renato Soffner de ponteiros

#include <stdio.h>
#include <stdlib.h>

int main(){
	
	char c='T', d='S';
	char *p1=&c; //declarou um ponteiro e o mesmo recebe um endereco de memoria
	char *p2=&d; //declarou um ponteiro e o mesmo recebe um endereco de memoria
	char *p3;
	
	printf("-------------------------------- \n");
	
	printf("char c='T', d='S' \n");
	printf("char *p1=&c \n");
	printf("char *p2=&d \n");
	printf("char *p3 \n");
	
	printf("-------------------------------- \n");
	
	printf("O valor do ponteiro p1 e: %c \n", *p1);
	printf("O valor do ponteiro apontado por p1 em c e %p \n", p1);
	printf("O valor do ponteiro p1 e: %p \n", &p1);
	
	printf("-------------------------------- \n");
	
	printf("O valor do ponteiro p2 e: %c \n", *p2);
	printf("O valor do ponteiro apontando por p2 em d e %p \n", p2);
	printf("O valor do ponteiro p2 e: %p \n", &p2);

	printf("-------------------------------- \n");
	
	printf("Fazendo p3=&d: \n");
	printf("p3=&d");
	p3=&d;
	printf("O valor do ponteiro p3 e: %c \n", *p3);
	printf("O valor do ponteiro apontado por p3 em d e %p \n", p3);
	printf("O valor do ponteiro p3 e: %p \n", &p3);
	
	printf("-------------------------------- \n");

	p3=p1;
	printf("p3=p1 \n");
	printf("O valor do ponteiro p3 e: %c \n", *p3);
	printf("O valor do ponteiro apontado por p3 em d e %p \n", p3);
	printf("O valor do ponteiro p3 e: %p \n", &p3);

	printf("-------------------------------- \n");

	*p1=*p2;
	printf("*p1=*p2 \n");
	printf("O valor do ponteiro p1 e: %c \n", *p1);
	printf("O valor do ponteiro apontado por p1 e %p \n", p1);
	printf("O valor do ponteiro p1 e: %p \n", &p1);

	printf("-------------------------------- \n");

	printf("O novo valor do ponteiro p3 e: %c \n", *p3);
	printf("O novo valor do ponteiro apontado por p3 em d e %p \n", p3);
	printf("O novo valor do ponteiro p3 e: %p \n", &p3);

	printf("-------------------------------- \n");
	
	printf("%c \n", c);
	printf("%c \n", d);

	return 0;
	
}
