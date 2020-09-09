#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(){

	char st[40]="HELLO"; //Aspas duplas mostram que e uma string, enquanto aspas simples um caracter
	int i;

	for(i=0; st[i]; i++){
		st[i]=tolower(st[i]);
		}

	printf("HELLO passara a ser minusculo: %s... \n", st);

	return 0;

	} 	

