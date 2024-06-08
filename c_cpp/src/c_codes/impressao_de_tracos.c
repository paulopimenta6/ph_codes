#include <stdlib.h>
#include <stdio.h>

void traco();
void coluna();
void tacos_duplos();
void tracos_recuados();

int main()
{

	traco();
	coluna();
	tacos_duplos();
	tracos_recuados();

	return 0;
			
}

void traco(){
	int i;
	
	for(i=0; i<6; i++){
		printf("*");
	}
}

void coluna(){
	int i;
	
	for(i=0; i<6; i++){
		printf("\n");
		printf("*");
		}
}

void tacos_duplos(){
	int i, j;
	printf("\n");
	for(i=0; i<6; i++){
		for(j=0; j<6; j++){
			if(j==0 || j==5){
				printf("*");
			}
			else{
				printf(" ");
			}
		}
		printf("\n");
	}
}

void tracos_recuados(){
	int i, j;
	
	for(i=0; i<6; i++){
		for(j=0; j<6; j++){
			if(j!=5){
				printf(" ");
			}
			else{
				printf("*");
			}
		}
		printf("\n");
	}
}