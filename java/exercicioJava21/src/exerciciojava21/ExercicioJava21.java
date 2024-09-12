package exerciciojava21;

import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava21 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        int N;
        double num1, num2, num3, mediaP;
        
        System.out.print("Digite o valor N: ");
        N = sc.nextInt();
        
        for(int i = 0; i < N; i++){
            System.out.print("Digite o primeiro valor: ");
            num1 = sc.nextDouble();
            
            System.out.print("Digite o segundo valor: ");
            num2 = sc.nextDouble();
            
            System.out.print("Digite o terceiro valor: ");
            num3 = sc.nextDouble();
            
            mediaP = (num1*2 + num2*3 + num3*5)/10;
            
            System.out.printf("A media ponderada e: %.1f%n", mediaP);
        }
        
        sc.close();
    }
    
}
