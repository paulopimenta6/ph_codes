#include <stdlib.h>
#include <stdio.h>

int main(){
	
	char casa, refeicao, bebida, compartilho;
	char interesse[30];
	char tipo;
	
	do{
		printf("Alguem em casa? \n");
		scanf("%c", &casa);
		///__fpurge(stdin); ///Ao invés de usar fflsuh(stdin) está é a melhor solução para Linux. Em windows se pode usar fflush(stdin)		
		///fflush(stdin);

		if(casa=='s'){
			break;
		}
		else{
			printf("++++++++++++++++++++++++++ \n");
			printf("++   Deixe mensagem     ++ \n");
			printf("++ Aguarde pelo retorno ++ \n");
			printf("++++++++++++++++++++++++++ \n");
		} 
		
	}while(casa!='s');
	
        printf("Gostaria de compartilhar uma refeição? s/n \n");
	scanf(" %c", &refeicao);
	///fflush(stdin);

	if(refeicao=='s'){
		printf("++++++++++++++++++++++++++++\n");
		printf("++     Vamos jantar!      ++\n");
		printf("++  inicio da amizade!!!  ++\n");
		printf("++++++++++++++++++++++++++++\n");
		exit(1);
	}
	else{
		printf("Gostaria de uma bebida quente? s/n \n");
		///__fpurge(stdin);
		///fflush(stdin);
		scanf(" %c", &bebida);
		
		if(bebida=='s'){
			printf("1 - cha \n");
			printf("2 - cafe \n");
			printf("3 - chocolate \n");
			
			///__fpurge(stdin);
			scanf(" %c", &tipo);
			///tipo=getchar();
			
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
			printf("Inicio de uma amizade \n");
			exit(1);		
		}
		else{
			printf("Conte-me dos seus interesses! \n");
			///fflush(stdin);
			scanf(" %s", interesse);
			printf("O interesse é: %s \n", interesse);
			
			printf("Compartilho deste interesse? \n");
			///__fpurge(stdin);
			///fflush(stdin);
			scanf(" %c", &compartilho);
			
			if(compartilho=='s'){
				printf("Por que não fazemos aquilo juntos? \n");
			}
			else{
				printf("Não compartilho deste interesse... \n");
				exit(1);
			}
		}
		printf("Inicio de uma amizade \n");		
	}	
		
		
	
	return 0;
		
}
