#include <stdio.h>
#include <stdlib.h>

int main(){
	int cont;
	char senha;
	
	cont=1;
        
	do{
		printf("Digite a sua senha: \n");
		scanf(" %c", &senha);

		cont=cont+1;

		if(senha=='f'){
			printf("Acertou!\n");
			break;
		}

		if(cont>3){
			printf("Senha incorreta. Tentativas já terminadas \n");
			break;
		}

	}while(1);

	return 0;

}
