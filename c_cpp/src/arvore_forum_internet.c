#include  <stdio.h>

int main () {
	int i, j, k=1, m, n, num;
 	printf ("Insira um número:\n");
 	scanf ("%d", &num);
 
	for (i=1; i<=num; i++){ 		
		 for (j=num; j>=i; j--){		 
			printf (" ");
  							}
  						
  		for (k=1; k<=i*2-1; k++){		  
			printf ("*");
  			printf ("\n");
  						}
 						}
 						
	for (m=num/2; m<num; m++){
		for (n=1; n<=k/2; n++){
			printf (" ");}
			printf ("*\n");

						}

	return 0;

			}
