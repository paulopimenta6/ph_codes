#include <stdio.h>
#include <stdlib.h>

struct funcionario{
	char nome[30];
	float salario;
	int registro;
};

struct funcionario colaborador;

int main(){
	
	printf("Digite o seu n de registro: \n");
	scanf("%d", &colaborador.registro);
	
	printf("Digite seu nome: \n");
	scanf("%s", colaborador.nome);
	
	printf("Digite o valor do salario: \n");
	scanf("%f", &colaborador.salario);
	
	printf("----------------------------------------- \n");
	printf("Registro: %d \n", colaborador.registro);
	printf("Nome: %s \n", colaborador.nome);
	printf("Salario: %.2f \n", colaborador.salario);
	
	return 0;
	
}