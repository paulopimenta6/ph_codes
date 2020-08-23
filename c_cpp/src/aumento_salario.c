#include <stdio.h>

int main(){
	
	float salario, novo_salario;
	
	printf("Digite o valor do salario: R$");
	scanf("%f", &salario);
	
	if(salario<=1000){
		 novo_salario=salario+(salario*0.10);
		 printf("O novo salario sera de: R$%.2f", novo_salario);
	 }
	 else{
		 printf("Valor não elegível a aumento");
	 }
	 
	 return 0;
	 
 }
	 
