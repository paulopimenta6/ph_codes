package exerciciojava08;
import java.util.Scanner;
import java.util.Locale;

/**
 *
 * @author paulo
 */
public class ExercicioJava08 {
      public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        int value;
        char ans;
        
        do{
            System.out.print("Digite um valor positivo ou negativo: ");
            value = sc.nextInt();
            if (value < 0){
                System.out.println("O valor digitado e negativo");
            } else{
                System.out.println("O valor e positivo!");
            } 
        System.out.println("Deseja continuar? s/S ou n/N");
        ans = sc.next().charAt(0);
        }while (ans == 's' || ans == 'S'); 
        sc.close();
      }
}
