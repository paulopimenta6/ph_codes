package exerciciojava09;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author paulo
 */
public class ExercicioJava09 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        int value;
        char ans;
        
        do{
            System.out.print("Digite um valor positivo ou negativo: ");
            value = sc.nextInt();
            if (value % 2 == 0){
                System.out.println("O valor digitado e par");
            } else{
            System.out.println("O valor e impar!");
            }                
            System.out.println("Deseja continuar? s/S ou n/N");
            ans = sc.next().charAt(0);
            }while (ans == 's' || ans == 'S');
            sc.close();
    }  
}
