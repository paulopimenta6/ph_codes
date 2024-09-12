package exerciciojava24;

import java.util.Scanner;

public class ExercicioJava24 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        int N; 
        int div = 1;
        
        System.out.print("Digite um valor: ");
        N = sc.nextInt();
        
        while(div<=N){
            if(N%div == 0){
                System.out.printf("%d%n", div);
            }
            div += 1;
        }        
    }    
}
