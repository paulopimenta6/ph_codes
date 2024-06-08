#include <stdlib.h>
#include <stdio.h>

void quick_sort(int array[], int primeiro, int ultimo){
    int i, temp, baixo, alto, separador;
    baixo=primeiro;
    alto=ultimo;
    separador=array[(alto+baixo)/2];

    do{
        while(array[baixo]<separador){
            baixo++;
        }
        while(array[alto]>separador){
            alto--;
        }
        if(baixo<=alto){
            temp=array[baixo];
            array[baixo++]=array[alto];
            array[alto--]=temp;
        }
     }while (baixo<=alto);

     if((primeiro<alto)){
         quick_sort(array, primeiro, alto);
     }
     if((baixo<ultimo)){
         quick_sort(array, baixo, ultimo);
     }
}

int main(){
    int valores[10000], i;
    for(i=0; i<9999; i++){
        valores[i]=rand()%100;
        }
    quick_sort(valores, 0, 9999);
    for(i=0; i<9999; i++){
        printf("%d ", valores[i]);
        }
    return 0;
    }
