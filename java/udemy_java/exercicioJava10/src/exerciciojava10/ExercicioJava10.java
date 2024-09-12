package exerciciojava10;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author paulo
 */
public class ExercicioJava10 {

    
    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        int value1, value2;
        char ans;
        do{
            System.out.print("Digite o primeiro valor positivo ou negativo: ");
            value1 = sc.nextInt();
            System.out.print("Digite o segundo valor positivo ou negativo: ");
            value2 = sc.nextInt();

            if (value1 % value2 == 0 || value2 % value1 == 0){
                System.out.println("Sao multiplos");
            } else{
                System.out.println("Nao sao multiplos");
            }
            System.out.print("Deseja consitnuar? s/S ou n/N: ");
            ans = sc.next().charAt(0);
        }while(ans == 's' || ans == 'S');
        sc.close();        
    }
    
}
