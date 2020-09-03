#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){

	char senha[20]; //vetor de caracteres para receber a senha
	int cont, comparacao;
	
	char senhaUsuario[20]="passwd";	
	cont=1;

	printf("+++Bem-vindo ao banco+++ \n");
	
	while(cont<=3){
		
		printf("Esta e a sua %d tentativa \n", cont);
		printf("Digite a senha: ");
		scanf(" %s", senha);
		
		comparacao=strcmp(senha, senhaUsuario);
		
		if(comparacao==0){
			printf("Senha acertada \n");
			break;
			}
		else{
			printf("Senha errada \n");
			}
		cont++;	
		}
		
	if(comparacao!=0){
		printf("Cartao bloqueado");
		}	
	
	return 0;
	}
