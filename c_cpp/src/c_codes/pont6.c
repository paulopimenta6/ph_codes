//Manipulando estruturas (struct) com ponteiros
#include <stdio.h>
#include <stdlib.h>

struct pessoa{
	char nome[50];
	int idade;
};

void alteracao(struct pessoa *acesso); //prototipo da funcao de alteracao de idade na struct

int main(){
	
	struct pessoa acesso;
	
	printf("Entre com nome: \n");
	scanf(" %s", acesso.nome);
	printf("Entre com a idade: \n");
	scanf("%d", &acesso.idade);
	
	printf("----------------\n");
	printf("Nome: %s \n", acesso.nome);
	printf("Idade: %d \n", acesso.idade);
	
	alteracao(&acesso); //Mudando a idade...
	
	printf("----------------\n");
	printf("dados apos mudanca: \n");
	printf("Nome: %s \n", acesso.nome);
	printf("Idade: %d \n", acesso.idade);	
	
	return 0;
	
}

void alteracao(struct pessoa *acesso){
	acesso->idade=acesso->idade+20; //ponteiros com struct devem usar -> ao invés do identificador . (ponto)
}
