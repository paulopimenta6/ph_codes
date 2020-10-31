
#include <stdio.h>

int main(){
	
	int valor;
	
	printf("Digite um valor: \n");
	scanf("%d", &valor);
	
	if(valor>=100 && valor<=200){
		printf("O valor está dentro do intervalo de 100 a 200");
	}
	else{
		printf("Fora do intervalo");
	}
	
	return 0;
	
}
		

