#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TAMANHO 100

int gerador_de_numeros_aleatorios(int vetor[], int tamanho); /*prototipo de funcao de geracao de numeros aleatorios*/
int ordena_vetor(int vetor[], int tamanho); /*prototipo da funcao de ordenamento de vetor*/
int busca_binaria(int vetor[], int valor, int tamanho); /*prototipo de funcao de busca binaria*/
 
int main(){

    int vetor[TAMANHO], v[TAMANHO], vo[TAMANHO];
        
 
    v[]=gerador_de_numeros_aleatorios(vetor, TAMANHO);    
    vo=ordena_vetor(vetor, TAMANHO);     
   
    printf("Resultado: da busca: %d \n", busca_binaria(vo, 33, TAMANHO));

    return 0;

}    

int gerador_de_numeros_aleatorios(int vetor[], int tamanho){
  
    int i; 
  
    printf("==================================================== \n");
    printf("Gerando numeros aleatorios a serem advinhandos... \n");
    srand(time(NULL));
    for(i=0; i<tamanho; i++){
        /*Gerando os valores aleatoriamente*/
        vetor[i]=rand()%100;
    }
    printf("==================================================== \n");
 
    return vetor;
}

int ordena_vetor(int vetor[], int tamanho){
//O metodo de ordenamento usado sera o bublesort

    int i, auxiliar;
    int ordenados=0; //indica que os elementos adjacentes nao estao ordenados

    while(ordenados==0){
        ordenados=1; //considera todos os elementos ordenados corretamente
        for(i=0; i<tamanho; i++){
            if(vetor[i]>vetor[(i+1)]){
                auxiliar=vetor[i];
                vetor[i]=vetor[(i+1)];
                vetor[(i+1)]=auxiliar;
                ordenados=0; //isto forca a passagem pelo laco while para ordenar mais de uma vez ate tudo estar totalmente ordenado    
            }    
        }
    }   
        
    return vetor;
}

int busca_binaria(int vetor[], int valor, int tamanho){

    int achou=0;
    int alto=tamanho, baixo=0;
    int meio=(alto + baixo)/2;

    /*Lembrando que em C o boolean numoerico e:
    0: False
    1: True */
    while((!achou) && alto>=baixo){
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
                meio=(alto+baixo)/2;
            }
        }
    }
    /*resultado do operador <a>?<b>:<c> = comparacao para saber o que e <a> ? if true entao o resultado e <b> : if false entao o resultado e <c>;*/
    return ((achou)?meio:-1);
}











