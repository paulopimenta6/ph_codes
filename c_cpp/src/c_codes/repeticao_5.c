#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
    int cont, total;
    char letra;
    float x, media;
               
    cont=0;
    total=0;
    
    do{
        printf("Digite uma nota: \n");
        scanf("%f", &x);
        
        cont++;        
        total=total+x;
        
        printf("Deseja continuar? s/S ou n/N \n");
        scanf(" %c", &letra);
        
    }while(letra=='s' || letra=='S');
    
    printf("Parando... \n");
    printf("Repetições=%d e total=%d \n", cont, total);
    
    media=total/cont;
    
    printf("Media=%.2f \n",media);
    
    return 0;
}    
