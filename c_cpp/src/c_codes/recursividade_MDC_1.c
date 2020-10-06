#include <stdio.h>
#include <stdlib.h>

int mdc(int m, int n); //funcao com mdc usando recursividade

int main(){

	int a, b, c;

	printf("Escolha um primeiro valor: \n");
	scanf("%d", &a);

	printf("Escolha um segundo valor: \n");
	scanf("%d", &b);	
	
	c=mdc(a,b);

	printf("O valor do MDC entre %d e %d e: %d \n", a, b, c);

}

int mdc(int m, int n){

	int r=m%n;
		
	if(r==0){
		return n;
	}
	else{
		return mdc(n, (m%n));
	}

}
	

		
