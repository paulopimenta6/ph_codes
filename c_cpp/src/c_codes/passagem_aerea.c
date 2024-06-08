#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define linha 100
#define coluna 100

void funcao_de_inicializacao(char matriz[][coluna], int contLinha, int contColuna); //constroi uma matriz com as passagens aereas/assentos livres
void funcao_de_exibicao_de_assentos(char matriz[][coluna], int contLinha, int contColuna); //exibe os assentos livres e nao livres
void funcao_compra_de_passagem(char matriz[][coluna], int contLinha, int contColuna); //Recebe o assento a ser reservado
                                                       //verifica se o assento existe
                                                       //verifica se esta disponivel
                                                       //finaliza a compra ou termina sem compra 
int funcao_verifica_assento(char matriz[][coluna], int assentolinha, int assentocoluna, int contLinha, int contColuna);


int main(){

    char assento[linha][coluna];
    int i, j;
    
    i=2;
    j=60;    

    printf("Programa simples de reserva de passagens Aereas \n");

    funcao_de_inicializacao(assento, i, j);
    funcao_de_exibicao_de_assentos(assento, i, j);
    funcao_compra_de_passagem(assento, i, j);
    
    system("clear");
    
    printf("Os assentos atualizados: \n");
    funcao_de_exibicao_de_assentos(assento, i, j);  

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
    
    
int funcao_verifica_assento(char matriz[][coluna], int assentolinha, int assentocoluna, int contLinha, int contColuna){
	
	//verificar que o assento selecionado se encontra no limite de assentos da aeronave	
    if(assentolinha<0 || assentolinha>(contLinha-1)){
		return -2;
	}
	if(assentocoluna<0 || assentocoluna>(contColuna-1)){
		return -1;
	}
	
	//verificar se o assento esta livre
	if(matriz[assentolinha][assentocoluna]=='L'){
		matriz[assentolinha][assentocoluna]='O';
		return 1;
	}
	else{
		return 0;
	}
	
	}		    

void funcao_compra_de_passagem(char matriz[][coluna], int contLinha, int contColuna){

    int assentolinha, assentocoluna, resultado;
    char ans;

    
    do{
		printf("\n");
		printf("Deseja escolher um assento? [s/S ou n/N] \n");
		scanf(" %c", &ans);

		if(ans=='s' || ans=='S'){
			printf("Digite o assento que deseja reservar: \n");
			scanf("%d %d", &assentolinha, &assentocoluna); //verificar que esses assentos existem
			resultado=funcao_verifica_assento(matriz, assentolinha, assentocoluna, contLinha, contColuna);
			if(resultado==-2){
				printf("Assento fora do limite \n");
			}
			else{
			if(resultado==-1){
				printf("Assento fora do limite \n");
			}
				else{
					if(resultado==1){
						printf("Assento [%d][%d] reservado \n", assentolinha, assentocoluna);
					}
					else{
						printf("Assento ja ocupado. Tente novamente \n");
					}
				}
			}			
		}
		else{
			printf("Saindo do sistema \n");
			break;
		}  
	}while(ans!='n' || ans!='N');
}


 
