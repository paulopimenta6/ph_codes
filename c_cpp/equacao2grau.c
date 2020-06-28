#include <stdio.h>
#include <math.h>

int main(){
	
	float a, b, c, delta, raiz_de_delta, x1, x2;
	
    printf("Digite o valor de \"a\": \n");
    scanf("%f", &a);
    
    printf("Digite o valor de \"b\": \n");
    scanf("%f", &b);

    printf("Digite o valor de \"c\": \n");
    scanf("%f", &c);
    
    delta=pow(b,2)-(4*a*c);
    
    if(delta>0){
		 raiz_de_delta=sqrt(delta);
		 x1=((-b)+raiz_de_delta)/(2*a);
		 x2=((-b)-raiz_de_delta)/(2*a);
		 printf("As raizes sao x1: %f e x2: %f", x1, x2);
     }
     
	else{
        if(delta<0){
            printf("Delta negativo não possibilita calcular raizes");
        }
        else{
            if(delta==0){
                x1=(-b)/(2*a);                    
                printf("A raiz é dupla e sao x1: %f e x2: %f", x1, x1);
            }
        }
    } 

return 0;

}
