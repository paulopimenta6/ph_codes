#include <stdio.h>
#include <stdlib.h>

int main(){

	int *p;
	int i;
	int k;
	
	i=42;
	k=i;
	p=&i;
	
	printf("O valor de i e: %d \n", i);
	printf("O valor de k e: %d \n", k);
	printf("O valor de p e: %d \n", *p);
	
	printf("---------------------------- \n");
	
	k=75;
	printf("k=75\n");
	printf("O valor de i e: %d \n", i);
	printf("O valor de k e: %d \n", k);
	printf("O valor de p e: %d \n", *p);
	
	//*k=75;
	//printf("*k=75\n");
	//printf("O valor de i e: %d \n", i);
	//printf("O valor de k e: %d \n", k);
	//printf("O valor de p e: %d \n", *p);		
	
	//p=75;
	//printf("p=75\n");
	//printf("O valor de i e: %d \n", i);
	//printf("O valor de k e: %d \n", k);
	//printf("O valor de p e: %d \n", *p);

	*p=75;
	printf("*p=75\n");
	printf("O valor de i e: %d \n", i);
	printf("O valor de k e: %d \n", k);
	printf("O valor de p e: %d \n", *p);
	
	return 0;
	
}
