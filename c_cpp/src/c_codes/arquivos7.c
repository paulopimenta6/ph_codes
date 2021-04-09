#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	
	FILE *arq;
	char texto[100]; 
//	char str4[100];
	
//	printf("Entre com um texto: ");
//	fgets(texto, 100, stdin); //Essa funcao estipula um valor minimo para a quantidade de caracteres
//  strcpy (str4,"henrique ");
//	strcat(str4, texto);
//	printf("%s", str4);
	
	arq=fopen("teste.txt", "w");
	if(arq==NULL){
		printf("Erro na abertura do arquivo\n");
		exit(1);
	}
	else{
		do{
			printf("Entre com um texto: ");
			fgets(texto, 100, stdin); //Essa funcao estipula um valor minimo para a quantidade de caracteres
			//strcat(texto, "\n");
			fputs(texto, arq);
			printf("%s", texto);
		}while(*texto!='\n');
	}	
	fclose(arq);
	return 0;
}
