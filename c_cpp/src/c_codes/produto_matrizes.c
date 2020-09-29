#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MAX 3

//colocar processo para verificar que:
//quais casos geram matriz*matriz=[[a11^2], [a12^2],..., [ann^2]]



int main(){

	int i, j, p, soma, matriz_origem[MAX][MAX], matriz_resposta[MAX][MAX];
	
        srand(time(NULL));
	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			matriz_origem[i][j]=(rand()%10+1);
			}
	}


//	int matriz_origem[MAX][MAX]={{1,1,1}, {2,2,2}, {3,3,3}};	
	
	printf("\nA matriz origem e: \n");

	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			printf("|%d| ", matriz_origem[i][j]);
		}
	printf("\n");
	}
	
	//printf("\n");	

	soma=0;

	for(i=0; i<MAX; i++){		
		for(j=0; j<MAX; j++){
			for(p=0; p<MAX; p++){
				soma=matriz_origem[i][p]*matriz_origem[p][j] + soma;
			}
		matriz_resposta[i][j]=soma;
		//printf("M[%d][%d]=%d ", i, j, matriz_resposta[i][j]);
		soma=0;	
		}
		//printf("\n");	
	}

	printf("\n");
	printf("O Produto da matriz por ela mesma e: \n");
	printf("\n");	

	for(i=0; i<MAX; i++){
		for(j=0; j<MAX; j++){
			printf("%d ", matriz_resposta[i][j]);
		}
	printf("\n");
	}	

	return 0;

}
				
