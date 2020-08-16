#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    int x, cont, total;
    char letra;
    
    cont=0;
    total=0;
    
    do{
        printf("Digite um número: \n");
        scanf("%d", &x);
        
        cont=cont+1;
        total=total+x;
        
        printf("Deseja continuar? s/S ou n/N \n");
        scanf(" %c", &letra);
    }while(letra=='s' || letra=='S');
    
    printf("Parando... \n");
    printf("Repetições=%d e total=%d \n", cont, total);
    
    return 0;
    
}
        
