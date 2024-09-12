package exerciciojava18;

import java.util.Scanner;

public class ExercicioJava18 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int alcool = 0;
        int gasolina = 0;
        int diesel = 0;
        int opt;
        
        System.out.print("Posto de Gasolina\n"
                + "1-\tAlcool\n2-\tGasolina\n3-\tDiesel\n4-\tFim\n"
                + "Escolha uma opcao: ");
        opt = sc.nextInt();
        
        while(opt!= 4){
            if(opt == 1){
                alcool = alcool + 1;
            }
            else if(opt == 2){
                gasolina = gasolina + 1;
            }
            else if(opt == 3){
                diesel = diesel + 1;
            }
            System.out.print("Escolha novamente uma nova opcao:"
                    + "1 - Alcool, 2 - Gasolina, 3 - Diesel, 4 - Sair: ");
            opt = sc.nextInt();
        }
        
        sc.close();
        System.out.print("Muito obrigado\n");
        System.out.printf("Alcool: %d%n", alcool);
        System.out.printf("Gasolina: %d%n", gasolina);
        System.out.printf("Diesel: %d%n", diesel);
    }
    
}
