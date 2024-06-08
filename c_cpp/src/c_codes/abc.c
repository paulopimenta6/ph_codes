#include <stdio.h>
#include <stdlib.h>

int main(){

	int a, b, c, menor, maior, soma;

	soma=0;

	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n");
	printf("++++Programa de divisibilidade                                                              + \n");
	printf("++++Serao requeridos 3 valores \"a\", \"b\" e \"c\"                                         + \n");
	printf("++++\"a\" deve ser maior que 1                                                              + \n");
	printf("++++Os valores entre \"b\" e \"c\" serão somados e verificados se sao divisiveis por \"a\"  + \n");
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n");
	printf("\n");

	printf("Digite um valor >0 para \"a\" \n");
	scanf("%d", &a);
	while(a<0){
		printf("Voces digitou um valor <0 para \"a\" \n");
		printf("Digite novamente um valor para \"a\" \n");
		scanf("%d", &a);
	}

	printf("Digite um valor para \"b\" \n");
	scanf("%d", &b);
	printf("Digite um valor para \"c\" \n");
	scanf("%d", &c);

	//transformando b e c em valores positivos caso valores negativos sejam digitados
	b=abs(b);
	c=abs(c);

	if(b>c){
		menor=c;
		maior=b;
	}
	else{
		menor=b;
		maior=c;
	}

	while(menor<=maior){
		if(menor%a==0){
			soma=soma+menor;
		}
		menor=menor+1;
	}

	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n");
	printf("O valor da soma dos valores entre %d e %d divisiveis por %d sao %d \n", b, c, a, soma);
    printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n");

	return 0;

	}
