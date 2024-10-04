package exerciciojava32;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author Paulo_Pimenta
 */
public class ExercicioJava32 {

    public static void main(String[] args) {
       Locale.setDefault(Locale.US);
       Scanner sc = new Scanner(System.in);
       
       System.out.print("Digite um numero: ");
       int n = sc.nextInt();
       
       while(n < 1 || n > 10){
           System.out.print("Digite um numero valido: ");
           n = sc.nextInt();
       }
       
       int[] vect = new int[n];
       for (int i=0; i<vect.length; i++){
           System.out.printf("Digite o [%d] valor: ", i );
           vect[i] = sc.nextInt();
       }
       
       System.out.println("================================================");
       for (int i=0; i<vect.length; i++){
           if(vect[i]<0){
               System.out.printf("Numero [%d] negativo: %d%n", i, vect[i]);               
            }
        }
    
       sc.close();
    }
    
}
