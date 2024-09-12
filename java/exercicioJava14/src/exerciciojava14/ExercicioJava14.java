package exerciciojava14;

import java.util.Scanner;
import java.util.Locale;

/**
 *
 * @author paulo
 */
public class ExercicioJava14 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
                
        double x, y;
        char ans;
        
        do{
            System.out.print("Digite a primeira coordenada: ");
            x = sc.nextDouble();

            System.out.print("Digite a segunda coordenada: ");
            y = sc.nextDouble();

            if (x == 0.0 && y == 0.0){
                System.out.print("Origem\n");
            }
            else if (x == 0.0){
                System.out.print("Eixo y\n");
            }

            else if (y == 0.0){
                System.out.print("Eixo x\n");
            }

            if (x > 0.0 && y > 0.0){
                System.out.print("Q1\n");
            }

            if (x < 0.0 && y > 0.0){
                System.out.print("Q2\n");
            }

            if (x < 0.0 && y < 0.0){
                System.out.print("Q3\n");
            }

            if (x > 0.0 && y < 0.0){
                System.out.print("Q4\n");
            }
            
            System.out.print("Deseja continua? s/S ou n/n: ");
            ans = sc.next().charAt(0);
            
        }while (ans == 's' || ans == 'S');
        
        sc.close();
        System.out.print("-----------------\n");
        System.out.print("Programa finalizado\n");
        System.out.print("-----------------\n");
    }
    
}
