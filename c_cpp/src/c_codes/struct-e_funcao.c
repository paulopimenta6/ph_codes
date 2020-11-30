#include <stdio.h>
#include <stdlib.h>
#define MAX 10

struct catalogo{
	char nome[100];
	char email[30];
	int telefone;
};

struct catalogo agenda;

void cadastro();
void exibe_cadastro();

int main(){

	char ans;

do{
	printf("++++++++++++++++++++++++++++ \n");
	printf("cadastro de usuarios \n");
	cadastro();
	exibe_cadastro();
	printf("Deseja continuar? s/S ou n/N \n");
	scanf(" %c", &ans);
}while(ans!='n' && ans!='N');

return 0;

}

void cadastro(){

	printf("Digite o nome: \n");
	scanf(" %s", agenda.nome);

	printf("Digite o email: \n");
	scanf(" %s", agenda.email);

	printf("Digite o telefone: \n");
	scanf("%d", &agenda.telefone);
	
	exibe_cadastro(agenda);
}

void exibe_cadastro(){
	
	printf("O nome do usuario: %s \n", agenda.nome);	
	printf("O email do usuario: %s \n", agenda.email);
	printf("O telefone do usuario: %d \n", agenda.telefone);

}