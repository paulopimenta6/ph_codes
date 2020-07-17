#include <stdlib.h>
#include <stdio.h>

int main(){
	
	char casa, refeicao, bebida, compartilho;
	char interesse[30];
	int tipo;
	
	do{
		printf("Alguem em casa? \n");
		scanf("%c", &casa);
		fflush(stdin);
		
		if(casa=='s'){
			break;
		}
		else{
			printf("Deixe mensagem \n");
			printf("Aguarde pelo retorno \n");
		}
	}while(casa!='s');
	
	printf("Gostaria de compartilhar uma refeição? s/n \n");
	scanf("%c", &refeicao);
	
	if(refeicao=='s'){
		printf("Vamos jantar! \n");
		printf("inicio da amizade!!! \n");
	}
	else{
		printf("Gostaria de uma bebida quente? s/n \n");
		fflush(stdin);
		scanf("%c", &bebida);
		
		if(bebida=='s'){
			printf("1 - cha \n");
			printf("2 - cafe \n");
			printf("3 - chocolate \n");
			
			fflush(stdin);
			tipo=getchar();
			
			switch(tipo){
				case '1':
				    printf("cha \n");
				    break;
				case '2':
				    printf("cafe \n");
				    break;
				case '3':
				    printf("chocolate \n");
				    break;        
				default:
				    printf("Opção não válida! \n");
				    break;
				}
				
			}
			
		else{
			printf("Conte-me dos seus interesses! \n");
			scanf("%s", interesse);
			printf("O interesse é: %s \n", interesse);
			
			printf("Compartilho deste interesse? \n");
			fflush(stdin);
			scanf("%c", &compartilho);
			
			if(compartilho=='s'){
				printf("Por que não fazemos aquilo juntos? \n");
			}
			else{
				printf("Não compartilho deste interesse... \n");
			}
		}
		
		printf("Inicio da amizade \n");
		
	}
	
	return 0;
		
}
		
			
			
	 
