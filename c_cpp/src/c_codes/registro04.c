#include <stdio.h>
#include <stdlib.h>

struct pessoa{
	char nome[30];
	char sobrenome[30];
	int idade;
	long int telefone;
};

void cria_cadastro();
void leitura_cadastro(struct pessoa *ptr);
void exibe_cadastro(struct pessoa *ptr);

int main(){
	char ans;

	do{
		cria_cadastro();

		printf("Deseja continuar? s/S n/N \n");
		scanf(" %c", &ans);
	}while(ans!='n' && ans!='N');
	
	printf("Saindo do programa \n");
	printf("Obrigado por usar este terminal! \n");

	return 0;
}

void cria_cadastro(){
	
	struct pessoa p;

	leitura_cadastro(&p);
	
}

void leitura_cadastro(struct pessoa *ptr){

	printf("Digite o nome do usuario: \n");
	scanf(" %s", (*ptr).nome);

	printf("Digite o sobrenome do usuario: \n");
	scanf(" %s", (*ptr).sobrenome);

	printf("Digite a sua idade: \n");
	scanf("%d", &(*ptr).idade);

	printf("Digite o seu numero de telefone: \n");
	scanf("%ld", &(*ptr).telefone);

	exibe_cadastro(&(*ptr));

}

void exibe_cadastro(struct pessoa *ptr){

	printf("O nome e: %s \n", (*ptr).nome);
	printf("O sobrenome e: %s \n", (*ptr).sobrenome);
	printf("A idade e: %d \n", (*ptr).idade);
	printf("O telefone e: %ld \n", (*ptr).telefone);
}
