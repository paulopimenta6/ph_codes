#include <stdio.h>
#include <stdlib.h>
#define MAX 3

struct veiculos{
	char fabricante[20];
	char modelo[20];
	int ano;
	char cor[10];
	float preco;
};

struct veiculos carro[MAX]; //Coloquei aqui como variavel global

int main(){
	int i;
	i=0;

	while(i<MAX){
		printf("++++++++++++++++++++++++++++++++++++ \n");
		printf("Usuario no: %d \n", i+1);

		printf("Digite o fabricante do carro: \n");
		scanf("%s", carro[i].fabricante);

		printf("Digite o modelo do carro: \n");
		scanf("%s", carro[i].modelo);

		printf("Digite o ano do veiculo: \n");
		scanf("%d", &carro[i].ano);

		printf("Digite a cor do carro: \n");
		scanf("%s", carro[i].cor);

		printf("Digite o preco do carro: \n");
		scanf("%f", &carro[i].preco);
		printf("++++++++++++++++++++++++++++++++++++ \n");
		
		i++;
	}

	for(i=0; i<MAX; i++){
		printf("++++++++++++++++++++++++++++++++++++ \n");
		printf("fabricante: %s \n", carro[i].fabricante);
		printf("Modelo: %s \n", carro[i].modelo);
		printf("Ano: %d \n", carro[i].ano);
		printf("Cor: %s \n", carro[i].cor);
		printf("Valor: %.2f \n", carro[i].preco);
		printf("++++++++++++++++++++++++++++++++++++ \n");
	}

	return 0;
}