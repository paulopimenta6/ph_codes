#include <stdio.h>
#include <stdlib.h>

int main(){
	
	float s, v;
	int op;
	
	s=1000.00;
	
	do{
		printf("+++++++++++++++++ \n");
		printf("+ Deposito - 1 \n");
		printf("+ Saque - 2 \n");
		printf("+ Saldo - 3 \n");
		printf("+ Sair - 4 \n");
		printf("+ Opcao? ");
		scanf("%d", &op);
		printf("+++++++++++++++++ \n");		
		
		switch(op){
			
			case 1:
				printf("Valor depositado: \n");
				scanf("%f", &v);
				s=s+v;
				break;				
			case 2:
				printf("Valor do saque: \n");
				scanf("%f", &v);
				s=s-v;
				break;
			case 3:
				printf("Saldo atual: R$%.2f \n", s);
				break;
			default:
				if(op!=4){
					printf("\nOpcao invalida! \n");
					}
			}
			}while(op!=4);
			
	printf("Fim das transacoes \n\n");
	
	return 0;
	
	}				
