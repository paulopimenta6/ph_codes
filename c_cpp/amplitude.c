#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(){

int a1, a2, a3, a4, a5, MAX;

  srand(time(NULL));
  
  a1=rand()%100;
  a2=rand()%100;  
  a3=rand()%100; 
  a4=rand()%100; 
  a5=rand()%100;
  
  printf("A serie aleatoria é: %d %d %d %d %d", a1, a2, a3, a4, a5);
  
  if(a1>a2 && a1>a3 && a1>a4 && a1>a5){
	  MAX=a1; //a1 é considerado maior valor
  }
  else{
       if(a1<a2 && a1<a3 && a1<a4 && a1<a5){
           MIN=a1; //a1 é considerado menor valor
       }
       else{
           if(a2>a1 && a2>a3 && a2>a4 && a2>a5){
               MAX=a2; //a1 é considerado maior valor
           }
           else{
               if(a2<a1 && a2<a3 && a2<a4 && a2<a5){
                   MIN=a2; //a1 é considerado menor valor
               }
                   
                   
       
	  
	    
  
  
  
  
  return 0;

}
