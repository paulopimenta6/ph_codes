package exerciciojava23;

import java.util.Scanner;

public class ExercicioJava23 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        int N;
        int f;
        
        System.out.print("Digite o valor de N: ");
        N = sc.nextInt();                    
       
        System.out.printf("O fatorial de %d e %d%n", N, fatorial(N));
        sc.close();
    }    
    
    public static int fatorial(int n){
        if(n <= 1){
            return 1;
        } else{
            return fatorial(n-1)*n;
        }
    }    
}
