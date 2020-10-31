#include <stdio.h>
#include <stdlib.h>

int fatorial(int valor); //funcao que usara recursividade para calcular fatorial

int main(){

	int a, ans;

	printf("Escolha um valor para ser calculado o fatorial: \n");
	scanf("%d", &a);
	
	ans=fatorial(a);

	printf("O valor do fatorial de %d e: %d \n", a, ans);	

}

int fatorial(int valor){

	if(valor==1){
		return 1;
	}
	else{
		return(valor*fatorial(valor-1)); //Aqui havera a multiplicacao de um valor pelo fatorial de (valor-1):
						 //n*(n-1)*((n-1)-1)*(((n-1)-1)-1*...*1)	
	}
}
