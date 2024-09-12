package exerciciojava22;

import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava22 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        int N, num1, num2;
        
        System.out.print("Digite o valor de N: ");
        N = sc.nextInt();
        
        for(int i = 0; i < N; i++){
            System.out.print("Digite o primeiro valor: ");
            num1 = sc.nextInt();
            
            System.out.print("Digite o segundo valor: ");
            num2 = sc.nextInt();
            
            if(num2 == 0){
                System.out.print("Sivisão impossivel\n");
            } else{
                double ans = (double) num1/num2;
                System.out.printf("%.1f%n", ans);
            }            
        }
        sc.close();
    }    
}
