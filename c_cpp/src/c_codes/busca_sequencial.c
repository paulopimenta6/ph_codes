/* Programa de busca sequencial elaborado como exercicio */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

    int numeros[5], i, valor;

    printf("==================================================== \n");
    printf("Gerando numeros aleatorios a serem advinhandos... \n");
    srand(time(NULL));
    for(i=0; i<5; i++){
        /*Gerando os valores aleatoriamente*/
        numeros[i]=rand()%100;
    }
    printf("==================================================== \n");

    printf("Qual e o valor a procurar? \n");
    scanf("%d", &valor);

    for(i=0; i<5; i++){
        if(valor==numeros[i]){
            printf("Valor encontrado!!! \n");            
            printf("A sequencia de valores e: ");
            for(i=0; i<5; i++){
                printf("%d ", numeros[i]);
            }
            exit(1);
        }
    }    

    printf("O valor nao foi encontrado... \n");
    printf("A sequencia de valores e: ");
    for(i=0; i<5; i++){
        printf("%d ", numeros[i]);
    }
    
    printf("\n");    

    return 0;

}
