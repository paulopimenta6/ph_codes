package exerciciojava33;

import java.util.Locale;
import java.util.Scanner;

public class ExercicioJava33 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite um numero: ");
        int n = sc.nextInt();
        double soma = 0;
        
        while(n < 1){
            System.out.print("Digite um numero valido: ");
            n = sc.nextInt();
        }
        
        double[] vect = new double[n];
        
        for (int i=0; i<vect.length; i++){
           System.out.printf("Digite o [%d] valor: ", i );
           vect[i] = sc.nextDouble();
        }
                        
        System.out.println("================================================");
        for (int i=0; i<vect.length; i++){
            System.out.printf("Numero [%d]: %.1f  ", i, vect[i]);
            soma += vect[i];
        }
        
        System.out.println("");
        System.out.printf("Soma: %.2f", soma);
        System.out.println("");
        System.out.printf("Media: %.2f%n", soma/(vect.length));
        
        sc.close();
        
    }
    
}
