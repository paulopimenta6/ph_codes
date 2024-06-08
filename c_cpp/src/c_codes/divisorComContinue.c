#include <stdio.h>
#include <stdlib.h>

int main(){

	int valor, divisor;

	printf("Digite um valor: \n");
	scanf("%d", &valor);

	while(valor<=0){
		printf("O valor digitado e menor ou igual a 0 \n");
		printf("Digite novamente um valor: \n");
		scanf("%d", &valor);
					}

	for(divisor=valor; divisor>0; divisor--){
		if(valor%divisor==0){
			continue;
							}
		else{
			printf("O valor %d dividido por %d tem quociente %d e resto diferente de 0: %d \n", valor, divisor, valor/divisor, valor%divisor);
			}

											}
	return 0;
			}
