#include <stdio.h>
#include <stdlib.h>

int main(){
	
        int cont;
	char senha;

	cont=1;

	do{
		printf("Digite uma senha: \n");
		scanf(" %c", &senha);

		cont++;

		if(senha=='f'){
			printf("Certa! \n");
			break;
		}
		else{
			if(cont>3){
				printf("Senha incorreta - Saindo \n");
				break;
			}
		}
	}while(1);

	return 0;

	}	
