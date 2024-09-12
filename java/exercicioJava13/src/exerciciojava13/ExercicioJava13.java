package exerciciojava13;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author paulo
 */
public class ExercicioJava13 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        System.out.print("Digite o valor: ");
        double value = sc.nextDouble();
        
        if (value >= 0 && value <= 25){
            System.out.print("O valor esta no intervalo [0,25]\n");
        }
        else if (value > 25 && value <= 50){
            System.out.print("O valor esta no intervalo [25,50]\n");
        }
        else if (value > 50 && value <= 75){
            System.out.print("O valor esta no intervalo (50, 75]\n");
        }
        else if (value > 75 && value <= 100){
            System.out.print("O valor esta no intervalo (75, 100]\n");
        }
        else{
            System.out.print("Valor fora dos intervalos usados!\n");
        }
         
        sc.close();
    }
    
}
