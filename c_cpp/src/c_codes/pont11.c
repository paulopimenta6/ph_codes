#include <stdio.h>
#include <stdlib.h>

void troca(int *pa, int *pb); //prototipo de funcao que faz a troca de valores

int main(){
	
	int a, b;
	int i=0;	
	int x[5]={0, 1, 2, 3, 4};
	
	while(i<5){
		a=x[i]+1;
		b=x[i]+4;
		troca(&a,&b);
		printf("*pa=%d e pb=%d \n", a, b);
		i++;		
	}
	
	return 0;
	
}

void troca(int *pa, int *pb){
	
	int t;
	
	t=*pa;
	*pa=*pb;
	*pb=t;	
	
} 
