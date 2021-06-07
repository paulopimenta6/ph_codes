#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TAMANHO 100

void gerador_de_numeros_aleatorios(int vetor[], int tamanho); /*prototipo de funcao de geracao de numeros aleatorios*/
void ordena_vetor(int vetor[], int tamanho); /*prototipo da funcao de ordenamento de vetor*/
int busca_binaria(int vetor[], int valor, int tamanho); /*prototipo de funcao de busca binaria*/
 
int main(){

    int i, vetor[TAMANHO];
        
 
    gerador_de_numeros_aleatorios(vetor, TAMANHO);    
    ordena_vetor(vetor, TAMANHO);
    for(i=0; i<TAMANHO; i++){
        printf("%d ", vetor[i]);
    }
    printf("\n");
    printf("v[0]: %d", vetor[0]);
    printf("\n");
    printf("\nResultado: da busca: %d \n", busca_binaria(vetor, 33, TAMANHO));
    fflush(stdout);   

    return 0;

}    

void gerador_de_numeros_aleatorios(int vetor[], int tamanho){
  
    int i; 
  
    printf("==================================================== \n");
    printf("Gerando numeros aleatorios a serem advinhandos... \n");
    srand (time(NULL));
    for(i=0; i<tamanho; i++){
        /*Gerando os valores aleatoriamente*/
        vetor[i]=(rand()%(100-0));
        printf("%d ", vetor[i]);
    }
    printf("\n");
    printf("==================================================== \n");
 
}

void ordena_vetor(int vetor[], int tamanho){
//O metodo de ordenamento usado sera o bublesort

    int i, auxiliar;
    int ordenados=0; //indica que os elementos adjacentes nao estao ordenados

    while(ordenados==0){
        ordenados=1; //considera todos os elementos ordenados corretamente
        for(i=0; i<tamanho; i++){
            if(vetor[i]>vetor[i+1]){
                auxiliar=vetor[i];
                vetor[i]=vetor[i+1];
                vetor[i+1]=auxiliar;
                ordenados=0; //isto forca a passagem pelo laco while para ordenar mais de uma vez ate tudo estar totalmente ordenado    
            }    
        }
    }

    printf("==================================================== \n");
    printf("vetor ordenado dentro da funcao \n");
    for(i=0; i<tamanho; i++){
        printf("%d, ", vetor[i]);
    } 
    printf("\n==================================================== \n");       
}

int busca_binaria(int vetor[], int valor, int tamanho){

    int achou=0;
    int alto=tamanho, baixo=0, meio;

    meio=(alto + baixo)/2;

    /*Lembrando que em C o boolean numoerico e:
    0: False
    1: True */
    while((!achou) && (alto>=baixo)){
        printf("Baixo: %d, Medio: %d, Alto: %d \n", baixo, meio, alto);
        if(valor==vetor[meio]){            
            achou=1;            
        }
        else{
            if(valor<vetor[meio]){
                alto=meio-1;
            }
            else{
                baixo=meio+1;                
            }
        }        
        meio=(alto+baixo)/2; 
    }
    /*resultado do operador <a>?<b>:<c> = comparacao para saber o que e <a> ? if true entao o resultado e <b> : if false entao o resultado e <c>;*/
    return ((achou)?vetor[meio]:-1);
}











