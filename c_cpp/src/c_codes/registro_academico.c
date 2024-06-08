#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 100

void cria_registro(char nome[], float nota[], int RA[], int n); //prototipo de funcao de criacao de registro

int main(){

	char nome[MAX];
	float nota[MAX];
	int i, RA[MAX];
	
	printf("+++Programa de registro de Academico+++ \n");
	printf("Digite a quantidade de registro a serem cadastrados: \n");
	scanf("%d", &i);
	
	cria_registro(nome, nota, RA, i);
	
	return 0;
	
}

void cria_registro(char nome[], float nota[], int RA[], int n){

	int i, j;
	float soma, media_notas;	 	

	printf("Inicio de construcao de registro academico: \n");
		
	for(i=0; i<n; i++){
		//Coletando nome do aluno
		printf("Digite o nome do aluno: \n");
		scanf(" %s", nome);
		//Coletando 3 notas do aluno
		soma=0;
		for(j=0; j<n; j++){
			printf("Digite a %d[a] nota do aluno: \n", j+1);
			scanf("%f", &nota[j]);
			printf("Nota: %.2f \n", nota[j]);
			soma=soma+nota[j];
			printf("%.2f \n", soma);
		}
		//Coletando o RA do aluno
		printf("Digite o Registro Academico do aluno: \n");
		scanf("%d", &RA[i]);
				
		//Fazendo estatisticas basicas
		media_notas=soma/n;
		//Imprimindo os resultados				
		printf("O nome e: %s \n", nome);
		printf("A media de notas e: %.2f \n", media_notas);
		printf("O RA(Registro Academico) e: %d \n", RA[i]);		
	}	
		
}		
