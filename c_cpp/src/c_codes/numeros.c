#include <stdio.h>
#include <stdlib.h>
#define tamanho 11

void numero_um(); //prototipo de print do numero um

void numero_dois(); 

int main(){

	numero_um();
	printf("\n\n");
	numero_dois();
	printf("\n");
}

void numero_um(){

	int i, j, n, p;
	
	n=2;
	p=1;
	
	while(n>0 || p<4){
		
		for(i=n; i>=0; i--){
			printf(" ");
		}
		
		for(j=0; j<p; j++){
			printf("*");
		}
		
		printf("\n");
		p++;
		n--;
	
	}

	for(j=0; j<3; j++){
		for(i=0; i<3; i++){
			printf(" ");
		}
		printf("*");
		printf("\n");
	}

	for(i=0; i<7; i++){
		printf("*");
	}


}

void numero_dois(){

	int i;
	
	for(i=0; i<7; i++){
		printf("*");
	}
	printf("\n");

	for(i=0; i<6; i++){
		printf(" ");
	}
	printf("*");	
	printf("\n");

	for(i=0; i<7; i++){
		printf("*");
	}
	printf("\n");

	

}




