package exerciciojava11;

import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author paulo
 */
public class ExercicioJava11 {

    public static void main(String[] args) {
        Locale.setDefault(Locale.US);
        Scanner sc = new Scanner(System.in);
        
        int horaInicial, horaFinal, intervalo;
        char ans;
        
        do{
            System.out.print("Digite a hora inicial: ");
            horaInicial = sc.nextInt();
            
            System.out.print("Digite a hora final: ");
            horaFinal = sc.nextInt();
            
            if(horaFinal > horaInicial){
                intervalo = horaFinal - horaInicial;
                System.out.printf("O intervalo de horas foi de: %d\n", intervalo);
            } else{
                intervalo = (24 - horaInicial) + horaFinal;
                System.out.printf("O intervalo de horas foi de: %d\n", intervalo);
            }
             
            System.out.print("Deseja continuar? s/s ou n/N: ");
            ans = sc.next().charAt(0);
            
        }while(ans == 's' || ans == 'S');
        
        sc.close();
        System.out.println("-----Programa Finalizado-----");
    }
    
}
