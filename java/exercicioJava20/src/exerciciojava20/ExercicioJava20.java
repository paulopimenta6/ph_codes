package exerciciojava20;

import java.util.Scanner;

public class ExercicioJava20 {

    public static void main(String[] args) {
     Scanner sc = new Scanner(System.in);
     int qtd, num;
     int in = 0; 
     int out = 0;
          
     System.out.print("Digite a quantidade de elementos a serem lidos: ");
     qtd = sc.nextInt();
     
     for(int i = 0; i < qtd; i++){
         System.out.print("Digite um valor: ");
         num = sc.nextInt();
         if(num >= 10 && num <= 20){
             in += 1;
         } else{
             out += 1;
         }         
     }
     sc.close();
     System.out.print(in + "\tin\n");
     System.out.print(out + "\tout\n");
     
    }
    
}
