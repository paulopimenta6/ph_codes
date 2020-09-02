#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){

	char senha[20]; //vetor de caracteres para receber a senha
	int x, comparacao;
		
	for (x=1; x<=3; x++){
		printf("Voce tem 3 tentativas. Agora é a %d° tentativa \n", x);
		printf("Digite a senha: ");
		scanf(" %s", senha);
		
		comparacao=strcmp(senha,"passwd");
		if(comparacao==0){
					printf("A senha foi acertada! \n");
					break;
				}
		else{
			printf("A senha esta errada \n");			
			}
			
				}			
	return 0;
	
	}			
