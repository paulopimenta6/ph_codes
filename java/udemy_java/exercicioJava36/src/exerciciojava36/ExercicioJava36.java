package exerciciojava36;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava36 {
    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite o tamanho que o vetor deve ter: ");
        int N = sc.nextInt();
        
        double[] vector = new double[N];
        
        for(int i = 0; i < vector.length; i++){
            System.out.printf("Digite o valor de vector[%d]: ", i);
            vector[i] = sc.nextDouble();
        }
        
        double soma = 0.0;
                
        for(int i = 0; i < vector.length; i++){
            soma += vector[i] ;
        }
        
        double media = soma/(vector.length);
        System.out.printf("O valor da media e:  %.3f%n", media);
        
        System.out.printf("Elemento abaixo da media: %n");
        for(int i = 0; i < vector.length; i++){
            if(vector[i]< media){
                System.out.printf("%.2f%n", vector[i]);
            }
        }
        
        sc.close();
    }
    
}
