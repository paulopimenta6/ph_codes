#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define linha 100
#define coluna 100

void funcao_de_inicializacao(char matriz[][coluna], int contLinha, int contColuna); //constroi uma matriz com as passagens aereas/assentos livres
void funcao_de_exibicao_de_assentos(char matriz[][coluna], int contLinha, int contColuna); //exibe os assentos livres e nao livres
void funcao_compra_de_passagem(char matriz[][coluna]); //Recebe o assento a ser reservado
                                                       //verifica se o assento existe
                                                       //verifica se esta disponivel
                                                       //finaliza a compra ou termina sem compra 

int main(){

    char assento[linha][coluna];
    int i, j;
    
    i=2;
    j=60;    

    printf("Programa simples de reserva de passagens Aereas \n");

    funcao_de_inicializacao(assento, i, j);
    funcao_de_exibicao_de_assentos(assento, i, j);    
    
    
//    do{
//    printf("\n");
//    printf("Deseja escolher um assento? \n");
//    scanf(" %c", &ans);

//    if(ans=='s' || ans=='S'){
//        printf("Escolha um assento: \n");
//        scanf("%d %d", &i, &j);
//        }
//    else{
//        printf("Saindo do sistema \n");
//        break;
//        } 
                               
     
//    }while(ans!='n' || ans!='N');
   

    return 0;
    
    }

void funcao_de_inicializacao(char matriz[][coluna], int contLinha, int contColuna){	

    int i, j;   
    
    for(j=0; j<contColuna; j++){                  
		for(i=0; i<contLinha; i++){
			matriz[i][j]='L';		
		        }                                               		
                }
    }

void funcao_de_exibicao_de_assentos(char matriz[][coluna], int contLinha, int contColuna){
	
    int i, j;    
    
    printf("Assendos Livres: L \n");
    printf("Assentos Ocupados: O \n");
    printf("---Status--- \n");
    for(j=0; j<contColuna; j++){
		for(i=0; i<contLinha; i++){
                    printf(" |--[%d][%d]: %c --|", i, j, matriz[i][j]);                    
                }
                printf("\n");  
                }
    }	

void funcao_compra_de_passagem(char matriz[][coluna]){

    



