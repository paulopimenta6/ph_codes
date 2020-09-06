#include <stdio.h>
#include <stdlib.h>
#define MAX 3

int main(){

	float salario[MAX], soma_salario, soma_filhos, maiorSalario, mediaSalario, mediaNfilhos, porcentagemacima1000;
	int i, n_filhos[MAX], cont1000;

	maiorSalario=0; //Vou arbritar um valor inicial para fazer comparacao
	i=1;
	cont1000=0;
	soma_salario=0;
	soma_filhos=0;

	printf("------Serao 10 perguntas------ \n");
	printf("\n");

	do{

		printf("------Programa Estatistico------ \n");

		///
		printf("pergunta no: %d \n", i);
		printf("Digite o valor do salario: \n");
		scanf("%f", &salario[i]);

		if(salario[i]<0){
			break;
		}

		if(salario[i]>1000){ //verificando aqueles que ganham acima de 1000
			cont1000=cont1000+1;
		}

		printf("Digite o numero de filhos: \n");
		scanf("%d", &n_filhos[i]);

		soma_salario=soma_salario+salario[i];
		soma_filhos=soma_filhos+n_filhos[i];

		//

		if(maiorSalario<salario[i]){ //verificando o maior salario
			maiorSalario=salario[i];
		}

		//

		//printf("indice: %d \n", i);
		i++;


	}while(i<=MAX);

	i=i-1;
	printf("+++++++++++++++++++++++++++ \n");
	mediaSalario=soma_salario/i; //media do total dos salarios
	mediaNfilhos=soma_filhos/i; //media do total do numero de filhos
	porcentagemacima1000=((cont1000*1.0)/i)*100; //porcentagem dos que ganham acima de R$ 1000.00

	printf("Foram %d entrevistados \n", i);
	printf("A media dos salarios e: %.2f \n", mediaSalario);
	printf("A media do numero de filhos e: %.2f \n", mediaNfilhos);
	printf("O maior salario e: %.2f \n", maiorSalario);
	printf("A quantidade de salarios acima de R$ 1000.00 e: %d \n", cont1000);
	printf("A porcentagem dos que ganham acima de R$1000.00 e: %.1f%% \n", porcentagemacima1000);
	printf("+++++++++++++++++++++++++++ \n");
}
