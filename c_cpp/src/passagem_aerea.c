#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define linha 2
#define coluna 6

int main(){

    char assento[linha][coluna], ans;
    int i, j;


    printf("Programa simples de reserva de passagens Aereas \n");
    printf("Assentos livres: \n");
    
    for(j=0; j<coluna; j++){                  
		for(i=0; i<linha; i++){
			assento[i][j]='L';                     
			printf(" |--[%d][%d]--|", i, j);			
		}
                printf("\n");                                		
    }


    printf("\n");
    printf("Status: \n");
    for(j=0; j<coluna; j++){
		for(i=0; i<linha; i++){
                    printf("| assento[%d][%d]: %c |", i, j, assento[i][j]);
                }
                printf("\n");  
    }

    
    do{
    printf("\n");
    printf("Deseja escolher um assento? \n");
    scanf(" %c", &ans);

    if(ans=='s' || ans=='S'){
        printf("Escolha um assento: \n");
        scanf("%d %d", &i, &j);
        }
    else{
        printf("Saindo do sistema \n");
        break;
        } 
                               
     
    }while(ans!='n' || ans!='N');
   

    return 0;



    }
