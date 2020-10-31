#include <stdio.h>
#include <stdlib.h>

int main(){
    char letra;
    int cont;
    
    cont=0;
    letra='i';
    
    while(letra!='q'){
        printf("Numero: %d \n", cont);
        printf("Deseja continuar? \"q\" para sair \n");
        scanf(" %c", &letra);        
        
        cont++;
    }
    return 0;
}
