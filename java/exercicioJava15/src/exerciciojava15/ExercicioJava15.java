package exerciciojava15;

import java.util.Scanner;
import java.util.Locale;

/**
 *
 * @author paulo
 */
public class ExercicioJava15 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        double renda, imposto;
        
        System.out.print("Digite o valor da sua renda: ");
        renda = sc.nextDouble();
        
        if (renda < 2000.00){
            imposto = 0.0;
        }
        else if (renda <= 3000.00){
            imposto = (renda - 2000.00)*0.08;
        }
        
        else if (renda <= 4500.00){
            imposto = (renda - 3000.00)*0.18 + 1000.00*0.08;
        }
        
        else {
            imposto = (renda - 4500.00)*0.28 + 1500.00*0.18 + 1000.00*0.08;
        }
        
        
        if (imposto == 0.0){
            System.out.print("Contribuinte isento\n");
        } else {
           System.out.printf("Valor de imposto a ser pago: %.2f%n", imposto); 
        }
        
        sc.close();    
    }
    
}
