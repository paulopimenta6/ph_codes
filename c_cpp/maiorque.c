#include <stdio.h>
#include <stdlib.h>

int main(){

    int a, b, c;

    printf("Digite um numero: \n");
    scanf("%d", &a);
    
    printf("Digite um segundo numero: \n");
    scanf("%d", &b);

    printf("Digite um terceiro numero: \n");
    scanf("%d", &c);

    if(c>b && c>a){
        if(b>a){
            printf("%d %d %d", c, b, a);
        }
        else{
            printf("%d %d %d", c, a, b);
        }
    }
    else{
        if(b>a && b>c){
            if(a>c){
                printf("%d %d %d", b, a, c);
            }    
            else{
		        printf("%d %d %d", b, c, a);
		    }		    	    
            }        
        else{
            if(a>b && a>c){
                if(b>c){
                    printf("%d %d %d", a, b, c);
                }
                else{
                    printf("%d %d %d", a, c, b);        
                }    			
            }
        }
    }    
    return 0;
}    
