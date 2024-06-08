#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

int a1, a2, a3, a4, a5, MAX, MIN, amplitude;

  srand(time(NULL));
  
  a1=rand()%100;
  a2=rand()%100;  
  a3=rand()%100; 
  a4=rand()%100; 
  a5=rand()%100;
  
  /*Mostrando a saida dos numeros randomicos*/
  printf("A serie aleatoria é: %d %d %d %d %d \n", a1, a2, a3, a4, a5);

/*Verificando o maior valor encontrando aleatoriamente*/
  
  if(a1>a2 && a1>a3 && a1>a4 && a1>a5){
	  MAX=a1; //a1 é considerado maior valor
  }
  else{
       if(a2>a1 && a2>a3 && a2>a4 && a2>a5){
           MAX=a2; //a2 é considerado maior valor
       }
       else{
           if(a3>a1 && a3>a2 && a3>a4 && a3>a5){
               MAX=a3; //a3 é considerado maior valor
           }
           else{
               if(a4<a1 && a4<a2 && a4<a3 && a4<a5){
                   MAX=a4; //a4 é considerado menor valor
               }               
               else{
				    if(a5>a1 && a5>a2 && a5>a3 && a5>a4){
						MAX=a5; //a5 é considerado menor valor
					}
				}
			}
		}
	}

/*Verificando o menor valor encontrando aleatoriamente*/
	
  if(a1<a2 && a1<a3 && a1<a4 && a1<a5){
	  MIN=a1; //a1 é considerado maior valor
  }
  else{
       if(a2<a1 && a2<a3 && a2<a4 && a2<a5){
           MIN=a2; //a2 é considerado maior valor
       }
       else{
           if(a3<a1 && a3<a2 && a3<a4 && a3<a5){
               MIN=a3; //a3 é considerado maior valor
           }
           else{
               if(a4<a1 && a4<a2 && a4<a3 && a4<a5){
                   MIN=a4; //a4 é considerado menor valor
               }               
               else{
				    if(a5<a1 && a5<a2 && a5<a3 && a5<a4){
						MIN=a5; //a5 é considerado menor valor
					}
				}
			}
		}
	}                   
                   
  printf("O maior valor é: %d e o menor valor é: %d \n", MAX, MIN);
  amplitude=MAX-MIN; 
  printf("A amplitude é %d \n", amplitude);
  
  return 0;

}
