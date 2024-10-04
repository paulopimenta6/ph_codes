package exerciciojava35;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava35 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        int soma = 0;        
        
        System.out.print("Digite a quantidade de numeros: ");
        int n = sc.nextInt();
        
        int[] vector = new int[n];
        
        for(int i=0; i < vector.length; i++){
            System.out.print("Digite um valor: ");
            vector[i] = sc.nextInt();            
        }
        
        for(int i = 0; i < vector.length; i++){
            if (vector[i]%2 == 0){
                System.out.printf("%d ", vector[i]);
                soma += 1;
            }
        }
        
        System.out.printf("%nQuantidade de pares: %d%n", soma);
        
        sc.close(); 
    }
    
}
