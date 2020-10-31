#include <stdio.h>

int main(){

    int valor;
    
    printf("Digite um valor: \n");
    scanf("%d", &valor);
    
    if(valor%2==0){
	    printf("O valor é par!");
	}
	else{
		printf("O valor não é par");
    }
    return 0;
}
	
	


