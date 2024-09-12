package exerciciojava25;

import java.util.Scanner;

public class ExercicioJava25 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        
        int N;
        
        System.out.print("Digite o valor: ");
        N = sc.nextInt();
                
        for(int i = 1; i <= N; i++){
            System.out.printf("%d %d %d%n", i, (int) Math.pow(i, 2), (int) Math.pow(i, 3));
        }

    }
    
}
